function linModelMultReg(multSessSegStruc, cell_registered_struct)

% linear model on multiple sessions registered

% INPUTS:
% multSessSegStruc: struc of session info, prior to cellReg
% cell_registered_struct: struc of registered sessions, corresponding to
% multSessSegStruc

% get cue cells (>2x omit rate) from registered sessions
% do linear model on these sessions, and then select coefs for cue cells
% and place cells and plot
% 1. get path from multSessSegStruc
% 2. do findCueCells in omitCue session, select 2x rate cueCells and place cells (pre, and
% post cue separately)
% 3. run linearFitCaCueSess on randCue session (make sure source segDict/seg2P is same as
% multSessSegStruc)
% 4. use cellReg mapInd to find randCue linFitStruc cells for omitCue cue
% cells (and place cells)
% 5. plot cue and place coeff for cue and place cells

% testFolder = '/Backup20TB/clay/DGdata/multSessStrucs/IR-519-B2';

startPath = '/Backup20TB/clay/DGdata';

mapInd = cell_registered_struct.cell_to_index_map;

numSess = length(multSessSegStruc);

fitStruc = struct();
for i = 1:numSess
    
    sessName = multSessSegStruc(i).sessName;
    path = [startPath '/' multSessSegStruc(i).dayName '/' sessName '/'];
    cd(path);
    
    if contains(sessName, 'Omit')
        cueShiftStrucName = findLatestFilename('cueShiftStruc');
        disp(['Finding cue cells in: ' cueShiftStrucName]);
        load(cueShiftStrucName);
        tic;
        eventName = 'olf'; segDictCode = sessName; toPlot = 0;
        [cueCellStruc] = findCueCells(cueShiftStruc, eventName, segDictCode, toPlot);
        toc;
        %fitStruc(i) = struct();
    elseif contains(sessName, 'rand')
        disp(['Linear regression for randCue sess: ' sessName]);
        tic;
        [linFitStruc] = linearFitCaCueSess(toPlot); % this will do linear model for all cells in sess
        toc;
        fitStruc(i).linFitStruc = linFitStruc;
    end
end

%% 

% get cueCell info

% cueCellStruc.path = cueShiftStruc.path;
% cueCellStruc.cueShiftName = cueShiftStruc.filename;
posRatesRef = cueCellStruc.posRatesRef; % posRates for reference laps
startCueCellInd = cueCellStruc.startCueCellInd; 
placeCellInd = cueCellStruc.placeCellInd; 
midCellInd = cueCellStruc.midCellInd; % just cells in middle
%midCueCellInd = cueCellStruc.midCueCellInd; % cells with 2x PF rate vs omit
nonCueCellInd = cueCellStruc.nonCueCellInd;
midCueCellInd = cueCellStruc.midCueCellInd; %3;

[maxVal, maxInd] = max(posRatesRef'); % sort omitCue cells based on position

% find coefs for diff cell types

for i = 1:length(midCueCellInd)
    matchSess = 2;
    cueSeg = midCueCellInd(i);
    mapIndRow = find(mapInd(:,1)==cueSeg); % find row for this cell in mapInd
    randSeg = mapInd(mapIndRow,matchSess); % find seg num for this cell in randCue sess
%     if randSeg==0
%         matchSess = 3;
%         randSeg = mapInd(mapIndRow,matchSess);
%     end
    
    if randSeg>0
        cellCoefs = fitStruc(matchSess).linFitStruc(randSeg).coefs;
        cellParams = [fitStruc(matchSess).linFitStruc(randSeg).goodParams];
        if ~isempty(find(cellParams==2))
            cueCoefs(i) = cellCoefs(1);
        end
        
        placeInds = find(cellParams>2);
        
        if ~isempty(placeInds)
            placeCoefs = cellCoefs(placeInds);
            [maxCoef,ind] = max(placeCoefs);
            if maxCoef>0
                placeCoef(i) = maxCoef;
            else
                [maxCoef,ind] = min(placeCoefs);
                placeCoef(i) = maxCoef;
            end
            placeParam(i) = cellParams(placeInds(ind))-2;
            
        end
        
    end
    
end

figure; plot(cueCoefs, placeCoef, '.');
semCue = std(cueCoefs)/sqrt(length(cueCoefs)); semPlace = std(placeCoef)/sqrt(length(placeCoef));
figure; hold on;
bar([mean(cueCoefs) mean(placeCoef)]); errorbar([mean(cueCoefs) mean(placeCoef)], [semCue semPlace]);