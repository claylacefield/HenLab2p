%%to get only goodsepks,leave others blank so it keeps correct seg index
%%from C
allIndexes = 1: length (pksCell);
goodInd = ismember(allIndexes, goodSeg);
badInd = find (~goodInd);
pksgoodSeg = pksCell;
for i = 1:length(badInd)
    pksgoodSeg{badInd(i)}= [];
end
