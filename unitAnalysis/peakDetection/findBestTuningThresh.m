function findBestTuningThresh(ca, treadBehStruc)





y = treadBehStruc.resampY(1:2:end);

[N, edges, binY] = histcounts(y,100);


toPlot=1; sdThresh=3; timeout=3;
pks3 = clayCaTransients(ca, 15, toPlot, sdThresh, timeout);
spks = zeros(length(ca),1);
spks(pks3) = 1;
spkBin = spks.*binY';
spkBin = spkBin(spkBin~=0);
[N, edges, bin] = histcounts(spkBin,edges);
figure; bar(N);

toPlot=1;
[mrl, mra] = clayMRL(N, toPlot); 
title(mrl);











