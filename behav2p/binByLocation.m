function [binCaAvg] = binByLocation(ca, pos)



[counts, edges, binInd] = histcounts(pos, 100);


for i = 1:100
    binCa = ca(binInd == i);
    binCaAvg(i) = mean(binCa);
end
