function [binCaAvg] = binByLocation(ca, pos, numBins);

% USAGE: [binCaAvg] = binByLocation(ca, pos, numBins);

[counts, edges, binInd] = histcounts(pos, numBins);

for j=1:size(ca,1)
    for i = 1:numBins
        inds = find(binInd==i);
        binCa = ca(j,inds);
        binCaAvg(j,i) = mean(binCa);
    end
end