function [lapAvAmp] = findPkAmp(pks, ca)

% find the amplitude of peaks identified in pksCell

% pseudocode
% pksCell might be from subset of laps
% and from subset of cells
% so have to find the correct cells and laps in C

%ca = C(seg,:);

numFr = length(ca); %size(C,2);
y = treadBehStruc.resampY;
frTimes = treadBehStruc.adjFrTimes;
if length(y)>numFr*1.5
    y = y(1:2:end);
    frTimes = frTimes(1:2:end);
end

[lapFrInds, lapEpochs] = findLaps(y); % NOTE: lapEpochs is in frInds


% find lap types
[lapCueStruc] = findCueLapTypes(0);
lapTypeArr = lapCueStruc.lapTypeArr;


for i=1:size(pks,1) % for each detected peak
    lapPks = pks(find(pks>lapEpochs(i,1) & pks<lapEpochs(i,2))); % find spikes in that lap
    for j=1:length(lapPks)  % for each spike
        pkAmp(j) = max(ca(lapPks(j):lapPks(j)+100)); % find its amplitude
    end
    if ~isempty(lapPks)
        lapAvAmp(i) = mean(pkAmp); % take mean of spike amplitudes in this lap
    else
        lapAvAmp(i) = 0; %[];
    end
end
    