function [lapCueStruc] = findCueLapTypes(varargin)

%% USAGE: [lapTypeArr] = findCueLapTypes();
% numLapTypes = number of different e.g. cue locations, not including omits
% (now using automated estimate based upon cuePos)

if length(varargin)>0
    rewOmit=varargin{1};
else
    rewOmit = 0;
end

load(findLatestFilename('treadBehStruc'));

numLaps = length(treadBehStruc.lapTime); % NOTE: these are the ends of laps so won't include last
numLaps = numLaps+1; % including first and last partial laps

try 
olfTime = treadBehStruc.olfTime;
catch
    [treadBehStruc] = procHen2pBehav('auto', 'cue');
    olfTime = treadBehStruc.olfTime;
end

olfPos = treadBehStruc.olfPos;
olfLap = treadBehStruc.olfLap+1; % +1 so not zero-numbered

rewTime = treadBehStruc.rewZoneStartTime;
rewPos = treadBehStruc.rewZoneStartPos;
%toneLap = treadBehStruc.toneLap+1;

% and for rewOmit laps
toneTime = treadBehStruc.toneTime;
tonePos = treadBehStruc.tonePos;
toneLap = treadBehStruc.toneLap+1;

% sometimes one cue is missing so take the one with most
if length(tonePos) > length(olfPos)
    cuePos = tonePos;
    cueLap = toneLap;
    cueTime = toneTime; 
    cueType = 'tone';
else
    cuePos = olfPos;
    cueLap = olfLap;
    cueTime = olfTime; 
    cueType = 'olf';
end

% quickly estimate number of cue lap types (NOTE: does not include omitCue)
if max(diff(cuePos))> 20
    [N, edges] = histcounts(cuePos);
    numLapTypes = length(find(N>numLaps/15));
else
    numLapTypes = 1;
end

% disp(['Number of lap types = ' num2str(numLapTypes)]);

% assign lap types for shift laps based upon cuePos (NOTE: doesn't include
% omitCue laps, which will later end up as zeros and then become last type)
[N, edges, bin] = histcounts(cuePos, numLapTypes);
for i=1:numLapTypes
    lapTypeCuePos(i) = round(mean(cuePos(bin==i)));
end

% sometimes you can't rely upon cueLap data because RFID might have missed
% a lap, so have to reconstruct from times
[lapFrInds, lapEpochs] = findLaps(treadBehStruc.resampY); % NOTE: lapEpochs is in frInds
adjFrTimes = treadBehStruc.adjFrTimes;
numLaps = size(lapEpochs,1);
for i=1:length(cueTime)
    for j=1:numLaps
       if cueTime(i)>=adjFrTimes(lapEpochs(j,1)) && cueTime(i)<=adjFrTimes(lapEpochs(j,2))
          cueLap(i) = j; 
       end
    end
end

lapTypeArr = zeros(1,numLaps);

lapTypeArr(cueLap) = bin;


%% also do this for reward
if rewOmit==1
    
    for i=1:length(rewTime)
        for j=1:numLaps
            if rewTime(i)>=adjFrTimes(lapEpochs(j,1)) && rewTime(i)<=adjFrTimes(lapEpochs(j,2))
                rewLap(i) = j;
            end
        end
    end
    
    lapsTemp = 1:numLaps;
    rewLapArr = ones(1,numLaps);
    rewLapArr(rewLap) = 0;
    lapsTemp = lapsTemp(rewLapArr~=0);
    
    lapTypeArr(lapsTemp) = numLapTypes+1;
    
end

lapCueStruc.lapTypeArr = lapTypeArr;
lapCueStruc.lapFrInds = lapFrInds;
lapCueStruc.lapEpochs = lapEpochs;
lapCueStruc.cuePos = cuePos; 
lapCueStruc.cueLap = cueLap;
lapCueStruc.cueType = cueType;
lapCueStruc.lapTypeCuePos = lapTypeCuePos;