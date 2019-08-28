function [cueTrigSigStruc] = avgCueTrigSig(segNum, eventName, toPlot, varargin)


% eventName = 'led' to make 'ledTime', etc.

if length(varargin)>0 % like 'auto'
    if length(varargin{1}>4)
        segDictName = varargin{1};
    else
        segDictName = findLatestFilename('_segDict_', 'goodSeg');
    end
else
    segDictName = uigetfile('*.mat', 'Select segDict to use');
    
end

load(segDictName);

if ~isempty(strfind(segDictName, 'seg2P'))
    C = seg2P.C2p;
end

%load(findLatestFilename('goodSeg'));
load(findLatestFilename('_treadBehStruc_'));


%[lapFrInds, lapEpochs] = findLaps(treadBehStruc.resampY(1:2:end));
[lapCueStruc] = findCueLapTypes(0);
lapTypeArr = lapCueStruc.lapTypeArr;

y = treadBehStruc.resampY; %(1:2:end); % NOTE that lapEpochs are based upon original (non-downsampled) frames
frTimes = treadBehStruc.adjFrTimes; %(1:2:end);

% if there are omitCue laps, estimate a time for typical cue position each
% lap
cuePos = lapCueStruc.lapTypeCuePos;
lapEpochs = lapCueStruc.lapEpochs;
if min(lapTypeArr)==0
%     cuePos = lapCueStruc.lapTypeCuePos;
%     lapEpochs = lapCueStruc.lapEpochs;
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

%% find times of cues at different locations
if length(cuePos)>1
    cueLapArr = lapTypeArr(find(lapTypeArr~=0)); % laps with cues
    pos1evInd = find(cueLapArr==1);
    pos2evInd = find(cueLapArr==2);
    [evTrigSig1, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos1evInd), 0, [-30 120], frTimes(1:2:end));
    [evTrigSig2, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos2evInd), 0, [-30 120], frTimes(1:2:end));
    if length(cuePos)>2
        pos3evInd = find(cueLapArr==3);
        [evTrigSig3, zeroFr] = eventTrigSig(C(segNum,:), evTimes(pos3evInd), 0, [-30 120], frTimes(1:2:end));
        
    end
else
    
    [evTrigSig1, zeroFr] = eventTrigSig(C(segNum,:), evTimes, 0, [-30 120], frTimes(1:2:end));
end

try
    [evTrigSig0, zeroFr] = eventTrigSig(C(segNum,:), omitCueTimes, 0, [-30 120], frTimes(1:2:end));
catch
end


%% save vars to output struc
cueTrigSigStruc.path = pwd;
cueTrigSigStruc.segDictName = segDictName;
try
cueTrigSigStruc.omitCueSig = evTrigSig0;
catch
    disp('No omit laps');
end
try
cueTrigSigStruc.shiftCueSig = evTrigSig1;
catch
    disp('No shift laps');
end
cueTrigSigStruc.midCueSig = evTrigSig2;

filename = findLatestFilename('.xml');
filename = filename(1:strfind(filename, '.xml')-1);

%% Plotting
<<<<<<< HEAD
% if toPlot
=======
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
try
    plotMeanSEMshaderr(evTrigSig3, 'c',25:30);
catch
end
yl = ylim; xl = xlim;
line([30 30], yl);
ylim(yl); xlim(xl);
title([filename ' ' eventName '-triggered avg., seg=' num2str(segNum)]);

subplot(2,1,2);
try
plot(evTrigSig0, 'r');
catch
end
hold on;
plot(evTrigSig1, 'g');
% yl = ylim; xl = xlim;
% line([30 30], yl);
% ylim(yl); xlim(xl);
try
    plot(evTrigSig2, 'b');
catch
end
try
    plot(evTrigSig3, 'c');
catch
end

yl = ylim; xl = xlim;
line([30 30], yl);
ylim(yl); xlim(xl);

>>>>>>> ef8bac3879c73b091bec3bfcd44d2579352419d9
% figure;
% subplot(2,1,1);
% try
% plotMeanSEMshaderr(evTrigSig0, 'r',25:30);
% catch
% end
% hold on;
% plotMeanSEMshaderr(evTrigSig1, 'g',25:30);
% try
%     plotMeanSEMshaderr(evTrigSig2, 'b',25:30);
% catch
% end
% try
%     plotMeanSEMshaderr(evTrigSig3, 'c',25:30);
% catch
% end
% 
% title(['seg=' num2str(segNum)]);
% 
% subplot(2,1,2);
% try
% plot(evTrigSig0, 'r');
% catch
% end
% hold on;
% plot(evTrigSig1, 'g');
% try
%     plot(evTrigSig2, 'b');
% catch
% end
% try
%     plot(evTrigSig3, 'c');
% catch
% end
% 
% % figure;
% % plot(evTrigSig1, 'b');
% % hold on;
% % plot(evTrigSig0, 'r');
% 
% end