function [cueCoefs, placeCoefs] = linModelMultRegSeb(varargin) %CellRegStrucforSigTrig)

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

% 050420: modifying linModelMultReg.m to work with sebnem input struc
% NOTE: that sessions 7 & 8 have different pattern of files in
% multSessSegStruc (omit/rand/omit instead of omit/rand/rand)

if nargin==0
    startPath = '/Backup20TB/clay/DGdata/multSessStrucs';
    load([startPath '/CellRegStrucforSigTrig.mat']);
else
    CellRegStrucforSigTrig = varargin{1};
end

cueCoefs = []; 
placeCoefs = [];
placeParams = [];
for j = 1:length(CellRegStrucforSigTrig) % for each animal in this struc
    try
        mapInd = CellRegStrucforSigTrig{j}.regMapInd; % load mapInd of registered cells
        multSessSegStruc = CellRegStrucforSigTrig{j}.multSessSegStruc;  % load multSessSegStruc for this animal
        numSess = length(multSessSegStruc);
        
        sessNames = {multSessSegStruc.sessName};
        
        cueSessInd = find(contains(sessNames, '_cue'));
        sessDays = str2double({multSessSegStruc.dayName});
        cueSessDays = sessDays(cueSessInd);
        randSessInd = find(contains(sessNames, '_rand'));
        randSessDays = sessDays(randSessInd);
        % for mice with two cueSess and one randSess, find cueSess from same
        % day as randSess
        if length(cueSessDays)>length(randSessDays)
            cueSess = find(cueSessDays==randSessDays);
        else
            cueSess = cueSessInd;
        end
        
        fitStruc = struct();
        for i = 1:numSess
            
            sessName = multSessSegStruc(i).sessName;
            %         path = [startPath '/' multSessSegStruc(i).dayName '/' sessName '/'];
            %         cd(path);
            
            if contains(sessName, 'Omit') && i==cueSessInd(cueSess)
                
                %cueOmitInd = i; % index of multSessSegStruc for cueOmit sess
                
                % get cueCell info
                
                % cueCellStruc.path = cueShiftStruc.path;
                % cueCellStruc.cueShiftName = cueShiftStruc.filename;
                %             posRatesRef = cueCellStruc.posRatesRef; % posRates for reference laps
                startCueCellInd = CellRegStrucforSigTrig{j}.EdgeCueCellInd{i}; % edge/lap cue cells (<10, >90 pos)
                placeCellInd = CellRegStrucforSigTrig{j}.placeCellInd{i}; % place cells are PCs in range 10:40, 70:90
                %midCellInd = CellRegStrucforSigTrig{j}.midCellInd{i}; % just cells in middle
                %midCueCellInd = cueCellStruc.midCueCellInd; % cells with 2x PF rate vs omit
                nonCueCellInd = CellRegStrucforSigTrig{j}.nonCueCellInd{i}; % middle cells with omit rates >1/2 normal rate
                midCueCellInd = CellRegStrucforSigTrig{j}.MidCueCellInd{i}; %3; % middle cells with omit rates <1/2 norm rates
                
                %             [maxVal, maxInd] = max(posRatesRef'); % sort omitCue cells based on position
                
            elseif contains(sessName, 'rand')
                disp(['Linear regression for randCue sess: ' sessName]);
                tic;
                %[linFitStruc] = linearFitCaCueSess(toPlot); % this will do linear model for all cells in sess
                
                C = multSessSegStruc(i).C;
                treadBehStruc = multSessSegStruc(i).treadBehStruc;
                linFitStruc = struct();
                for k=1:size(C,1)
                    
                    % run linear model
                    [goodParams, coefs, pvals, r2, paramNames] = fitCaCuePos(C(k,:), treadBehStruc);
                    
                    linFitStruc(k).r2 = r2;
                    linFitStruc(k).goodParams = goodParams;
                    linFitStruc(k).coefs = coefs;
                    linFitStruc(k).pvals = pvals;
                    linFitStruc(k).paramNames = paramNames;
                    
                end
                toc;
                fitStruc(i).linFitStruc = linFitStruc;
            end
        end  % end FOR sessions in multSessSegStruc
        
        %end % end FOR loop through all animals
        
        %%
        
        % find coefs for diff cell types
        
        
        for i = 1:length(midCueCellInd)
            %matchSess = 2;
            cueSeg = midCueCellInd(i);
            mapIndRow = find(mapInd(:,cueSessInd)==cueSeg); % find row for this cell in mapInd
            matchSess = randSessInd(2);
            randSeg = mapInd(mapIndRow,matchSess); % find seg num for this cell in randCue sess
            if randSeg==0
                try
                    %matchSess = 3;
                    matchSess = randSessInd(1);
                    randSeg = mapInd(mapIndRow,matchSess);
                catch
                end
            end
            
            if randSeg>0 % if there are any matching cells, find coefs (if signif)
                cellCoefs = fitStruc(matchSess).linFitStruc(randSeg).coefs;
                cellParams = [fitStruc(matchSess).linFitStruc(randSeg).goodParams];
                if ~isempty(find(cellParams==2)) % if and signif cue coefs, add
                    %cueCoefs = [cueCoefs cellCoefs(1)];
                    %end
                    
                    placeInds = find(cellParams>3); % find any place coefs for this cell
                    
                    if ~isempty(placeInds)
                        placeCoef = cellCoefs(placeInds);
                        [maxCoef,ind] = max(placeCoef); % find max positive place coef
                        if maxCoef>0
                            %placeCoefs = [placeCoefs maxCoef];
                        else
                            [maxCoef,ind] = min(placeCoef);
                            %placeCoefs = [placeCoefs maxCoef];
                        end
                        placeParams = [placeParams cellParams(placeInds(ind))-3]; % just tabulate which spatial bin max signif coef is in
                    end % end IF there are any signif place coefs
                end % end IF there is significant cue coef
                
                cueCoefs = [cueCoefs cellCoefs(1)];
                placeCoefs = [placeCoefs maxCoef];
                
            end % end IF there are any registered cells
        end % end FOR loop through all midCue Cells in animal
        
    catch
    end
    
end % end FOR loop through all animals

%% plot
try
figure; plot(cueCoefs, placeCoefs, '.');
semCue = std(cueCoefs)/sqrt(length(cueCoefs)); semPlace = std(placeCoefs)/sqrt(length(placeCoefs));
figure; hold on;
bar([mean(cueCoefs) mean(placeCoefs)]); errorbar([mean(cueCoefs) mean(placeCoefs)], [semCue semPlace]);
catch
end