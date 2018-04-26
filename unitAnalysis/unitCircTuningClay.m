function [pval] = unitCircTuningClay(ca, pos, numBins, toPlot);

%% USAGE: [pval] = wrapTuningNewClay(ca, pos, numBins, toPlot);
% calculate tuning pvalues based upon circular and non-circular methods

% Clay
% 042318
% Circular tuning working (my method, clayMRL), but not non-circular yet.

disp('Calculating pval based upon shuffled position');
%tic;

% shuffle
[shufBinCaAvg] = fabShuf(ca, pos, numBins, toPlot);

%% Circular tuning

% circ tuning of shuffled
[shuffMRL, meanAngRad] = clayMRL(shufBinCaAvg, numBins, toPlot);
circ95 = prctile(shuffMRL, 95); % 95% of shuff MRL dist

% and orig
[binCaAvg] = binByLocation(ca, pos, numBins);
[origMRL, origMRA] = clayMRL(binCaAvg, numBins, toPlot);

pval = 1-length(find(shuffMRL<origMRL))/1000;

if pval==0
    pval = 0.001;
end

%% now non-circ
maxs = max(shufBinCaAvg,[],1); % peaks of shuffled
prcMax = prctile(maxs,95);
% BUT should probably smooth first, because absolute peak has lots of
% noise.

%toc;