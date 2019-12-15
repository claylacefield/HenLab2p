function [cueTrigSigStruc, segDictName] = avgCueTrigSigAllLaps(eventName, toPlot, varargin)

%% USAGE: [cueTrigSigStruc, segDictName] = avgCueTrigSigAllLaps(eventName, toPlot, varargin);
% Clay 2019
% description:
% Performs avgCueTrigSig on all cells in segDict, then compares the event
% triggered avg with a lap-shuffled distribution of activity from the same
% cell (i.e. distribution of positions is the same as real but whether
% event is on that lap is shuffled).
% This works well for "random" events (randRew, randCue), but doesn't seem
% to work for shift (why?).
% >>> because the lower % of other laps types means that the resampling
% will produce many of the same cue positions

% Examples:
% [cueTrigSigStruc, segDictName] = avgCueTrigSigAllLaps(eventName, toPlot, toZ, C, treadBehStruc);

% basically needs C and treadBehStruc
% eventName = 'led' to make 'ledTime', etc.

if length(varargin)>0 % like 'auto'
    if ~isempty(strfind(varargin{1},'seg'))
        segDictName = varargin{1};
    elseif varargin{1}==0
        segDictName = findLatestFilename('_segDict_', 'goodSeg');
    elseif varargin{1}==1
        toZ=1;
    end
    
    try
    load(segDictName);
    if ~isempty(strfind(segDictName, 'seg2P'))
        C = seg2P.C2p;
    end
    catch
    end
    
    if length(varargin)==2
        toZ = varargin{2};
    end
    
    if length(varargin)==3
        toZ = varargin{1};
        C = varargin{2};
        treadBehStruc = varargin{3};
    end
else
    segDictName = uigetfile('*.mat', 'Select segDict to use');
    %load(findLatestFilename('_treadBehStruc_'));
    try
    load(segDictName);
    if ~isempty(strfind(segDictName, 'seg2P'))
        C = seg2P.C2p;
    end
    catch
    end
end

if ~exist('treadBehStruc')
    load(findLatestFilename('_treadBehStruc_'));
end

if ~exist('C')
    segDictName = findLatestFilename('_segDict_', 'goodSeg');
    load(segDictName);
    if ~isempty(strfind(segDictName, 'seg2P'))
        C = seg2P.C2p;
    end
end

if ~exist('toZ')
    toZ = 0;
end


%[lapFrInds, lapEpochs] = findLaps(treadBehStruc.resampY(1:2:end));
[lapCueStruc] = findCueLapTypes2(0);
lapTypeArr = lapCueStruc.lapTypeArr;

y = treadBehStruc.resampY; %(1:2:end); % NOTE that lapEpochs are based upon original (non-downsampled) frames
frTimes = treadBehStruc.adjFrTimes; %(1:2:end);


% times (and positions) for all cues (slightly diff for rew)
if isempty(strfind(eventName, 'rew'))
evTimes = treadBehStruc.([eventName 'TimeStart']);
evPos = treadBehStruc.([eventName 'PosStart']);
else
    evTimes = treadBehStruc.rewZoneStartTime; %rewTime;
    evPos = treadBehStruc.rewZoneStartPos; %rewPos;
end

%% find times of cues at different locations

% adjust if downsampled temporally
if size(C,2)<(length(frTimes)/1.5)
frTimes2 = frTimes(1:2:end);
y = y(1:2:end);
else
    frTimes2 = frTimes;
end

% for i = 1:size(C,1)
%     [evTrigSig0, zeroFr] = eventTrigSig(C(i,:), evTimes, 0, [-30 120], frTimes2);
%     evTrigSig1(:,i) = mean(evTrigSig0,2);
%     
%     % bootstrap shuffle
%     numShuff = 100;
%     maxTime = max(frTimes2);
%     %r = rng('shuffle');
%     %randArr = randi([-round(maxTime/2) round(maxTime/2)],0,numShuff);
%     for j=1:numShuff
%         evTimes2 =  maxTime-evTimes;    % flip
%         evTimes2 = evTimes2(end:-1:1)+round(rand*maxTime); % shift
%         evTimes2(evTimes2>maxTime)= evTimes2(evTimes2>maxTime)-maxTime; % adjust for rollover
%         evTimes2 = sort(evTimes2);
%         [evTrigSig, zeroFr] = eventTrigSig(C(i,:), evTimes2(end:-1:1), 0, [-30 120], frTimes2);
%         evTrigSigShuff(:,j) = mean(evTrigSig,2);
%     end
%     maxShuff = max(evTrigSigShuff(30:100,:)-mean(evTrigSigShuff(25:30,:),1),[],1);
%     if length(find(maxShuff>(max(evTrigSig1(31:100,i)-mean(evTrigSig1(25:30,i),1),[],1))))<5
%         isCueCell(i)=1;
%     else
%         isCueCell(i)=0;
%     end
% end

