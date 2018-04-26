function [unitTuningStruc] = wrapTuningNewClay(C, toPlot);

%% USAGE: [unitTuningStruc] = wrapTuningNewClay(C, toPlot);
% calculate tuning pvalues based upon circular and non-circular methods

% Clay
% 042518
% Circular tuning working (my method, clayMRL), and other analyses

numBins = 100;

[out, PCLappedSess] = wrapAndresPlaceFieldsClay(C, 1);
unitTuningStruc.outPC = out;
unitTuningStruc.PCLappedSess = PCLappedSess;

disp('Calculating pval based upon shuffled position');

%% Circular tuning

load(findLatestFilename('treadBehStruc'));
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
pos = treadPos/max(treadPos);  % normalize position vector

for i = 1:size(C,1)
%ca = cells(i,:);
ca = C(i,:);
disp(['Processing cell ' num2str(i) ' out of ' num2str(size(C,1))]);
[binCaAvg] = binByLocation(ca, pos, numBins);
[origMRL, origMRA] = clayMRL(binCaAvg, numBins, toPlot);
mrl(i) = origMRL; mra(i) = origMRA;
pvals(i) = unitCircTuningClay(ca, pos, numBins, 0);
end
unitTuningStruc.mrl=mrl; unitTuningStruc.mra=mra;
unitTuningStruc.pvals = pvals;