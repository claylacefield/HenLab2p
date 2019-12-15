function [lapCueStruc] = findCueLapTypes2(varargin)

%% USAGE: [lapTypeArr] = findCueLapTypes(varargin{rewOmit, treadBehStruc});
% numLapTypes = number of different e.g. cue locations, not including omits
% (now using automated estimate based upon cuePos)

if length(varargin)>0
    rewOmit=varargin{1};
    if length(varargin)==2
        treadBehStruc = varargin{2};
    else
        load(findLatestFilename('treadBehStruc'));
    end
else
    rewOmit = 0;
    load(findLatestFilename('treadBehStruc'));
end


numLaps = length(treadBehStruc.lapTime); % NOTE: these are the ends of laps so won't include last
numLaps = numLaps+1; % including first and last partial laps

try 
olfTime = treadBehStruc.olfTimeStart;
catch
    [treadBehStruc] = procHen2pBehav('auto', 'cue');
    olfTime = treadBehStruc.olfTimeStart;
end

olfPos = treadBehStruc.olfPosStart;
olfPosEnd = treadBehStruc.olfPosEnd;
olfLap = treadBehStruc.olfLap+1; % +1 so not zero-numbered

rewTime = treadBehStruc.rewZoneStartTime;
rewPos = treadBehStruc.rewZoneStartPos;
%toneLap = treadBehStruc.toneLap+1;

% and for tone
toneTime = treadBehStruc.toneTimeStart;
tonePos = treadBehStruc.tonePosStart;
tonePosEnd = treadBehStruc.tonePosEnd;
toneLap = treadBehStruc.toneLap+1;

% and for led (have to try/catch because earlier treadBehStruc may not have
% these)
try
    ledTime = treadBehStruc.ledTimeStart;
    ledPos = treadBehStruc.ledPosStart;
    ledPosEnd = treadBehStruc.ledPosEnd;
    ledLap = treadBehStruc.ledLap+1;
catch
    ledTime = [];
    ledPos = [];
    ledLap = [];
end

% and for tactile
try
    tactTime = treadBehStruc.tactTimeStart;
    tactPos = treadBehStruc.tactPosStart;
    tactPosEnd = treadBehStruc.tactPosEnd;
    tactLap = treadBehStruc.tactLap+1;
catch
    tactTime = [];
    tactPos = [];
    tactLap = [];
end

try
    optoTime = treadBehStruc.optoTimeStart;
    optoPos = treadBehStruc.optoPosStart;
    optoPosEnd = treadBehStruc.optoPosEnd;
    optoLap = treadBehStruc.optoLap+1;
catch
    optoTime = [];
    optoPos = [];
    optoLap = [];
end

%[sortVals,order] = sort([length(ledPos), length(olfPos), length(tonePos)]);

% sometimes one cue is missing so take the one with most to establish lap
% types
if length(tonePos) >= length(olfPos) && length(tonePos) >= length(ledPos) && length(tonePos) >= length(tactPos)
    cuePos = tonePos;
    cuePosEnd = tonePosEnd;
    cueLap = toneLap;
    cueTime = toneTime;
    cueType = 'tone';
elseif length(olfPos) >= length(tonePos) && length(olfPos) >= length(ledPos) && length(olfPos) >= length(tactPos)
    cuePos = olfPos;
    cuePosEnd = olfPosEnd;
    cueLap = olfLap;
    cueTime = olfTime;
    cueType = 'olf';
elseif length(ledPos) >= length(olfPos) && length(ledPos) >= length(tonePos) && length(ledPos) >= length(tactPos)
    cuePos = ledPos;
    cuePosEnd = ledPosEnd;
    cueLap = ledLap;
    cueTime = ledTime;
    cueType = 'led';
elseif length(tactPos) >= length(olfPos) && length(tactPos) >= length(tonePos) && length(tactPos) >= length(ledPos)
    cuePos = tactPos;
    cuePosEnd = tactPosEnd;
    cueLap = tactLap;
    cueTime = tactTime;
    cueType = 'tact';
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

%% New method for building lapTypeArr
% find all positions for all cues

edges = 0:100:2000; % edges for histcounts of cue positions

cuesPosLap = zeros(4,numLaps); % for {'led', 'olf', 'tact', 'tone'}

% LED cue
try
    ledPosLap = zeros(1,numLaps);
for i=1:length(ledTime)
    for j=1:numLaps
       if ledTime(i)>=adjFrTimes(lapEpochs(j,1)) && ledTime(i)<=adjFrTimes(lapEpochs(j,2))
          ledPosLap(j) = ledPos(i); 
       end
    end
end
%cuesPosLap(1,:) = ledPosLap;
[N, edges, bin] = histcounts(ledPosLap, edges); %numLapTypes);
bin(ledPosLap==0)=0;
locs = unique(bin); locs(locs==0)=[]; % find unique cue locations
for i=1:length(locs); bin(bin==locs(i))=i; end % and find which one for each lap
cuesPosLap(1,:) = bin; %olfPosLap;
cueNameCell{1} = 'led';
cuePosCell{1} = locs; % diff unique positions (sorted) for led cues 
catch
end

