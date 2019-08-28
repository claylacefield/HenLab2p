close all; 
load(findLatestFilename('2PcueShiftStruc')); 
% calculate inhibition
[posBinNumCells, pcRatesBlanked, pcOmitRatesBlanked] = cuePosInhib2P(cueShiftStruc);
outPCRateNon= mean([nanmean(mean(pcRatesBlanked(:,11:44),2),1) nanmean(mean(pcRatesBlanked(:,56:89),2),1)]);
outPCRateEdge= mean([nanmean(mean(pcRatesBlanked(:,1:10),2),1) nanmean(mean(pcRatesBlanked(:,90:100),2),1)]);
outPCRateMid = nanmean(mean(pcRatesBlanked(:,45:55),2),1);
outPCRateMidOmit = nanmean(mean(pcOmitRatesBlanked(:,45:55),2),1);

%outPCIRAll=[]; pathIRCell = {};

outPCMice=[]; 
outPCMice = [outPCRateNon , outPCRateEdge, outPCRateMid, outPCRateMidOmit ];
outPCIRAll=[outPCIRAll; outPCMice];
pathIRCell = [pathIRCell pwd];

%%
%  SpatPropCueCellsmice.outPCtitles = {'outPCRateNon', 'outPCRateEdge', 'outPCRateMid', 'outPCRateMidOmit'};
  SpatPropCueCellsmice.outPCIRAll = outPCIRAll;
%  SpatPropCueCellsmice.outPCAll = outPCAll;
%  SpatPropCueCellsmice.pathCell  = pathCell;
  SpatPropCueCellsmice.pathIRCell  = pathIRCell;
 save('SpatPropCueCellsmice.mat', 'SpatPropCueCellsmice');
