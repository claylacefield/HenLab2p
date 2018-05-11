function [remapStruc] = sameCellRemap(sameCellTuningStruc);


% Clay Dec. 2017
% find cells active in subsets of sessions (or are place cells in
% subsets of sessions?)
% May2018
% Now including more followup analyses

%% unpack some variables
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)
unitSpatCell = sameCellTuningStruc.unitSpatCell;  % cell array of spatial profiles of ziv cells
zivCentroids = sameCellTuningStruc.zivCentroids;    % centroids of these cells
placeCellOrigInd = sameCellTuningStruc.placeCellOrigInd;  % ind of place cells (Andres) w. re. to orig C/A
cellsInAll = sameCellTuningStruc.cellsInAll; % orig C/A index of all ziv registered cells present in all sessions
placeCellAllOrigInd = sameCellTuningStruc.placeCellAllOrigInd; % orig C/A index of all cells that are place cells in all sessions
regMapOrigInd = sameCellTuningStruc.regMapOrigInd; % orig C/A ind for all cells in ziv mat
regMapGoodSegInd = sameCellTuningStruc.regMapGoodSegInd;
sameCellPlaceBool = sameCellTuningStruc.sameCellPlaceBool;  % boolean for this mat (no its not)


%% find place cells in diff combin of sessions
% NOTE: indices reference ziv array, e.g. regMapOrigInd
n=0;m=0;p=0;q=0;

for i = 1:size(sameCellPlaceBool,1)
    pcs = sameCellPlaceBool(i,:); % whether cell present in all sessions is a place cell in each
    if pcs==[1,0,0]
        n=n+1;
        firstOnly(n) = i;
    elseif pcs==[0,1,1]
        m=m+1;
        lastTwoOnly(m) = i;
    elseif pcs==[0,1,0]
        p=p+1;
        secondOnly(p) = i;
    elseif pcs==[0,0,1]
        q=q+1;
        lastOnly(q) = i;
    end
end

%% Fractions of cells
% note that tuning in outPC struc only performed for goodSeg

for i = 1:length(multSessSegStruc)
pcInds = find(multSessSegStruc(i).outPC.Shuff.isPC);
remapStruc.numPCs(i) = length(pcInds);
remapStruc.fracPCs(i) = remapStruc.numPCs(i)/length(multSessSegStruc(i).goodSeg);
end


%% tuning xcorr

% find goodSeg indices (for extracting tuning from outPC)
for i = 1:size(placeCellAllOrigInd,1)
    for j = 1:length(multSessSegStruc)
        placeCellAllGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == placeCellAllOrigInd(i,j));
        posRatesCell{i,j} = multSessSegStruc(j).outPC.posRates(placeCellAllGoodSegInd(i,j),:);
    end
end

% correlate tuning for cells that are place cells in all sessions
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
%% now for all cells present in all sessions
for i = 1:size(cellsInAll,1)
    for j = 1:length(multSessSegStruc)
        placeCellAllGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == cellsInAll(i,j));
        posRatesCell{i,j} = multSessSegStruc(j).outPC.posRates(placeCellAllGoodSegInd(i,j),:);
    end
end

% correlate tuning for cells that are place cells in all sessions
for i = 1:size(posRatesCell,1)
    rates = [];
    for j = 1:size(posRatesCell,2)
        rates = [rates; posRatesCell{i,j}];
    end
    [remapStruc.cellsInAllCoef{i}, remapStruc.cellsInAllPval{i}] = corrcoef(rates');
end

A1A2=[]; A1B=[]; A2B=[];
for i = 1:length(remapStruc.cellsInAllCoef)
    A1A2 = [A1A2; remapStruc.cellsInAllCoef{i}(2)];
    A1B = [A1B; remapStruc.cellsInAllCoef{i}(3)];
    A2B = [A2B; remapStruc.cellsInAllCoef{i}(6)];
end
remapStruc.AllCorrCoeff121323 = [A1A2, A1B, A2B];
%figure; pie([229 35 8 42]);
