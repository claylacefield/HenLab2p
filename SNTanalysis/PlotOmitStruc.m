%collect everything in a structure
  IROmitStruc = {};
%   RefPCposRates = []; RefMCposRates = []; RefECposRates = []; RefNCposRates = []; 
%  OmPCposRates = []; OmMCposRates = []; OmECposRates = []; OmNCposRates = []; 
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
%plotACByCellType (seg2P, MidCueCellInd, EdgeCueCellInd, nonCueCellInd);

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

IROmitStruc{9}.TotalCell=TotalCell;
IROmitStruc{9}.RefposRatesAllpc=RefposRatesAllpc;
IROmitStruc{9}.OmitposRatesAllpc=OmitposRatesAllpc;
IROmitStruc{9}.RefposRatesMidCue=RefposRatesMidCue;
IROmitStruc{9}.OmitposRatesMidCue=OmitposRatesMidCue;
IROmitStruc{9}.RefposRatesEdgeCue=RefposRatesEdgeCue;
IROmitStruc{9}.OmitposRatesEdgeCue=OmitposRatesEdgeCue;
IROmitStruc{9}.RefposRatesnonCue=RefposRatesnonCue;
IROmitStruc{9}.OmitposRatesnonCue=OmitposRatesnonCue;
save ('IROmitStruc.mat', 'IROmitStruc');

% RefPCposRates=[RefPCposRates; RefposRatesAllpc];
% OmPCposRates=[OmPCposRates; OmitposRatesAllpc];
% RefMCposRates=[RefMCposRates; RefposRatesMidCue];
% OmMCposRates=[OmMCposRates; OmitposRatesMidCue];
% RefECposRates=[RefECposRates; RefposRatesEdgeCue];
% OmECposRates=[OmECposRates; OmitposRatesEdgeCue];
% RefNCposRates=[RefNCposRates;RefposRatesnonCue];
% OmNCposRates=[OmNCposRates; OmitposRatesnonCue];


% %%
% TotalOmposRates ={};
% TotalOmposRates.RefPCposRates=RefPCposRates;
% TotalOmposRates.OmPCposRates=OmPCposRates;
% TotalOmposRates.RefMCposRates=RefMCposRates;
% TotalOmposRates.OmMCposRates=OmMCposRates;
% TotalOmposRates.RefECposRates=RefECposRates;
% TotalOmposRates.OmECposRates=OmECposRates;
% TotalOmposRates.RefNCposRates=RefNCposRates;
% TotalOmposRates.OmNCposRates=OmNCposRates;
%  save ('TotalOmposRates.mat', 'TotalOmposRates');

%% plot cue shift omit:
% posRate={};
% posRate{1,1}= ShiftStruc.;
% posRate{1,2}= OmPCposRates;
% [~, s1] = nanmax(posRate{1}, [], 2);
% [~, s2] = sort(s1);
% for i = 1:length(posRate)
%     posRate{i} = posRate{i}(s2, :);
% end
% figure;
% maxRate = Inf;
% CLims = [0, 0.1];
% for i = 1:2
%     subplot(1, 2, i);
%     c = posRate{i};
%     c(c> maxRate) = maxRate;
%     imagesc(c);
%     set (gca, 'CLim', CLims)
% end
% suptitle('nonNormRates');
% colormap hot;
