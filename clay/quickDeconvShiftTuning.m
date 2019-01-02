function [unitTuningStruc] = quickDeconvShiftTuning()

load(findLatestFilename('_deconvC_'));

fps=15; toPlot=0; calcPvals=0;
[unitTuningStruc] = wrapTuningNewClay(deconvC, fps, toPlot, calcPvals);

pc = find(unitTuningStruc.PCLappedSess.Shuff.isPC==1);

load(findLatestFilename('_treadBehStruc_'));

goodSeg = 1:size(deconvC,1);
plotLapTypeTuning(unitTuningStruc, treadBehStruc, goodSeg, 1, 3);


