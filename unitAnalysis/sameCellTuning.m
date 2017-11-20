function sameCellTuning(multSessTuningStruc, cell_registered_struct);


mapInd = cell_registered_struct.cell_to_index_map;

unitSpatCell = cell_registered_struct.spatial_footprints_corrected;


% NOTE: placeCellStruc is for greatSegs, 
% whereas cellReg is for goodSegs
%
% Questions: 
% - are place cells more likely to be present in all sessions?
% - is there a change in average tuning strength over sessions? (on avg,
% for strong place cells?)
% - i.e. how do cells transition between groups?

% for all sessions
for i = 1:size(mapInd,2)
    
    % index of cellReg cells with respect to original C/A
   goodSeg = multSessTuningStruc(i).goodSegPosPkStruc.goodSeg; 
   cellRegArr = mapInd(:,i);
   
   for j = 1:length(cellRegArr)
       if cellRegArr(j)~=0
       mapInd2(j,i) = goodSeg(cellRegArr(j));
       else
           mapInd2(j,i) = 0;
       end
   end
   
   % ind of place cells w. re. to orig C/A
   greatSeg = multSessTuningStruc(i).goodSegPosPkStruc.greatSeg; 
   placeCellOrigInd{i} = greatSeg(multSessTuningStruc(i).placeCellStruc.goodRay);
   
end

% find cells in all sessions
cellRegIndInAll = find(min(mapInd2, [], 2));
cellsInAll = mapInd2(cellRegIndInAll,:);

% see if cells present in all sessions are place cells in all
for i = 1:size(cellsInAll,1)
    for j = 1:size(cellsInAll,2)
        if find(placeCellOrigInd{j}== cellsInAll(i,j))
            sameCellPlaceBool(i,j) = 1;
        else
            sameCellPlaceBool(i,j) = 0;
        end
    end
end


% cellRegInd for cells present in all sessions, that are place cells in all
placeCellsInAll = find(min(sameCellPlaceBool, [], 2));

notPlaceCellsInAll = find(~max(sameCellPlaceBool, [], 2));
