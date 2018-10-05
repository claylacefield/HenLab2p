function [remapSubsetsStruc] = sameCellRemapSubsets1(sameCellTuningStruc);

%% USAGE: [remapStruc] = sameCellRemap(sameCellTuningStruc);

% Clay Dec. 2017, 
% May2018
% Now including more followup analyses
% remapStruc.sessComb = ziv rows with cells present in diff combin of sess
% remapStruc.allZivCorrCoef = cell array of corr coeff for all ziv cells
% Sebnem Sept. 2018
% find cells active during reward zones in outNonPC, and registers across
% sessions


%% unpack some variables
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)
unitSpatCell = sameCellTuningStruc.unitSpatCell;  % cell array of spatial profiles of ziv cells
zivCentroids = sstameCellTuningStruc.zivCentroids;    % centroids of these cells
placeCellOrigInd = sameCellTuningStruc.placeCellOrigInd;  % ind of place cells (Andres) w. re. to orig C/A
rewCellOrigInd = sameCellTuningStruc.rewCellOrigInd;
cellsInAll = sameCellTuningStruc.cellsInAll; % orig C/A index of all ziv registered cells present in all sessions
placeCellAllOrigInd = sameCellTuningStruc.placeCellAllOrigInd;% orig C/A index of all cells that are place cells in all sessions
placeCellAnyOrigInd = sameCellTuningStruc.placeCellInAnyOrigInd;
placeCellNoneOrigInd = sameCellTuningStruc.placeCellInNoneOrigInd;
rewCellAllOrigInd = sameCellTuningStruc.rewCellAllOrigInd; 
rewCellNoneOrigInd = sameCellTuningStruc.rewCellInNoneOrigInd; 
rewCellAnyOrigInd = sameCellTuningStruc.rewCellInAnyOrigInd; 
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
remapSubsetsStruc.sessComb = sessComb;

figure;
bar([length(sessComb.firstTwoOnly) length(sessComb.lastTwoOnly)]);
title('#Reg cells in 1-2, 2-3 (may be affected by reg)');

%% Fractions of all reward and place cells

remapSubsetsStruc.isRCinPC = {};
for i = 1:length(multSessSegStruc)
    remapSubsetsStruc.numRCs(i) = length(rewCellOrigInd{i});
    pcInds = find(multSessSegStruc(i).PCLapSess.Shuff.isPC);
    remapSubsetsStruc.numPCs(i) = length(pcInds);
    remapSubsetsStruc.fracPCs(i) = remapSubsetsStruc.numPCs(i)/length(multSessSegStruc(i).goodSeg);
    remapSubsetsStruc.fracRCs(i) = remapSubsetsStruc.numRCs(i)/length(multSessSegStruc(i).goodSeg);
    remapSubsetsStruc.isRCinPC{i} = rewCellOrigInd{i}(ismember(rewCellOrigInd{i}, placeCellOrigInd{i}));
    remapSubsetsStruc.fracPCinRC(i) = sum(ismember(rewCellOrigInd{i}, placeCellOrigInd{i}))/remapSubsetsStruc.numRCs(i);                             
    remapSubsetsStruc.fracOverlap(i) = sum(ismember(placeCellOrigInd{i}, rewCellOrigInd{i}))/length(multSessSegStruc(i).goodSeg);                              
    
end

figure; 
subplot(1,4,1);
bar(remapSubsetsStruc.fracPCs);
title('fracPCs');
subplot(1,4,2);
bar(remapSubsetsStruc.fracRCs);
title('fracRewCs');
subplot(1,4,3);
bar(remapSubsetsStruc.fracPCinRC);
title('fracPCinRC');
subplot(1,4,4);
bar(remapSubsetsStruc.fracOverlap);
title('fracOverlap');

%% for cells with reward related activity in nonmove periods in at least one session (rewCellAny)

