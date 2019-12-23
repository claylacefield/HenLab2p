function [movEpochs, velocity] = calcMovEpochs1(treadPos, T, varargin)
%function [movEpochs, velocity] = calcMovEpochs1(treadPos, T, minVel(def=5), minEpochDur(def=3))

minVel = 5;
minEpochDur = 3;
if ~isempty(varargin)
    minVel = varargin{1};
    if length(varargin) >= 2
        minEpochDur = varargin{2};
    end
end

treadPos = treadPos*2;
if size(T, 2) > size(T, 1)
    T = T';
end

fs = 1/median(diff(T));

d = double(round(fs/2));
g = fspecial('Gaussian',[d*3 1], d);

treadPos = (0.5 - treadPos)*pi()*2;

d1 = angleDiff(treadPos(1:(end - 1)), treadPos(2:end));
d1 = 200*abs((d1/(2*pi())));


d1 = convWith(d1', g);

velocity = abs(d1)*fs;
velocity = [velocity; 0];
movEpochs = [];

[s, l] = suprathresh(velocity, minVel);

movEpochs = [T(s(:, 1)), T(s(:, 2))];
movEpochs = movEpochs(diff(movEpochs, [], 2) > minEpochDur, :);
