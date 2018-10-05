function [fracSubsetsStruc] = fracSubsetsStruc(sameCellTuningStruc);
%% unpack some variables
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)
unitSpatCell = sameCellTuningStruc.unitSpatCell;  % cell array of spatial profiles of ziv cells
zivCentroids = sameCellTuningStruc.zivCentroids;    % centroids of these cells
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

%% Fractions of all reward and place cells

fracSubsetsStruc.isRCinPC = {};
for i = 1:length(multSessSegStruc)
    fracSubsetsStruc.numRCs(i) = length(rewCellOrigInd{i});
    pcInds = find(multSessSegStruc(i).PCLapSess.Shuff.isPC);
    fracSubsetsStruc.numPCs(i) = length(pcInds);
    fracSubsetsStruc.numgoodSegs(i) = length(multSessSegStruc(i).goodSeg);                        
    fracSubsetsStruc.fracPCs(i) = fracSubsetsStruc.numPCs(i)/length(multSessSegStruc(i).goodSeg);
    fracSubsetsStruc.fracRCs(i) = fracSubsetsStruc.numRCs(i)/length(multSessSegStruc(i).goodSeg);
    fracSubsetsStruc.isRCinPC{i} = rewCellOrigInd{i}(ismember(rewCellOrigInd{i}, placeCellOrigInd{i}));
    fracSubsetsStruc.fracRCinPC(i) = sum(ismember(rewCellOrigInd{i}, placeCellOrigInd{i}))/fracSubsetsStruc.numRCs(i);                             
    fracSubsetsStruc.fracOverlap(i) = sum(ismember(placeCellOrigInd{i}, rewCellOrigInd{i}))/length(multSessSegStruc(i).goodSeg);                              
    
end

figure; 
subplot(1,4,1);
bar(fracSubsetsStruc.fracPCs);
title('fracPCs');
subplot(1,4,2);
bar(fracSubsetsStruc.fracRCs);
title('fracRewCs');
subplot(1,4,3);
bar(fracSubsetsStruc.fracPCinRC);
title('fracPCinRC');
subplot(1,4,4);
bar(fracSubsetsStruc.fracOverlap);
title('fracOverlap');