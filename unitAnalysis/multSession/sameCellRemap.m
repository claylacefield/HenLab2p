adfirtfunction [remapStruc] = sameCellRemap(sameCellTuningStruc);

%% USAGE: [remapStruc] = sameCellRemap(sameCellTuningStruc);

% Clay Dec. 2017
% find cells active in subsets of sessions (or are place cells in
% subsets of sessions?)
% May2018
% Now including more followup analyses
% remapStruc.sessComb = ziv rows with cells present in diff combin of sess
% remapStruc.allZivCorrCoef = cell array of corr coeff for all ziv cells
%


%% unpack some variables
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)
unitSpatCell = sameCellTuningStruc.unitSpatCell;  % cell array of spatial profiles of ziv cells
zivCentroids = sameCellTuningStruc.zivCentroids;    % centroids of these cells
placeCellOrigInd = sameCellTuningStruc.placeCellOrigInd;  % ind of place cells (Andres) w. re. to orig C/A
cellsInAll = sameCellTuningStruc.cellsInAll; % orig C/A index of all ziv registered cells present in all sessions
placeCellAllOrigInd = sameCellTuningStruc.placeCellAllOrigInd; % orig C/A index of all cells that are place cells in all sessions
placeCellNoneOrigInd = sameCellTuningStruc.placeCellInNoneOrigInd ;
placeCellAnyOrigInd = sameCellTuningStruc.placeCellInAnyOrigInd;
regMapOrigInd = sameCellTuningStruc.regMapOrigInd; % orig C/A ind for all cells in ziv mat
regMapGoodSegInd = sameCellTuningStruc.regMapGoodSegInd;
sameCellPlaceBool = sameCellTuningStruc.sameCellPlaceBool;  % boolean for this mat (no its not)


%% find place cells in diff combin of sessions
% NOTE: indices reference ziv array, e.g. regMapOrigInd
n=0;m=0;p=0;q=0;r=0;s=0;
zivMatBool = regMapOrigInd;
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
remapStruc.sessComb = sessComb;

figure;
bar([length(sessComb.firstTwoOnly) length(sessComb.lastTwoOnly)]);
title('#Reg cells in 1-2, 2-3 (may be affected by reg)');

%% Fractions of cells
% note that tuning in outPC struc only performed for goodSeg

for i = 1:length(multSessSegStruc)
    pcInds = find(multSessSegStruc(i).PCLapSess.Shuff.isPC);
    remapStruc.numPCs(i) = length(pcInds);
    remapStruc.fracPCs(i) = remapStruc.numPCs(i)/length(multSessSegStruc(i).goodSeg);
end

figure;
subplot(1,2,1);
bar(remapStruc.numPCs);
title('numPCs');
subplot(1,2,2);
bar(remapStruc.fracPCs);
title('fracPCs');


%% tuning xcorr for cells that are place cells in all three sessions

% find goodSeg indices (for extracting tuning from PCLapSess)
for i = 1:size(placeCellAllOrigInd,1)
    for j = 1:length(multSessSegStruc)
        placeCellAllGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == placeCellAllOrigInd(i,j));
        posRatesCell{i,j} = multSessSegStruc(j).PCLapSess.posRates(placeCellAllGoodSegInd(i,j),:);
    end
end

