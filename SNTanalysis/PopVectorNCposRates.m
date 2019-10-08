%% by lap
%cells 1-9 2 lapTypes, cells 10-17 3 lapTypes
CueOmitLappedSess={};
for j=1:4
PCLappedSessCell = New4sdTactStruc{j}.PCLappedSessCell;
lapCueStruc = New4sdTactStruc{j}.lapCueStruc;
pksCellCell= New4sdTactStruc{j}.pksCellCell;
[MidCueCellInd, EdgeCueCellInd, nonCueCellInd, refLapType, shiftLapType] =  AllCueCells(PCLappedSessCell,lapCueStruc,pksCellCell);
PCLappedSessCue = PCLappedSessCell{1,refLapType};
pksCell=pksCellCell{1,refLapType};
PCLappedSessOmit = PCLappedSessCell{1,shiftLapType};
CueOmitLappedSess{j}.PCLappedSessCue=PCLappedSessCue;
CueOmitLappedSess{j}.PCLappedSessOmit=PCLappedSessOmit;
CueOmitLappedSess{j}.pksCell=pksCell;
CueOmitLappedSess{j}.MidCueCellInd=MidCueCellInd;
CueOmitLappedSess{j}.EdgeCueCellInd=EdgeCueCellInd;
CueOmitLappedSess{j}.nonCueCellInd=nonCueCellInd;
end
for j=5:8
PCLappedSessCell = New4sdTactStruc{j}.PCLappedSessCell;
lapCueStruc = New4sdTactStruc{j}.lapCueStruc;
pksCellCell= New4sdTactStruc{j}.pksCellCell;
[MidCueCellInd, EdgeCueCellInd, nonCueCellInd, refLapType, shiftLapType] =  AllCueCells(PCLappedSessCell,lapCueStruc,pksCellCell);
PCLappedSessCue = PCLappedSessCell{1,refLapType};
PCLappedSessOmit =PCLappedSessCell{end};
pksCell=pksCellCell{1,refLapType};
CueOmitLappedSess{j}.PCLappedSessCue=PCLappedSessCue;
CueOmitLappedSess{j}.PCLappedSessOmit=PCLappedSessOmit;
CueOmitLappedSess{j}.pksCell=pksCell;
CueOmitLappedSess{j}.MidCueCellInd=MidCueCellInd;
CueOmitLappedSess{j}.EdgeCueCellInd=EdgeCueCellInd;
CueOmitLappedSess{j}.nonCueCellInd=nonCueCellInd;
end


%%
   NonCumPVCorrCueCue=[]; NonCumPVCorrOmitOmit=[]; NonCumPVCorrCueOmit=[];
   NonCumPerCellCueCue={}; NonCumPerCellOmitOmit={}; NonCumPerCellCueOmit={};

for i=1:length(CueOmitLappedSess)
PCLappedSessCue = CueOmitLappedSess{i}.PCLappedSessCue;
PCLappedSessOmit= CueOmitLappedSess{i}.PCLappedSessOmit;
nonPCCells = find(PCLappedSessCue.Shuff.isPC==0);
ind=[];
for j=1:length(CueOmitLappedSess{i}.pksCell)
    ind(j)= length(CueOmitLappedSess{i}.pksCell{j})>=10;
end
% ind = find(ind > 0);
nonPCAct=nonPCCells(ind(nonPCCells) > 0);

AllCellexptMidInd = [nonPCAct;CueOmitLappedSess{i}.nonCueCellInd]; 
whichCells = AllCellexptMidInd;
out = calcCueShiftFiringStabilityByLap1(PCLappedSessCue, PCLappedSessOmit, whichCells);
NonCumPVCorrCueCue=[NonCumPVCorrCueCue;out.PVCorrCueCue];
NonCumPVCorrOmitOmit=[NonCumPVCorrOmitOmit;out.PVCorrOmitOmit];
NonCumPVCorrCueOmit=[NonCumPVCorrCueOmit;out.PVCorrCueOmit];
NonCumPerCellCueCue{i}=out.PerCellCueCue;
NonCumPerCellOmitOmit{i}=out.PerCellOmitOmit;
NonCumPerCellCueOmit{i}=out.PerCellCueOmit;
end

