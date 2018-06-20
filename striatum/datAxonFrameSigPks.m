function [frameAvg, pkVals, pkInds] = datAxonFrameSigPks()

[filename, path] = uigetfile('*.h5', 'Select downsampled .h5 video');
cd(path);

segCh = 1; endFr = 0;
[Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);

frameAvg = squeeze(mean(mean(Y,1),2));
frameAvg = frameAvg-min(frameAvg);
frameAvg = frameAvg/max(frameAvg);

frameAvg2 = frameAvg-runmean(frameAvg,100);

Fs = 15; % fps
T = 1:length(frameAvg);
[pkVals, pkInds] = findpeaks(frameAvg2, T, 'MinPeakProminence', std(frameAvg), 'MinPeakDistance', Fs);

T=T/15;

pkRate = 1./diff(pkInds)/Fs;

figure;
subplot(2,2,1);
plot(T, frameAvg);
hold on;
plot(T,runmean(frameAvg,100), 'g');
plot(T(pkInds), frameAvg(pkInds), 'r.');
title(filename);
xlabel('sec');
ylabel('norm. frame Ca2+');

subplot(2,2,2);
hist(diff(pkInds));
xlabel('fr bet pks');

subplot(2,2,3);
plot(diff(pkInds)/15);
hold on;
plot(pkVals(2:end)*10, 'g');
legend('ipi', 'ampl');

subplot(2,2,4);
plot(diff(pkInds), pkVals(2:end), '*');
