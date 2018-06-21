function  [evTrigSig] = datEventAnal()

[frameAvg, pkVals, pkInds] = datAxonFrameSigPks();

[v, vTimes, ttlOnInds, ttlOffInds] = readBrukerVoltage();
audStimTimes = vTimes(ttlOnInds)/1000;

[relFrTimes, absFrTimes, frInds] = get2pFrTimes();

%[frInds] = findNearestFr(audStimTimes, relFrTimes);

relFrTimes = relFrTimes(1:2:end);

% do eventTrigSig for tone1 vs. tone2
[evTrigSig, zeroFr] = eventTrigSig(frameAvg, audStimTimes, 1, [-15*15 15*15], relFrTimes);
[evTrigSig1, zeroFr] = eventTrigSig(frameAvg, audStimTimes(1:2:end), 1, [-15*15 15*15], relFrTimes);
[evTrigSig2, zeroFr] = eventTrigSig(frameAvg, audStimTimes(2:2:end), 1, [-15*15 15*15], relFrTimes);

figure; 
plotMeanSEMshaderr(evTrigSig1, 'b');
hold on; 
plotMeanSEMshaderr(evTrigSig2, 'g');


colors = jet(length(audStimTimes));
figure; hold on;
for i = 1:length(audStimTimes)
plot(evTrigSig(:,i), 'Color', colors(i,:));
end