figure; shadedErrorBarAG([],nanmean(NonCumPVCorrCueCue), (nanstd(NonCumPVCorrCueCue)/(sqrt(length(NonCumPVCorrCueCue)))), 'k', 1);
hold on;
shadedErrorBarAG([],nanmean(NonCumPVCorrOmitOmit), (nanstd(NonCumPVCorrOmitOmit)/(sqrt(length(NonCumPVCorrOmitOmit)))), 'r', 1);
  hold on;
  shadedErrorBarAG([],nanmean(NonCumPVCorrCueOmit), (nanstd(NonCumPVCorrCueOmit)/(sqrt(length(NonCumPVCorrCueOmit)))), 'b', 1);
hold on; plot([45;45], [0, 0.15], '--k');
hold on; plot([55;55], [0, 0.15], '--k');
hold on; plot([5;5], [0, 0.15], '--k');
hold on; plot([95;95], [0, 0.15], '--k'); 
title('PV cue-cue(k) cue-shift(b) shift-shift(r)');
set (gcf, 'Renderer', 'painters');

sessMeanPerCellCueCue=[]; sessMeanPerCellCueOmit=[];
sessMeanPerCellOmitOmit=[];
for i=1:length(NonCumPerCellCueCue)
sessMean=nanmean(nanmean(NonCumPerCellCueCue{i}));
    sessMeanPerCellCueCue=[sessMeanPerCellCueCue;sessMean];
end
for i=1:length(NonCumPerCellCueOmit)
sessMean=nanmean(nanmean(NonCumPerCellCueOmit{i}));
    sessMeanPerCellCueOmit=[sessMeanPerCellCueOmit;sessMean];
end

for i=1:length(NonCumPerCellOmitOmit)
sessMean=nanmean(nanmean(NonCumPerCellOmitOmit{i}));
    sessMeanPerCellOmitOmit=[sessMeanPerCellOmitOmit;sessMean];
end

 X=[1,2,3]; Y= [nanmean(sessMeanPerCellCueCue) nanmean(sessMeanPerCellCueOmit) nanmean(sessMeanPerCellOmitOmit)]; 
 err=[(nanstd(sessMeanPerCellCueCue)/sqrt(length(sessMeanPerCellCueCue))) (nanstd(sessMeanPerCellCueOmit)/sqrt(length(sessMeanPerCellCueOmit))) (nanstd(sessMeanPerCellOmitOmit)/sqrt(length(sessMeanPerCellOmitOmit)))];
 figure; bar(X,Y); hold on; er = errorbar(X,Y, err); 
 er.Color=[0 0 0]; title('PerCell Corr cue-cue(k) cue-shift(b) shift-shift(r)');

 
 PAll = [sessMeanPerCellCueCue; sessMeanPerCellCueOmit; sessMeanPerCellOmitOmit];
PGroup = [zeros(length(sessMeanPerCellCueCue), 1) + 1; zeros(length(sessMeanPerCellCueOmit), 1) + 2; zeros(length(sessMeanPerCellOmitOmit), 1) + 3];
[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);
% 
% x=[diag(cellCorr12),diag(cellCorr13),nanmean(ShcellCorr12,2), nanmean(ShcellCorr13,2)];
% figure; boxplot(x, 'Notch', 'on', 'Labels', {'Within Day','Across Days','Shuffle'}, 'Whisker', 1)
% figure; violin (x);

%% by mice
CueStabilityOENon={};CueStabilityFLNon={}; CueCorrToLapNumNon={};
OmitStabilityOENon={};OmitStabilityFLNon={}; OmitCorrToLapNumNon={};
CuemeanStabilityOENon=[];CuemeanStabilityFLNon={}; CuemeanCorrToLapNumNon={};
OmitmeanStabilityOENon=[];OmitmeanStabilityFLNon={}; OmitmeanCorrToLapNumNon={};
CueStabilityOEEdge={};CueStabilityFLEdge={}; CueCorrToLapNumEdge={};
OmitStabilityOEEdge={};OmitStabilityFLEdge={}; OmitCorrToLapNumEdge={};
CuemeanStabilityOEEdge=[];CuemeanStabilityFLEdge={}; CuemeanCorrToLapNumEdge={};
OmitmeanStabilityOEEdge=[];OmitmeanStabilityFLEdge={}; OmitmeanCorrToLapNumEdge={};
[PCLapped1] = calcWithinSessStability(CueOmitLappedSess);
[PCLapped2] = calcWithinSessStabilityOmit(CueOmitLappedSess);

