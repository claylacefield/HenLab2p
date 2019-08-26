function [startCueCellInd, midCueCellInd3] = findCueCells(cueShiftStruc, eventName)

%% USAGE: findCueCells(cueShiftStruc);
% This function finds the identity of putative start and middle/variable
% cue cells based upon:
% 1.) is a place cell (i.e. fires significantly more at cue location than
% elsewhere)
% 2.) position: firing within certain range of the cue
% 3.) (for middle cue) omitCue responses: if responses go away when cue not
% present.

% Issues:
%
% 073119:
%   - exactly what range do we use for cue location (start and middle)
%       - static location, or based upon TDML cue location (pin or
%       context?)
%   - omitCue response: should I take from avgCueTrigSig? or posRates at
%   middle cue location?


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

% plot to check
figure;
plotUnitsByTuning(posRatesRef(startCueCellInd,:), 0, 1);
title('start cue cells');

%% Middle PC ind
midCellInd = pc(find(pcPkPos>=40 & pcPkPos<=65)); % pc(find(pcPkPos>=45 & pcPkPos<=65));
% NOTE that 45 might not include some predictive cells that fire just
% before the cue (but may not omit/shift)

% plot to check
%maxVal = max(max(posRatesRef(midCellInd,:)));
figure('Position',[200,50,400,1200]);
subplot(2,1,1);
[sortInd] = plotUnitsByTuning(posRatesRef(midCellInd,:), 0, 1);
cl = caxis;
title('midCellInd');

% extract posRates for omit laps
posRatesOmit = cueShiftStruc.PCLappedSessCell{end}.posRates;

% plot to check
subplot(2,1,2); 
colormap(jet); imagesc(posRatesOmit(midCellInd(sortInd),:));  caxis(cl);
title('omit laps');

%% Criteria 3: lack of omitCue response

% find mean firing rate for area around peak (+/-5)
for i=1:length(midCellInd)
    midFieldRateRef(i) = mean(posRatesRef(midCellInd(i),maxInd(midCellInd(i))-5:maxInd(midCellInd(i))+5),2);
    midFieldRateOmit(i) = mean(posRatesOmit(midCellInd(i),maxInd(midCellInd(i))-5:maxInd(midCellInd(i))+5),2);
end

%% Method #1: "cue cells" are middle cells with >= 2x posRate for cue trials vs. omit
% quick and dirty for now: midCueCellInd = twice as big response to cue as omit
midCueCellInd = midCellInd(find(midFieldRateRef./midFieldRateOmit>2));
% NOTE: some are Inf, which is still>2, but these points don't plot below

% plots
figure; 
subplot(2,2,1);
plot(maxInd(midCellInd),midFieldRateRef./midFieldRateOmit,'.');
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
hist(midFieldRateRef./midFieldRateOmit,20);
xlabel('midFieldRateRef./midFieldRateOmit');

figure('Position', [200,50,400,1200]);
subplot(2,1,1); 
[sortInd] = plotUnitsByTuning(posRatesRef(midCueCellInd,:), 0, 1);
cl = caxis;
title('midCueCell (2x PF rate) cueLaps');
subplot(2,1,2); 
colormap(jet); imagesc(posRatesOmit(midCueCellInd(sortInd),:)); caxis(cl);
title('midCueCell omitLaps');


%% scratch

% playing with shuffle significance test for cueVsOmit response
% NOTE: may also t-test on amplitude
% pseudo:
% 1.) find cue-triggered responses for each unit, find peak/auc amplitude
% of each response
% 2.) calc diff in mean response
% 3.) put together cue and omit and randomly resample cue and omit laps
% 4.) calc diff in mean response

%% Method #2: "cue cells" are middle cells w. ttest2<0.05 for event amp
% This is based upon ttest2 bet cue and omit (NOTE: event max amp)
%eventName = 'tact';
midCueCellInd2 = [];
for i = 1:length(midCellInd)
    %tic;
    [cueTrigSigStruc] = avgCueTrigSig(midCellInd(i), eventName, 1);    
    omitCueSig = cueTrigSigStruc.omitCueSig;
    midCueSig = cueTrigSigStruc.midCueSig;
    %toc;
    
    for j=1:size(midCueSig,2)
        midCueAmp(j) = max(midCueSig(30:130,j)-midCueSig(30,j));
    end
    
    for j=1:size(omitCueSig,2)
        omitCueAmp(j) = max(omitCueSig(30:130,j)-omitCueSig(30,j));
    end
    
    [h,p,ci,stats] = ttest2(midCueAmp, omitCueAmp);
    
    if h==1
        midCueCellInd2 = [midCueCellInd2 midCellInd(i)];
    end
    
