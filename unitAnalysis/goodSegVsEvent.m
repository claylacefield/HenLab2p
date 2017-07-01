function [avEvCa] = goodSegVsEvent(C,goodSeg, treadBehStruc, eventName)


tCa = treadBehStruc.relFrTimes;
eventTimes = treadBehStruc.(eventName);


prePostSec = [10 30];

for i = 1:length(goodSeg)
    ca = C(goodSeg(i),:);
    [eventCa, zeroInds] = calcEventTrigCa(ca, tCa, eventTimes, prePostSec);
    avEvCa(:,i) = nanmean(eventCa,2);
end

figure; hold on;
for i=1:length(goodSeg)
   plot(avEvCa(:,i)+i/10); 
    
end




