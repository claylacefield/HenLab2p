function [unitTuningStruc] = wrapTuningNewClay(C, fps, toPlot, calcPvals);

%% USAGE: [unitTuningStruc] = wrapTuningNewClay(C, fps, toPlot, calcPvals);
% calculate tuning pvalues based upon circular and non-circular methods

% Clay
% 042518
% Circular tuning working (my method, clayMRL), and other analyses

numBins = 100;

% load behavior from latest file in current directory
try
load(findLatestFilename('treadBehStruc'));
catch
    [treadBehStruc] = procHen2pBehav('auto');
end

% if input is cell array of peaks, make matrix
if iscell(C)
    cCell = C;
    C = zeros(length(C),round(length(treadBehStruc.resampY)/(30/fps)));
    for i = 1:length(cCell)
        C(i,cCell{i})=1;
    end
end

% format position vector
totalFrames = size(C,2);
resampY = treadBehStruc.resampY;
downSamp = round(length(resampY)/totalFrames);  % find downsample rate
treadPos = resampY(1:downSamp:end); % downsample position vector
pos = treadPos/max(treadPos);  % normalize position vector

% place cell analysis (currently using Andres's but it's pretty much same
% as my earlier one)
disp('Analyzing tuning for movement epochs');
tic;
[out, PCLappedSess] = wrapAndresPlaceFieldsClay(C, 0, treadBehStruc);
unitTuningStruc.outPC = out;
unitTuningStruc.PCLappedSess = PCLappedSess;
toc;

% now for non-movement epochs
disp('...and non-movement');
tic;
[outNon, PCLappedSess] = wrapAndresPlaceFieldsClay(C, 0, treadBehStruc, -3);
unitTuningStruc.outNonmovPC = outNon;
toc;

%% Circular tuning
disp('Computing circular tuning');
tic;
[binCaAvg] = binByLocation(C, pos, numBins);
[origMRL, origMRA] = clayMRL(binCaAvg, numBins, 0);
toc;
mrl = origMRL; mra = origMRA;
unitTuningStruc.mrl=mrl; unitTuningStruc.mra=mra;

if calcPvals == 1
    
disp('Calculating pval based upon shuffled position');
    for i = 1:size(C,1)
        %ca = cells(i,:);
        ca = C(i,:);
        disp(['Processing cell ' num2str(i) ' out of ' num2str(size(C,1))]);
        pvals(i) = unitCircTuningClay(ca, pos, numBins, 0);
    end
    unitTuningStruc.pvals = pvals;
end

%% plotting

%% plotting
if toPlot == 1 || toPlot == 2
    
    if toPlot == 2 % to only plot place cells
        pcInd = find(out.Shuff.isPC);
        posRates = out.posRates(pcInd,:);
    else
        posRates = out.posRates;%(pcInd,:);
    end
    
    notNullRows = find(sum(posRates,2)~=0);
    posRates2 = posRates(notNullRows,:);
    
    [maxVal, maxInd] = max(posRates2');
    [newInd, oldInd] = sort(maxInd);
    posRates2 = posRates2(oldInd,:);
    
    % for i = 1:size(posRates,1)
    %     posRates2(i,:) = posRates2(i,:)/max(posRates2(i,:));
    % end
    
    figure;
    subplot(2,3,1);
    colormap(jet);
    imagesc(posRates2);
    title('mov epochs');
    xlabel('position');
    
    subplot(2,3,2);
    imagesc(outNon.posRates(oldInd,:));
    title('non-mov');
    xlabel('position');
    
    vel = treadBehStruc.vel(1:30/fps:end);
    vel = fixVel(vel);
    posVel = binByLocation(vel, pos, numBins);
    %figure; plot(posVel);
    
    %figure;
    subplot(2,3,4);
    plot(posVel/max(posVel)*max(mean(posRates2,1)),'g');
    hold on;
    plot(mean(posRates2,1));
    plot(mean(outNon.posRates,1), 'r');
    title('mov. epoch (b), non-mov. (r), vel (g)');
    ylabel('mean rate');
    xlabel('position');
    
    subplot(2,3,3);
    compass(mrl.*cos(mra), mrl.*sin(mra));
    title('unit tuning vector');
    
    subplot(2,3,5);
    hist(maxInd);
    ylabel('#units');
    xlabel('position');
    
end