function wrapAccelDecel()

[accelPks, decelPks] = findAccelDecel(treadBehStruc, 1);

for i = 1:length(goodSeg)
    [evTrigSig, zeroFr] = eventTrigSig(C(goodSeg(i),:), accelPks, 0, [-100 500]);
    unitEvSig(:,i) = mean(evTrigSig,2);
end

figure; plot(unitEvSig);

for i = 1:length(goodSeg)
    unitEvSig2(:,i) = unitEvSig(:,i)/max(unitEvSig(:,i));
end
figure; plotMeanSEMshaderr(unitEvSig2,'b');
figure; plot(mean(unitEvSig2,2));