% correlate tuning for cells that are place cells in all sessions
if exist('posRatesCell')
    
    for i = 1:size(posRatesCell,1)
        rates = [];
        for j = 1:size(posRatesCell,2)
            rates = [rates; posRatesCell{i,j}];
        end
        [remapStruc.pcInAllCoef{i}, remapStruc.pcInAllPval{i}] = corrcoef(rates');
    end
    
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapStruc.pcInAllCoef)
        A1A2 = [A1A2; remapStruc.pcInAllCoef{i}(2)];
        A1B = [A1B; remapStruc.pcInAllCoef{i}(3)];
        A2B = [A2B; remapStruc.pcInAllCoef{i}(6)];
    end
    remapStruc.PCCorrCoeff121323 = [A1A2, A1B, A2B];
  
    % shuffle cell identities
     rng('shuffle')
   pcRShuff1=[]; pcRShuff2 = [];
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
           pcRShuff1(sh, i) = r(2, 1);
           pcRShuff2(sh, i) = r(2, 3);
       end
   end
   isSigAAPCAll = A1A2' > prctile(pcRShuff1, 97.5);
   isSigABPCAll = A2B' > prctile(pcRShuff2, 97.5);
   remapStruc.ShuffSig1223 = [(mean(pcRShuff1))', (mean(pcRShuff2))', isSigAAPCAll' , isSigABPCAll'];
   
    %plot tunig sorted by sess2
    PCMatchedAll = {};% make a cell array of all posRates together
    for i = 1:size(posRatesCell, 2)
        PCMatchedAll{i} = [];
        for ii = 1:size(posRatesCell, 1)
            PCMatchedAll{i} = [PCMatchedAll{i}; posRatesCell{ii, i}];
        end
    end
    remapStruc.PCMatchedAll = [PCMatchedAll];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(PCMatchedAll{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(PCMatchedAll)
        PCMatchedAll{i} = PCMatchedAll{i}(s2, :);
    end
    figure;
    for i = 1:3
        subplot(1, 3, i);
        imagesc(PCMatchedAll{i});
    end
    suptitle('nonNormRates');
    %normalize each by max firing rate
    for i = 1:length(PCMatchedAll)
        for ii = 1:size(PCMatchedAll{i}, 1)
            PCMatchedAll{i}(ii, :) = PCMatchedAll{i}(ii, :)/nanmax(PCMatchedAll{i}(ii, :));
        end
        PCMatchedAll{i}(isnan(PCMatchedAll{i})) = 0;
    end
    
    figure;
    for i = 1:3
        subplot(1, 3, i);
        imagesc(PCMatchedAll{i});
    end
    suptitle('NormRates');
end
%% tuningxcorr for cells that are place cells in at least one session (PCAny)

% find goodSeg indices (for extracting tuning from outPC)
for i = 1:size(placeCellAnyOrigInd,1)
    for j = 1:length(multSessSegStruc)
        placeCellAnyGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == placeCellAnyOrigInd(i,j));
        posRatesCellAnyPC{i,j} = multSessSegStruc(j).PCLapSess.posRates(placeCellAnyGoodSegInd(i,j),:);
    end
end

% correlate tuning for AnyPC

for i = 1:size(posRatesCellAnyPC,1)
    rates = [];
    for j = 1:size(posRatesCellAnyPC,2)
        rates = [rates; posRatesCellAnyPC{i,j}];
    end
    [remapStruc.pcInAnyCoef{i}, remapStruc.pcInAnyPval{i}] = corrcoef(rates');
end

A1A2=[]; A1B=[]; A2B=[];
for i = 1:length(remapStruc.pcInAnyCoef)
    A1A2 = [A1A2; remapStruc.pcInAnyCoef{i}(2)];
    A1B = [A1B; remapStruc.pcInAnyCoef{i}(3)];
    A2B = [A2B; remapStruc.pcInAnyCoef{i}(6)];
end
remapStruc.PCAnyCorrCoeff121323 = [A1A2, A1B, A2B];
%suffle cell identities
   pcRShuff1=[]; pcRShuff2 = [];
   for sh = 1:200
       posRatesCellRand = posRatesCellAnyPC;
       posRatesCellRand(:, 1) = posRatesCellAnyPC(randperm(size(posRatesCellAnyPC, 1)), 1);
       posRatesCellRand(:, 2) = posRatesCellAnyPC(randperm(size(posRatesCellAnyPC, 1)), 2);
       posRatesCellRand(:, 3) = posRatesCellAnyPC(randperm(size(posRatesCellAnyPC, 1)), 3);

       for i = 1:size(posRatesCellAnyPC,1)
           rates = [];
           for j = 1:size (posRatesCellAnyPC,2)
               rates = [rates; posRatesCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           pcRShuff1(sh, i) = r(2, 1);
           pcRShuff2(sh, i) = r(2, 3);
       end
   end
   isSigAAPCAny = A1A2' > prctile(pcRShuff1, 97.5);
   isSigABPCAny = A2B' > prctile(pcRShuff2, 97.5);
   remapStruc.PCAnyShuffSig1223 = [(mean(pcRShuff1))', (mean(pcRShuff2))', isSigAAPCAny' , isSigABPCAny'];
 
%plot tunig sorted by sess2
PCMatchedAny = {};% make a cell array of all posRates together
for i = 1:size(posRatesCellAnyPC, 2)
    PCMatchedAny{i} = [];
    for ii = 1:size(posRatesCellAnyPC, 1)
        PCMatchedAny{i} = [PCMatchedAny{i}; posRatesCellAnyPC{ii, i}];
    end
end
remapStruc.PCMatchedAny = [PCMatchedAny];

%sort second column and match 1 and 3 accordingly:
[~, s1] = nanmax(PCMatchedAny{2}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(PCMatchedAny)
    PCMatchedAny{i} = PCMatchedAny{i}(s2, :);
end
figure;
for i = 1:3
    subplot(1, 3, i);
    imagesc(PCMatchedAny{i});
end
suptitle('nonNormRates');
%normalize each by max firing rate
for i = 1:length(PCMatchedAny)
    for ii = 1:size(PCMatchedAny{i}, 1)
        PCMatchedAny{i}(ii, :) = PCMatchedAny{i}(ii, :)/nanmax(PCMatchedAny{i}(ii, :));
    end
    PCMatchedAny{i}(isnan(PCMatchedAny{i})) = 0;
end

figure;
for i = 1:3
    subplot(1, 3, i);
    imagesc(PCMatchedAny{i});
end
suptitle('NormRates');
colormap jet;
% %% now for all cells present in all sessions
% for i = 1:size(cellsInAll,1)
%     for j = 1:length(multSessSegStruc)
%         placeCellAllGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == cellsInAll(i,j));
%         posRatesCell{i,j} = multSessSegStruc(j).PCLapSess.posRates(placeCellAllGoodSegInd(i,j),:);
%     end
% end
%
% % correlate tuning for cells that are place cells in all sessions
% for i = 1:size(posRatesCell,1)
%     rates = [];
%     for j = 1:size(posRatesCell,2)
%         rates = [rates; posRatesCell{i,j}];
%     end
%     [remapStruc.cellsInAllCoef{i}, remapStruc.cellsInAllPval{i}] = corrcoef(rates');
% end
%
% A1A2=[]; A1B=[]; A2B=[];
% for i = 1:length(remapStruc.cellsInAllCoef)
%     A1A2 = [A1A2; remapStruc.cellsInAllCoef{i}(2)];
%     A1B = [A1B; remapStruc.cellsInAllCoef{i}(3)];
%     A2B = [A2B; remapStruc.cellsInAllCoef{i}(6)];
% end
% remapStruc.AllCorrCoeff121323 = [A1A2, A1B, A2B];
% %figure; pie([229 35 8 42]);


%% find posRates for all cells in mapInd2/regMapOrigInd (ziv regist matr)
for i = 1:size(regMapOrigInd,1)
    for j = 1:length(multSessSegStruc)
        try
            goodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == regMapOrigInd(i,j));
            posRatesCell{i,j} = multSessSegStruc(j).outPC.posRates(goodSegInd(i,j),:);
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
    [remapStruc.allZivCorrCoef{i}, remapStruc.allZivCorrPval{i}] = corrcoef(rates');
end


%% now use this to compare correlations bet. 1-2, 2-3
%
firstTwoPcell = remapStruc.allZivCorrPval(remapStruc.sessComb.firstTwoOnly);
firstTwoCorrCell = remapStruc.allZivCorrCoef(remapStruc.sessComb.firstTwoOnly);
for i = 1:length(firstTwoPcell)
    firstTwoP(i)=firstTwoPcell{i}(2);
    firstTwoCorr(i)=firstTwoCorrCell{i}(2);
end

lastTwoPcell = remapStruc.allZivCorrPval(remapStruc.sessComb.lastTwoOnly);
lastTwoCorrCell = remapStruc.allZivCorrCoef(remapStruc.sessComb.lastTwoOnly);
for i = 1:length(lastTwoPcell)
    lastTwoP(i)=lastTwoPcell{i}(2);
    lastTwoCorr(i)=lastTwoCorrCell{i}(2);
end


figure('Position', [50 50 800 400]);
subplot(1,2,1);
f = firstTwoCorr(firstTwoP<0.05);
l = lastTwoCorr(lastTwoP<0.05);
bar([nanmean(f) nanmean(l)]); hold on;
sem12 = nanstd(f)/sqrt(length(f));
sem23 = nanstd(l)/sqrt(length(l));
errorbar([nanmean(f) nanmean(l)],[sem12 sem23], '.');
title('mean tuning correl, sig pval, sess 1-2 vs. 2-3');

subplot(1,2,2);
bar([nanmean(firstTwoCorr) nanmean(lastTwoCorr)]); hold on;
sem12b = nanstd(firstTwoCorr)/sqrt(length(firstTwoCorr));
sem23b = nanstd(lastTwoCorr)/sqrt(length(lastTwoCorr));
errorbar([nanmean(firstTwoCorr) nanmean(lastTwoCorr)],[sem12b sem23b], '.');
title('mean tuning correl, sess 1-2 vs. 2-3');