%% Olfactory
try
    olfPosLap = zeros(1,numLaps);
for i=1:length(olfTime)
    for j=1:numLaps
       if olfTime(i)>=adjFrTimes(lapEpochs(j,1)) && olfTime(i)<=adjFrTimes(lapEpochs(j,2))
          olfPosLap(j) = olfPos(i);
       end
    end
end

[N, edges, bin] = histcounts(olfPosLap, edges); %numLapTypes);
bin(olfPosLap==0)=0;
locs = unique(bin); locs(locs==0)=[]; % find unique cue locations
for i=1:length(locs); bin(bin==locs(i))=i; end % and find which one for each lap
cuesPosLap(2,:) = bin; %olfPosLap;
cueNameCell{2} = 'olf';
cuePosCell{2} = locs;
catch
end


%% Tactile
try
    tactPosLap = zeros(1,numLaps);
for i=1:length(tactTime)
    for j=1:numLaps
       if tactTime(i)>=adjFrTimes(lapEpochs(j,1)) && tactTime(i)<=adjFrTimes(lapEpochs(j,2))
          tactPosLap(j) = tactPos(i); 
       end
    end
end
%cuesPosLap(3,:) = tactPosLap;
[N, edges, bin] = histcounts(tactPosLap, edges); %numLapTypes);
bin(tactPosLap==0)=0;
locs = unique(bin); locs(locs==0)=[]; % find unique cue locations
for i=1:length(locs); bin(bin==locs(i))=i; end % and find which one for each lap
cuesPosLap(3,:) = bin; %olfPosLap;
cueNameCell{3} = 'tact';
cuePosCell{3} = locs;
catch
end

%% Tone
try
    tonePosLap = zeros(1,numLaps);
for i=1:length(toneTime)
    for j=1:numLaps
       if toneTime(i)>=adjFrTimes(lapEpochs(j,1)) && toneTime(i)<=adjFrTimes(lapEpochs(j,2))
          tonePosLap(j) = tonePos(i); 
       end
    end
end
%cuesPosLap(4,:) = tonePosLap;
[N, edges, bin] = histcounts(tonePosLap, edges); %numLapTypes);
bin(tonePosLap==0)=0;
locs = unique(bin); locs(locs==0)=[]; % find unique cue locations
for i=1:length(locs); bin(bin==locs(i))=i; end % and find which one for each lap
cuesPosLap(4,:) = bin; %olfPosLap;
cueNameCell{4} = 'tone';
cuePosCell{4} = locs;
catch
end

%% Opto
try
    optoPosLap = zeros(1,numLaps);
for i=1:length(optoTime)
    for j=1:numLaps
       if optoTime(i)>=adjFrTimes(lapEpochs(j,1)) && optoTime(i)<=adjFrTimes(lapEpochs(j,2))
          optoPosLap(j) = optoPos(i); 
       end
    end
end
%cuesPosLap(4,:) = tonePosLap;
[N, edges, bin] = histcounts(optoPosLap, edges); %numLapTypes);
bin(optoPosLap==0)=0;
locs = unique(bin); locs(locs==0)=[]; % find unique cue locations
for i=1:length(locs); bin(bin==locs(i))=i; end % and find which one for each lap
cuesPosLap(5,:) = bin; %olfPosLap;
cueNameCell{5} = 'opto';
cuePosCell{5} = locs;
catch
end

% construct code from cue locations
for i=1:size(cuesPosLap,2)
   cueLapCode(i) = cuesPosLap(1,i)+10*cuesPosLap(2,i)+100*cuesPosLap(3,i)+1000*cuesPosLap(4,i)+10000*cuesPosLap(5,i); 
end

lapTypeCodes = unique(cueLapCode);
lapTypeCodes(lapTypeCodes==0)=[];
for i=1:length(lapTypeCodes)
    cueLapCode(cueLapCode==lapTypeCodes(i))=i;
end
lapTypeArr = cueLapCode;

%lapTypeArr = zeros(1,numLaps);

%lapTypeArr(cueLap) = bin;


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
lapCueStruc.cuePosEnd = cuePosEnd; 
lapCueStruc.cueLap = cueLap;
lapCueStruc.cueType = cueType;
lapCueStruc.lapTypeCuePos = lapTypeCuePos;
lapCueStruc.numLapTypes = length(unique(lapTypeArr)); %numLapTypes;

lapCueStruc.cuesPosLap = cuesPosLap; % array of cue type by position index (see cuePosCell) #cueTypes possible x #laps
lapCueStruc.cueNameCell = cueNameCell;  % cueNames for diff cue types {'led', 'olf', 'tact', 'tone'}
lapCueStruc.cuePosCell = cuePosCell; % unique cue positions for each cue type (see cueNames)
