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
    otherwise
        % read behavioral events and times
        [treadBehStruc] = readTDML();
        
        % find 2p frame times
        [relFrTimes, absFrTimes, frInds] = get2pFrTimes();
end

treadBehStruc.relFrTimes = relFrTimes;
treadBehStruc.absFrTimes = absFrTimes;
treadBehStruc.frInds = frInds; % just indices of each from from Bruker XML

%% calculate frame times adjusted to behav TDML times
% take into account offset between behavior start time and 2p trigger ON
adjFrTimes = relFrTimes + treadBehStruc.syncOnTime;  % this gives you 2p frame times relative to behav/TDML timescale
treadBehStruc.adjFrTimes = adjFrTimes;

%% resamply position to frame times and calculate velocity over each frame (at 30hz)
y = treadBehStruc.y;
yTimes = treadBehStruc.yTimes;

% only take position data from same period as images (but times themselves
% are unchanged)
frEpochInds = find(yTimes>=adjFrTimes(1) & yTimes<=adjFrTimes(end));
y2 = y(frEpochInds);
yTimes2 = yTimes(frEpochInds);

resampY = interp1(yTimes2, y2, adjFrTimes); % THIS IS REALLY THE POSITION OUTPUT YOU WANT
vel = abs(diff(resampY)); % units are mm/frame
vel = [vel vel(end)];  % just repeat last vel to make same length as fr


%% save relevant variables to output structure
treadBehStruc.y = y2;
treadBehStruc.yTimes = yTimes2;
treadBehStruc.resampY = resampY; % NOTE that times will be = adjFrTimes
treadBehStruc.vel = vel*30; % units now mm/sec

