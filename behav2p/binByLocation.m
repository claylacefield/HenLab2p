function [binCaAvg] = binByLocation(ca, pos, numBins)



[counts, edges, binInd] = histcounts(pos, numBins);


for i = 1:numBins
    binCa = ca(binInd == i);
    binCaAvg(i) = mean(binCa);
end
