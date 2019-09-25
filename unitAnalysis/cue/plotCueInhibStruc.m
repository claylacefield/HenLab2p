function plotCueInhibStruc(cueInhibStruc)



numSess = length(cueInhibStruc.cueShiftNameCell);
%range = [30 70];

for i=1:numSess
    normRatesBlanked(i,:) = nanmean(cueInhibStruc.normRatesBlankedCell{i},1);
    omitRatesBlanked(i,:) = nanmean(cueInhibStruc.omitRatesBlankedCell{i},1);
end


figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(normRatesBlanked','b'); % , 80);
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(omitRatesBlanked','r'); % , 80);
legend('refLaps', 'omitLaps');


nonEp1 = 20:45; %11:50; %11:44;
nonEp2 = 65:85; %61:89; %56:89;
startEp1 = 1:10; 
startEp2 = 90:100;
midEp = 51:60; %45:55;

noncueNorm = mean([mean(normRatesBlanked(:,nonEp1),2) mean(normRatesBlanked(:,nonEp2),2)],2);
startNorm = mean([mean(normRatesBlanked(:,startEp1),2) mean(normRatesBlanked(:,startEp2),2)],2);
midNorm = mean(normRatesBlanked(:,midEp),2);
midOmit = mean(omitRatesBlanked(:,midEp),2);

y = [nanmean(noncueNorm) nanmean(startNorm) nanmean(midNorm) nanmean(midOmit)];
sem = [nanstd(noncueNorm) nanstd(startNorm) nanstd(midNorm) nanstd(midOmit)]/sqrt(numSess);

figure;
x = categorical({'nonCueNorm', 'startNorm', 'midNorm', 'midOmit'});
x = reordercats(x,{'nonCueNorm', 'startNorm', 'midNorm', 'midOmit'});
b = bar(x,y); 
b.FaceColor = 'flat';
b.CData(1,:) = [0 1 0]; b.CData(2,:) = [0 0 1]; b.CData(3,:) = [1 0 0]; b.CData(4,:) = [0.5 0.5 1];
hold on;
errorbar(y,sem,'.');
title('pkPos blanked non-cue, startCue, middleCue, omitCue');
%legend('startCueBlanked', 'middleCueBlanked', 'middleOmitBlanked');
ylabel('mean rate');


%%


for i=1:numSess
    posBinFrac(i,:) = nanmean(cueInhibStruc.posBinFracCell{i},1);
    posInfo(i,:) = nanmean(cueInhibStruc.posInfoCell{i},1);
end

y = nanmean(posBinFrac,1);
sem = nanstd(posBinFrac,1)/sqrt(numSess);

figure;
b = bar(y); 
hold on;
errorbar(y,sem,'.');
title('Frac. PCs in each spatial bin');
ylabel('Frac. cells');

y = nanmean(posInfo,1);
sem = nanstd(posInfo,1)/sqrt(numSess);

figure;
b = bar(y); 
hold on;
errorbar(y,sem,'.');
title('Spatial info/sec in each spatial bin');
ylabel('bits/sec');
xlabel('posBin');
