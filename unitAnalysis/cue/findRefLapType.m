function [refLapType] = findRefLapType(varargin)

% Clay Oct 2019
% just find most numerous lapType for reference lap type

% if input length=1 then it's cueShiftStruc, else lapTypeArr
if length(varargin{1})==1
    cueShiftStruc = varargin{1};
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
else
    lapTypeArr = varargin{1};
end

lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:max(lapTypeArr)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType); % use ref lap from one with most laps