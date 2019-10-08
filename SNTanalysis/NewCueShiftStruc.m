
New4sdIROmitStruc = {};

for i=1:9
C=IRShiftStruc{i}.TotalCell{1,3}.C2p;
treadBehStruc = IRShiftStruc{i}.TotalCell{1,2};

 % pksCell 4 sd now   
pksCell={};
for seg=1:size(C,1)
    pksCell{seg}=clayCaTransients(C(seg,:),15);
end
[cueShiftStruc] = wrapCueShiftTuningMultSess(pksCell, treadBehStruc);
New4sdIROmitStruc{i}=cueShiftStruc;
[MidCueCellInd, EdgeCueCellInd, nonCueCellInd,  refLapType, shiftLapType] =  AllCueCells(cueShiftStruc);
    
PCLappedSessCue = cueShiftStruc.PCLappedSessCell{refLapType};
posRatesRef = cueShiftStruc.PCLappedSessCell{refLapType}.posRates;
posRatesOmit= cueShiftStruc.PCLappedSessCell{end}.posRates;

Allpc = find(PCLappedSessCue.Shuff.isPC==1);
New4sdIROmitStruc{i}.RefposRatesAllpc = posRatesRef(Allpc,:);
New4sdIROmitStruc{i}.OmposRatesAllpc = posRatesOmit(Allpc,:);
%New4sdIROmitStruc{i}.ShposRatesAllpc = posRatesShift(Allpc,:);
New4sdIROmitStruc{i}.RefposRatesMidCue= posRatesRef(MidCueCellInd,:);
New4sdIROmitStruc{i}.RefposRatesEdgeCue = posRatesRef(EdgeCueCellInd,:);
New4sdIROmitStruc{i}.RefposRatesnonCue = posRatesRef(nonCueCellInd,:);
%New4sdIROmitStruc{i}.ShiftposRatesMidCue= posRatesShift(MidCueCellInd,:);
%New4sdIROmitStruc{i}.ShiftposRatesEdgeCue = posRatesShift(EdgeCueCellInd,:);
%New4sdIROmitStruc{i}.ShiftposRatesnonCue = posRatesShift(nonCueCellInd,:);
New4sdIROmitStruc{i}.OmposRatesMidCue= posRatesOmit(MidCueCellInd,:);
New4sdIROmitStruc{i}.OmposRatesEdgeCue = posRatesOmit(EdgeCueCellInd,:);
New4sdIROmitStruc{i}.OmposRatesnonCue = posRatesOmit(nonCueCellInd,:);

end
save('New4sdIROmitStruc.mat', 'New4sdIROmitStruc');
%%
 RefPCposRates = []; RefMCposRates = []; RefECposRates = []; RefNCposRates = []; 
 OmPCposRates = []; OmMCposRates = []; OmECposRates = []; OmNCposRates = []; 
for i=1:6
    
RefPCposRates=[RefPCposRates; New4sdIROmitStruc{i}.RefposRatesAllpc];
%ShPCposRates=[ShPCposRates; ShposRatesAllpc];
OmPCposRates=[OmPCposRates; New4sdIROmitStruc{i}.ShposRatesAllpc];

RefMCposRates=[RefMCposRates; New4sdIROmitStruc{i}.RefposRatesMidCue];
%ShMCposRates=[ShMCposRates; ShiftposRatesMidCue];
OmMCposRates=[OmMCposRates; New4sdIROmitStruc{i}.ShiftposRatesMidCue];

RefECposRates=[RefECposRates; New4sdIROmitStruc{i}.RefposRatesEdgeCue];
%ShECposRates=[ShECposRates; ShiftposRatesEdgeCue];
OmECposRates=[OmECposRates; New4sdIROmitStruc{i}.ShiftposRatesEdgeCue];
RefNCposRates=[RefNCposRates;New4sdIROmitStruc{i}.RefposRatesnonCue];
%ShNCposRates=[ShNCposRates; ShiftposRatesnonCue];
OmNCposRates=[OmNCposRates; New4sdIROmitStruc{i}.ShiftposRatesnonCue];
end

