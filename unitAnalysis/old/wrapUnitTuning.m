function [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning(C, treadBehStruc, numbins, rayThresh);

%% USAGE: [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning(C, treadBehStruc, numbins, rayThresh);
% Clay 2017
%
% Instructions:
% 1.) load in session_segDict.mat (for C unit temporal profiles)
% 2.) load in treadBehStruc, or process from procHen2pBehav.m
% 3.) numbins = # of spatial bins over belt
% 4.) rayThesh = Rayleigh circular tuning threshold for well-tuned, "place"
% cells

% calc unit firing/position
[goodSegPosPkStruc] = findGoodSegPksCaiman(C, treadBehStruc, numbins);

% compute unit spatial tuning
toPlot = 0;
[circStatStruc] = circStatClay(goodSegPosPkStruc.greatSegPosPks, toPlot);

% plot only well tuned units (Rayleigh < rayThresh, e.g. 0.01 or 0.05)
wellTunedInd = find(circStatStruc.uniform(:,1)< rayThresh);
[popCaPos, popCaPosNorm] = plotGoodSegTuning(C, goodSegPosPkStruc.greatSeg(wellTunedInd), treadBehStruc, 2, 1);

% and plot mean tuning vectors
plotTunedUnitVect(circStatStruc);



