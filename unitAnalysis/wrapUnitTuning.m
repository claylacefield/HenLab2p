function [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning(C, treadBehStruc, numbins, rayThresh);




[goodSegPosPkStruc] = findGoodSegPksCaiman(C, treadBehStruc, numbins);


toPlot = 0;
[circStatStruc] = circStatClay(goodSegPosPkStruc.greatSegPosPks, toPlot);

% plot only well tuned units (Rayleigh < rayThresh, e.g. 0.01 or 0.05)
wellTunedInd = find(circStatStruc.uniform(:,1)< rayThresh);
[popCaPos, popCaPosNorm] = plotGoodSegTuning(C, goodSegPosPkStruc.greatSeg(wellTunedInd), treadBehStruc, 2, 1);


plotTunedUnitVect(circStatStruc);
