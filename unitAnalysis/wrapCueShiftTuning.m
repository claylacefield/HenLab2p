function [cueShiftStruc] = wrapCueShiftTuning(varargin); %pksCell, goodSeg, treadBehStruc)

% % if input is cell array of peaks
% if iscell(C)
%     cCell = C;
%     C = zeros(length(C),round(length(treadBehStruc.resampY)/2));
%     for i = 1:length(cCell)
%         C(i,cCell{i})=1;
%     end
% end

% %% format position vector
% totalFrames = size(C,2);
% resampY = treadBehStruc.resampY;
% downSamp = round(length(resampY)/totalFrames);  % find downsample rate
% treadPos = resampY(1:downSamp:end); % downsample position vector
% treadPos = treadPos/max(treadPos);  % normalize position vector

filename = findLatestFilename('_goodSeg_');
load(filename); 

disp(['Calculating cue shift tuning for ' filename]);

if nargin==1
    if ischar(varargin{1})
        load(findLatestFilename('treadBehStruc'));
    else
        treadBehStruc = varargin{1};
    end
else
    treadName = uigetfile('*.mat', 'Select treadBehStruc');
    load(treadName);
end

%% format other stuff
T = treadBehStruc.adjFrTimes(1:2:end);

[pksCell1, posLap1, pksCell2, posLap2, lapFrInds] = sepCueShiftLapSpkTimes(pksCell, goodSeg, treadBehStruc);

posLap1 = posLap1/max(posLap1); posLap2 = posLap2/max(posLap2);

%cCell = C;
C1 = zeros(length(pksCell1),length(posLap1));
C2 = zeros(length(pksCell2),length(posLap2));
for i = 1:length(pksCell1)
    C1(i,pksCell1{i})=1;
    C2(i,pksCell2{i})=1;
end

disp('Calc lapType1 tuning'); tic;
shuffN = 1000;
spikes = C1; treadPos = posLap1;
PCLappedSess1 = computePlaceCellsLappedWithEdges3(spikes, treadPos, T(1:length(posLap1)), shuffN);
toc;

disp('Calc lapType2 tuning'); tic;
spikes = C2; treadPos = posLap2;
PCLappedSess2 = computePlaceCellsLappedWithEdges3a(spikes, treadPos, T(1:length(posLap2)), shuffN);
toc;

cueShiftStruc.PCLappedSess1 = PCLappedSess1;
cueShiftStruc.PCLappedSess2 = PCLappedSess2;

cueShiftStruc.pksCell1=pksCell1; cueShiftStruc.posLap1=posLap1; 
cueShiftStruc.pksCell2=pksCell2; cueShiftStruc.posLap2=posLap2; cueShiftStruc.lapFrInds=lapFrInds;

pc = find(PCLappedSess1.Shuff.isPC==1);
posRates1 = PCLappedSess1.posRates(pc,:);
[maxVal, maxInd] = max(posRates1');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;
posRates1 = posRates1(sortInd,:);

posRates2 = PCLappedSess2.posRates(pc,:);
posRates2 = posRates2(sortInd,:);

figure('Position', [0 0 800 800]);
subplot(2,2,1);
colormap(jet);
imagesc(posRates1);
xlabel('position');
title('LapType1');

% tuning of lapType2 PCs
subplot(2,2,2);
colormap(jet);
imagesc(posRates2);
xlabel('position');
title('LapType2');

% and mean of each
subplot(2,2,3);
plot(mean(posRates1,1));
hold on;
plot(mean(posRates2,1),'g');
title('posRates1=b, posRates2=g');


