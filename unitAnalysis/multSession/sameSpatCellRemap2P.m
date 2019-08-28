function [remapSpatCellStruc] = sameSpatCellRemap2P(sameCellCueShiftTuningStruc);

%% USAGE: [remapStruc] = sameCellRemap(sameCellTuningStruc);Sebnem 
% Clay Dec. 2017
% find cells active in subsets of sessions (or are place cells in
% subsets of sessions?)
% May2018
% Now including more followup analyses
% remapStruc.sessComb = ziv rows with cells present in diff combin of sess
% remapStruc.allZivCorrCoef = cell array of corr coeff for all ziv cells
%Sebnem June 2019 modified for suite2p


%% unpack some variables
multSessSegStruc = sameCellCueShiftTuningStruc.multSessSegStruc; 
unitSpatCell = sameCellCueShiftTuningStruc.unitSpatCell;  
zivCentroids = sameCellCueShiftTuningStruc.zivCentroids;    
placeCellInd = sameCellCueShiftTuningStruc.placeCellInd;  
MidCueCellInd = sameCellCueShiftTuningStruc.MidCueCellInd;  
EdgeCueCellInd = sameCellCueShiftTuningStruc.EdgeCueCellInd;  
nonCueCellInd = sameCellCueShiftTuningStruc.nonCueCellInd;  
cellsInAll = sameCellCueShiftTuningStruc.cellsInAll; 
regMapInd = sameCellCueShiftTuningStruc.regMapInd; 
sameCellPlaceBool = sameCellCueShiftTuningStruc.sameCellPlaceBool;  
placeCellAllInd = sameCellCueShiftTuningStruc.placeCellsAllInd; 
placeCellNoneInd = sameCellCueShiftTuningStruc.placeCellsInNoneInd ;
placeCellAnyInd = sameCellCueShiftTuningStruc.placeCellsInAnyInd;
MidCueCellsAllInd = sameCellCueShiftTuningStruc.MidCueCellsAllInd; 
MidCueCellsInNoneInd = sameCellCueShiftTuningStruc.MidCueCellsInNoneInd ;
MidCueCellsInAnyInd = sameCellCueShiftTuningStruc.MidCueCellsInAnyInd;
EdgeCueCellsAllInd = sameCellCueShiftTuningStruc.EdgeCueCellsAllInd; 
EdgeCueCellsInNoneInd = sameCellCueShiftTuningStruc.EdgeCueCellsInNoneInd ;
EdgeCueCellsInAnyInd = sameCellCueShiftTuningStruc.EdgeCueCellsInAnyInd;
nonCueCellsAllInd = sameCellCueShiftTuningStruc.nonCueCellsAllInd; 
nonCueCellsInNoneInd = sameCellCueShiftTuningStruc.nonCueCellsInNoneInd ;
nonCueCellsInAnyInd = sameCellCueShiftTuningStruc.nonCueCellsInAnyInd;

%% find place cells in diff combin of sessions
% NOTE: indices reference ziv array
n=0;m=0;p=0;q=0;r=0;s=0;
zivMatBool = regMapInd;
zivMatBool(zivMatBool~=0)=1;
for i = 1:size(zivMatBool,1)
    pcs = zivMatBool(i,:);
    if pcs==[1,0,0]
        n=n+1;
        sessComb.firstOnly(n) = i;
    elseif pcs==[1,1,0]
        r=r+1;
        sessComb.firstTwoOnly(r) = i;
    elseif pcs==[0,1,1]
        m=m+1;
        sessComb.lastTwoOnly(m) = i;
    elseif pcs==[0,1,0]
        p=p+1;
        sessComb.secondOnly(p) = i;
    elseif pcs==[0,0,1]
        q=q+1;
        sessComb.lastOnly(q) = i;
    elseif pcs==[1,1,1]
        s=s+1;
        sessComb.allSess(s) = i;
    end
end
remapSpatCellStruc.sessComb = sessComb;

%% Fractions of cells
for i = 1:length(multSessSegStruc)
    refLapType = multSessSegStruc(i).refLapType;
    PCLappedSessCue = multSessSegStruc(i).cueShiftStruc.PCLappedSessCell{1,refLapType};
    pcInds = find(PCLappedSessCue.Shuff.isPC);
    remapSpatCellStruc.numPCs(i) = length(pcInds);
    remapSpatCellStruc.fracPCs(i) = remapSpatCellStruc.numPCs(i)/length(multSessSegStruc(i).pksCell);
end

figure;
subplot(1,3,1);
bar([length(sessComb.firstTwoOnly) length(sessComb.lastTwoOnly)]);
title('#Reg cells in 1-2, 2-3');
subplot(1,3,2);
bar(remapSpatCellStruc.numPCs);
title('numPCs');
subplot(1,3,3);
bar(remapSpatCellStruc.fracPCs);
title('fracPCs');

