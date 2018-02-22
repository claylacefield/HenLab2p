function [stillEpochs, velocity] = calcStillEpochs1(treadPos, T, varargin)
%function [stillEpochs, velocity] = calcStillEpochs1(treadPos, T, maxVel(opt), minEpochDur(opt))

maxVel = 3;
minEpochDur = 3;
if ~isempty(varargin)
    maxVel = varargin{1};
    if length(varargin) >= 2
        minEpochDur = varargin{2};
    end
end

treadPos = treadPos*2;

fs = 1/median(diff(T));

d = double(round(fs/2));
g = fspecial('Gaussian',[d*3 1], d);

treadPos = (0.5 - treadPos)*pi()*2;

d1 = angleDiff(treadPos(1:(end - 1)), treadPos(2:end));
d1 = 200*abs((d1/(2*pi())));


d1 = convWith(d1', g);

velocity = abs(d1)*fs;
velocity = [velocity; 0];
stillEpochs = [];

[s, l] = suprathresh(-1*velocity, -1*maxVel);

stillEpochs = [T(s(:, 1))', T(s(:, 2))'];
stillEpochs = stillEpochs(diff(stillEpochs, [], 2) > minEpochDur, :);
