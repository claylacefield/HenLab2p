function plotLapTypeTuning(unitTuningStruc, treadBehStruc, goodSeg, pcOnly, plotArr)

segList = goodSeg;

% plot unit tuning (posRateByLap) for each unit, for each lap
if ~isempty(find(plotArr==1))
    numfigs = 0;
    for i=1:length(segList)
        if mod(i,25)==1
            figure;
            numfigs=numfigs+1;
        end
        subplot(5,5,i-(numfigs-1)*25);
        imagesc(squeeze(unitTuningStruc.PCLappedSess.ByLap.posRateByLap(i,:,:))');
        title(num2str(segList(i)));
    end
end

% make list of lapTypes based upon treadBehStruc.lapTime, where every 5th
% is a cue switch lap
% NOTE: should find better way to do this that doesn't assume timing/order
rewPos = treadBehStruc.rewZoneStartPos; % note: may not work if last lap is switch
lapList = ones(length(treadBehStruc.lapTime)+1,1);
for lap = 1:length(lapList)
    if mod(lap,5)==0
        lapList(lap)=2;
    end
end

% and find indices of laps of each type (normal=1, cue switch=2)
lapType1ind = find(lapList==1);
lapType2ind = find(lapList==2);

% find lapType specific rates for each unit
numfigs = 0;
for i=1:length(segList)
    % unit rates for all laps (for all goodSegs)
    posRateLap = squeeze(unitTuningStruc.PCLappedSess.ByLap.posRateByLap(i,:,:));
    
    % and for each lap type
    posRateLap1 = posRateLap(:,lapType1ind(lapType1ind<=size(posRateLap,2)));
    posRateLap2 = posRateLap(:,lapType2ind(lapType2ind<=size(posRateLap,2)));
    
    % mean over all laps of each type
    posRateLap1avg(:,i) = mean(posRateLap1,2)';
    posRateLap2avg(:,i) = mean(posRateLap2,2)';
    
    % and plot if desired (but's it's a lot)
    if ~isempty(find(plotArr==2))
        if mod(i,25)==1
            figure;
            numfigs=numfigs+1;
        end
        subplot(5,5,i-(numfigs-1)*25);
        plot(squeeze(posRateLap1avg(:,i)), 'b'); hold on;
        plot(squeeze(posRateLap2avg(:,i)), 'g');
        title(num2str(segList(i)));
    end
end

%% plot sorted units

% only look at place cells
if pcOnly==1
pc = find(unitTuningStruc.PCLappedSess.Shuff.isPC==1);
else
    pc=1:length(goodSeg);
end

% sort lapType1 posRates
posRates1 = posRateLap1avg(:,pc)';

[maxVal, maxInd] = max(posRates1');
[newInd, oldInd] = sort(maxInd);

posRates1 = posRates1(oldInd,:);

% and sort lapType2 based upon lapType1 tuning
posRates2 = posRateLap2avg(:,pc)';
posRates2 = posRates2(oldInd,:);


% and plot..

% tuning of lapType1 PCs
if ~isempty(find(plotArr==3))
    figure('Position', [0 0 800 800]);
    subplot(2,2,1);
    colormap(jet);
    imagesc(posRates1);
    xlabel('position');
    title('LapType1');
    
    % tuning of lapType2 PCs
    subplot(2,2,2);
    colormap(jet);
    imagesc(posRates2);
    xlabel('position');
    title('LapType2');
    
    % and mean of each
    subplot(2,2,3);
    plot(mean(posRates1,1));
    hold on;
    plot(mean(posRates2,1),'g');
    title('posRates1=b, posRates2=g');
end