function [cueTrigSigStruc, segDictName] = avgCueTrigSigNew(segNum, eventName, toPlot, varargin)

%% USAGE: [cueTrigSigStruc, segDictName] = avgCueTrigSigNew(segNum, eventName, toPlot, varargin)
% Examples:
% [cueTrigSigStruc, segDictName] = avgCueTrigSig(eventName, toPlot, toZ, C, treadBehStruc);

% basically needs C and treadBehStruc
% eventName = 'led' to make 'ledTime', etc.

% ToDo:
% - fix omit time estimation for randCue sessions
% - 121019: This now just computes different cueTrigSigs for different cue
% positions, but should do this for all lapTypes (like opto)
%
% Notes:
% - Fall 2019: "New" version now computes arbitrary number of cue positions

%% read varargin
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
    

%load(findLatestFilename('goodSeg'));



%[lapFrInds, lapEpochs] = findLaps(treadBehStruc.resampY(1:2:end));
rewOmit = 0;
[lapCueStruc] = findCueLapTypes2(rewOmit, treadBehStruc);
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

%% Estimate omit times
% if there are omitCue laps, estimate a time for typical cue position each
% lap. For shiftOmit, choose midCue pos, for rand, use rand pos (not done yet).
%cuePos = lapCueStruc.lapTypeCuePos;

% find avg pos for this cue
[N,edges,bin] = histcounts(evPos,'BinWidth', 200);
[val,ind] = max(N);
cuePos = round(mean(evPos(find(bin==ind))));

lapEpochs = lapCueStruc.lapEpochs;
evRow = find(strcmp(lapCueStruc.cueNameCell, eventName));
omitLaps2 = find(lapCueStruc.cuesPosLap(evRow,:)==0); % omit is all laps with no eventName cues (including opto)
omitLaps = find(lapTypeArr==0);
if length(omitLaps)~=0%min(lapTypeArr)==0
%     cuePos = lapCueStruc.lapTypeCuePos;
%     lapEpochs = lapCueStruc.lapEpochs;
    %omitLaps = find(lapTypeArr==0);
    
    for i=1:length(omitLaps)
        try
        epochPos = y(lapEpochs(omitLaps(i),1):lapEpochs(omitLaps(i),2)); % array of positions for this omit lap
        cuePosInd = find(epochPos>cuePos(end),1); % find index of normal cue pos on this lap
        epochTimes = frTimes(lapEpochs(omitLaps(i),1):lapEpochs(omitLaps(i),2)); % match with time for this pos/lap
        omitCueTimes(i) = epochTimes(cuePosInd);
        catch
        end
    end
    
end


%% find times of cues at different locations, and do eventTrigSig

ca = C(segNum,:);

% compute downsample
if length(y)>length(ca)*1.5
    ds = 2;
else
    ds = 1;
end


% zScore Ca if desired
%toZ = 1;
if toZ==1
    ca = zScoreCa(ca);
end

% evTrigSig for each cue type/pos
% questionable conditions: two cuePos/lap, one type of cue omitted laps, 
cueLapArr = lapTypeArr(setxor(1:length(lapTypeArr),omitLaps2));%lapTypeArr(find(lapTypeArr~=0)); % assumes that all omit laps are lapType=0 which is not always the case
if max(cueLapArr)>1%length(cuePos)>1 % if multiple cue positions
    %cueLapArr = lapTypeArr(find(lapTypeArr~=0)); % laps with cues
    goodLapTypes = 0;
    for i=1:max(cueLapArr) % for each lap type with a cue (i.e. not "omit" OR omit+opto)
        lapTypeInds = find(cueLapArr==i);
        if ~isempty(lapTypeInds)
            if length(lapTypeInds)>3 % just in case few weird laps (e.g. end)
                goodLapTypes = goodLapTypes+1;
                try
                    [evTrigSig{goodLapTypes}, zeroFr] = eventTrigSig(ca, evTimes(lapTypeInds), 0, [-30 180], frTimes(1:ds:end));
                catch
                    disp(['prob with lap type ' num2str(i) ' (maybe weird pos cue one lap)']);
                end
            end
        else % if lapTypeInds = [] then maybe omit + opto (or anyway, do like omit)
            goodLapTypes = goodLapTypes+1;
            laps = find(lapTypeArr==i);
            for j=1:length(laps)
                try
                    epochPos = y(lapEpochs(laps(j),1):lapEpochs(laps(j),2)); % array of positions for this omit lap
                    cuePosInd = find(epochPos>cuePos(end),1); % find index of normal cue pos on this lap
                    epochTimes = frTimes(lapEpochs(laps(j),1):lapEpochs(laps(j),2)); % match with time for this pos/lap
                    pseudoCueTimes(j) = epochTimes(cuePosInd);
                catch
                end
            end
            [evTrigSig{goodLapTypes}, zeroFr] = eventTrigSig(ca, pseudoCueTimes, 0, [-30 180], frTimes(1:ds:end));
        end
    end
    
    
else % else if only one (probably middle cue)
    i=1;
    [evTrigSig{i}, zeroFr] = eventTrigSig(ca, evTimes, 0, [-30 180], frTimes(1:ds:end));
end

% tack omit onto end if present
try
    [evTrigSig0, zeroFr] = eventTrigSig(ca, omitCueTimes, 0, [-30 180], frTimes(1:ds:end));
catch
end


%% save vars to output struc
cueTrigSigStruc.path = pwd;
try
cueTrigSigStruc.segDictName = segDictName;
catch
end
try
cueTrigSigStruc.evTrigSigCell = evTrigSig;
catch
end
try
cueTrigSigStruc.omitTrigSig = evTrigSig0;
catch
    hasOmit = 0;
end


filename = findLatestFilename('.xml');
filename = filename(1:strfind(filename, '.xml')-1);

%% Plotting
colors = {'g','b','c','m','k','y'};
if toPlot
    figure;
    subplot(2,1,1); hold on;
    try
        plotMeanSEMshaderr(evTrigSig0, 'r',25:30);
    catch
    end
    for i=1:length(cueTrigSigStruc.evTrigSigCell)
        try
            plotMeanSEMshaderr(cueTrigSigStruc.evTrigSigCell{i}, colors{i},25:30);
        catch
        end
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
    for i=1:length(cueTrigSigStruc.evTrigSigCell)
        try
            plot(cueTrigSigStruc.evTrigSigCell{i}, colors{i});
        catch
        end
    end
    
    yl = ylim; xl = xlim;
    line([30 30], yl);
    ylim(yl); xlim(xl);
    
end


