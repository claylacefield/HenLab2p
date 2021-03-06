


cl = [0,0.3];
figure; 
subplot(2,3,1);
[order] = plotPosRates(cueInhibStruc.posRates,0,1); colormap(hot);
caxis(cl);

subplot(2,3,2);
imagesc(cueInhibStruc.normRatesBlanked(order,:));
caxis(cl);

subplot(2,3,3);
imagesc(cueInhibStruc.omitRatesBlanked(order,:));
caxis(cl);


subplot(2,3,4);
plotMeanSEMshaderr(cueInhibStruc.posRates','b'); 
hold on; 
plotMeanSEMshaderr(cueInhibStruc.normRatesBlanked', 'r');
plotMeanSEMshaderr(cueInhibStruc.omitRatesBlanked', 'g');


subplot(2,3,6);
plotMeanSEMshaderr(cueInhibStruc.pfRates','b'); 
hold on; 
plotMeanSEMshaderr(cueInhibStruc.pfOmitRates', 'g');

%%%%%%%%%%%%%%%%
for i=51:63
figure; 
subplot(2,3,1);
[order] = plotPosRates(cueInhibStruc.posRatesCell{i},0,1); 
caxis([0,0.3]);
title(i);

subplot(2,3,2);
imagesc(cueInhibStruc.normRatesBlankedCell{i}(order,:));

subplot(2,3,3);
imagesc(cueInhibStruc.omitRatesBlankedCell{i}(order,:));

subplot(2,3,4);
plotMeanSEMshaderr(cueInhibStruc.posRatesCell{i}','b'); 
hold on; 
plotMeanSEMshaderr(cueInhibStruc.normRatesBlankedCell{i}', 'r');
plotMeanSEMshaderr(cueInhibStruc.omitRatesBlankedCell{i}', 'g');
end