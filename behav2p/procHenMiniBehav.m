function [treadBehStruc] = procHenMiniBehav(numFrames, fps);

%% USAGE: [treadBehStruc] = procHen2pBehav();
% Clay 2017
% GUI select TDML behavior and 2p XML files
% to process 2p behavioral data from Jack Bowler's 
% BehaviorMate system


[treadBehStruc] = readTDML_cueShift(1); % process latest .tdml in folder
    
frTimesEst = (0:numFrames-1)/fps; % estimated frame times based upon Fs

adjFrTimes = frTimesEst + treadBehStruc.syncOnTime; % adjust for start trig time
% NOTE: now all frame times registered to TDML behavior
treadBehStruc.adjFrTimes = adjFrTimes;

%treadBehStruc.relFrTimes = []; % times relative to start of frame grab (trig by beMate)
%treadBehStruc.absFrTimes = [];  % absolute time from start of acq (before trig)
treadBehStruc.frInds = 1:numFrames; % just indices of each from from Bruker XML

%% resample y position to frame times and calculate velocity over each frame (at 30hz)
y = treadBehStruc.y;

% as of 112418 using pos times adjusted based upon rotary encoder nano
yTimes = treadBehStruc.yTimesAdj; 

% have to fix this:
if length(y)~=length(yTimes)
    yTimes = yTimes(1:length(y));
end

% and also, fix position (for discontinuities and other problems around lap
% boundaries)
%y = fixPos(y);

% only take position data from same period as images (but times themselves
% are unchanged)
frEpochInds = find(yTimes>=adjFrTimes(1) & yTimes<=adjFrTimes(end));
y2 = y(frEpochInds);
yTimes2 = yTimes(frEpochInds);

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

%% make filename and save treadBehStruc
tdmlName = findLatestFilename('.tdml');
undScor = strfind(tdmlName, '_');
mouseName = tdmlName(1:undScor-1);
datename = tdmlName(undScor+3:undScor+8);
tbsName = [datename '_' mouseName '_' tdmlName(undScor+11:undScor+14) '_treadBehStruc_' date '.mat'];
save(tbsName, 'treadBehStruc');