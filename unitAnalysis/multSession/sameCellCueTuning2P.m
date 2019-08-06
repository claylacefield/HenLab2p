function [sameCellTuningStruc] = sameCellCueTuning2P(multSessSegStruc, cell_registered_struct, toPlot);

%% USAGE: [sameCellTuningStruc] = sameCellTuning(multSessTuningStruc, cell_registered_struct);


% ziv array of indices of registered cells in each sessions (with respect to goodSegs,
% usually; thus must reference to goodSeg array to get orig C/A indices)
mapInd = cell_registered_struct.cell_to_index_map;
% NOTE: placeCellStruc is for greatSegs,
% whereas cellReg is for goodSegs

% spatial footprints of all ziv array cells
unitSpatCell = cell_registered_struct.spatial_footprints_corrected;
zivCentroids = cell_registered_struct.registered_cells_centroids;

%%
% for all sessions
for i = 1:size(mapInd,2)
    
      
    % Calculate Cue shift tuning
    [cueShiftStruc] = wrapCueShiftTuningMultSess(multSessSegStruc(i).pksCell, multSessSegStruc(i).treadBehStruc);
    %placeCellInd{i} = find(cueShiftStruc.Shuff.isPC);
    lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
    lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
    for j=1:length(cueShiftStruc.pksCellCell)
        numLapType(j) = length(find(lapTypeArr==j));
    end
    [val, refLapType] = max(numLapType);
    
    PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
   placeCellInd{i} = find(PCLappedSessCue.Shuff.isPC==1);
    
    multSessSegStruc(i).cueShiftStruc = cueShiftStruc;
    multSessSegStruc(i).PCLappedSessCue = PCLappedSessCue;
end

%%

disp('Finding cells (and their tuning) in diff sessions'); tic;

% find ziv array cells present in all sessions
cellRegIndInAll = find(min(mapInd, [], 2)); % [1,1,1,...] in all col (i.e. none have zeros)
%cellsInAllOrig = mapInd2(cellRegIndInAll,:); % orig C/A index of all ziv registered cells present in all sessions
cellsInAll = mapInd(cellRegIndInAll,:);

%%
% see if cells present in all sessions are place cells in all
for i = 1:size(cellsInAll,1) % for all cells 
    for j = 1:size(cellsInAll,2)    % for each session from that cell
        if find(placeCellInd{j}== cellsInAll(i,j)) % see if it's a place cell
            sameCellPlaceBool(i,j) = 1;
        else
            sameCellPlaceBool(i,j) = 0;
        end
    end
end

%%
% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
placeCellsInAll = find(min(sameCellPlaceBool, [], 2)); % index in array of only place cells present in all sessions
placeCellsInNone = find(~max(sameCellPlaceBool, [], 2)); % or cells present in all sessions that are place cells in none
placeCellsInAny = find(max(sameCellPlaceBool,[],2));% or cells present in all sessions that are place cells in at least one
%%
% tuning in placeCellsInAll
%placeCellAllGoodSegInd = cellsInAll(placeCellsInAll,:);
placeCellAllInd = cellsInAll(placeCellsInAll,:);
placeCellInNoneInd = cellsInAll(placeCellsInNone,:);
placeCellInAnyInd = cellsInAll(placeCellsInAny,:);
%= cellRegIndInAll(placeCellsInAll,:);


%% Save useful vars to output struc

sameCellTuningStruc.multSessSegStruc = multSessSegStruc; % just save orig struc (not too huge)
sameCellTuningStruc.unitSpatCell = unitSpatCell;  % cell array of spatial profiles of ziv cells
sameCellTuningStruc.zivCentroids = zivCentroids;    % centroids of these cells
sameCellTuningStruc.placeCellInd = placeCellInd;  
sameCellTuningStruc.cellsInAll = cellsInAll;
sameCellTuningStruc.placeCellAllInd = placeCellAllInd; % index of all cells that are place cells in all sessions
sameCellTuningStruc.placeCellInNoneInd = placeCellInNoneInd; % index of all cells that are not place cells in all sessions
sameCellTuningStruc.placeCellInAnyInd = placeCellInAnyInd; % index of all cells that are place cells in at least one session
sameCellTuningStruc.regMapInd = mapInd; % C/A ind for all cells in ziv mat
sameCellTuningStruc.sameCellPlaceBool = sameCellPlaceBool;  % boolean for this mat

%% Plotting
% plot tuning of cells that are place cells (outPC.Shuff.isPC) in all
% sessions

figure; color = {'r' 'g' 'b'};
%title('Place cells in all sessions');
% for all cells
dim = ceil(sqrt(length(placeCellsInAll)));
for i = 1:size(placeCellsInAll,1)
    subplot(dim,dim,i);
    hold on;
    for j = 1:size(placeCellAllInd,2)
        origInd = placeCellAllInd(i,j); % orig C/A index of this cell
%         goodSegInd = find(multSessSegStruc(j).goodSeg == origInd);
        posPks = multSessSegStruc(j).PCLapSess.posRates(origInd,:);
        samePlacePosPks(i,j,:) = posPks;
        plot(posPks, color{j});
    end
end
title('Place cells in all sessions');


%% for all units in multiple sessions (not just all sessions), find tuning
% similarity; go ahead and get posPks for all ziv cells, to look at tuning of cells
% that appear or disappear in different sessions

% PLOT posRates for all sameCells over sessions
% for all cells
if toPlot == 2
for i = 1:size(mapInd,1)
    for j = 1:size(mapInd,2)
        try
        origInd = mapInd(i,j); % orig C/A index of this cell
        if origInd ~= 0
        posPks = multSessSegStruc(j).outPC.posRates(origInd,:);
        else
           posPks = zeros(40,1); 
        end
        allPlacePosPks(i,j,:) = posPks;
        catch
        end
    end
end

% PLOT only place cells in all sesions
% posRates over sessions for placeCellsInAll
color = {'r' 'g' 'b'};
%figure;
for i = 1:size(allPlacePosPks,1)
    %ceil(size(allPlacePosPks,1)/25)
    if mod(i,25)-1==0
        figure;
        n = 1;
    else
        n=n+1;
    end
    subplot(5,5,n);
   for j = 1:size(allPlacePosPks,2)
       hold on;
        plot(squeeze(allPlacePosPks(i,j,:)), color{j});
   end
end
end

%% 
% and from this I see that some cells seem to have consistent apparent place fields
% between sessions, but aren't considered place cells in some, so maybe I should check and see if cells are place cells
% when considering all sessions from cellReg registered cells

%figure; pie([229 35 8 42]);
