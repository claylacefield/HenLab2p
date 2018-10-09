function wrapLapDecodingFormat(tag, varargin)


% just make basename
xmlName = findLatestFilename('.xml');
basename = xmlName(1:end-4);

% load in unit data (with pksCell and goodSeg)
load(findLatestFilename('goodSeg'));
if nargin == 1
    pksCell = pksCell(goodSeg(varargin{1})); % e.g. if you want to only use PCs
else
    pksCell = pksCell(goodSeg);
end

% load behavior data
[treadBehStruc] = procHen2pBehav('auto');

pos = treadBehStruc.resampY(1:2:end)'; % extract position data

[lapFrInds, lapEpochs] = findLaps(pos); % find laps (uses pos pks, not RFID)

% strip out laps of a type
pos1 = [];pos2 = [];
for i = 1:length(lapFrInds)+1
    if mod(i,5)~=0
        pos1 = [pos1; pos(lapEpochs(i,1):lapEpochs(i,2))];
    else
        pos2 = [pos2; pos(lapEpochs(i,1):lapEpochs(i,2))];
    end
end

% now find only spikes in these times
% NOTE: I thought about just NaNing switch laps which would be easier in
% many ways, but might not be ideal in the end (e.g. when predicting switch
% laps)
%pksCell1 = {};
for i = 1:length(pksCell)
    selPks = [];
    spks = pksCell{i};
    for j = 1:size(lapEpochs,1)
    if mod(j,5)~=0
        try
        selPks = [selPks spks(find(spks>=lapEpochs(j,1) & spks<=lapEpochs(j,2)))];
        catch
        end
        
    end
    end
    pksCell1{i} = selPks;
end


frTimes = treadBehStruc.adjFrTimes(1:2:end);
pos_times1 = frTimes(1:length(pos1)); % just create pseudo-frTimes length of lap subset

[spike_times, pos, pos_times] = preFormatForDecoding(pksCell1, treadBehStruc, pos1, pos_times1);

save([basename '_pcsForDecoding' tag '_' date], 'spike_times', 'pos', 'pos_times');


