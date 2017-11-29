function [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning(C, treadBehStruc, numbins);




[goodSegPosPkStruc] = findGoodSegPksCaiman(C, treadBehStruc, numbins);


toPlot = 0;
[circStatStruc] = circStatClay(goodSegPosPkStruc.greatSegPosPks, toPlot);

% plot only well tuned units
wellTunedInd = find(circStatStruc.uniform(:,1)<0.01);
[popCaPos, popCaPosNorm] = plotGoodSegTuning(C, goodSegPosPkStruc.greatSeg(wellTunedInd), treadBehStruc, 2, 1);


plotTunedUnitVect(circStatStruc);
