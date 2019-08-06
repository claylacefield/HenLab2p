
Licks_Sham = Mean_Lapnumber_sham (:,1);
Licks_img_ctrl = Mean_Lapnumber_img_ctrl (:,1);
Licks_IR = Mean_Lapnumber_IR (:,1);

Laps_Sham = Mean_Lapnumber_sham (:,2);
Laps_img_ctrl = Mean_Lapnumber_img_ctrl (:,2);
Laps_IR = Mean_Lapnumber_IR (:,2);

figure;subplot(121) %means 1 row, 2 columns, 1st item
% darkgreen = ([30, 160, 41] - 1)/255;
gray = rgb('gray');
errorbar(1,mean(Licks_img_ctrl,1),std(Licks_img_ctrl,1)/sqrt(size(Licks_img_ctrl,1)),'k');hold on;
bar(1,mean(Licks_img_ctrl,1),'r');
errorbar(2,mean(Licks_Sham,1),std(Licks_Sham,1)/sqrt(size(Licks_Sham,1)),'k');hold on;
bar(2,mean(Licks_Sham,1),'k');
errorbar(3,mean(Licks_IR,1),std(Licks_IR,1)/sqrt(size(Licks_IR,1)),'k');hold on;
bar(3,mean(Licks_IR,1),'FaceColor', gray)
ylabel('number of licks','FontSize',16);
set(gca,'XTick',[1:3])
set(gca,'XTickLabel',[{['Ctrl'],['Sham'],['IR']}])
set(gca,'FontSize',16)
pLicks = ranksum(Mean_Lapnumber_IR(:, 1), Mean_Lapnumber_sham(:, 1));
title(['Lick Incidence, Rank-Sum p < ', num2str(pLicks, 4)]); 
%there are two strings here
%1) 'Rank-Sum p < '
%2) the output of num2str
%by putting them together within brackets [], we concatenate them into 1 string
%(In Matlab strings are just vectors of characters)
%'title' can also take cell arrays of strings as input, in which case
%each item of the cell array gets its own line

subplot(122)
errorbar(1,mean(Laps_img_ctrl,1),std(Laps_img_ctrl,1)/sqrt(size(Laps_img_ctrl,1)),'k');hold on;
bar(1,mean(Laps_img_ctrl,1),'r');
errorbar(2,mean(Laps_Sham,1),std(Laps_Sham,1)/sqrt(size(Laps_Sham,1)),'k');hold on;
bar(2,mean(Laps_Sham,1),'k')
errorbar(3,mean(Laps_IR,1),std(Laps_IR,1)/sqrt(size(Laps_IR,1)),'k');hold on;
bar(3,mean(Laps_IR),'FaceColor', gray)
ylabel('number of laps','FontSize',16);
set(gca,'XTick',[1:3]);
set(gca,'XTickLabel',[{['Ctrl'],['Sham'],['IR']}]);
set(gca,'FontSize',16)
pLaps = ranksum(Mean_Lapnumber_IR(:, 2), Mean_Lapnumber_sham(:, 2));
title2 = title(['Lap Numbers, Rank-Sum p < ', num2str(pLaps, 4)]); 
%there are two strings here
%1) 'Rank-Sum p < '
%2) the output of num2str
%by putting them together within brackets [], we concatenate them into 1 string
%(In Matlab strings are just vectors of characters)
%'title' can also take cell arrays of strings as input, in which case
%each item of the cell array gets its own line