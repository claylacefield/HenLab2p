function [cueTrigSigStruc, segDictName] = avgCueTrigSigAllLaps(eventName, toPlot, varargin)


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


% times for all cues
evTimes = treadBehStruc.([eventName 'TimeStart']);

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
evPos = treadBehStruc.([eventName 'PosStart']);
numLaps = size(lapEpochs,1);
numOmitLaps = length(find(lapTypeArr==0));
tic;
for i = 1:size(C,1)
    [evTrigSig1, zeroFr] = eventTrigSig(C(i,:), evTimes, 0, [-30 120], frTimes2);   % normal cueTrigSig for this unit
    for k = 1:numShuff  % shuffle
        evPos2 = [evPos evPos(randsample(length(evPos),numOmitLaps))]; % fill in omit lap pos with random pos from other laps
        rs1 = randsample(numLaps,numLaps); rs2 = randsample(numLaps,numLaps); rs = rs1(rs2); % randomize random (because too many same!)
        evPos2 = evPos2(rs); % resample event positions by lap (thus same distr of event positions)
        for j=1:numLaps     % for each lap/eventPosition, find nearest frame for that pseudo-event
            try
                evFrIndRes(j) = find(y(lapEpochs(j,1):lapEpochs(j,2))>evPos2(j),1)+lapEpochs(j,1);
            catch
            end
        end
        evFrIndRes = evFrIndRes(evFrIndRes>30);    % just trim first if necessary
        [evTrigSig, zeroFr] = eventTrigSig(C(i,:), evFrIndRes, 0, [-30 120]); % find evTrigSig for that pseudo-event
        evTrigSigShuff(:,k) = mean(evTrigSig,2); % just take mean of all event evTrigSigs for this shuffle iteration
    end
    maxShuff = max(evTrigSigShuff(41:100,:),[],1); %-mean(evTrigSigShuff(25:30,:),1),[],1);
    avEvTrigSig1 = mean(evTrigSig1,2);
    
    sd = std(evTrigSigShuff(:)); %meanShuff = mean(evTrigSigShuff(:));
    
    if length(find((maxShuff+2*sd)>(max(avEvTrigSig1(41:100)))))==0 %-mean(avEvTrigSig1(25:30))))))<=1 %max(avEvTrigSig1(31:100))>meanShuff+2*sd  %
        isCueCell(i)=1; disp(['cue cell, seg ' num2str(i)]);
        figure; plot(evTrigSigShuff); hold on; plot(avEvTrigSig1,'k'); title(['cue cell, seg ' num2str(i)]);
    else
        isCueCell(i)=0;
    end
end
toc;

%% save vars to output struc
cueTrigSigStruc.path = pwd;
cueTrigSigStruc.segDictName = segDictName;

cueTrigSigStruc.isCueCell = isCueCell;

cueTrigSigStruc.cueTrigSig = evTrigSig1;

filename = findLatestFilename('.xml');
filename = filename(1:strfind(filename, '.xml')-1);

%% Plotting

if toPlot
figure;
% subplot(2,1,1);
% try
% plotMeanSEMshaderr(evTrigSig1, 'g',25:30);
% catch
% end
% yl = ylim; xl = xlim;
% line([30 30], yl);
% ylim(yl); xlim(xl);
% title([filename ' ' eventName '-triggered avg., seg=' num2str(segNum)]);
% 
% subplot(2,1,2);
plot(evTrigSig1, 'g');
% yl = ylim; xl = xlim;
% line([30 30], yl);
% ylim(yl); xlim(xl);


yl = ylim; xl = xlim;
line([30 30], yl);
ylim(yl); xlim(xl);

end

