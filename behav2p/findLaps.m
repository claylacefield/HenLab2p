function [lapFrInds, lapEpochs] = findLaps(y)

%% USAGE: 
% Clay 2018
% 
% inputs:
% y = treadmill position (resampled to 2p frame times)
%
% outputs:
% lapFrInds = frame indices of treadmill lap crossings
% lapEpochs = start and end frames of each lap

y = y/max(y);

%dy = diff(y);

% use matlab builtin findpeaks to see when mouse reaches end of belt
[pks, lapFrInds] = findpeaks(y, 'MinPeakProminence', 0.8, 'MinPeakDistance', 100);

lapEpochs = [1 lapFrInds(1)-1];
for i = 2:length(lapFrInds)
lapEpochs(i,:) = [lapFrInds(i-1) lapFrInds(i)-1];
end
lapEpochs(length(lapFrInds)+1,:) = [lapFrInds(end) length(y)];


% plot to check
figure;
plot(y);
hold on; 
t = 1:length(y);
plot(t(lapFrInds), y(lapFrInds), 'r*');
