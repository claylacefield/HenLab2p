function [pksCellCell, posLapCell, lapCueStruc] = sepCueShiftLapSpkTimesMulti(pksCell, goodSeg, treadBehStruc, varargin) %, lapTypeInfo)

%% USAGE: [pksCellCell, posLapCell, lapFrInds] = sepCueShiftLapSpkTimes(pksCell, goodSeg, treadBehStruc, lapTypeInfo);
% Strips out and concatenates unit events/pks and position of different lap types

% lapTypeInfo = n+1 array of lap numbers for different lap types, then max
% lap number in cycle (e.g. [5 10 10] for shift on 5th, omit on 10th, of
% 10)

% Clay Nov. 2018
% 
% ToDo:
% - integ this with wrapAndresPlaceFieldsClay (no, I put it in
% wrapCueShiftTuning)
% - BUG: need to adjust pks because of diff times when excerpted
%      Fixed I think
% - need to add last lap (it's not in loop)
% 021619: need to add options for diff lap cycles (e.g. max shift, omit)

%[caLapBin] = wrapLapTuning(C,treadBehStruc);

% extract position and find lap boundaries (lapFrInds = ends of laps)
pos = treadBehStruc.resampY(1:2:end);
%pos2 = pos;
%pos2(pos2>2000)=pos2(pos2>2000)-2000;
[lapFrInds, lapEpochs] = findLaps(pos);
lapFrInds = [lapFrInds length(pos)]; % just for last lap (partial lap)
lapCueStruc.lapFrInds = lapFrInds;


if length(varargin)==1
    if length(varargin{1})==1
        rewOmit = varargin{1};
        autoLapType = 1;
    else
        rewOmit = 0;
        lapTypeInfo = varargin{1};
        autoLapType = 0;
    end
elseif length(varargin)==2
        rewOmit = varargin{1};
        lapTypeInfo = varargin{2};
        autoLapType = 0;
else
    rewOmit = 0;
    autoLapType = 1;
end

% build lapTypeArr
if autoLapType==1
    [lapCueStruc] = findCueLapTypesMulti(rewOmit, treadBehStruc);
    lapTypeArr = lapCueStruc.lapTypeArr;
else
    if length(lapTypeInfo)<10 % if length of lapTypeInfo is <10 then it's prob lap sequence
        lapTypeArr = ones(size(lapEpochs,1),1)';
        numLapTypes = length(lapTypeInfo)-1;
        for i=1:numLapTypes
            lapTypeLaps = lapTypeInfo(i):lapTypeInfo(end):length(lapTypeArr);
            lapTypeArr(lapTypeLaps)=i+1;
        end
    else
        lapTypeArr = lapTypeInfo; % else it's a full lapTypeArr
        lapTypeArr = lapTypeArr(1:size(lapEpochs,1));  % just trim if necessary
    end
    lapCueStruc.lapTypeArr = lapTypeArr;
end


pksCellGood = pksCell(goodSeg);

% assign lap types for all laps based upon lapTypeInfo
% lapSeqN = 0;
% for n = 1:length(lapFrInds) %+1)
%     lapSeqN = lapSeqN + 1;
%     
%     for m = 1:length(lapTypeInfo)-1
%         if lapSeqN == lapTypeInfo(m);
%             lapTypeArr(n) = m+1; % find(lapTypeInfo(1:end-1),m)
%         else
%             lapTypeArr(n) = 1;
%         end
%     end
%     
%     % reset lap cycle counter if necessary
%     if lapSeqN == lapTypeInfo(end)
%        lapSeqN = 0; 
%     end
% end


numLapTypes = max(lapTypeArr);
numOmit = length(find(lapTypeArr==0));
if numOmit>2
    numLapTypes = numLapTypes+1;
    lapTypeArr(lapTypeArr==0) = numLapTypes;
end

disp('Separating spikes and pos by lap type');

% initialize output arrays
for k=1:numLapTypes
    posLapCell{k} = [];
    pksCellCell{k} = cell(1,length(pksCellGood));
    if k==1
        posLapCell{k} = pos(1:lapFrInds(1));
    end
end

% first, just fill in first lap (for each cell, find spikes in first lap)
lapType = lapTypeArr(1);
if lapType~=0
    for p = 1:length(pksCellGood)
        unitPks = unique(pksCellGood{p}); % get all pks for that cell
        lapPks = unitPks(find(unitPks>=1 & unitPks<=lapFrInds(1))); % see which are in this lap
        pksCellCell{lapType}{p} = lapPks;
    end
end

% now find spikes for each lap, for each cell, based upon lapType
for i=1:length(lapFrInds)-1
    lapType = lapTypeArr(i+1);
    if lapType ~= 0
    for j=1:length(pksCellGood)  % for each cell
        unitPks = unique(pksCellGood{j}); % get all pks for that cell (sometimes repeats, so get unique)
        lapPks = unitPks(find(unitPks>=lapFrInds(i) & unitPks<=lapFrInds(i+1))); % see which are in this lap
        
        % now adjust based upon separated lapType epochs
        pksCellCell{lapType}{j} = [pksCellCell{lapType}{j}; lapPks-lapFrInds(i)+length(posLapCell{lapType})+1];
        
    end
    
    % and concatenate pos for this lap based upon this lapType
    posLapCell{lapType} = [posLapCell{lapType} pos(lapFrInds(i):lapFrInds(i+1))];
    end
end

% and now fill in the last lap

