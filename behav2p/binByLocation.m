function [binCaAvg] = binByLocation(ca, pos, numBins);

% USAGE: [binCaAvg] = binByLocation(ca, pos, numBins);

if size(ca,1)>size(ca,2)
    ca = ca';
end

[counts, edges, binInd] = histcounts(pos, numBins);

for j=1:size(ca,1)
    for i = 1:numBins
        inds = find(binInd==i);
        binCa = ca(j,inds);
        binCaAvg(j,i) = mean(binCa);
    end
end