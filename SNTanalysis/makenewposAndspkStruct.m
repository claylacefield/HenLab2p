%%to get only goodsegpks,leave others blank so it keeps correct seg index
%%from C
allIndexes = 1: length (pksCell);
goodInd = ismember(allIndexes, goodSeg);
badInd = find (~goodInd);
pksgoodSeg = pksCell;
for i = 1:length(badInd)
    pksgoodSeg{badInd(i)}= [];
end

[treadBehStruc] = procHen2pBehav();
BigposAndSpkArray {1,3}.C=C;
BigposAndSpkArray {1,3}.pksgoodSeg=pksgoodSeg;
BigposAndSpkArray {1,3}.treadBehStruct=treadBehStruc;
BigposAndSpkArray {1,3}.filename='XIR.0718.02_500-003';

