function wrapTuningNewClay()


% shuffle
[shufBinCaAvg] = fabShuf(ca, pos, numBins, 1);

% circ tuning of shuffled
[meanLength, meanAngRad] = clayMRL(shufBinCaAvg, 1);
circ95 = prctile(meanLength, 95); % 95% of shuff MRL dist

% and orig
[binCaAvg] = binByLocation(ca, pos, numBins);
[origMRL, origMRA] = clayMRL(binCaAvg, 1);


% now non-circ
maxs = max(shufBinCaAvg,[],1); % peaks of shuffled
prcMax = prctile(maxs,95);
% BUT should probably smooth first, because absolute peak has lots of
% noise.
