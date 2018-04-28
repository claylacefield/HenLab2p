function [unitTuningStruc] = wrapTuningNewClay(C, fps, toPlot, calcPvals);

%% USAGE: [unitTuningStruc] = wrapTuningNewClay(C, fps, toPlot, calcPvals);
% calculate tuning pvalues based upon circular and non-circular methods

% Clay
% 042518
% Circular tuning working (my method, clayMRL), and other analyses

numBins = 100;

% load behavior from latest file in current directory
load(findLatestFilename('treadBehStruc'));

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
[out, PCLappedSess] = wrapAndresPlaceFieldsClay(C, 0, treadBehStruc);
unitTuningStruc.outPC = out;
unitTuningStruc.PCLappedSess = PCLappedSess;

% now for non-movement epochs
[outNon, PCLappedSess] = wrapAndresPlaceFieldsClay(C, 0, treadBehStruc, -3);
unitTuningStruc.outNonmovPC = outNon;

disp('Calculating pval based upon shuffled position');

%% Circular tuning

[binCaAvg] = binByLocation(C, pos, numBins);
[origMRL, origMRA] = clayMRL(binCaAvg, numBins, 0);
mrl = origMRL; mra = origMRA;
unitTuningStruc.mrl=mrl; unitTuningStruc.mra=mra;

if calcPvals == 1
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

[maxVal, maxInd] = max(posRates');
[newInd, oldInd] = sort(maxInd);
posRates2 = posRates(oldInd,:);

% for i = 1:size(posRates,1)
%     posRates2(i,:) = posRates2(i,:)/max(posRates2(i,:));
% end

figure; 
subplot(2,2,1);
colormap(jet);
imagesc(posRates2);


vel = treadBehStruc.vel(1:30/fps:end);
vel = fixVel(vel);
posVel = binByLocation(vel, pos, numBins);
%figure; plot(posVel);

%figure; 
subplot(2,2,3);
plot(posVel/max(posVel)*max(mean(posRates2,1)),'g');
hold on;
plot(mean(posRates2,1));
plot(mean(outNon.posRates,1), 'r');
title('movement cells (b), non-movement (r), vs. vel (g)');

subplot(2,2,2);
compass(mrl.*cos(mra), mrl.*sin(mra));

end