for i=1:length(CueOmitLappedSess)
    for j = 1:length(CueOmitLappedSess{i}.nonCueCellInd)
CueStabilityOENon{i}{j}= PCLapped1{i}.StabilityOE(CueOmitLappedSess{i}.nonCueCellInd(j));
CueStabilityFLNon{i}{j}= PCLapped1{i}.StabilityFL(CueOmitLappedSess{i}.nonCueCellInd(j));
CueCorrToLapNumNon{i}{j}= PCLapped1{i}.CorrToLapNum(CueOmitLappedSess{i}.nonCueCellInd(j));
OmitStabilityOENon{i}{j}= PCLapped2{i}.StabilityOE(CueOmitLappedSess{i}.nonCueCellInd(j));
OmitStabilityFLNon{i}{j}= PCLapped2{i}.StabilityFL(CueOmitLappedSess{i}.nonCueCellInd(j));
OmitCorrToLapNumNon{i}{j}= PCLapped2{i}.CorrToLapNum(CueOmitLappedSess{i}.nonCueCellInd(j));
    end
end

for i=1:length(CueOmitLappedSess)
CuemeanStabilityOENon=[CuemeanStabilityOENon; nanmean(cell2mat(CueStabilityOENon{i}))];
CuemeanStabilityFLNon=[CuemeanStabilityFLNon; nanmean(cell2mat(CueStabilityFLNon{i}))];
CuemeanCorrToLapNumNon=[CuemeanCorrToLapNumNon; nanmean(cell2mat(CueCorrToLapNumNon{i}))];
OmitmeanStabilityOENon=[OmitmeanStabilityOENon; nanmean(cell2mat(OmitStabilityOENon{i}))];
OmitmeanStabilityFLNon=[OmitmeanStabilityFLNon; nanmean(cell2mat(OmitStabilityFLNon{i}))];
OmitmeanCorrToLapNumNon=[OmitmeanCorrToLapNumNon; nanmean(cell2mat(OmitCorrToLapNumNon{i}))];
end


for i=1:length(CueOmitLappedSess)
    for j = 1:length(CueOmitLappedSess{i}.EdgeCueCellInd)
CueStabilityOEEdge{i}{j}= PCLapped1{i}.StabilityOE(CueOmitLappedSess{i}.EdgeCueCellInd(j));
CueStabilityFLEdge{i}{j}= PCLapped1{i}.StabilityFL(CueOmitLappedSess{i}.EdgeCueCellInd(j));
CueCorrToLapNumEdge{i}{j}= PCLapped1{i}.CorrToLapNum(CueOmitLappedSess{i}.EdgeCueCellInd(j));
OmitStabilityOEEdge{i}{j}= PCLapped2{i}.StabilityOE(CueOmitLappedSess{i}.EdgeCueCellInd(j));
OmitStabilityFLEdge{i}{j}= PCLapped2{i}.StabilityFL(CueOmitLappedSess{i}.EdgeCueCellInd(j));
OmitCorrToLapNumEdge{i}{j}= PCLapped2{i}.CorrToLapNum(CueOmitLappedSess{i}.EdgeCueCellInd(j));
    end
end

for i=1:length(CueOmitLappedSess)
CuemeanStabilityOEEdge=[CuemeanStabilityOEEdge; nanmean(cell2mat(CueStabilityOEEdge{i}))];
CuemeanStabilityFLEdge=[CuemeanStabilityFLEdge; nanmean(cell2mat(CueStabilityFLEdge{i}))];
CuemeanCorrToLapNumEdge=[CuemeanCorrToLapNumEdge; nanmean(cell2mat(CueCorrToLapNumEdge{i}))];
OmitmeanStabilityOEEdge=[OmitmeanStabilityOEEdge; nanmean(cell2mat(OmitStabilityOEEdge{i}))];
OmitmeanStabilityFLEdge=[OmitmeanStabilityFLEdge; nanmean(cell2mat(OmitStabilityFLEdge{i}))];
OmitmeanCorrToLapNumEdge=[OmitmeanCorrToLapNumEdge; nanmean(cell2mat(OmitCorrToLapNumEdge{i}))];
end

 X=[1,2,3,4]; Y= [nanmean(CuemeanStabilityOENon) nanmean(OmitmeanStabilityOENon) nanmean(CuemeanStabilityOEEdge) nanmean(OmitmeanStabilityOEEdge)]; 
 err=[(nanstd(CuemeanStabilityOENon)/sqrt(length(CuemeanStabilityOENon))) (nanstd(OmitmeanStabilityOENon)/sqrt(length(OmitmeanStabilityOENon))) (nanstd(CuemeanStabilityOEEdge)/sqrt(length(CuemeanStabilityOEEdge))) (nanstd(OmitmeanStabilityOEEdge)/sqrt(length(OmitmeanStabilityOEEdge)))];
 figure; bar(X,Y); hold on; er = errorbar(X,Y, err); 
 er.Color=[0 0 0]; title('StabilityFL Noncue(1) Nonshift(2) Edgecue(1) Edgeshift(2)');
 PAll = [CuemeanStabilityOENon; OmitmeanStabilityOENon; CuemeanStabilityOEEdge; OmitmeanStabilityOEEdge];
