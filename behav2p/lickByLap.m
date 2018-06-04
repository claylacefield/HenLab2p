function [lickLap] = lickByLap(treadBehStruc);

%% USAGE: [lickLap] = lickByLap(treadBehStruc);

y = treadBehStruc.resampY;
[lapFrInds] = findLaps(y);
frTimes = treadBehStruc.adjFrTimes;

lickTimes = treadBehStruc.lickTime;
[lickInds] = findNearestFr(lickTimes, frTimes);
lickSig = zeros(length(y),1);
lickSig(lickInds)=1;

numBins = 40;

% just for first epoch (incomplete lap)
yLap = y(1:lapFrInds(1)-1);
licks = lickSig(1:lapFrInds(1)-1);
lickLap(1,1:numBins) = binByLocation(licks, yLap, numBins);

% now all others
for i = 1:length(lapFrInds)-1
    %try
    yLap = y(lapFrInds(i):lapFrInds(i+1)-1);
    licks = lickSig(lapFrInds(i):lapFrInds(i+1)-1);
    lickLap(i+1,1:numBins) = binByLocation(licks, yLap, numBins);
    %catch
    %end
end

figure; 
imagesc(lickLap);
title(treadBehStruc.tdmlName);
ylabel('lap');
xlabel('position');
