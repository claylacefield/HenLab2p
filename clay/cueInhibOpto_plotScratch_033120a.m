


cl = [0,0.3];
figure; 
subplot(2,4,1);
[order] = plotPosRates(cueInhibStruc.posRates,0,1); colormap(hot);
caxis(cl);
title('normal posRates');

subplot(2,4,2);
imagesc(cueInhibStruc.optoRates(order,:));
caxis(cl);
title('opto posRates');

subplot(2,4,3);
imagesc(cueInhibStruc.normRatesBlanked(order,:));
caxis(cl);
title('normal PF blanked');

subplot(2,4,4);
imagesc(cueInhibStruc.omitRatesBlanked(order,:));
caxis(cl);
title('omit');

subplot(2,4,5);
imagesc(cueInhibStruc.optoRatesBlanked(order,:));
caxis(cl);
title('cue+opto');

subplot(2,4,6);
%plotMeanSEMshaderr(cueInhibStruc.posRates','c'); 
hold on; 
plotMeanSEMshaderr(cueInhibStruc.normRatesBlanked', 'b');
plotMeanSEMshaderr(cueInhibStruc.omitRatesBlanked', 'g');
plotMeanSEMshaderr(cueInhibStruc.optoRatesBlanked', 'r');
plotMeanSEMshaderr(cueInhibStruc.omitOptoRatesBlanked', 'c');
title('b=cue, g=omit, r=cue+opto, c=omit+opto');


subplot(2,4,7);
%figure;
base = 25:30;
plotMeanSEMshaderr(cueInhibStruc.pfRates','b', base); 
hold on; 
plotMeanSEMshaderr(cueInhibStruc.pfOmitRates', 'g', base);
plotMeanSEMshaderr(cueInhibStruc.pfOptoRates', 'r', base);
plotMeanSEMshaderr(cueInhibStruc.pfOmitOptoRates', 'c', base);
title('PF only');

%%

% subplot(2,3,5);
% %plot(cuePosRate,omitPosRate,'x');
% plot(cuePkPos,cuePosRate-omitPosRate,'x');
% %hold on; line([0 0.2], [0 0.2]);
% title('middle cell mean ref lap rate - omit');

%%
% 

pcRatesBlanked = cueInhibStruc.normRatesBlanked;
pcOmitRatesBlanked = cueInhibStruc.omitRatesBlanked;
pcOptoRatesBlanked = cueInhibStruc.optoRatesBlanked;


nonEp1 = 11:40; %11:44;
nonEp2 = 71:89; %56:89;
startEp1 = 1:10; 
startEp2 = 90:100;
midEp = 41:70; %45:55;

%if toPlot
figure;
%bar([mean(mean(pcRates(:,40:60),2),1) mean(mean(pcRates2(:,40:60),2),1)]);
bar([mean([nanmean(nanmean(pcRatesBlanked(:,nonEp1),2),1) nanmean(nanmean(pcRatesBlanked(:,nonEp2),2),1)]) nanmean([nanmean(nanmean(pcRatesBlanked(:,startEp1),2),1) nanmean(nanmean(pcRatesBlanked(:,startEp2),2),1)]) nanmean(nanmean(pcRatesBlanked(:,midEp),2),1) nanmean(nanmean(pcOmitRatesBlanked(:,midEp),2),1) nanmean(nanmean(pcOptoRatesBlanked(:,midEp),2),1)]);
title('pkPos blanked non-cue, startCue, middleCue, omitCue');
legend('placeEpoch', 'startCueBlanked', 'middleCueBlanked', 'middleOptoBlanked');
ylabel('mean rate');

% figure; 
% subplot(2,1,2);
% plot(nanmean(cueInhibStruc.pfRates,1));
% subplot(2,1,1);
% imagesc(cueInhibStruc.pfRates);
% title('pfOnly rates');

%end

%% %%%%%%%%%%%%%%%%
% for i=51:63
% figure; 
% subplot(2,3,1);
% [order] = plotPosRates(cueInhibStruc.posRatesCell{i},0,1); 
% caxis([0,0.3]);
% title(i);
% 
% subplot(2,3,2);
% imagesc(cueInhibStruc.normRatesBlankedCell{i}(order,:));
% 
% subplot(2,3,3);
% imagesc(cueInhibStruc.omitRatesBlankedCell{i}(order,:));
% 
% subplot(2,3,4);
% imagesc(cueInhibStruc.optoRatesBlankedCell{i}(order,:));
% 
% subplot(2,3,5);
% plotMeanSEMshaderr(cueInhibStruc.posRatesCell{i}','b'); 
% hold on; 
% plotMeanSEMshaderr(cueInhibStruc.normRatesBlankedCell{i}', 'r');
% plotMeanSEMshaderr(cueInhibStruc.omitRatesBlankedCell{i}', 'g');
% plotMeanSEMshaderr(cueInhibStruc.optoRatesBlankedCell{i}', 'b');
% end