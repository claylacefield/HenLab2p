function [avEvCa] = goodSegVsEvent(C,goodSeg, treadBehStruc, eventName, dsFactor);


% This computes the event-triggered average for 2p treadmill behavior
% dsFactor = temporal downsampling factor of 2p imaging

tCa = treadBehStruc.adjFrTimes; %relFrTimes;
eventTimes = treadBehStruc.(eventName);

tCa = tCa(1:dsFactor:end);
tCa = tCa(1:size(C,2));

eventTimes = eventTimes(eventTimes>=tCa(1) & eventTimes<=tCa(end));

prePostSec = [10 30];

for i = 1:length(goodSeg)
    ca = C(goodSeg(i),:);
    [eventCa, zeroInds] = calcEventTrig2pSig(ca, tCa, eventTimes, 0);
    avEvCa(:,i) = nanmean(eventCa,2);
end

figure; hold on;
for i=1:length(goodSeg)
   plot(avEvCa(:,i)+i/30); 
    
end