end

figure('Position', [200,50,400,1200]);
subplot(2,1,1); 
[sortInd] = plotUnitsByTuning(posRatesRef(midCueCellInd2,:), 0, 1);
cl = caxis;
title('midCueCell (ttest) cueLaps');
subplot(2,1,2); 
colormap(jet); imagesc(posRatesOmit(midCueCellInd2(sortInd),:)); caxis(cl);
title('midCueCell omitLaps');

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
    
end

figure('Position', [200,50,400,1200]);
subplot(2,1,1); 
[sortInd] = plotUnitsByTuning(posRatesRef(midCueCellInd3,:), 0, 1);
cl = caxis;
title('midCueCell (shuff) cueLaps');
subplot(2,1,2); 
colormap(jet); imagesc(posRatesOmit(midCueCellInd3(sortInd),:)); caxis(cl);
title('midCueCell omitLaps');

%% old stuff with COM, xcorr

% % difference in center of mass for each cell
% dcom = com1-com2;
% 
% % plot lapType xcorr peak lags and plot
% for i=1:length(pc)
%    [val, lag] = max(xcorr(posRates1(pc(i),:),posRates2(pc(i),:))); 
%    lags(i)=100-lag;
% end

%% shift
% testing on 190628_B4, seg 46, 87 (lower on shift)
% a.) calc rate at normal location vs shift location
% OR
% b.) shuffle avgCueTrigSig; [cueTrigSigStruc] = avgCueTrigSig(segNum, eventName, toPlot)
% c.) also look at shift in cue cells by omit, and all midCellInd (i.e. are
% cells that don't show omit more likely to shift?

if length(numLapType)==3 %3
    
    posRatesShift = cueShiftStruc.PCLappedSessCell{1}.posRates;
    
    lapTypeCuePos = cueShiftStruc.lapCueStruc.lapTypeCuePos;
    
    for i=1:length(midCellInd)
        midFieldRateRef(i) = mean(posRatesRef(midCellInd(i),20:35),2);
        midFieldRateShift(i) = mean(posRatesShift(midCellInd(i),20:35),2);
    end
    
    % now trying shuffle with laps
    midCellRateDiff = midFieldRateShift-midFieldRateRef;
    posRateLapRef = cueShiftStruc.PCLappedSessCell{refLapType}.ByLap.posRateByLap;
    posRateLapShift = cueShiftStruc.PCLappedSessCell{1}.ByLap.posRateByLap;
    numRefLaps = size(posRateLapRef,3);
    numShiftLaps = size(posRateLapShift,3);
    
    posRateLapRefShift = cat(3, posRateLapRef, posRateLapShift);
    
    midShiftCellInd3 = [];
    for i = 1:length(midCellInd)
        
        for j=1:100
            
            % resample laps
            refLapRes = randsample(numRefLaps+numShiftLaps, numRefLaps);
            shiftLapRes = setdiff(1:(numRefLaps+numShiftLaps),refLapRes);
            
            % find rates based upon resampled laps
            posRateRefRes = squeeze(mean(posRateLapRefShift(midCellInd(i),:,refLapRes),3));
            posRateShiftRes = squeeze(mean(posRateLapRefShift(midCellInd(i),:,shiftLapRes),3));
            
            midFieldRateRefRes = mean(posRateRefRes(20:35));
            midFieldRateShiftRes = mean(posRateShiftRes(20:35));
            resampMeanDiff(j) = midFieldRateShiftRes-midFieldRateRefRes;
        end
        
        numGreater = length(find(resampMeanDiff>=midCellRateDiff(i)));
        
        if numGreater<=5
            midShiftCellInd3 = [midShiftCellInd3 midCellInd(i)];
        end
        
    end
    
end

figure('Position', [200,50,400,1200]);
subplot(2,1,1); 
[sortInd] = plotUnitsByTuning(posRatesRef(midShiftCellInd3,:), 0, 1);
cl = caxis;
title('midShiftCell (shuff) cueLaps');
subplot(2,1,2); 
colormap(jet); imagesc(posRatesShift(midShiftCellInd3(sortInd),:)); caxis(cl);
title('midShiftCell shiftLaps');