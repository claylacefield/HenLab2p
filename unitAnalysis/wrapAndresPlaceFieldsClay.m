function [PCLappedSess] = wrapAndresPlaceFieldsClay(C, toPlot, varargin);

%% USAGE: [out, PCLappedSess] = wrapAndresPlaceFieldsClay(C, toPlot, treadBehStruc, minVel, );
%% variables
shuffN = 1000;

if ~isempty(varargin)
    treadBehStruc = varargin{1};
    if length(varargin) == 2
    minVel = varargin{2};
    else
        minVel = 5;
    end
else
    minVel = 5;
    try
    load(findLatestFilename('treadBehStruc'));
    catch
        treadBehStruc = procHen2pBehav('auto');
    end
end

%% load other data
% [file, path] = uigetfile('*.mat', 'Select segDict file to process');
% cd(path);
% load(file);



% if input is cell array of peaks
if iscell(C)
    cCell = C;
    C = zeros(length(C),round(length(treadBehStruc.resampY)/2));
    for i = 1:length(cCell)
        C(i,cCell{i})=1;
    end
end

%% format position vector
totalFrames = size(C,2);
resampY = treadBehStruc.resampY;
downSamp = round(length(resampY)/totalFrames);  % find downsample rate
treadPos = resampY(1:downSamp:end); % downsample position vector
treadPos = treadPos/max(treadPos);  % normalize position vector

%% format other stuff
T = treadBehStruc.adjFrTimes(1:downSamp:end);

% calculate laps 
[lapVec, lapInts] = calcLaps1(treadPos, T);

%% Run place field analysis


PCLappedSess = computePlaceCellsLappedWithEdges3(C, treadPos, T, shuffN);
 

%% plotting
if toPlot == 1 || toPlot == 2
    
    if toPlot == 2 % to only plot place cells
        pcInd = find(PCLappedSess.Shuff.isPC);
        posRates = PCLappedSess.posRates(pcInd,:);
    else
        posRates = PCLappedSess.posRates;%(pcInd,:);
    end
    
    [maxVal, maxInd] = max(posRates');
    [newInd, oldInd] = sort(maxInd);
    posRates2 = posRates(oldInd,:);
    
    % for i = 1:size(posRates,1)
    %     posRates2(i,:) = posRates2(i,:)/max(posRates2(i,:));
    % end
    
    figure;
    subplot(2,1,1);
    colormap(jet);
    imagesc(posRates2);
    
    vel = treadBehStruc.vel(1:2:end);
    vel = fixVel(vel);
    posVel = binByLocation(vel, treadPos, 100);
    %figure; plot(posVel);
    
    %figure;
    subplot(2,1,2);
    plot(posVel/max(posVel)*max(mean(posRates2,1)),'g');
    hold on;
    plot(mean(posRates2,1));
    
end




