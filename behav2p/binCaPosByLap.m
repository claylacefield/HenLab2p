function [caLapBin] = binCaPosByLap(ca, pos, lapFrInds)

numBins = 100;

caLapBin = [];

for i = 1:length(lapFrInds)-1
    caLap = ca(lapFrInds(i):lapFrInds(i+1));
    posLap = pos(lapFrInds(i):lapFrInds(i+1));
    caLapBin = [caLapBin; binByLocation(caLap, posLap)];
end

caLapBin = caLapBin';

figure; 
hold on;
for j = 1:size(caLapBin,1)
    plot(caLapBin(:,j)+j/10000);
end


