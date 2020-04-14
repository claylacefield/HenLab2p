% cueSpatModPlotScratch



norm = cueSpatModStruc.avMidCueAmps;
shift = cueSpatModStruc.avShiftCueAmps;

% delete extreme values if necessary
norm(shift>50)=[]; shift(shift>50)=[];
shift(norm>50)=[]; norm(norm>50)=[];

% bar plot with ttest and errorbars
[h,p] = ttest(shift,norm); %bd
sdNorm = std(norm)/sqrt(length(norm)); sdShift = std(shift)/sqrt(length(shift));
figure; 
x = categorical({'shift', 'norm'});
x = reordercats(x,{'shift', 'norm'});
b = bar(x,[mean(shift), mean(norm)]); 
b.FaceColor = 'flat';
b.CData(1,:) = [0 1 0]; b.CData(2,:) = [0 0 1];
hold on; 
errorbar([mean(shift), mean(norm)],[sdShift, sdNorm],'.');
title(['paired ttest, shift vs norm, p = ' num2str(p)]);

% log scale 
figure; plot(shift./norm, '.'); set(gca, 'YScale','log');
hold on; line([0 350], [1 1]);

% violin plot
Y = [shift; norm];
Y=Y';
figure; 
[h,L,MX,MED,bw]=violin(Y,'xlabel', {'shift', 'norm'}, 'facecolor', [0 1 0;0 0 1]);

% boxplot
figure; boxplot(Y);

% linear fit
lm = fitlm(norm, shift)

