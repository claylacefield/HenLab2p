function [lapTypeArr] = findCueLapTypes()

%% USAGE: [lapTypeArr] = findCueLapTypes();
% numLapTypes = number of different e.g. cue locations, not including omits
% (now using automated estimate based upon cuePos)

load(findLatestFilename('treadBehStruc'));

numLaps = length(treadBehStruc.lapTime); % NOTE: these are the ends of laps so won't include last
numLaps = numLaps+1; % including first and last partial laps

olfTime = treadBehStruc.olfTime;
olfPos = treadBehStruc.olfPos;
olfLap = treadBehStruc.olfLap+1; % +1 so not zero-numbered

toneTime = treadBehStruc.toneTime;
tonePos = treadBehStruc.tonePos;
toneLap = treadBehStruc.toneLap+1;

% sometimes one cue is missing so take the one with most
if length(tonePos) > length(olfPos)
    cuePos = tonePos;
    cueLap = toneLap;
else
    cuePos = olfPos;
    cueLap = olfLap;
end

% quickly estimate number of lap types 
[N, edges] = histcounts(cuePos);
numLapTypes = length(find(N>numLaps/10));

% assign lap types for shift laps based upon cuePos (NOTE: doesn't include
% omitCue laps)
[N, edges, bin] = histcounts(cuePos, numLapTypes);

lapTypeArr = zeros(1,numLaps);

lapTypeArr(cueLap) = bin;