PGroup = [zeros(length(CuemeanStabilityOENon), 1) + 1; zeros(length(OmitmeanStabilityOENon), 1) + 2; zeros(length(CuemeanStabilityOEEdge), 1) + 3; zeros(length(OmitmeanStabilityOEEdge), 1) + 4];
[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);
% 
%% find out of field Rates in ref vs omit session

posRatesCellByLapCue = {}; posRatesCellCue={};
posRatesCellByLapOmit = {}; posRatesCellOmit={};
pfInPos={};
for i=1:length(CueOmitLappedSess)
    for j = 1:length(CueOmitLappedSess{i}.nonCueCellInd)
        posRatesCellByLapCue{i}{j} = CueOmitLappedSess{i}.PCLappedSessCue.ByLap.posRateByLap(CueOmitLappedSess{i}.nonCueCellInd(j),:, :);
        posRatesCellByLapCue{i}{j} = squeeze(posRatesCellByLapCue{i}{j})';
        posRatesCellCue{i}{j} = CueOmitLappedSess{i}.PCLappedSessCue.posRates(CueOmitLappedSess{i}.nonCueCellInd(j),:);
        posRatesCellByLapOmit{i}{j} = CueOmitLappedSess{i}.PCLappedSessOmit.ByLap.posRateByLap(CueOmitLappedSess{i}.nonCueCellInd(j),:, :);
        posRatesCellByLapOmit{i}{j} = squeeze(posRatesCellByLapOmit{i}{j})';
        posRatesCellOmit{i}{j} = CueOmitLappedSess{i}.PCLappedSessOmit.posRates(CueOmitLappedSess{i}.nonCueCellInd(j),:);
        pfInPos{i}{j} = [];
        for ii = 1:length(CueOmitLappedSess{i}.PCLappedSessCue.Shuff.PFInAllPos{CueOmitLappedSess{i}.nonCueCellInd(j)})
            pfInPos{i}{j} = [pfInPos{i}{j}, CueOmitLappedSess{i}.PCLappedSessCue.Shuff.PFInAllPos{CueOmitLappedSess{i}.nonCueCellInd(j)}{ii}];
        end
    end
end
%%
j=5; i=1;
 % for j=1:length(posRatesCellByLapOmit)
 % for i=1:length(posRatesCellByLapOmit{j})
    o=posRatesCellByLapOmit{j}{i};
   r=posRatesCellByLapCue{j}{i};
   
figure;subplot(1, 2, 1);imagesc(o);
subplot(1, 2, 2);imagesc(r); colormap hot;
 % end
  %end
%%
pfOutPos = {};
    for j = 1:size(pfInPos, 2)
        pfInPos2{j}= [];
        for i = 1:length(pfInPos{j})      
            pfOutPos{j}{i} = setdiff([1:100],pfInPos{j}{i});
        end
    end
    

