function [treadBehStruc] = procHen2pBehav(varargin);

%% USAGE: [treadBehStruc] = procHen2pBehav();
% Clay 2017
% GUI select TDML behavior and 2p XML files
% to process 2p behavioral data from Jack Bowler's 
% BehaviorMate system

switch nargin
    case 1
        % read behavioral events and times
        [treadBehStruc] = readTDML('auto');
        
        % find 2p frame times
        [relFrTimes, absFrTimes, frInds] = get2pFrTimes('auto');
    case 2 % if two inputs, then 'auto' and cue task
         % read behavioral events and times
        [treadBehStruc] = readTDML_cueShift('auto');
        % find 2p frame times
        [relFrTimes, absFrTimes, frInds] = get2pFrTimes('auto');
    otherwise
        % read behavioral events and times
        [treadBehStruc] = readTDML();
        
        % find 2p frame times
        [relFrTimes, absFrTimes, frInds] = get2pFrTimes();
end

treadBehStruc.relFrTimes = relFrTimes; % times relative to start of frame grab (trig by beMate)
treadBehStruc.absFrTimes = absFrTimes;  % absolute time from start of acq (before trig)
treadBehStruc.frInds = frInds; % just indices of each from from Bruker XML

%% calculate frame times adjusted to behav TDML times
% take into account offset between behavior start time and 2p trigger ON
adjFrTimes = relFrTimes + treadBehStruc.syncOnTime;  % this gives you 2p frame times relative to behav/TDML timescale
treadBehStruc.adjFrTimes = adjFrTimes;

%% resample y position to frame times and calculate velocity over each frame (at 30hz)
y = treadBehStruc.y;
% yTimes = treadBehStruc.yTimes;
% yTimeNano = treadBehStruc.yTimeNano; % in msec
% yTimes = (yTimeNano-yTimeNano(1))/1000+yTimes(1);

% as of 112418 using pos times adjusted based upon rotary encoder nano
% millis(), because sometimes beMate position readings come in late (i.e.
% serial is logged later than actually occurs due to processor/serial
% loading). This is adjusted in readTDML scripts (but should probably be
% here instead?)
yTimes = treadBehStruc.yTimesAdj; 

% and also, fix position (for discontinuities and other problems around lap
% boundaries)
%y = fixPos(y);

% only take position data from same period as images (but times themselves
% are unchanged)
frEpochInds = find(yTimes>=adjFrTimes(1) & yTimes<=adjFrTimes(end));
y2 = y(frEpochInds);
yTimes2 = yTimes(frEpochInds);

% position resampled to 2p frame times
resampY = interp1(yTimes2, y2, adjFrTimes); % THIS IS REALLY THE POSITION OUTPUT YOU WANT

% now fix resamples at lap boundaries
resampY = fixResampY(resampY);

% calc velocity
vel = abs(diff(resampY)); % units are mm/frame
vel = [vel vel(end)];  % just repeat last vel to make same length as fr


%% save relevant variables to output structure
treadBehStruc.y = y2; % this is position from TDML from same epoch as frames
treadBehStruc.yTimes = yTimes2; % and the times of TDML position from this epoch
treadBehStruc.resampY = resampY; % NOTE that times will be = adjFrTimes
treadBehStruc.vel = vel*30; % units now mm/sec

% save 
xmlName = findLatestFilename('.xml');
basename = xmlName(1:strfind(xmlName,'.xml')-1);
save([basename '_treadBehStruc_' date '.mat'], 'treadBehStruc');