function [sameCellCueShiftTuningStruc] = sameCellCueShiftTuning2P(multSessSegStruc, cell_registered_struct);

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
    % Find CueCells based on position and 2XPF omit/shift response
    [MidCueCellInd, EdgeCueCellInd, nonCueCellInd,  refLapType] =  AllCueCells(cueShiftStruc);
    PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
    placeCellInd{i} = find(PCLappedSessCue.Shuff.isPC==1);
    multSessSegStruc(i).cueShiftStruc = cueShiftStruc;
    multSessSegStruc(i).refLapType = refLapType;
    multSessSegStruc(i).MidCueCellInd = MidCueCellInd;
    multSessSegStruc(i).EdgeCueCellInd = EdgeCueCellInd;
    multSessSegStruc(i).nonCueCellInd = nonCueCellInd;
end

 MidCueCellInd={};  EdgeCueCellInd={}; nonCueCellInd ={};
for i = 1:size(mapInd,2)
    MidCueCellInd{i} =  multSessSegStruc(i).MidCueCellInd;
    EdgeCueCellInd{i} =  multSessSegStruc(i).EdgeCueCellInd ;
    nonCueCellInd {i} = multSessSegStruc(i).nonCueCellInd;
end


%% find ziv array cells present in sessions ref session is 2
cellRegIndInAll = find(min(mapInd, [], 2)); % [1,1,1,...] in all col (i.e. none have zeros)
cellsInAll = mapInd(cellRegIndInAll,:);
cellRegIndFirstTwo=find(min(mapInd(:,1:2), [], 2));
cellsInFirstTwo = mapInd(cellRegIndFirstTwo,:);
cellRegIndLastTwo=find(min(mapInd(:,2:3), [], 2));
cellsInLastTwo = mapInd(cellRegIndLastTwo,:);
%% Place Cells
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

% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
placeCellsInAll = find(min(sameCellPlaceBool, [], 2)); % index in array of only place cells present in all sessions
placeCellsInNone = find(~max(sameCellPlaceBool, [], 2)); % or cells present in all sessions that are place cells in none
placeCellsInAny = find(max(sameCellPlaceBool,[],2));% or cells present in all sessions that are place cells in at least one
% tuning in placeCellsInAll
placeCellsAllInd = cellsInAll(placeCellsInAll,:);
placeCellsInNoneInd = cellsInAll(placeCellsInNone,:);
placeCellsInAnyInd = cellsInAll(placeCellsInAny,:);

%% Mid Cue Cells
% see if cells present in all sessions are place cells in all
for i = 1:size(cellsInAll,1) % for all cells 
    for j = 1:size(cellsInAll,2)    % for each session from that cell
        if find(MidCueCellInd{j}== cellsInAll(i,j)) % see if it's a place cell
            sameCellPlaceBool(i,j) = 1;
        else
            sameCellPlaceBool(i,j) = 0;
        end
    end
end

% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
MidCueCellsInAll = find(min(sameCellPlaceBool, [], 2)); % index in array of only place cells present in all sessions
MidCueCellsInNone = find(~max(sameCellPlaceBool, [], 2)); % or cells present in all sessions that are place cells in none
MidCueCellsInAny = find(max(sameCellPlaceBool,[],2));% or cells present in all sessions that are place cells in at least one
% tuning in placeCellsInAll
MidCueCellsAllInd = cellsInAll(MidCueCellsInAll,:);
MidCueCellsInNoneInd = cellsInAll(MidCueCellsInNone,:);
MidCueCellsInAnyInd = cellsInAll(MidCueCellsInAny,:);

%% Edge Cue Cells
% see if cells present in all sessions are place cells in all
for i = 1:size(cellsInAll,1) % for all cells 
    for j = 1:size(cellsInAll,2)    % for each session from that cell
        if find(EdgeCueCellInd{j}== cellsInAll(i,j)) % see if it's a place cell
            sameCellPlaceBool(i,j) = 1;
        else
            sameCellPlaceBool(i,j) = 0;
        end
    end
end

% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
EdgeCueCellsInAll = find(min(sameCellPlaceBool, [], 2)); % index in array of only place cells present in all sessions
EdgeCueCellsInNone = find(~max(sameCellPlaceBool, [], 2)); % or cells present in all sessions that are place cells in none
EdgeCueCellsInAny = find(max(sameCellPlaceBool,[],2));% or cells present in all sessions that are place cells in at least one
% tuning in placeCellsInAll
EdgeCueCellsAllInd = cellsInAll(EdgeCueCellsInAll,:);
EdgeCueCellsInNoneInd = cellsInAll(EdgeCueCellsInNone,:);
EdgeCueCellsInAnyInd = cellsInAll(EdgeCueCellsInAny,:);