% find goodSeg indices (for extracting tuning from )
for i = 1:size(rewCellAnyOrigInd,1)
    for j = 1:length(multSessSegStruc)
        rewCellAnyGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == rewCellAnyOrigInd(i,j));
        posRatesCellAnyRew{i,j} = multSessSegStruc(j).PCLapSess.posRates(rewCellAnyGoodSegInd(i,j),:);
    end
end

% correlate tuning for AnyPC
for i = 1:size(posRatesCellAnyRew,1)
    rates = [];
    for j = 1:size(posRatesCellAnyRew,2)
        rates = [rates; posRatesCellAnyRew{i,j}];
    end
    [remapSubsetsStruc.rewInAnyCoef{i}, remapSubsetsStruc.rewInAnyPval{i}] = corrcoef(rates');
end

A1A2=[]; A1B=[]; A2B=[];
for i = 1:length(remapSubsetsStruc.rewInAnyCoef)
    A1A2 = [A1A2; remapSubsetsStruc.rewInAnyCoef{i}(2)];
    A1B = [A1B; remapSubsetsStruc.rewInAnyCoef{i}(3)];
    A2B = [A2B; remapSubsetsStruc.rewInAnyCoef{i}(6)];
end
remapSubsetsStruc.RewAnyCorrCoeff121323 = [A1A2, A1B, A2B];

%plot tunig sorted by sess2
RewMatchedAny = {};% make a cell array of all posRates together
for i = 1:size(posRatesCellAnyRew, 2)
    RewMatchedAny{i} = [];
    for ii = 1:size(posRatesCellAnyRew, 1)
        RewMatchedAny{i} = [RewMatchedAny{i}; posRatesCellAnyRew{ii, i}];
    end
end
remapSubsetsStruc.RewMatchedAny = [RewMatchedAny];

%sort second column and match 1 and 3 accordingly: 
[~, s1] = nanmax(RewMatchedAny{2}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(RewMatchedAny)
    RewMatchedAny{i} = RewMatchedAny{i}(s2, :);
end
figure;
for i = 1:3
    subplot(1, 3, i);
    imagesc(RewMatchedAny{i});
end
suptitle('nonNormRates');
%normalize each by max firing rate
for i = 1:length(RewMatchedAny)
    for ii = 1:size(RewMatchedAny{i}, 1)
        RewMatchedAny{i}(ii, :) = RewMatchedAny{i}(ii, :)/nanmax(RewMatchedAny{i}(ii, :));
    end
    RewMatchedAny{i}(isnan(RewMatchedAny{i})) = 0;
end

figure;
for i = 1:3
    subplot(1, 3, i);
    imagesc(RewMatchedAny{i});
end
suptitle('NormRates');
colormap jet;
%% from outNonPC find posRates for all cells in mapInd2/regMapOrigInd (ziv regist matr) 
for i = 1:size(regMapOrigInd,1)
    for j = 1:length(multSessSegStruc)
        try
            goodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == regMapOrigInd(i,j));
            posRatesCell{i,j} = multSessSegStruc(j).outNonPC.posRates(goodSegInd(i,j),:);
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
    [remapSubsetsStruc.allZivCorrCoef{i}, remapSubsetsStruc.allZivCorrPval{i}] = corrcoef(rates');
end


%% now use this to compare correlations bet. 1-2, 2-3
% 
firstTwoPcell = remapSubsetsStruc.allZivCorrPval(remapSubsetsStruc.sessComb.firstTwoOnly);
firstTwoCorrCell = remapSubsetsStruc.allZivCorrCoef(remapSubsetsStruc.sessComb.firstTwoOnly);
for i = 1:length(firstTwoPcell)
    firstTwoP(i)=firstTwoPcell{i}(2);
    firstTwoCorr(i)=firstTwoCorrCell{i}(2);
end

lastTwoPcell = remapSubsetsStruc.allZivCorrPval(remapSubsetsStruc.sessComb.lastTwoOnly);
lastTwoCorrCell = remapSubsetsStruc.allZivCorrCoef(remapSubsetsStruc.sessComb.lastTwoOnly);
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
