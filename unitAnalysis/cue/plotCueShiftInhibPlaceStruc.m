function plotCueShiftInhibPlaceStruc(cueShiftInhibPlaceStruc)



numSess = length(cueShiftInhibPlaceStruc.shiftLocNormRatesCell);
%range = [30 70];

for i=1:numSess
    normRates(i,:) = nanmean(cueShiftInhibPlaceStruc.shiftLocNormRatesCell{i},1);
    shiftRates(i,:) = nanmean(cueShiftInhibPlaceStruc.shiftLocShiftRatesCell{i},1);
end


figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(normRates','b',1); % , 80);
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(shiftRates','g',1); % , 80);
plotMeanSEMshaderr(shiftRates'-normRates','r',1);
legend('refLaps', 'shiftLaps', 'diff');
yl = ylim;
line([20 20], yl);