%% non Cue Cells
% see if cells present in all sessions are place cells in all
for i = 1:size(cellsInAll,1) % for all cells 
    for j = 1:size(cellsInAll,2)    % for each session from that cell
        if find(nonCueCellInd{j}== cellsInAll(i,j)) % see if it's a place cell
            sameCellPlaceBool(i,j) = 1;
        else
            sameCellPlaceBool(i,j) = 0;
        end
    end
end

% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
nonCueCellsInAll = find(min(sameCellPlaceBool, [], 2)); % index in array of only place cells present in all sessions
nonCueCellsInNone = find(~max(sameCellPlaceBool, [], 2)); % or cells present in all sessions that are place cells in none
nonCueCellsInAny = find(max(sameCellPlaceBool,[],2));% or cells present in all sessions that are place cells in at least one
% tuning in placeCellsInAll
nonCueCellsAllInd = cellsInAll(nonCueCellsInAll,:);
nonCueCellsInNoneInd = cellsInAll(nonCueCellsInNone,:);
nonCueCellsInAnyInd = cellsInAll(nonCueCellsInAny,:);
%% Save useful vars to output struc

sameCellCueShiftTuningStruc.multSessSegStruc = multSessSegStruc; % just save orig struc (not too huge)
sameCellCueShiftTuningStruc.unitSpatCell = unitSpatCell;  % cell array of spatial profiles of ziv cells
sameCellCueShiftTuningStruc.zivCentroids = zivCentroids;    % centroids of these cells
sameCellCueShiftTuningStruc.placeCellInd = placeCellInd;  
sameCellCueShiftTuningStruc.MidCueCellInd = MidCueCellInd;  
sameCellCueShiftTuningStruc.EdgeCueCellInd = EdgeCueCellInd;  
sameCellCueShiftTuningStruc.nonCueCellInd = nonCueCellInd;  
sameCellCueShiftTuningStruc.cellsInAll = cellsInAll;
sameCellCueShiftTuningStruc.placeCellsAllInd = placeCellsAllInd; % index of all cells that are place cells in all sessions
sameCellCueShiftTuningStruc.placeCellsInNoneInd = placeCellsInNoneInd; % index of all cells that are not place cells in all sessions
sameCellCueShiftTuningStruc.placeCellsInAnyInd = placeCellsInAnyInd; % index of all cells that are place cells in at least one session
sameCellCueShiftTuningStruc.MidCueCellsAllInd = MidCueCellsAllInd; 
sameCellCueShiftTuningStruc.MidCueCellsInNoneInd = MidCueCellsInNoneInd; 
sameCellCueShiftTuningStruc.MidCueCellsInAnyInd = MidCueCellsInAnyInd;
sameCellCueShiftTuningStruc.EdgeCueCellsAllInd = EdgeCueCellsAllInd; 
sameCellCueShiftTuningStruc.EdgeCueCellsInNoneInd = EdgeCueCellsInNoneInd; 
sameCellCueShiftTuningStruc.EdgeCueCellsInAnyInd = EdgeCueCellsInAnyInd;
sameCellCueShiftTuningStruc.nonCueCellsAllInd = nonCueCellsAllInd; 
sameCellCueShiftTuningStruc.nonCueCellsInNoneInd = nonCueCellsInNoneInd; 
sameCellCueShiftTuningStruc.nonCueCellsInAnyInd = nonCueCellsInAnyInd;
sameCellCueShiftTuningStruc.regMapInd = mapInd; % C/A ind for all cells in ziv mat
sameCellCueShiftTuningStruc.sameCellPlaceBool = sameCellPlaceBool;  % boolean for this mat

%% Plotting
% plot tuning of cells that are place cells (outPC.Shuff.isPC) in all
% sessions

figure; color = {'r' 'g' 'b'};
dim = ceil(sqrt(length(placeCellsInAll)));
for i = 1:size(placeCellsInAll,1)
    subplot(dim,dim,i);
    hold on;
    for j = 1:size(placeCellsAllInd,2)
        origInd = placeCellsAllInd(i,j); % orig C/A index of this cell
        PCLappedSessCue(j) = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1, multSessSegStruc(j).refLapType };
        posPks = PCLappedSessCue(j).posRates(origInd,:);
        samePlacePosPks(i,j,:) = posPks;
        plot(posPks, color{j});
    end
end
title('Place cells in all sessions');





