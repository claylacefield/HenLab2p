
numBins=100;

seg = 100; %88; %100; %185;
ca = C(seg,:);

[c,s,options] = deconvolveCa(ca, 'ar2');

s = s/max(s);
%s = ca/max(ca);

binCaAvg = binByLocation(s, pos, numBins);

[shufBinCaAvg] = fabShuf(s, pos, numBins, 0);

prc = prctile(shufBinCaAvg, 95, 2);

figure; 
subplot(3,1,1);
plot(C(seg,:));
subplot(3,1,2);
plot(prc);
hold on;
plot(binCaAvg,'g');
title(['seg = ' num2str(seg)]);

out = computePlaceTransVectorSimple1(s, T, pos, shuffN);
subplot(3,1,3); plot(out.Shuff.ThreshRate); hold on; plot(out.posRates, 'g');
