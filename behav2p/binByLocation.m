function [binCaAvg] = binByLocation(ca, pos, numBins);

% USAGE: [binCaAvg] = binByLocation(ca, pos, numBins);

if size(ca,1)>size(ca,2)
    ca = ca';
end

if iscell(ca)
    cCell = ca;
    ca = zeros(length(ca),length(pos));
    for i = 1:length(cCell)
        ca(i,cCell{i})=1;
    end
end



[counts, edges, binInd] = histcounts(pos, numBins);

for j=1:size(ca,1)
    %try
    for i = 1:numBins
        inds = find(binInd==i);
        binCa = ca(j,inds);
        binCaAvg(j,i) = mean(binCa);
    end
    %catch
    %end
end