%% tuning xcorr for cells that are place cells in all three sessions
% find goodSeg indices (for extracting tuning from PCLapSess)
for i = 1:size(placeCellAllInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(placeCellAllInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesCell')
    for i = 1:size(posRatesCell,1)
        rates = [];
        for j = 1:size(posRatesCell,2)
            rates = [rates; posRatesCell{i,j}];
        end
        [remapSpatCellStruc.pcInAllCoef{i}, remapSpatCellStruc.pcInAllPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapSpatCellStruc.pcInAllCoef)
        A1A2 = [A1A2; remapSpatCellStruc.pcInAllCoef{i}(2)];
        A1B = [A1B; remapSpatCellStruc.pcInAllCoef{i}(3)];
        A2B = [A2B; remapSpatCellStruc.pcInAllCoef{i}(6)];
    end
    remapSpatCellStruc.PCCorrCoeff121323 = [A1A2, A1B, A2B];
  
    % shuffle cell identities
     rng('shuffle')
   pcRShuff12=[]; pcRShuff13 = []; pcRShuff23 = [];
   for sh = 1:200
       posRatesCellRand = posRatesCell;
       posRatesCellRand(:, 1) = posRatesCell(randperm(size(posRatesCell, 1)), 1);
       posRatesCellRand(:, 2) = posRatesCell(randperm(size(posRatesCell, 1)), 2);
       posRatesCellRand(:, 3) = posRatesCell(randperm(size(posRatesCell, 1)), 3);
       for i = 1:size(posRatesCell,1)
           rates = [];
           for j = 1:size (posRatesCell,2)
               rates = [rates; posRatesCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           pcRShuff12(sh, i) = r(2, 1);
           pcRShuff23(sh, i) = r(2, 3);
           pcRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2PCAll = A1A2' > prctile(pcRShuff12, 97.5);
   isSigA2BPCAll = A2B' > prctile(pcRShuff23, 97.5);
   isSigA1BPCAll = A1B' > prctile(pcRShuff13, 97.5);
   remapSpatCellStruc.ShuffSig121323 = [(mean(pcRShuff12))', (mean(pcRShuff13))',(mean(pcRShuff23))', isSigA1A2PCAll' , isSigA1BPCAll',isSigA2BPCAll'];
    %plot tunig sorted by sess2
    PCMatchedAll = {};% make a cell array of all posRates together
    for i = 1:size(posRatesCell, 2)
        PCMatchedAll{i} = [];
        for ii = 1:size(posRatesCell, 1)
            PCMatchedAll{i} = [PCMatchedAll{i}; posRatesCell{ii, i}];
        end
    end
    remapSpatCellStruc.PCMatchedAll = [PCMatchedAll];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(PCMatchedAll{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(PCMatchedAll)
        PCMatchedAll{i} = PCMatchedAll{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = PCMatchedAll{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('PC All Rates');
    colormap hot;
end

%% tuningxcorr for cells that are place cells in at least one session (PCAny)

% find goodSeg indices (for extracting tuning from outPC)
for i = 1:size(placeCellAnyInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(placeCellAnyInd(i,j),:);
    end
end

% correlate tuning for AnyPC

for i = 1:size(posRatesCell,1)
    rates = [];
    for j = 1:size(posRatesCell,2)
        rates = [rates; posRatesCell{i,j}];
    end
    [remapSpatCellStruc.pcInAnyCoef{i}, remapSpatCellStruc.pcInAnyPval{i}] = corrcoef(rates');
end

A1A2=[]; A1B=[]; A2B=[];
for i = 1:length(remapSpatCellStruc.pcInAnyCoef)
    A1A2 = [A1A2; remapSpatCellStruc.pcInAnyCoef{i}(2)];
    A1B = [A1B; remapSpatCellStruc.pcInAnyCoef{i}(3)];
    A2B = [A2B; remapSpatCellStruc.pcInAnyCoef{i}(6)];
end
remapSpatCellStruc.PCAnyCorrCoeff121323 = [A1A2, A1B, A2B];
%suffle cell identities
   pcRShuff12=[]; pcRShuff13 = []; pcRShuff23 = [];
   for sh = 1:200
       posRatesCellRand = posRatesCell;
       posRatesCellRand(:, 1) = posRatesCell(randperm(size(posRatesCell, 1)), 1);
       posRatesCellRand(:, 2) = posRatesCell(randperm(size(posRatesCell, 1)), 2);
       posRatesCellRand(:, 3) = posRatesCell(randperm(size(posRatesCell, 1)), 3);

       for i = 1:size(posRatesCell,1)
           rates = [];
           for j = 1:size (posRatesCell,2)
               rates = [rates; posRatesCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           pcRShuff12(sh, i) = r(2, 1);
           pcRShuff23(sh, i) = r(2, 3);
           pcRShuff13(sh, i) = r(1, 3);

       end
   end
   isSigA1A2PCAny = A1A2' > prctile(pcRShuff12, 97.5);
   isSigA2BPCAny = A2B' > prctile(pcRShuff23, 97.5);
   isSigA1BPCAny = A1B' > prctile(pcRShuff13, 97.5);
   remapSpatCellStruc.PCAnyShuffSig121323 = [(mean(pcRShuff12))',(mean(pcRShuff13))', (mean(pcRShuff23))', isSigA1A2PCAny', isSigA1BPCAny',isSigA2BPCAny'];
 
%plot tunig sorted by sess2
PCMatchedAny = {};% make a cell array of all posRates together
for i = 1:size(posRatesCell, 2)
    PCMatchedAny{i} = [];
    for ii = 1:size(posRatesCell, 1)
        PCMatchedAny{i} = [PCMatchedAny{i}; posRatesCell{ii, i}];
    end
end
remapSpatCellStruc.PCMatchedAny = [PCMatchedAny];

%sort second column and match 1 and 3 accordingly:
[~, s1] = nanmax(PCMatchedAny{2}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(PCMatchedAny)
    PCMatchedAny{i} = PCMatchedAny{i}(s2, :);
end
figure;
maxRate = Inf;
CLims = [0, 0.6];
for i = 1:3
    subplot(1, 3, i);
    c = PCMatchedAny{i};
    c(c> maxRate) = maxRate;
    imagesc(c);
    set (gca, 'CLim', CLims)
end
suptitle('PC Any Rates');
colormap hot;



%% find posRates for all cells in mapInd2/regMapOrigInd (ziv regist matr)
for i = 1:size(regMapInd,1)
    for j = 1:length(multSessSegStruc)
        try
            %goodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == regMapInd(i,j));
            posRatesCell{i,j} = multSessSegStruc(j).outPC.posRates(regMapInd(i,j),:);
        catch
            posRatesCell{i,j} = [];
        end
    end
end

% correlate tuning for all cells in ziv matrix
for i = 1:size(posRatesCell,1)
    rates = [];
    for j = 1:size(posRatesCell,2)
        rates = [rates; posRatesCell{i,j}];
    end
    [remapSpatCellStruc.allZivCorrCoef{i}, remapSpatCellStruc.allZivCorrPval{i}] = corrcoef(rates');
end


%% now use this to compare correlations bet. 1-2, 2-3
%
% firstTwoPcell = remapStruc.allZivCorrPval(remapStruc.sessComb.firstTwoOnly);
% firstTwoCorrCell = remapStruc.allZivCorrCoef(remapStruc.sessComb.firstTwoOnly);
% for i = 1:length(firstTwoPcell)
%     firstTwoP(i)=firstTwoPcell{i}(2);
%     firstTwoCorr(i)=firstTwoCorrCell{i}(2);
% end
% 
% lastTwoPcell = remapStruc.allZivCorrPval(remapStruc.sessComb.lastTwoOnly);
% lastTwoCorrCell = remapStruc.allZivCorrCoef(remapStruc.sessComb.lastTwoOnly);
% for i = 1:length(lastTwoPcell)
%     lastTwoP(i)=lastTwoPcell{i}(2);
%     lastTwoCorr(i)=lastTwoCorrCell{i}(2);
% end
% 
% 
% figure('Position', [50 50 800 400]);
% subplot(1,2,1);
% f = firstTwoCorr(firstTwoP<0.05);
% l = lastTwoCorr(lastTwoP<0.05);
% bar([nanmean(f) nanmean(l)]); hold on;
% sem12 = nanstd(f)/sqrt(length(f));
% sem23 = nanstd(l)/sqrt(length(l));
% errorbar([nanmean(f) nanmean(l)],[sem12 sem23], '.');
% title('mean tuning correl, sig pval, sess 1-2 vs. 2-3');
% 
% subplot(1,2,2);
% bar([nanmean(firstTwoCorr) nanmean(lastTwoCorr)]); hold on;
% sem12b = nanstd(firstTwoCorr)/sqrt(length(firstTwoCorr));
% sem23b = nanstd(lastTwoCorr)/sqrt(length(lastTwoCorr));
% errorbar([nanmean(firstTwoCorr) nanmean(lastTwoCorr)],[sem12b sem23b], '.');
% title('mean tuning correl, sess 1-2 vs. 2-3');
