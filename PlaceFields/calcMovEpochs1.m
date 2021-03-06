function [movEpochs, velocity] = calcMovEpochs1(treadPos, T, varargin)
%function [movEpochs, velocity] = calcMovEpochs1(treadPos, T, minVel(def=5), minEpochDur(def=3))

% Calculate epochs when the animal is running over a certain speed, for
% more than a certain length of time.
% Input: 
%   treadPos = animal position, I think interpolated to 2p frame times
%   T = frame times, I think
%   varargin = optional minVel and minEpochDur params
% Output:
% movEpochs = a Tx2 matrix of running epoch start/stop times

minVel = 5; % minimum velocity (in cm/sec?)
minEpochDur = 3;    % in sec?
if ~isempty(varargin)
    minVel = varargin{1};
    if length(varargin) >= 2
        minEpochDur = varargin{2};
    end
end

treadPos = treadPos*2; % adjust position vector times 2 (don't know why this is necessary)
if size(T, 2) > size(T, 1) % just make sure time vector is in correct orientation
    T = T';
end

fs = 1/median(diff(T)); % calculate position sample frequency (so this must already be interpolated to imaging framerate)

d = double(round(fs/2));   % downsampled frame rate/sample freq?
g = fspecial('Gaussian',[d*3 1], d);    % gaussian filter

treadPos = (0.5 - treadPos)*pi()*2; % treadmill position in radians?

d1 = angleDiff(treadPos(1:(end - 1)), treadPos(2:end));  % like angular velocity (using angleDiff script)
d1 = 200*abs((d1/(2*pi())));    % and now back to linear position? or maybe now velocity?


d1 = convWith(d1', g); % convolve velocity(?) with gaussian kernel

velocity = abs(d1)*fs;
velocity = [velocity; 0];
movEpochs = [];

[s, l] = suprathresh(velocity, minVel);

movEpochs = [T(s(:, 1)), T(s(:, 2))];
movEpochs = movEpochs(diff(movEpochs, [], 2) > minEpochDur, :);
