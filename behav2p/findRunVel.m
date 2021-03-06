function [meanRunVel, runVelThresh] = findRunVel(vel, toPlot)

%% USAGE: [meanRunVel, runVelThresh] = findRunVel(vel, toPlot);
% Clay Oct.16, 2018
% Look at the distribution of velocities from treadBehStruc (in mm/sec),
% corrected with fixVel.m, and find running speeds

disp('Finding runVelThresh based upon distribution of velocities');
%tic;

nbins = 50;

% find distribution of velocities (in mm/sec)
[numVals, edges] = histcounts(vel, nbins);

% find ind of meanRunVel
[val, meanRunVelInd] = findpeaks(numVals, 'MinPeakDistance', nbins-2);

% and of local minimum between running and non-running
[val, runVelThreshInd] = min(numVals(1:meanRunVelInd));

% take mean of vel bin from center of running distribution
meanRunVel = edges(meanRunVelInd)+round((edges(meanRunVelInd+1)-edges(meanRunVelInd))/2);

% take low edge of low speed local minimum for run thresh
runVelThresh = edges(runVelThreshInd);

if toPlot
    figure;
    plot(edges(1:end-1), numVals);
    hold on;
    line([edges(runVelThreshInd) edges(runVelThreshInd)], [0 max(numVals)], 'Color', 'r');
    line([edges(meanRunVelInd) edges(meanRunVelInd)], [0 max(numVals)], 'Color', 'g');
    xlabel('velocity (mm/sec)');
end

%toc;
