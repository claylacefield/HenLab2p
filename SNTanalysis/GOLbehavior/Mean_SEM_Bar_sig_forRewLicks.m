


figure;subplot(121) %means 1 row, 2 columns, 1st item

gray = rgb('gray');

errorbar(1,mean(sham_RZ_C1,1),std(sham_RZ,1)/sqrt(size(sham_RZ_C1,1)),'k');hold on;
bar(1,mean(sham_RZ_C1,1),'k');
errorbar(2,mean(IR_RZ_C1,1),std(IR_RZ_C1,1)/sqrt(size(IR_RZ_C1,1)),'k');hold on;
bar(2,mean(IR_RZ_C1,1),'FaceColor', gray)
ylabel('fraction of licks','FontSize',16);
set(gca,'XTick',[1:2])
set(gca,'XTickLabel',[{['Sham'],['IR']}])
set(gca,'FontSize',16)
pLicks = ranksum(sham_RZ_C1, IR_RZ_C1);
title(['Fraction of licks in RZ/Conflict trial , Rank-Sum p < ', num2str(pLicks, 4)]); 
%there are two strings here
%1) 'Rank-Sum p < '
%2) the output of num2str
%by putting them together within brackets [], we concatenate them into 1 string
%(In Matlab strings are just vectors of characters)
%'title' can also take cell arrays of strings as input, in which case
%each item of the cell array gets its own line

% subplot(132)
% errorbar(1,mean(sham_C1,1),std(sham_C1,1)/sqrt(size(sham_C1,1)),'k');hold on;
% bar(1,mean(sham_C1,1),'k');
% errorbar(2,mean(IR_C1,1),std(IR_C1,1)/sqrt(size(IR_C1,1)),'k');hold on;
% bar(2,mean(IR_C1,1),'FaceColor', gray)
% ylabel('fraction of licks','FontSize',16);
% set(gca,'XTick',[1:2])
% set(gca,'XTickLabel',[{['Sham'],['IR']}])
% set(gca,'FontSize',16)
% pLicks = ranksum(sham_C1, IR_C1);
% title(['Fraction of conflict licks , Rank-Sum p < ', num2str(pLicks, 4)]); 

subplot(122)
errorbar(1,mean(T1_sham_C1,1),std(sham_RZ,1)/sqrt(size(T1_sham_C1,1)),'k');hold on;
bar(1,mean(T1_sham_C1,1),'k');
errorbar(2,mean(T1_IR_C1,1),std(T1_IR_C1,1)/sqrt(size(T1_IR_C1,1)),'k');hold on;
bar(2,mean(T1_IR_C1,1),'FaceColor', gray)
errorbar(3,mean(T2_sham_C1,1),std(T2_sham_C1,1)/sqrt(size(T2_sham_C1,1)),'k');hold on;
bar(3,mean(T2_sham_C1,1),'k');
errorbar(4,mean(T2_IR_C1,1),std(T2_IR_C1,1)/sqrt(size(T2_IR_C1,1)),'k');hold on;
bar(4,mean(T2_IR_C1,1),'FaceColor', gray)

ylabel('fraction of licks','FontSize',16);
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',[{['1stSham'],['1stIR'],['2ndSham'],['2ndIR']}])
set(gca,'FontSize',16)
pLicks = ranksum(T2_sham_C1, T2_IR_C1);
title(['Fraction of conflict licks , Rank-Sum p < ', num2str(pLicks, 4)]);

