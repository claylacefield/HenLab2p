function [lapFrInds, lapEpochs] = findLaps2(y, varargin)

%% USAGE: 
% Clay 2020 (from findLaps 2018)
% Modified to fix laps where there is a weird slow return from 2000-0 at
% lap boundary. Not sure where this happens, but not infrequent when freely running.
% 
% Actually no, I went ahead and did this inside fixPos2, 
% BUT I still use a different method to detect laps in this one.
% (
%
% inputs:
% y = treadmill position (resampled to 2p frame times)
%
% outputs:
% lapFrInds = frame indices of treadmill lap crossings
% lapEpochs = start and end frames of each lap

if nargin==2
    toPlot = varargin{1};
else toPlot=0;
end

y = y/max(y);

dy = [diff(y) 0];

% use matlab builtin findpeaks to see when mouse reaches end of belt
[pks, lapFrInds] = findpeaks(-dy, 'MinPeakHeight', 0.5, 'MinPeakDistance', 50); % NOTE: changed MinPeakDistance to 50 from 100 on 4/3/19 because too short for fast animals

lapEpochs = [1 lapFrInds(1)];
for i = 2:length(lapFrInds)
lapEpochs(i,:) = [lapFrInds(i-1)+1 lapFrInds(i)];
end
lapEpochs(length(lapFrInds)+1,:) = [lapFrInds(end)+1 length(y)];


% plot to check
if toPlot==1
figure;
plot(y);
hold on; 
t = 1:length(y);
plot(t(lapFrInds), y(lapFrInds), 'r*');
end