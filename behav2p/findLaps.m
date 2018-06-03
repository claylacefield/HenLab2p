function [lapFrInds] = findLaps(y)

%% USAGE: 
% Clay 2018
% 
% inputs:
% y = treadmill position (resampled to 2p frame times)
%
% outputs:
% lapFrInds = frame indices of treadmill lap crossings

y = y/max(y);

%dy = diff(y);

% use matlab builtin findpeaks to see when mouse reaches end of belt
[pks, lapFrInds] = findpeaks(y, 'MinPeakProminence', 0.8); % , 'MinPeakDistance', 100);


% plot to check
figure;
plot(y);
hold on; 
t = 1:length(y);
plot(t(lapFrInds), y(lapFrInds), 'r*');