MeanposRatebyCueLapsoutPFAll = {};
MeanposRatebyCueLapsoutPFCue = {};
MeanposRatebyOmitLapsoutPFAll = {};
MeanposRatebyOmitLapoutPFCue = {};
 MidCueRegion=[45, 55];

    for i = 1:length(posRatesCellByLapCue)
        for j = 1:length(posRatesCellByLapCue{i})
              if isempty(posRatesCellByLapCue{i}{j})
                  MeanposRatebyCueLapsoutPFAll {i}{j} ={};
                  MeanposRatebyCueLapsoutPFCue {i}{j} = {};
                  MeanposRatebyOmitLapsoutPFAll {i}{j} ={};
                  MeanposRatebyOmitLapoutPFCue {i}{j} = {};
              else
             inCuebin=[];
            MeanposRatebyCueLapsoutPFAll {i}{j} = mean(nanmean(posRatesCellByLapCue{i}{j}(:, pfOutPos{i}{j}),2),1);
            MeanposRatebyOmitLapsoutPFAll {i}{j} = mean(nanmean(posRatesCellByLapOmit{i}{j}(:, pfOutPos{i}{j}),2),1);
            n=1:length(pfOutPos{i}{j});
            inCuebin = pfOutPos{i}{j}(pfOutPos{i}{j}(n)>=MidCueRegion(1) & pfOutPos{i}{j}(n)<=MidCueRegion(2));
            MeanposRatebyCueLapsoutPFCue {i}{j} = mean(nanmean(posRatesCellByLapCue{i}{j}(:, inCuebin),2),1);
            MeanposRatebyOmitLapoutPFCue {i}{j} = mean(nanmean(posRatesCellByLapOmit{i}{j}(:, inCuebin),2),1);

              end
        end
    end
   
