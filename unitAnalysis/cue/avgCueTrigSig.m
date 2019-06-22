function avgCueTrigSig(segNum, eventName)


% eventName = 'led' to make 'ledTime', etc.

load(findLatestFilename('_segDict_', 'goodSeg'));
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
evTimes = treadBehStruc.([eventName 'Time']);

% find times of cues at different locations
if length(cuePos)>1
cueLapArr = lapTypeArr(find(lapTypeArr~=0)); % laps with cues
pos1evInd = find(cueLapArr==3);
pos2evInd = find(cueLapArr==2);
[evTrigSig1, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos1evInd), 0, [-30 120], frTimes(1:2:end));
[evTrigSig2, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos2evInd), 0, [-30 120], frTimes(1:2:end));
else

[evTrigSig1, zeroFr] = eventTrigSig(C(segNum,:), evTimes, 0, [-30 120], frTimes(1:2:end));
end

try
[evTrigSig0, zeroFr] = eventTrigSig(C(segNum,:), omitCueTimes, 0, [-30 120], frTimes(1:2:end));
catch
end

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

% figure;
% plot(evTrigSig1, 'b');
% hold on;
% plot(evTrigSig0, 'r');