%% another method (now trying this for randCue, but should think about whether it works for shift)
% take lapTypes, shuffle the positions of the events for different
% lapTypes, then find times for those positions
% Thus the distribution of positions will be the same, but 

numShuff = 100;


[lapFrInds, lapEpochs] = findLaps(y);
%cueLaps = find(lapTypeArr~=0);
%cueLapTypes = 
%resInds = randsample(length(cueLaps),length(cueLaps));
%evPos = treadBehStruc.([eventName 'PosStart']);
numLaps = size(lapEpochs,1);
numOmitLaps = length(find(lapTypeArr==0));
tic;
for i = 1:size(C,1) % for each unit/seg
    [evTrigSig1, zeroFr] = eventTrigSig(C(i,:), evTimes, 0, [-30 120], frTimes2);   % normal cueTrigSig for this unit
    for k = 1:numShuff  % shuffle
        evPos2 = [evPos evPos(randsample(length(evPos),numOmitLaps))]; % fill in omit lap pos with random pos from other laps
        rs1 = randsample(numLaps,numLaps); 
        rs2 = randsample(numLaps,numLaps); 
        rs = rs1(rs2); % randomize random (because too many same!)
        evPos2 = evPos2(rs); % resample event positions by lap (thus same distr of event positions)
        for j=1:numLaps     % for each lap/eventPosition, find nearest frame for that pseudo-event
            try
                evFrIndRes(j) = find(y(lapEpochs(j,1):lapEpochs(j,2))>evPos2(j),1)+lapEpochs(j,1);
            catch
            end
        end
        evFrIndRes = evFrIndRes(evFrIndRes>30);    % just trim first event if necessary (<30 fr from beg)
        [evTrigSig, zeroFr] = eventTrigSig(C(i,:), evFrIndRes, 0, [-30 120]); % find evTrigSig for that pseudo-event
        evTrigSigShuff(:,k) = mean(evTrigSig,2); % just take mean of all event evTrigSigs for this shuffle iteration
    end
    maxShuff = max(evTrigSigShuff(41:100,:),[],1); %-mean(evTrigSigShuff(25:30,:),1),[],1);
    shuffBaseline = mean(evTrigSigShuff(1:29,:),1); % baseline for shuffle
    avEvTrigSig1 = mean(evTrigSig1,2); % mean event ca response for all laps
    realBaseline = mean(avEvTrigSig1(1:29));    % baseline for real mean evTrigSig
    %sdRef = std(evTrigSig1,0,2); sd = mean(sdRef(:));
    
    sd = std(evTrigSigShuff(:)); %meanShuff = mean(evTrigSigShuff(:));
    
    % if real peak is always much larger than any shuffled peaks, then is cueCell
    if length(find((maxShuff+3*sd)-shuffBaseline>(max(avEvTrigSig1(41:100)))-realBaseline))==0 %-mean(avEvTrigSig1(25:30))))))<=1 %max(avEvTrigSig1(31:100))>meanShuff+2*sd  %
        isCueCell(i)=1; disp(['cue cell, seg ' num2str(i)]);
        figure; 
        subplot(2,1,1); 
        plot(evTrigSigShuff); hold on; plot(avEvTrigSig1,'k'); title(['cue cell, seg ' num2str(i)]);
        subplot(2,1,2); 
         hold on;
        plotMeanSEMshaderr(evTrigSigShuff,'k');
        plotMeanSEMshaderr(evTrigSig1,'b');
        line([30 30], get(gca,'ylim'));
    else
        isCueCell(i)=0;
    end
end
toc;

if sum(isCueCell)==0
    disp(['No ' eventName ' cue cells!!!']);
end

%% save vars to output struc
try
cueTrigSigStruc.path = pwd;
cueTrigSigStruc.segDictName = segDictName;
catch
end

cueTrigSigStruc.isCueCell = isCueCell;

cueTrigSigStruc.cueTrigSig = evTrigSig1;

filename = findLatestFilename('.xml');
filename = filename(1:strfind(filename, '.xml')-1);

%% Plotting

% if toPlot
% figure;
% % subplot(2,1,1);
% % try
% % plotMeanSEMshaderr(evTrigSig1, 'g',25:30);
% % catch
% % end
% % yl = ylim; xl = xlim;
% % line([30 30], yl);
% % ylim(yl); xlim(xl);
% % title([filename ' ' eventName '-triggered avg., seg=' num2str(segNum)]);
% % 
% % subplot(2,1,2);
% plot(evTrigSig1, 'g');
% % yl = ylim; xl = xlim;
% % line([30 30], yl);
% % ylim(yl); xlim(xl);
% 
% 
% yl = ylim; xl = xlim;
% line([30 30], yl);
% ylim(yl); xlim(xl);
% 
% end
% 
% 
