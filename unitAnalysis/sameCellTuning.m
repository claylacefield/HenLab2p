function [sameCellTuningStruc] = sameCellTuning(multSessTuningStruc, cell_registered_struct);

%% USAGE: [sameCellTuningStruc] = sameCellTuning(multSessTuningStruc, cell_registered_struct);
%
% Questions:
% - are place cells more likely to be present in all sessions?
% - is there a change in average tuning strength over sessions? (on avg,
% for strong place cells?)
% - i.e. how do cells transition between groups?

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
    
    % find index of cellReg cells with respect to original C/A
    goodSeg = multSessTuningStruc(i).goodSegPosPkStruc.goodSeg;
    cellRegArr = mapInd(:,i);
    
    for j = 1:length(cellRegArr) % for all cells in cellReg array from this session (0's for cells not in session)
        if cellRegArr(j)~=0  % if this cell is present in this session
            mapInd2(j,i) = goodSeg(cellRegArr(j));
        else
            mapInd2(j,i) = 0; % NOTE: mapInd2 is now ziv cellReg array with orig C/A indices
        end
    end
    
    % find ind of place cells w. re. to orig C/A
    greatSeg = multSessTuningStruc(i).goodSegPosPkStruc.greatSeg;
    placeCellOrigInd{i} = greatSeg(multSessTuningStruc(i).placeCellStruc.goodRay);
    
end

%%
% find ziv array cells present in all sessions
cellRegIndInAll = find(min(mapInd2, [], 2)); % [1,1,1,...] in all col
cellsInAll = mapInd2(cellRegIndInAll,:); % orig C/A index of all ziv registered cells present in all sessions

%%
% see if cells present in all sessions are place cells in all
for i = 1:size(cellsInAll,1) % for all cells 
    for j = 1:size(cellsInAll,2)    % for each session from that cell
        if find(placeCellOrigInd{j}== cellsInAll(i,j)) % see if it's a place cell
            sameCellPlaceBool(i,j) = 1;
        else
            sameCellPlaceBool(i,j) = 0;
        end
    end
end

%%
% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
placeCellsInAll = find(min(sameCellPlaceBool, [], 2)); % index in array of only cells present in all sessions
notPlaceCellsInAll = find(~max(sameCellPlaceBool, [], 2)); % or cells present in all sessions that are place cells in none

%%
% tuning in placeCellsInAll
placeCellAllOrigInd = cellsInAll(placeCellsInAll,:);
%= cellRegIndInAll(placeCellsInAll,:);

%% Plotting
% plot tuning of cells that are place cells (Rayleigh<0.01) in all
% sessions

figure; color = {'r' 'g' 'b'};
% for all cells
for i = 1:length(placeCellsInAll)
    subplot(3,3,i);
    hold on;
    for j = 1:size(placeCellAllOrigInd,2)
        origInd = placeCellAllOrigInd(i,j); % orig C/A index of this cell
        goodSegInd = find(multSessTuningStruc(j).goodSegPosPkStruc.goodSeg == origInd);
        posPks = multSessTuningStruc(j).goodSegPosPkStruc.goodSegPosPks(goodSegInd,:);
        samePlacePosPks(i,j,:) = posPks;
        plot(posPks, color{j});
    end
end


%%
%save spatial profiles of cells from all sessions, aligned with ziv
for i = 1:length(unitSpatCell)
    allCell = mean(unitSpatCell{i},1);
    rgb(:,:,i) = allCell/max(allCell(:));
end

imwrite(rgb, 'cellRegRGB.tif');

%cellRegIndInAll

% mark centroids of place cells in all
rgb2 = insertMarker(rgb, zivCentroids(cellRegIndInAll(placeCellsInAll),:));
figure;
imshow(rgb2);

% also, want to look at whether there are clusters or domains of tuning
% similarity

% go ahead and get posPks for all ziv cells, to look at tuning of cells
% that appear or disappear in different sessions

%figure; pie([229 35 8 42]);