% for i=5:8
% RefPCposRates=[RefPCposRates; New4sdToneStruc{i}.RefposRatesAllpc];
% %ShPCposRates=[ShPCposRates; ShposRatesAllpc];
% OmPCposRates=[OmPCposRates; New4sdToneStruc{i}.ShposRatesAllpc];
% 
% RefMCposRates=[RefMCposRates; New4sdToneStruc{i}.RefposRatesMidCue];
% %ShMCposRates=[ShMCposRates; ShiftposRatesMidCue];
% OmMCposRates=[OmMCposRates; New4sdToneStruc{i}.ShposRatesAllpc];
% 
% RefECposRates=[RefECposRates; New4sdToneStruc{i}.RefposRatesEdgeCue];
% %ShECposRates=[ShECposRates; ShiftposRatesEdgeCue];
% OmECposRates=[OmECposRates; New4sdToneStruc{i}.ShposRatesAllpc];
% RefNCposRates=[RefNCposRates;RefposRatesnonCue];
% %ShNCposRates=[ShNCposRates; ShiftposRatesnonCue];
% OmNCposRates=[OmNCposRates; New4sdToneStruc{i}.ShposRatesAllpc];
% end

RefPCposRates58=[];ShPCposRates58=[]; OmPCposRates58=[];
RefMCposRates58=[];ShMCposRates58=[];OmMCposRates58=[];
RefECposRates58=[];ShECposRates58=[];OmECposRates58=[];
RefNCposRates58=[];ShNCposRates58=[];OmNCposRates58=[];

for i=1:6
RefPCposRates58=[RefPCposRates58; New4sdIROmitStruc{i}.RefposRatesAllpc];
ShPCposRates58=[ShPCposRates58; New4sdIROmitStruc{i}.ShposRatesAllpc];
OmPCposRates58=[OmPCposRates58; New4sdIROmitStruc{i}.OmposRatesAllpc];

RefMCposRates58=[RefMCposRates58; New4sdIROmitStruc{i}.RefposRatesMidCue];
ShMCposRates58=[ShMCposRates58; New4sdIROmitStruc{i}.ShiftposRatesMidCue];
OmMCposRates58=[OmMCposRates58; New4sdIROmitStruc{i}.OmposRatesMidCue];

RefECposRates58=[RefECposRates58; New4sdIROmitStruc{i}.RefposRatesEdgeCue];
ShECposRates58=[ShECposRates58; New4sdIROmitStruc{i}.ShiftposRatesEdgeCue];
OmECposRates58=[OmECposRates58; New4sdIROmitStruc{i}.OmposRatesEdgeCue];
RefNCposRates58=[RefNCposRates58;New4sdIROmitStruc{i}.RefposRatesnonCue];
ShNCposRates58=[ShNCposRates58; New4sdIROmitStruc{i}.ShiftposRatesnonCue];
OmNCposRates58=[OmNCposRates58; New4sdIROmitStruc{i}.OmposRatesnonCue];
end
    
    
%%


  posRate={};
  posRate{1,1}= RefPCposRates58;
  posRate{1,2}= ShPCposRates58;
  posRate{1,3}= OmPCposRates58;
%gaussian smoothing
g=[];
g = fspecial ('gaussian', [10, 1], 2.5); 
p = posRate{1, 1}; s = posRate{1, 2}; o = posRate{1, 3};
goodBins = [zeros(100, 1); zeros(100, 1) + 1; zeros(100, 1)];
pSmooth = convWith(repmat(p', [3, 1]), g);
pSmooth = pSmooth(goodBins == 1, :)';
sSmooth = convWith(repmat(s', [3, 1]), g);
sSmooth = sSmooth(goodBins == 1, :)';
  oSmooth = convWith(repmat(o', [3, 1]), g);
  oSmooth = oSmooth(goodBins == 1, :)';

posRateSm={};
posRateSm{1,1}= pSmooth;
posRateSm{1,2}= sSmooth;
posRateSm{1,3}= oSmooth;
  
%%
[~, s1] = nanmax(posRateSm{1}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(posRateSm)
    posRateSm{i} = posRateSm{i}(s2, :);
end
figure;
maxRate = Inf;
CLims = [0, 0.5];
for i = 1:3
    subplot(1, 3, i);
    c = posRateSm{i};
    c(c> maxRate) = maxRate;
    imagesc(c);
    set (gca, 'CLim', CLims)
end
suptitle('nonNormRates');
colormap hot;



figure; shadedErrorBarAG([],mean(posRateSm{1}), (std(posRateSm{1})/(sqrt(length(posRateSm{1})))), 'k', 1);
hold on;
shadedErrorBarAG([],mean(posRateSm{2}), (std(posRateSm{2})/(sqrt(length(posRateSm{2})))), 'r', 1);
  hold on;
  shadedErrorBarAG([],mean(posRateSm{3}), (std(posRateSm{3})/(sqrt(length(posRateSm{3})))), 'b', 1);
hold on; plot([45;45], [0, 0.06], '--k');
hold on; plot([55;55], [0, 0.06], '--k');
hold on; plot([5;5], [0, 0.06], '--k');
hold on; plot([95;95], [0, 0.06], '--k'); 

