function plotCueOptoInhibPlaceStruc(cueOptoInhibPlaceStruc)

% just like plotCueShiftInhibPlaceStruc

numSess = length(cueOptoInhibPlaceStruc.optoLocNormRatesCell);
%range = [30 70];

for i=1:numSess
    normRates(i,:) = nanmean(cueOptoInhibPlaceStruc.optoLocNormRatesCell{i},1);
    optoRates(i,:) = nanmean(cueOptoInhibPlaceStruc.optoLocOptoRatesCell{i},1);
end


figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(normRates','b',1); % , 80);
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(optoRates','g',1); % , 80);
plotMeanSEMshaderr(optoRates'-normRates','r',1);
%legend('refLaps', 'shiftLaps', 'diff');
yl = ylim;
line([30 30], yl);


