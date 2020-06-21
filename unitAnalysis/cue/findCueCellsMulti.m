function [cueCellStruc] = findCueCellsMulti(cueShiftStruc, cueEpoch, omitLap, toPlot)

% Clay 2020
% from findCueCells.m 
% 

cueStart = cueEpoch(1); cueEnd = cueEpoch(2);

% if segDictCode~=0
%     if isnumeric(segDictCode)
        segDictName = findLatestFilename('segDict', 'goodSeg');
%     else
%         segDictName = segDictCode;
%     end
% else
%     segDictName = uigetfile('*.mat', 'Select segDict/seg2P file');
% end


%% Find "normal" lap type (middle cue in typical location)
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1; % make omitCue last
for i=1:length(cueShiftStruc.pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType); % use ref lap from one with most laps

% extract posRates for normal/reference laps
posRatesRef = cueShiftStruc.PCLappedSessCell{refLapType}.posRates;

%% Criteria 1: place cell
% take PCs from normal laps
pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);

%% Criteria 2: position
% find the peak firing position of each cell
% (or should we use centerOfMass?)
[maxVal, maxInd] = max(posRatesRef');
pcPkPos = maxInd(pc); % just PCs

%% Start cue cells
% find start cue cells just based upon position (ind w.re. to all seg)
startCueCellInd = pc(find(pcPkPos>=90 | pcPkPos<=10));

% extract posRates for omit laps (all cells)
posRatesOmit = cueShiftStruc.PCLappedSessCell{omitLap}.posRates;
%posRatesShift = cueShiftStruc.PCLappedSessCell{1}.posRates;

% plot to check
if toPlot
    figure('Position',[0,50,800,800]);
    
    subplot(2,2,1);
    [sortInd] = plotUnitsByTuning(posRatesRef(startCueCellInd,:), 0, 1);
    cl = caxis;
    title('start cue cells');
    
    % plot to check
    subplot(2,2,3);
    colormap(jet); imagesc(posRatesOmit(startCueCellInd(sortInd),:));  caxis(cl);
    title('omit laps');
    
    subplot(2,2,2);
    %figure;
    plot(mean(posRatesRef(startCueCellInd,:),1), 'b');
    hold on;
    plot(mean(posRatesOmit(startCueCellInd,:),1), 'r');
    title('avgs');
    xlabel('pos');
    ylabel('mean rate (Hz)');
    legend('cue laps', 'omit laps');
end

%% Middle PC ind
midCellInd = pc(find(pcPkPos>=cueStart & pcPkPos<=cueEnd)); % pc(find(pcPkPos>=45 & pcPkPos<=65));
% NOTE that 45 might not include some predictive cells that fire just
% before the cue (but may not omit/shift)

% plot to check
if toPlot
    %maxVal = max(max(posRatesRef(midCellInd,:)));
    figure('Position',[0,50,800,800]);
    subplot(2,2,1);
    [sortInd] = plotUnitsByTuning(posRatesRef(midCellInd,:), 0, 1);
    cl = caxis;
    title('midCellInd');
    
    % extract posRates for omit laps
    %posRatesOmit = cueShiftStruc.PCLappedSessCell{end}.posRates;
    
    % plot to check
    subplot(2,2,3);
    colormap(jet); imagesc(posRatesOmit(midCellInd(sortInd),:));  caxis(cl);
    title('omit laps');
    
    subplot(2,2,2);
    %figure;
    plot(mean(posRatesRef(midCellInd,:),1), 'b');
    hold on;
    plot(mean(posRatesOmit(midCellInd,:),1), 'r');
    title('avgs');
    xlabel('pos');
    ylabel('mean rate (Hz)');
    legend('cue laps', 'omit laps');
end

%% Criteria 3: lack of omitCue response
try  % TRY/CATCH all sections based on omit laps, just in case they don't exist
    % find mean firing rate for area around peak (+/-5)
    for i=1:length(midCellInd)
        midFieldRateRef(i) = mean(posRatesRef(midCellInd(i),maxInd(midCellInd(i))-5:maxInd(midCellInd(i))+5),2);
        midFieldRateOmit(i) = mean(posRatesOmit(midCellInd(i),maxInd(midCellInd(i))-5:maxInd(midCellInd(i))+5),2);
    end
    
    %% Method #1: "cue cells" are middle cells with >= 2x posRate for cue trials vs. omit
    % quick and dirty for now: midCueCellInd = twice as big response to cue as omit
    midCueCellInd = midCellInd(find(midFieldRateRef./midFieldRateOmit>2));
    % NOTE: some are Inf, which is still>2, but these points don't plot below
    
    % take out Inf's for ratios (max at 25)
    refOmitRatio = midFieldRateRef./midFieldRateOmit;
    for i=1:length(refOmitRatio)
        if refOmitRatio(i)==Inf
            refOmitRatio(i)=25;
        end
    end
    
    nonCueCellInd = setdiff(midCellInd, midCueCellInd); % nonCueCells are middle cells that still have omit activ
    
    % plots
    if toPlot
        try
            figure;
            subplot(2,2,1);
            plot(maxInd(midCellInd),refOmitRatio,'.');
            hold on;
            line([45 65], [1 1]);
            title('spatial profile of cue/omit');
            xlabel('pos');
            
            %figure;
            subplot(2,2,2);
            plot(midFieldRateRef,midFieldRateOmit,'.');
            hold on;
            line([0 0.5], [0 0.5]);
            title('cue vs. omit');
            xlabel('cue'); ylabel('omit');
            
            %figure;
            subplot(2,2,3);
            hist(refOmitRatio,20);
            xlabel('midFieldRateRef./midFieldRateOmit');
            
            figure('Position', [50,100,800,800]);
            subplot(2,2,1);
            [sortInd] = plotUnitsByTuning(posRatesRef(midCueCellInd,:), 0, 1);
            cl = caxis;
            title('midCueCell (2x PF rate) cueLaps');
            subplot(2,2,3);
            colormap(jet); imagesc(posRatesOmit(midCueCellInd(sortInd),:)); caxis(cl);
            title('midCueCell omitLaps');
            if length(numLapType)==3
                posRatesShift = cueShiftStruc.PCLappedSessCell{1}.posRates;
                subplot(2,2,4);
                colormap(jet); imagesc(posRatesShift(midCueCellInd(sortInd),:)); caxis(cl);
                title('midCueCell ShiftLaps');
            end
            
            subplot(2,2,2);
            plot(mean(posRatesRef(midCueCellInd,:),1), 'b');
            hold on;
            plot(mean(posRatesOmit(midCueCellInd,:),1), 'r');
            title('avgs');
            xlabel('pos');
            ylabel('mean rate (Hz)');
            legend('cue laps', 'omit laps');
            
            figure('Position', [50,100,800,800]);
            subplot(2,2,1);
            [sortInd] = plotUnitsByTuning(posRatesRef(nonCueCellInd,:), 0, 1);
            cl = caxis;
            title('nonCueCell (<2x PF rate) cueLaps');
            subplot(2,2,3);
            colormap(jet); imagesc(posRatesOmit(nonCueCellInd(sortInd),:)); caxis(cl);
            title('nonCueCell omitLaps');
            if length(numLapType)==3
                %posRatesShift = cueShiftStruc.PCLappedSessCell{1}.posRates;
                subplot(2,2,4);
                colormap(jet); imagesc(posRatesShift(nonCueCellInd(sortInd),:)); caxis(cl);
                title('nonCueCell ShiftLaps');
            end
            
            subplot(2,2,2);
            plot(mean(posRatesRef(nonCueCellInd,:),1), 'b');
            hold on;
            plot(mean(posRatesOmit(nonCueCellInd,:),1), 'r');
            title('avgs');
            xlabel('pos');
            ylabel('mean rate (Hz)');
            legend('cue laps', 'omit laps');
        catch
        end
    end
    
    %% Method #3: "cue cells" have posRate diff cue-omit > 95% lap shuffled
    % now trying shuffle with laps
    midCellRateDiff = midFieldRateRef-midFieldRateOmit; % observed diff in middle rate for every middle cell
    posRateLapRef = cueShiftStruc.PCLappedSessCell{refLapType}.ByLap.posRateByLap;
    posRateLapOmit = cueShiftStruc.PCLappedSessCell{end}.ByLap.posRateByLap;
    numRefLaps = size(posRateLapRef,3);
    numOmitLaps = size(posRateLapOmit,3);
    
    posRateLapRefOmit = cat(3, posRateLapRef, posRateLapOmit);
    
    midCueCellInd3 = [];
    for i = 1:length(midCellInd)
        try
            for j=1:100
                
                % resample laps
                refLapRes = randsample(numRefLaps+numOmitLaps, numRefLaps);
                omitLapRes = setdiff(1:(numRefLaps+numOmitLaps),refLapRes);
                
                posRateRefRes = squeeze(mean(posRateLapRefOmit(midCellInd(i),:,refLapRes),3));
                posRateOmitRes = squeeze(mean(posRateLapRefOmit(midCellInd(i),:,omitLapRes),3));
                
                midFieldRateRefRes = mean(posRateRefRes(maxInd(midCellInd(i))-5:maxInd(midCellInd(i))+5));
                midFieldRateOmitRes = mean(posRateOmitRes(maxInd(midCellInd(i))-5:maxInd(midCellInd(i))+5));
                resampMeanDiff(j) = midFieldRateRefRes-midFieldRateOmitRes;
            end
            
            numGreater = length(find(resampMeanDiff>=midCellRateDiff(i)));
            
            if numGreater<=5
                midCueCellInd3 = [midCueCellInd3 midCellInd(i)];
            end
        catch
        end
        
    end
    
    if toPlot
        try
            figure('Position', [150,200,800,800]);
            subplot(2,2,1);
            [sortInd] = plotUnitsByTuning(posRatesRef(midCueCellInd3,:), 0, 1);
            cl = caxis;
            title('midCueCell (shuff) cueLaps');
            subplot(2,2,3);
            colormap(jet); imagesc(posRatesOmit(midCueCellInd3(sortInd),:)); caxis(cl);
            title('midCueCell omitLaps');
            if length(numLapType)==3
                %posRatesShift = cueShiftStruc.PCLappedSessCell{1}.posRates;
                subplot(2,2,4);
                colormap(jet); imagesc(posRatesShift(midCueCellInd3(sortInd),:)); caxis(cl);
                title('midCueCell ShiftLaps');
            end
            
            subplot(2,2,2);
            plot(mean(posRatesRef(midCueCellInd3,:),1), 'b');
            hold on;
            plot(mean(posRatesOmit(midCueCellInd3,:),1), 'r');
            title('avgs');
            xlabel('pos');
            ylabel('mean rate (Hz)');
            legend('cue laps', 'omit laps');
        catch
        end
    end
    
catch
    disp('No omit laps');
end


%% pack some stuff in output structure
cueCellStruc.path = cueShiftStruc.path;
cueCellStruc.cueShiftName = cueShiftStruc.filename;
cueCellStruc.posRatesRef = posRatesRef; % posRates for reference laps
cueCellStruc.startCueCellInd = startCueCellInd;
cueCellStruc.placeCellInd = setdiff(pc, [midCellInd; startCueCellInd]);
cueCellStruc.midCellInd = midCellInd; % just cells in middle

cueCellStruc.midCueCellInd = midCueCellInd; % cells with 2x PF rate vs omit
cueCellStruc.nonCueCellInd = nonCueCellInd;

cueCellStruc.midCueCellInd3 = midCueCellInd3;   % cue cells by lap shuffle event amplitude





