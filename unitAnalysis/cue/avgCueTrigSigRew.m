function [cueTrigSigStruc] = avgCueTrigSigRew(segNum, eventName, toPlot, segDictName)


% eventName = 'led' to make 'ledTime', etc.
try
load(findLatestFilename('_seg2P_', 'goodSeg'));
C = seg2P.C2p;
catch
    load(findLatestFilename('_segDict_', 'goodSeg'));
end

%load(findLatestFilename('goodSeg'));
load(findLatestFilename('_treadBehStruc_'));


%[lapFrInds, lapEpochs] = findLaps(treadBehStruc.resampY(1:2:end));
[lapCueStruc] = findCueLapTypes(0);
lapTypeArr = lapCueStruc.lapTypeArr;

y = treadBehStruc.resampY; %(1:2:end); % NOTE that lapEpochs are based upon original (non-downsampled) frames
frTimes = treadBehStruc.adjFrTimes; %(1:2:end);

% if there are omitCue laps, estimate a time for typical cue position
if min(lapTypeArr)==0
    cuePos = lapCueStruc.lapTypeCuePos;
    lapEpochs = lapCueStruc.lapEpochs;
    omitLaps = find(lapTypeArr==0);
    
    for i=1:length(omitLaps)
        try
        epochPos = y(lapEpochs(omitLaps(i),1):lapEpochs(omitLaps(i),2));
        cuePosInd = find(epochPos>cuePos(end),1);
        epochTimes = frTimes(lapEpochs(omitLaps(i),1):lapEpochs(omitLaps(i),2));
        omitCueTimes(i) = epochTimes(cuePosInd);
        catch
        end
    end
    
end

% times for all cues
evTimes = treadBehStruc.([eventName 'TimeStart']);
evPos = treadBehStruc.([eventName 'PosStart']);

%% rew times each lap

% find refLapType
refLapType = findRefLapType(lapTypeArr);

% finding rewards actually consumed
rewZoneStartTimes = treadBehStruc.rewZoneStartTime;
rewZoneEndTimes = treadBehStruc.rewZoneStopTime;
rewOnTimes = treadBehStruc.rewTime;
rewZoneStartPos = treadBehStruc.rewZoneStartPos;
rewTimes = []; rewPos = []; goodLaps = [];
for i=1:length(rewZoneStartTimes)
    try
        if length(find(rewOnTimes>=rewZoneStartTimes(i) & rewOnTimes<=rewZoneEndTimes(i)))>2
            rewTimes = [rewTimes rewZoneStartTimes(i)];
            rewPos = [rewPos rewZoneStartPos(i)];
            goodLaps = [goodLaps i];
        end
    catch
    end
end

[counts, edges, rewPosBin] = histcounts(rewPos,1:200:2000);
midRewInds = find(rewPosBin>=4 & rewPosBin<=7); % +1;
%notMidRewInds = find(rewPosBin>7 | rewPosBin<5); % +1; notMidRewInds = notMidRewInds(1:end-1);

midCueLaps = find(lapTypeArr==refLapType);
midCueRewInds = intersect(midCueLaps, midRewInds); % inds of laps w midCue and rew
notMidRewInds = setxor(midCueLaps, midCueRewInds);

lapTypeArr2 = NaN(1,length(lapTypeArr));
lapTypeArr2(midCueRewInds) = 1;
lapTypeArr2(notMidRewInds) = 2;
lapTypeArr2(omitLaps) = 0;

% find times of cues at different locations

cueLapArr = lapTypeArr2(find(lapTypeArr2~=0)); % laps with cues
pos1evInd = find(cueLapArr==1);
pos2evInd = find(cueLapArr==2);
[evTrigSig1, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos1evInd), 0, [-30 120], frTimes(1:2:end));
[evTrigSig2, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos2evInd), 0, [-30 120], frTimes(1:2:end));


try
[evTrigSig0, zeroFr] = eventTrigSig(C(segNum,:), omitCueTimes, 0, [-30 120], frTimes(1:2:end));
catch
end


%% save vars to output struc
cueTrigSigStruc.path = pwd;
try
cueTrigSigStruc.segDictName = segDictName;
catch
end
try
cueTrigSigStruc.omitCueSig = evTrigSig0;
catch
    %disp('No omit laps');
end
try
cueTrigSigStruc.midRewCueSig = evTrigSig1;
catch
    %disp('No shift laps');
end
try
cueTrigSigStruc.midCueSig = evTrigSig2;
catch
end

filename = findLatestFilename('.xml');
filename = filename(1:strfind(filename, '.xml')-1);


%% plotting
if toPlot
    figure;
    subplot(2,1,1);
    try
        plotMeanSEMshaderr(evTrigSig0, 'r',25:30);
    catch
    end
    hold on;
    plotMeanSEMshaderr(evTrigSig1, 'g',25:30);
    try
        plotMeanSEMshaderr(evTrigSig2, 'b',25:30);
    catch
    end
    
    title(['seg=' num2str(segNum)]);
    
    subplot(2,1,2);
    try
        plot(evTrigSig0, 'r');
    catch
    end
    hold on;
    plot(evTrigSig1, 'g');
    try
        plot(evTrigSig2, 'b');
    catch
    end
end



