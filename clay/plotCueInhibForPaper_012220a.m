% plotCueInhibForPaper



%% plot cueInhibStruc (for nonspecific firing)

load('/Backup20TB/clay/DGdata/cuePaper/inhib/cueInhibStruc_2_noTone_20-Jan-2020.mat');

normRates = cueInhibStruc.normRatesBlanked;
omitRates = cueInhibStruc.omitRatesBlanked;
figure;
subplot(1,2,1);
imagesc(normRates); colormap(hot);
cl = caxis;
subplot(1,2,2);
imagesc(omitRates);
caxis(cl);


aFilt = fspecial('gaussian', [20,1], 10);
normRates2 = imfilter(normRates,aFilt);
omitRates2 = imfilter(omitRates,aFilt);
figure; 
subplot(1,2,1); imagesc(normRates2); colormap(hot); caxis([0,0.08]);
subplot(1,2,2); imagesc(omitRates2); caxis([0,0.08]);

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

%% for cueShiftInhibPlaceStruc
load('/Backup20TB/clay/DGdata/cuePaper/inhib/cueShiftInhibPlaceStruc_pos25to40_10-Nov-2019.mat');

normCell = cueShiftInhibPlaceStruc.shiftLocNormRatesCell;
shiftCell = cueShiftInhibPlaceStruc.shiftLocShiftRatesCell;

normPkRates=[]; shiftPkRates=[];
normRates=[]; shiftRates=[];
for i=1:length(normCell)
    normRatesSess = normCell{i};
    shiftRatesSess = shiftCell{i};
    normRates = [normRates; normRatesSess];
    shiftRates = [shiftRates; shiftRatesSess];
    normPkRates = [normPkRates; max(normRatesSess(:,25:40),[],2)];
    shiftPkRates = [shiftPkRates; max(shiftRatesSess(:,25:40),[],2)];
    
end

figure;
subplot(1,2,1);
colormap(hot);
imagesc(normRates);
cl = caxis;
title('cueInhibPlace, PF25-40, normal laps');
subplot(1,2,2);
%colormap(hot);
imagesc(shiftRates);
caxis(cl);
title('shift laps');

figure; plot(normPkRates, shiftPkRates, '.');
hold on; line([0,0.6],[0,0.6]);
[h,p] = ttest(1-shiftPkRates./normPkRates);

figure; bar([mean(normPkRates),mean(shiftPkRates)]); ylim([0,0.2]); 
hold on; 
sem1 = std(normPkRates)/sqrt(76); sem2 = std(shiftPkRates)/sqrt(76); % actually should be 645
errorbar([mean(normPkRates),mean(shiftPkRates)], [sem1,sem2]);

%% plot cueCompet relAmpAll (cue cell mutual inhibition)

load('/Backup20TB/clay/DGdata/cuePaper/inhib/190703_cueCompet_B4P4S2_03-Jan-2020.mat');

figure; bar([mean(relAmpAll(1,:),2),mean(relAmpAll(2,:),2)]); ylim([0,1.5]); hold on; 
sem1 = std(relAmpAll(1,:))/sqrt(56); sem2 = std(relAmpAll(2,:))/sqrt(56); 
errorbar([mean(relAmpAll(1,:),2),mean(relAmpAll(2,:),2)], [sem1,sem2]);



%% 

