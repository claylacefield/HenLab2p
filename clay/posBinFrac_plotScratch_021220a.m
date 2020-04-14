



numSess = length(cueInhibStruc.cueShiftNameCell);

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

cueFrac = []; noncueFrac = [];
for i=1:size(posBinFrac,1)
    cue = [posBinFrac(i,1:2) posBinFrac(i,10:12) posBinFrac(i,20)];
    nonCue = [posBinFrac(i,5:8) posBinFrac(i,15:18)];
    cueFrac = [cueFrac cue];
    noncueFrac = [noncueFrac nonCue];
end

[h,p] = ttest2(cueFrac,noncueFrac);
avCue = mean(cueFrac)

frac = mean(posBinFrac,1);

cueFrac2 = (sum(frac(1:2))+sum(frac(9:12))+sum(frac(end-1:end)))/8;
noncueFrac2 = (sum(frac(3:8))+sum(frac(13:18)))/12;