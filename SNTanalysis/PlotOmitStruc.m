%collect everything in a structure
 PlotShiftStruc = {};
 RefPCposRates = []; RefMCposRates = []; RefECposRates = []; RefNCposRates = []; 
OmPCposRates = []; OmMCposRates = []; OmECposRates = []; OmNCposRates = []; 
close all;
 load(findLatestFilename('treadBehStruc'));
 load(findLatestFilename('_seg2P_'));
load(findLatestFilename('2PcueShiftStruc'));

TotalCell={};
TotalCell{1}=pwd;
TotalCell{2}=treadBehStruc;
TotalCell{3}=seg2P;
TotalCell{4}=cueShiftStruc;

[MidCueCellInd, EdgeCueCellInd, nonCueCellInd, refLapType, shiftLapType] =  AllCueCells(cueShiftStruc);
plotACByCellType (seg2P, MidCueCellInd, EdgeCueCellInd, nonCueCellInd);

% now collect posRates



PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
posRatesRef = cueShiftStruc.PCLappedSessCell{refLapType}.posRates;
posRatesOmit= cueShiftStruc.PCLappedSessCell{end}.posRates;
Allpc = find(PCLappedSessCue.Shuff.isPC==1);
RefposRatesAllpc = posRatesRef(Allpc,:);
OmitposRatesAllpc = posRatesOmit(Allpc,:);
RefposRatesMidCue= posRatesRef(MidCueCellInd,:);
RefposRatesEdgeCue = posRatesRef(EdgeCueCellInd,:);
RefposRatesnonCue = posRatesRef(nonCueCellInd,:);
OmitposRatesMidCue= posRatesOmit(MidCueCellInd,:);
OmitposRatesEdgeCue = posRatesOmit(EdgeCueCellInd,:);
OmitposRatesnonCue = posRatesOmit(nonCueCellInd,:);

PlotShiftStruc{1}.TotalCell=TotalCell;
PlotShiftStruc{1}.RefposRatesAllpc=RefposRatesAllpc;
PlotShiftStruc{1}.OmitposRatesAllpc=OmitposRatesAllpc;
PlotShiftStruc{1}.RefposRatesMidCue=RefposRatesMidCue;
PlotShiftStruc{1}.OmitposRatesMidCue=OmitposRatesMidCue;
PlotShiftStruc{1}.RefposRatesEdgeCue=RefposRatesEdgeCue;
PlotShiftStruc{1}.OmitposRatesEdgeCue=OmitposRatesEdgeCue;
PlotShiftStruc{1}.RefposRatesnonCue=RefposRatesnonCue;
PlotShiftStruc{1}.OmitposRatesnonCue=OmitposRatesnonCue;
%save ('PlotShiftStruc.mat', 'PlotShiftStruc');

RefPCposRates=[RefPCposRates; RefposRatesAllpc];
OmPCposRates=[OmPCposRates; OmitposRatesAllpc];
RefMCposRates=[RefMCposRates; RefposRatesMidCue];
OmMCposRates=[OmMCposRates; OmitposRatesMidCue];
RefECposRates=[RefECposRates; RefposRatesEdgeCue];
OmECposRates=[OmECposRates; OmitposRatesEdgeCue];
RefNCposRates=[RefNCposRates;RefposRatesnonCue];
OmNCposRates=[OmNCposRates; OmitposRatesnonCue];


%%
TotalOmposRates ={};
TotalOmposRates.RefPCposRates=RefPCposRates;
TotalOmposRates.OmPCposRates=ShPCposRates;
TotalOmposRates.RefMCposRates=RefMCposRates;
TotalOmposRates.OmMCposRates=ShMCposRates;
TotalOmposRates.RefECposRates=RefECposRates;
TotalOmposRates.OmECposRates=ShECposRates;
TotalOmposRates.RefNCposRates=RefNCposRates;
TotalOmposRates.OmNCposRates=ShNCposRates;
 save ('OmitposRatesnonCue.mat', 'OmitposRatesnonCue');
