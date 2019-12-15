function cueCellTypePlast()


% find cue cell types
[cueCellStruc] = findCueCells(cueShiftStruc, eventName, segDictCode, toPlot);

cueCellInd = cueCellStruc.midCueCellInd;
startCellInd = cueCellStruc.startCueCellInd;
nonCueCellInd = cueCellStruc.nonCueCellInd;
placeCellInd = cueCellStruc.placeCellInd;

cellInd = nonCueCellInd;
for i=1:length(cellInd)
    try
    [lapAvAmp, lapRate, lapCa] = findCaPkAmpLap(C(cellInd(i),:), 0);
    mdl = fitlm(1:length(lapRate),lapRate);
    slope(i) = mdl.Coefficients.Estimate(2);
    catch
    end
end
figure; 
plot(slope);