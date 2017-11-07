function [treadBehStruc] = procHen2pBehav();

% USAGE: [treadBehStruc] = align2pBehav();
% GUI select TDML behavior and 2p XML files
% to process 2p behavioral data from Jack Bowler's 
% BehaviorMate system


% read behavioral events and times
[treadBehStruc] = readTDML();

% find 2p frame times
[relFrTimes, absFrTimes, frInds] = get2pFrTimes();
treadBehStruc.relFrTimes = relFrTimes;
treadBehStruc.absFrTimes = absFrTimes;
treadBehStruc.frInds = frInds;

% take into account offset between behavior start time and 2p trigger ON
adjFrTimes = relFrTimes + treadBehStruc.syncOnTime;  % this gives you 2p frame times relative to behav/TDML timescale
treadBehStruc.adjFrTimes = adjFrTimes;

% calculate velocity over each frame (at 30hz)
y = treadBehStruc.y;
yTimes = treadBehStruc.yTimes;

frEpochInds = find(yTimes>=adjFrTimes(1) & yTimes<=adjFrTimes(end));
y2 = y(frEpochInds);
yTimes2 = yTimes(frEpochInds);

resampY = interp1(yTimes2, y2, adjFrTimes); % 0:0.033:900);
vel = abs(diff(resampY)); %units are cm/frame
vel = [vel vel(end)];  % just repeat last vel to make same length as fr


% save relevant variables to output structure
treadBehStruc.y = y2;
treadBehStruc.yTimes = yTimes2;
treadBehStruc.resampY = resampY; % NOTE that times will be = adjFrTimes
treadBehStruc.vel = vel;