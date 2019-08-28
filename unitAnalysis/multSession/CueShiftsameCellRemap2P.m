function [remapCueShiftStruc] = CueShiftsameCellRemap2P(sameCellCueShiftTuningStruc);

%% USAGE: [remapStruc] = sameCellRemap(sameCellTuningStruc);Sebnem 
% Clay Dec. 2017
% find cells active in subsets of sessions (or are place cells in
% subsets of sessions?)
% May2018
% Now including more followup analyses
% remapStruc.sessComb = ziv rows with cells present in diff combin of sess
% remapStruc.allZivCorrCoef = cell array of corr coeff for all ziv cells
%Sebnem June 2019 modified for suite2p
%S modified Aug. 2019 for MidCue, edge cue etc cells


%% unpack some variables
multSessSegStruc = sameCellCueShiftTuningStruc.multSessSegStruc; 
refLapType = sameCellCueShiftTuningStruc.multSessSegStruc.refLapType;
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


%% tuning xcorr for cells that are not cue cells in all three sessions
% find goodSeg indices (for extracting tuning from PCLapSess)
for i = 1:size(nonCueCellsAllInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesnonCueCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(nonCueCellsAllInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesnonCueCell')
    for i = 1:size(posRatesnonCueCell,1)
        rates = [];
        for j = 1:size(posRatesnonCueCell,2)
            rates = [rates; posRatesnonCueCell{i,j}];
        end
        [remapCueShiftStruc.nonCueInAllCoef{i}, remapCueShiftStruc.nonCueInAllPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapCueShiftStruc.nonCueInAllCoef)
        A1A2 = [A1A2; remapCueShiftStruc.nonCueInAllCoef{i}(2)];
        A1B = [A1B; remapCueShiftStruc.nonCueInAllCoef{i}(3)];
        A2B = [A2B; remapCueShiftStruc.nonCueInAllCoef{i}(6)];
    end
    remapCueShiftStruc.nonCueAllCorrCoeff121323 = [A1A2, A1B, A2B];
  
    % shuffle cell identities
     rng('shuffle')
   nonCueRShuff12=[]; nonCueRShuff13 = []; nonCueRShuff23 = [];
   for sh = 1:200
       posRatesnonCellRand = posRatesnonCueCell;
       posRatesnonCellRand(:, 1) = posRatesnonCueCell(randperm(size(posRatesnonCueCell, 1)), 1);
       posRatesnonCellRand(:, 2) = posRatesnonCueCell(randperm(size(posRatesnonCueCell, 1)), 2);
       posRatesnonCellRand(:, 3) = posRatesnonCueCell(randperm(size(posRatesnonCueCell, 1)), 3);
       for i = 1:size(posRatesnonCueCell,1)
           rates = [];
           for j = 1:size (posRatesnonCueCell,2)
               rates = [rates; posRatesnonCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           nonCueRShuff12(sh, i) = r(2, 1);
           nonCueRShuff23(sh, i) = r(2, 3);
           nonCueRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2PCAll = A1A2' > prctile(nonCueRShuff12, 97.5);
   isSigA2BPCAll = A2B' > prctile(nonCueRShuff23, 97.5);
   isSigA1BPCAll = A1B' > prctile(nonCueRShuff13, 97.5);
   remapCueShiftStruc.nonCueAllShuffSig121323 = [(mean(nonCueRShuff12))', (mean(nonCueRShuff13))',(mean(nonCueRShuff23))', isSigA1A2PCAll' , isSigA1BPCAll',isSigA2BPCAll'];
    %plot tunig sorted by sess2
    nonCueMatchedAll = {};% make a cell array of all posRates together
    for i = 1:size(posRatesnonCueCell, 2)
        nonCueMatchedAll{i} = [];
        for ii = 1:size(posRatesnonCueCell, 1)
            nonCueMatchedAll{i} = [nonCueMatchedAll{i}; posRatesnonCueCell{ii, i}];
        end
    end
    remapCueShiftStruc.nonCueMatchedAll = [nonCueMatchedAll];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(nonCueMatchedAll{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(nonCueMatchedAll)
        nonCueMatchedAll{i} = nonCueMatchedAll{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = nonCueMatchedAll{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('All nonCue Cell Rates');
    colormap hot;
end


%% tuning xcorr for cells that are MidCue cells in all three sessions
for i = 1:size(MidCueCellsAllInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesMidCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(MidCueCellsAllInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesMidCell')
    for i = 1:size(posRatesMidCell,1)
        rates = [];
        for j = 1:size(posRatesMidCell,2)
            rates = [rates; posRatesMidCell{i,j}];
        end
        [remapCueShiftStruc.MidCueInAllCoef{i}, remapCueShiftStruc.MidCueInAllPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapCueShiftStruc.MidCueInAllCoef)
        A1A2 = [A1A2; remapCueShiftStruc.MidCueInAllCoef{i}(2)];
        A1B = [A1B; remapCueShiftStruc.MidCueInAllCoef{i}(3)];
        A2B = [A2B; remapCueShiftStruc.MidCueInAllCoef{i}(6)];
    end
    remapCueShiftStruc.MidCueInAllCorrCoeff121323 = [A1A2, A1B, A2B];
 
    % shuffle cell identities
     rng('shuffle')
   MidRShuff12=[]; MidRShuff13 = []; MidRShuff23 = [];
   for sh = 1:200
       posRatesMidCellRand = posRatesMidCell;
       posRatesMidCellRand(:, 1) = posRatesMidCell(randperm(size(posRatesMidCell, 1)), 1);
       posRatesMidCellRand(:, 2) = posRatesMidCell(randperm(size(posRatesMidCell, 1)), 2);
       posRatesMidCellRand(:, 3) = posRatesMidCell(randperm(size(posRatesMidCell, 1)), 3);
       for i = 1:size(posRatesMidCell,1)
           rates = [];
           for j = 1:size (posRatesMidCell,2)
               rates = [rates; posRatesMidCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           MidRShuff12(sh, i) = r(2, 1);
           MidRShuff23(sh, i) = r(2, 3);
           MidRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2MidAll = A1A2' > prctile(MidRShuff12, 97.5);
   isSigA2BMidAll = A2B' > prctile(MidRShuff23, 97.5);
   isSigA1BMidAll = A1B' > prctile(MidRShuff13, 97.5);
   remapCueShiftStruc.MidCueAllShuffSig121323 = [(mean(MidRShuff12))', (mean(MidRShuff13))',(mean(MidRShuff23))', isSigA1A2MidAll' , isSigA1BMidAll', isSigA2BMidAll'];
    %plot tunig sorted by sess2
    MidMatchedAll = {};% make a cell array of all posRates together
    for i = 1:size(posRatesMidCell, 2)
        MidMatchedAll{i} = [];
        for ii = 1:size(posRatesMidCell, 1)
            MidMatchedAll{i} = [MidMatchedAll{i}; posRatesMidCell{ii, i}];
        end
    end
    remapCueShiftStruc.MidMatchedAll = [MidMatchedAll];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(MidMatchedAll{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(MidMatchedAll)
        MidMatchedAll{i} = MidMatchedAll{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = MidMatchedAll{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('All Middle Cue Rates');
    colormap hot;
end

%% tuning xcorr for cells that are EdgeCue cells in all three sessions
for i = 1:size(EdgeCueCellsAllInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesEdgeCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(EdgeCueCellsAllInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesEdgeCell')
    for i = 1:size(posRatesEdgeCell,1)
        rates = [];
        for j = 1:size(posRatesEdgeCell,2)
            rates = [rates; posRatesEdgeCell{i,j}];
        end
        [remapCueShiftStruc.EdgeCueInAllCoef{i}, remapCueShiftStruc.EdgeCueInAllPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapCueShiftStruc.EdgeCueInAllCoef)
        A1A2 = [A1A2; remapCueShiftStruc.EdgeCueInAllCoef{i}(2)];
        A1B = [A1B; remapCueShiftStruc.EdgeCueInAllCoef{i}(3)];
        A2B = [A2B; remapCueShiftStruc.EdgeCueInAllCoef{i}(6)];
    end
    remapCueShiftStruc.EdgeCueInAllCorrCoeff121323 = [A1A2, A1B, A2B];
 
    % shuffle cell identities
     rng('shuffle')
   EdgeRShuff12=[]; EdgeRShuff13 = []; EdgeRShuff23 = [];
   for sh = 1:200
       posRatesEdgeCellRand = posRatesEdgeCell;
       posRatesEdgeCellRand(:, 1) = posRatesEdgeCell(randperm(size(posRatesEdgeCell, 1)), 1);
       posRatesEdgeCellRand(:, 2) = posRatesEdgeCell(randperm(size(posRatesEdgeCell, 1)), 2);
       posRatesEdgeCellRand(:, 3) = posRatesEdgeCell(randperm(size(posRatesEdgeCell, 1)), 3);
       for i = 1:size(posRatesEdgeCell,1)
           rates = [];
           for j = 1:size (posRatesEdgeCell,2)
               rates = [rates; posRatesEdgeCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           EdgeRShuff12(sh, i) = r(2, 1);
           EdgeRShuff23(sh, i) = r(2, 3);
           EdgeRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2EdgeAll = A1A2' > prctile(EdgeRShuff12, 97.5);
   isSigA2BEdgeAll = A2B' > prctile(EdgeRShuff23, 97.5);
   isSigA1BEdgeAll = A1B' > prctile(EdgeRShuff13, 97.5);
   remapCueShiftStruc.EdgeCueAllShuffSig121323 = [(mean(EdgeRShuff12))', (mean(EdgeRShuff13))',(mean(EdgeRShuff23))', isSigA1A2EdgeAll' , isSigA1BEdgeAll', isSigA2BEdgeAll'];
    %plot tunig sorted by sess2
    EdgeMatchedAll = {};
    for i = 1:size(posRatesEdgeCell, 2)
        EdgeMatchedAll{i} = [];
        for ii = 1:size(posRatesEdgeCell, 1)
            EdgeMatchedAll{i} = [EdgeMatchedAll{i}; posRatesEdgeCell{ii, i}];
        end
    end
    remapCueShiftStruc.EdgeMatchedAll = [EdgeMatchedAll];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(EdgeMatchedAll{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(EdgeMatchedAll)
        EdgeMatchedAll{i} = EdgeMatchedAll{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = EdgeMatchedAll{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('All Edge Cue Rates');
    colormap hot;
end
%% tuning xcorr for cells that are not cue cells in any three sessions
% find goodSeg indices (for extracting tuning from PCLapSess)
for i = 1:size(nonCueCellsInAnyInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesnonCueCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(nonCueCellsInAnyInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesnonCueCell')
    for i = 1:size(posRatesnonCueCell,1)
        rates = [];
        for j = 1:size(posRatesnonCueCell,2)
            rates = [rates; posRatesnonCueCell{i,j}];
        end
        [remapCueShiftStruc.nonCueInAnyCoef{i}, remapCueShiftStruc.nonCueInAnyPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapCueShiftStruc.nonCueInAnyCoef)
        A1A2 = [A1A2; remapCueShiftStruc.nonCueInAnyCoef{i}(2)];
        A1B = [A1B; remapCueShiftStruc.nonCueInAnyCoef{i}(3)];
        A2B = [A2B; remapCueShiftStruc.nonCueInAnyCoef{i}(6)];
    end
    remapCueShiftStruc.nonCueAnyCorrCoeff121323 = [A1A2, A1B, A2B];
  
    % shuffle cell identities
     rng('shuffle')
   nonCueRShuff12=[]; nonCueRShuff13 = []; nonCueRShuff23 = [];
   for sh = 1:200
       posRatesnonCellRand = posRatesnonCueCell;
       posRatesnonCellRand(:, 1) = posRatesnonCueCell(randperm(size(posRatesnonCueCell, 1)), 1);
       posRatesnonCellRand(:, 2) = posRatesnonCueCell(randperm(size(posRatesnonCueCell, 1)), 2);
       posRatesnonCellRand(:, 3) = posRatesnonCueCell(randperm(size(posRatesnonCueCell, 1)), 3);
       for i = 1:size(posRatesnonCueCell,1)
           rates = [];
           for j = 1:size (posRatesnonCueCell,2)
               rates = [rates; posRatesnonCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           nonCueRShuff12(sh, i) = r(2, 1);
           nonCueRShuff23(sh, i) = r(2, 3);
           nonCueRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2PCAll = A1A2' > prctile(nonCueRShuff12, 97.5);
   isSigA2BPCAll = A2B' > prctile(nonCueRShuff23, 97.5);
   isSigA1BPCAll = A1B' > prctile(nonCueRShuff13, 97.5);
   remapCueShiftStruc.nonCueAnyShuffSig121323 = [(mean(nonCueRShuff12))', (mean(nonCueRShuff13))',(mean(nonCueRShuff23))', isSigA1A2PCAll' , isSigA1BPCAll',isSigA2BPCAll'];
    %plot tunig sorted by sess2
    nonCueMatchedAny = {};% make a cell array of all posRates together
    for i = 1:size(posRatesnonCueCell, 2)
        nonCueMatchedAny{i} = [];
        for ii = 1:size(posRatesnonCueCell, 1)
            nonCueMatchedAny{i} = [nonCueMatchedAny{i}; posRatesnonCueCell{ii, i}];
        end
    end
    remapCueShiftStruc.nonCueMatchedAny = [nonCueMatchedAny];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(nonCueMatchedAny{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(nonCueMatchedAny)
        nonCueMatchedAny{i} = nonCueMatchedAny{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = nonCueMatchedAny{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('Any nonCue Cell Rates');
    colormap hot;
end


%% tuning xcorr for cells that are MidCue cells in all three sessions
for i = 1:size(MidCueCellsInAnyInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesMidCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(MidCueCellsInAnyInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesMidCell')
    for i = 1:size(posRatesMidCell,1)
        rates = [];
        for j = 1:size(posRatesMidCell,2)
            rates = [rates; posRatesMidCell{i,j}];
        end
        [remapCueShiftStruc.MidCueInAnyCoef{i}, remapCueShiftStruc.MidCueInAnyPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapCueShiftStruc.MidCueInAnyCoef)
        A1A2 = [A1A2; remapCueShiftStruc.MidCueInAnyCoef{i}(2)];
        A1B = [A1B; remapCueShiftStruc.MidCueInAnyCoef{i}(3)];
        A2B = [A2B; remapCueShiftStruc.MidCueInAnyCoef{i}(6)];
    end
    remapCueShiftStruc.MidCueInAnyCorrCoeff121323 = [A1A2, A1B, A2B];
 
    % shuffle cell identities
     rng('shuffle')
   MidRShuff12=[]; MidRShuff13 = []; MidRShuff23 = [];
   for sh = 1:200
       posRatesMidCellRand = posRatesMidCell;
       posRatesMidCellRand(:, 1) = posRatesMidCell(randperm(size(posRatesMidCell, 1)), 1);
       posRatesMidCellRand(:, 2) = posRatesMidCell(randperm(size(posRatesMidCell, 1)), 2);
       posRatesMidCellRand(:, 3) = posRatesMidCell(randperm(size(posRatesMidCell, 1)), 3);
       for i = 1:size(posRatesMidCell,1)
           rates = [];
           for j = 1:size (posRatesMidCell,2)
               rates = [rates; posRatesMidCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           MidRShuff12(sh, i) = r(2, 1);
           MidRShuff23(sh, i) = r(2, 3);
           MidRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2MidAll = A1A2' > prctile(MidRShuff12, 97.5);
   isSigA2BMidAll = A2B' > prctile(MidRShuff23, 97.5);
   isSigA1BMidAll = A1B' > prctile(MidRShuff13, 97.5);
   remapCueShiftStruc.MidCueAnyShuffSig121323 = [(mean(MidRShuff12))', (mean(MidRShuff13))',(mean(MidRShuff23))', isSigA1A2MidAll' , isSigA1BMidAll', isSigA2BMidAll'];
    %plot tunig sorted by sess2
    MidMatchedAny = {};% make a cell array of all posRates together
    for i = 1:size(posRatesMidCell, 2)
        MidMatchedAny{i} = [];
        for ii = 1:size(posRatesMidCell, 1)
            MidMatchedAny{i} = [MidMatchedAny{i}; posRatesMidCell{ii, i}];
        end
    end
    remapCueShiftStruc.MidMatchedAny = [MidMatchedAny];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(MidMatchedAny{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(MidMatchedAny)
        MidMatchedAny{i} = MidMatchedAny{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = MidMatchedAny{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('Any Middle Cue Rates');
    colormap hot;
end

%% tuning xcorr for cells that are EdgeCue cells in all three sessions
for i = 1:size(EdgeCueCellsInAnyInd,1)
    for j = 1:length(multSessSegStruc)
        posRatesEdgeCell{i,j} = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(EdgeCueCellsInAnyInd(i,j),:);
    end
end
% correlate tuning for cells that are place cells in all sessions
if exist('posRatesEdgeCell')
    for i = 1:size(posRatesEdgeCell,1)
        rates = [];
        for j = 1:size(posRatesEdgeCell,2)
            rates = [rates; posRatesEdgeCell{i,j}];
        end
        [remapCueShiftStruc.EdgeCueInAnyCoef{i}, remapCueShiftStruc.EdgeCueInAnyPval{i}] = corrcoef(rates');
    end
    
    A1A2=[]; A1B=[]; A2B=[];
    for i = 1:length(remapCueShiftStruc.EdgeCueInAnyCoef)
        A1A2 = [A1A2; remapCueShiftStruc.EdgeCueInAnyCoef{i}(2)];
        A1B = [A1B; remapCueShiftStruc.EdgeCueInAnyCoef{i}(3)];
        A2B = [A2B; remapCueShiftStruc.EdgeCueInAnyCoef{i}(6)];
    end
    remapCueShiftStruc.EdgeCueInAnyCorrCoeff121323 = [A1A2, A1B, A2B];
 
    % shuffle cell identities
     rng('shuffle')
   EdgeRShuff12=[]; EdgeRShuff13 = []; EdgeRShuff23 = [];
   for sh = 1:200
       posRatesEdgeCellRand = posRatesEdgeCell;
       posRatesEdgeCellRand(:, 1) = posRatesEdgeCell(randperm(size(posRatesEdgeCell, 1)), 1);
       posRatesEdgeCellRand(:, 2) = posRatesEdgeCell(randperm(size(posRatesEdgeCell, 1)), 2);
       posRatesEdgeCellRand(:, 3) = posRatesEdgeCell(randperm(size(posRatesEdgeCell, 1)), 3);
       for i = 1:size(posRatesEdgeCell,1)
           rates = [];
           for j = 1:size (posRatesEdgeCell,2)
               rates = [rates; posRatesEdgeCellRand{i,j}];
           end
           [r, p] = corrcoef(rates');
           EdgeRShuff12(sh, i) = r(2, 1);
           EdgeRShuff23(sh, i) = r(2, 3);
           EdgeRShuff13(sh, i) = r(1, 3);
       end
   end
   isSigA1A2EdgeAll = A1A2' > prctile(EdgeRShuff12, 97.5);
   isSigA2BEdgeAll = A2B' > prctile(EdgeRShuff23, 97.5);
   isSigA1BEdgeAll = A1B' > prctile(EdgeRShuff13, 97.5);
   remapCueShiftStruc.EdgeCueAnyShuffSig121323 = [(mean(EdgeRShuff12))', (mean(EdgeRShuff13))',(mean(EdgeRShuff23))', isSigA1A2EdgeAll' , isSigA1BEdgeAll', isSigA2BEdgeAll'];
    %plot tunig sorted by sess2
    EdgeMatchedAny = {};
    for i = 1:size(posRatesEdgeCell, 2)
        EdgeMatchedAny{i} = [];
        for ii = 1:size(posRatesEdgeCell, 1)
            EdgeMatchedAny{i} = [EdgeMatchedAny{i}; posRatesEdgeCell{ii, i}];
        end
    end
    remapCueShiftStruc.EdgeMatchedAny = [EdgeMatchedAny];
    
    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(EdgeMatchedAny{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(EdgeMatchedAny)
        EdgeMatchedAny{i} = EdgeMatchedAny{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.6];
    
    for i = 1:3
        subplot(1, 3, i);
        c = EdgeMatchedAny{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('Any Edge Cue Rates');
    colormap hot;
end