MeanRateCueLapsoutPFAll=[];MeanRateCueLapsoutPFCue=[];
MeanRateOmitLapsoutPFAll=[];MeanRateOmitLapsoutPFCue=[];

    for i=1:length(CueOmitLappedSess)
        MeanRateCueLapsoutPFAll=[MeanRateCueLapsoutPFAll; cell2mat(MeanposRatebyCueLapsoutPFAll{i})'];
        MeanRateCueLapsoutPFCue=[MeanRateCueLapsoutPFCue; cell2mat(MeanposRatebyCueLapsoutPFCue{i})'];
        MeanRateOmitLapsoutPFAll=[MeanRateOmitLapsoutPFAll; cell2mat(MeanposRatebyOmitLapsoutPFAll{i})'];
        MeanRateOmitLapsoutPFCue=[MeanRateOmitLapsoutPFCue;cell2mat(MeanposRatebyOmitLapoutPFCue{i})'];
    end

   
    
%% total sess blanked posRates (to do: compare IR vs ctrl )
RefPCposRates=[]; OmPCposRates=[];
for i=1:length(CueOmitLappedSess)
   PCLappedSessCue = CueOmitLappedSess{i}.PCLappedSessCue;
PCLappedSessOmit = CueOmitLappedSess{i}.PCLappedSessOmit;
[pcRatesBlanked, pcOmitRatesBlanked] = cuePosInhib(PCLappedSessCue, PCLappedSessOmit, 0);
RefPCposRates=[RefPCposRates;pcRatesBlanked];
OmPCposRates=[OmPCposRates; pcOmitRatesBlanked];
end
%%
RefPCposRates=[]; OmPCposRates=[]; IRRefPCposRates=[]; IROmPCposRates=[]; 
for i=1:55
    RefPCposRates=[RefPCposRates;cueInhibStruc.normRatesBlankedCell{i}];
OmPCposRates=[OmPCposRates; cueInhibStruc.omitRatesBlankedCell{i}];
end

%%
for i=106:108
    IRRefPCposRates=[IRRefPCposRates;cueInhibStruc.normRatesBlankedCell{i}];
IROmPCposRates=[IROmPCposRates; cueInhibStruc.omitRatesBlankedCell{i}];
end
%%
NCposRates={};
NCposRates{1, 1}=cueInhibStruc.normRatesBlanked;
NCposRates{1, 2}=cueInhibStruc.omitRatesBlanked; 

% smooth for plotting 
g=[];
g = fspecial ('gaussian', [10, 1], 2.5); 
p = NCposRates{1, 1}; o = NCposRates{1, 2}; %o = NCposRates{1, 3};
goodBins = [zeros(100, 1); zeros(100, 1) + 1; zeros(100, 1)];
pSmooth = convWith(repmat(p', [3, 1]), g);
pSmooth = pSmooth(goodBins == 1, :)';
oSmooth = convWith(repmat(o', [3, 1]), g);
oSmooth = oSmooth(goodBins == 1, :)';
% oSmooth = convWith(repmat(o', [3, 1]), g);
% oSmooth = oSmooth(goodBins == 1, :)';

%%
figure; shadedErrorBarAG([],nanmean(IRRefPCposRates), (nanstd(IRRefPCposRates)/(sqrt(length(IRRefPCposRates)))), 'k', 1);
hold on;
shadedErrorBarAG([],nanmean(IROmPCposRates), (nanstd(IROmPCposRates)/(sqrt(length(IROmPCposRates)))), 'b', 1);
%   hold on;
%   shadedErrorBarAG([],nanmean(NonCumPVCorrCueOmit), (nanstd(NonCumPVCorrCueOmit)/(sqrt(length(NonCumPVCorrCueOmit)))), 'b', 1);
hold on; plot([45;45], [0, 0.02], '--k');
hold on; plot([55;55], [0, 0.02], '--k');
hold on; plot([5;5], [0, 0.02], '--k');
hold on; plot([95;95], [0, 0.02], '--k'); 
title('Firing Rate IR PF blanked ref (k) omit (b) laps');
set (gcf, 'Renderer', 'painters');

%% NCposRates{3}=oSmooth;
[~, s1] = nanmax(NCposRates{1}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(NCposRates)
    NCposRates{i} = NCposRates{i}(s2, :);
end



% Rate correlation
popVecCorr12 = 1 - pdist2(NCposRates{1}', NCposRates{2}', 'correlation');
cellCorr12 = 1 - pdist2(NCposRates{1}, NCposRates{2}, 'correlation'); 

ShuffpopVecCorr12=[];
ShuffcellCorr12=[];
   rng('shuffle')
   for sh = 1:200
       posRatesCellRand = NCposRates;
       posRatesCellRand{1} = NCposRates{1}(randperm(size(NCposRates{1}, 1)), :);
       posRatesCellRand{2} = NCposRates{2}(randperm(size(NCposRates{2}, 1)), :);
ShuffpopVecCorr12{sh} = 1 - pdist2(posRatesCellRand{1}', NCposRates{2}', 'correlation');
ShuffcellCorr12{sh}= 1 - pdist2(posRatesCellRand{1}, NCposRates{2}, 'correlation');
   end
    ShpopVecCorr12=[]; 
   ShcellCorr12=[];
   for i=1:length(ShuffpopVecCorr12)
        a=ShuffpopVecCorr12{i};
       c=ShuffcellCorr12{i};
       a=diag(a); 
       c=diag(c);
        ShpopVecCorr12=[ShpopVecCorr12 a];
       ShcellCorr12=[ShcellCorr12 c];
   end
   
    meanShpopVecCorr12 = nanmean(ShpopVecCorr12,2); 
    meancellCorr12 = nanmean(diag(cellCorr12),1);   
     semcellCorr12 = std(diag(cellCorr12),1)/sqrt(length(diag(cellCorr12)));     
     meanShcellCorr12=mean(nanmean(ShcellCorr12,2),1);
semShcellCorr12=std(nanmean(ShcellCorr12,2),1)/sqrt(length(nanmean(ShcellCorr12,2)));  
%
figure; plot(diag(popVecCorr12)); hold on;  hold on; plot(meanShpopVecCorr12, '--');
set (gcf, 'Renderer', 'painters');
X=[1,2]; Y= [meancellCorr12  meanShcellCorr12 ]; err=[semcellCorr12  semShcellCorr12 ];
 figure; bar(X,Y); hold on; er = errorbar(X,Y, err); 
 er.Color=[0 0 0];
 
 PAll = [diag(cellCorr12);  nanmean(ShcellCorr12,2); ];
PGroup = [zeros(length(diag(cellCorr12)), 1) + 1; zeros(length(nanmean(ShcellCorr12,2)), 1) + 2];

[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);

% x=[diag(cellCorr12),nanmean(ShcellCorr12,2)];
% figure; boxplot(x, 'Notch', 'on', 'Labels', {'Within Day','Across Days','Shuffle'}, 'Whisker', 1)
% figure; violin (x);

%
figure;
maxRate = Inf;
CLims = [0, 0.5];
for i = 1:2
    subplot(1, 2, i);
    c = NCposRates{i};
    c(c > maxRate) = maxRate;
    imagesc(c);
    set(gca, 'CLim', CLims);
end
suptitle('Smooth IR NCposRates ');
colormap hot;


