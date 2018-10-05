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
BigposAndSpkArray {1,10}.C=C;
BigposAndSpkArray {1,10}.pksgoodSeg=pksgoodSeg;
BigposAndSpkArray {1,10}.treadBehStruct=treadBehStruc;
BigposAndSpkArray {1,10}.filename='1217_MM7_1500-001';

