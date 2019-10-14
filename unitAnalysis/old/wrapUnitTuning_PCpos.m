function [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning_PCpos(C, treadBehStruc, numbins);




[goodSegPosPkStruc] = findGoodSegPksCaiman(C, treadBehStruc, numbins);



[circStatStruc] = circStatClay(goodSegPosPkStruc.greatSegPosPks);

% plot only well tuned units
wellTunedInd = find(circStatStruc.uniform(:,1)<0.01);

[popCaPos, popCaPosNorm] = plotGoodSegTuning_PCpos(C, goodSegPosPkStruc.greatSeg(wellTunedInd), treadBehStruc, 2, 1);


plotTunedUnitVect(circStatStruc);