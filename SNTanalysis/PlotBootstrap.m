

%%
MCfrac12=sum(CumCueNonBootStruc.DiffCellType12,1)./sum([CumCueNonBootStruc.Sess1MidCueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2);
MCfrac12Shuff=sum(CumBootStruc.MidShuff12,1)/sum(sum([CumCueNonBootStruc.Sess1MidCueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2),1);

MCfrac23=sum(CumCueNonBootStruc.DiffCellType23,1)/sum(sum([CumCueNonBootStruc.Sess2MidCueTotal,CumCueNonBootStruc.Sess2NonCueTotal],2),1);
MCfrac23Shuff=sum(CumCueNonBootStruc.DiffShuff23,1)/sum(sum([CumCueNonBootStruc.Sess2MidCueTotal,CumCueNonBootStruc.Sess2NonCueTotal],2),1);

MCfrac13=sum(CumCueNonBootStruc.DiffCellType13,1)/sum(sum([CumCueNonBootStruc.Sess3MidCueTotal,CumCueNonBootStruc.Sess3NonCueTotal],2),1);
MCfrac13Shuff=sum(CumCueNonBootStruc.DiffShuff13,1)/sum(sum([CumCueNonBootStruc.Sess3MidCueTotal,CumCueNonBootStruc.Sess3NonCueTotal],2),1);

MCfrac123=mean([MCfrac12,MCfrac23, MCfrac13]);
MCfrac123Shuff=mean([MCfrac12Shuff;MCfrac23Shuff; MCfrac13Shuff],1);
figure; hist(MCfrac123Shuff, 20);
nanmean(MCfrac123Shuff < MCfrac123);
boundsDiffNC1 = prctile(MCfrac123Shuff, [2.5, 97.5]);
hold on; plot([boundsDiffNC1(1), boundsDiffNC1(1)], [0, 1000], '--k');
hold on; plot([boundsDiffNC1(2), boundsDiffNC1(2)], [0, 1000], '--k'); 
hold on; plot([MCfrac123, MCfrac123], [0, 1000], '--r'); title(' Ctrl Mid Cue vs Non overlap MultSess');
NonCueDifffrac123P= 1 - nanmean(MCfrac123Shuff < MCfrac123);


% subplot (1,3,2); hist(MCfrac13Shuff, 20);
% nanmean(MCfrac13Shuff < MCfrac13);
% boundsDiffNC3 = prctile(MCfrac13Shuff, [2.5, 97.5]);
% hold on; plot([boundsDiffNC3(1), boundsDiffNC3(1)], [0, 1000], '--k');
% hold on; plot([boundsDiffNC3(2), boundsDiffNC3(2)], [0, 1000], '--k'); 
% hold on; plot([MCfrac13, MCfrac13], [0, 1000], '--r'); title(' Ctrl Non overlap Sess13');
% MCfrac13P= 1 - nanmean(MCfrac13Shuff < MCfrac13);
% subplot (1,3,3); hist(MCfrac23Shuff, 20);
% nanmean(MCfrac23Shuff < MCfrac23);
% bounds = prctile(MCfrac23Shuff, [2.5, 97.5]);
% hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
% hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
% hold on; plot([MCfrac23, MCfrac23], [0, 1000], '--r'); title('Ctrl Non overlap Sess23');
% MCfrac23P= 1 - nanmean(MCfrac23Shuff < MCfrac23);
% Pvalues.MCfrac12P=MCfrac12P;
% Pvalues.MCfrac13P=MCfrac13P;
 Pvalues.NonCueDifffrac123P=NonCueDifffrac123P;


%%
%make dot plots with SEM


% QuantFrac.semMEN=semMEN;
% QuantFrac.Pvalues=Pvalues;
% QuantFrac.meanMEN=meanMEN;

MCfrac12= CumBootStruc.MidBoth122313(:,1) ./ CumBootStruc.MidTotal123(:,1);
MCfrac23= CumBootStruc.MidBoth122313(:,2) ./ CumBootStruc.MidTotal123(:,2);
MCfrac13= CumBootStruc.MidBoth122313(:,3) ./ CumBootStruc.MidTotal123(:,3);
BothMC123=nanmean([MCfrac12;MCfrac23;MCfrac13]); semBothMC123= nanstd([MCfrac12;MCfrac23;MCfrac13])/sqrt(length([MCfrac12;MCfrac23;MCfrac13]));

MCfrac12Shuff=sum(CumBootStruc.MidShuff12,1)./sum(CumBootStruc.MidTotal123(:,1),1);
MCfrac23Shuff=sum(CumBootStruc.MidShuff23,1)./sum(CumBootStruc.MidTotal123(:,2),1);
MCfrac13Shuff=sum(CumBootStruc.MidShuff13,1)./sum(CumBootStruc.MidTotal123(:,3),1);
boundsShuffMC = prctile(mean([MCfrac12Shuff;MCfrac23Shuff;MCfrac13Shuff],2), [2.5, 97.5]);

ECfrac12= CumBootStruc.EdgeBoth122313(:,1) ./ CumBootStruc.EdgeTotal123(:,1);
ECfrac23= CumBootStruc.EdgeBoth122313(:,2) ./ CumBootStruc.EdgeTotal123(:,2);
ECfrac13= CumBootStruc.EdgeBoth122313(:,3) ./ CumBootStruc.EdgeTotal123(:,3);
BothEC123=nanmean([ECfrac12;ECfrac23;ECfrac13]); semBothEC123= nanstd([ECfrac12;ECfrac23;ECfrac13])/sqrt(length([ECfrac12;ECfrac23;ECfrac13]));

ECfrac12Shuff=sum(CumBootStruc.EdgeShuff12,1)./sum(CumBootStruc.EdgeTotal123(:,1),1);
ECfrac23Shuff=sum(CumBootStruc.EdgeShuff23,1)./sum(CumBootStruc.EdgeTotal123(:,2),1);
ECfrac13Shuff=sum(CumBootStruc.EdgeShuff13,1)./sum(CumBootStruc.EdgeTotal123(:,3),1);
boundsShuffEC = prctile(mean([ECfrac12Shuff;ECfrac23Shuff;ECfrac13Shuff],2), [2.5, 97.5]);

NCfrac12= CumBootStruc.NonBoth122313(:,1) ./ CumBootStruc.NonTotal123(:,1);
NCfrac23= CumBootStruc.NonBoth122313(:,2) ./ CumBootStruc.NonTotal123(:,2);
NCfrac13= CumBootStruc.NonBoth122313(:,3) ./ CumBootStruc.NonTotal123(:,3);
BothNC123=nanmean([NCfrac12;NCfrac23;NCfrac13]); semBothNC123= nanstd([NCfrac12;NCfrac23;NCfrac13])/sqrt(length([NCfrac12;NCfrac23;NCfrac13]));

NCfrac12Shuff=sum(CumBootStruc.NonShuff12,1)./sum(CumBootStruc.NonTotal123(:,1),1);
NCfrac23Shuff=sum(CumBootStruc.NonShuff23,1)./sum(CumBootStruc.NonTotal123(:,2),1);
NCfrac13Shuff=sum(CumBootStruc.NonShuff13,1)./sum(CumBootStruc.NonTotal123(:,3),1);
boundsShuffNC = prctile(mean([NCfrac12Shuff;NCfrac23Shuff;NCfrac13Shuff],2), [2.5, 97.5]);

PAll = [[MCfrac12;MCfrac23;MCfrac13]; [ECfrac12;ECfrac23;ECfrac13]; [NCfrac12;NCfrac23;NCfrac13]];
PGroup = [zeros(length([MCfrac12;MCfrac23;MCfrac13]), 1) + 1; zeros(length([ECfrac12;ECfrac23;ECfrac13]), 1) + 2; zeros(length([NCfrac12;NCfrac23;NCfrac13]), 1) + 3];

[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);


%%
MidNonfrac12=CumCueNonBootStruc.DiffCellType12 ./ sum([CumCueNonBootStruc.Sess1MidCueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2);
MidNonfrac12Shuff=sum(CumCueNonBootStruc.DiffShuff12,1) ./ sum([CumCueNonBootStruc.Sess1MidCueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2);

MidNonfrac23=CumCueNonBootStruc.DiffCellType23 ./ sum([CumCueNonBootStruc.Sess2MidCueTotal,CumCueNonBootStruc.Sess2NonCueTotal],2);
MidNonfrac23Shuff=sum(CumCueNonBootStruc.DiffShuff23,1)./sum([CumCueNonBootStruc.Sess2MidCueTotal,CumCueNonBootStruc.Sess2NonCueTotal],2);

MidNonfrac13=CumCueNonBootStruc.DiffCellType13 ./sum([CumCueNonBootStruc.Sess3MidCueTotal,CumCueNonBootStruc.Sess3NonCueTotal],2);
MidNonfrac13Shuff=sum(CumCueNonBootStruc.DiffShuff13,1)./ sum([CumCueNonBootStruc.Sess3MidCueTotal,CumCueNonBootStruc.Sess3NonCueTotal],2);

MidNonfrac123=mean([MidNonfrac12;MidNonfrac23;MidNonfrac13],1);
boundsShuffMidNon = prctile(mean([MidNonfrac12Shuff;MidNonfrac23Shuff;MidNonfrac13Shuff],2), [2.5, 97.5]);
%%
meanMEN=[BothMC123 BothEC123 BothNC123];

% boundsDiffNC1 = prctile(MCfrac12Shuff, [2.5, 97.5]);
% MCfrac13Shuff=sum(CumCueNonBootStruc.DiffShuff13,1)/sum(sum([CumCueNonBootStruc.Sess1CueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2),1);
% boundsDiffNC3 = prctile(MCfrac13Shuff, [2.5, 97.5]);
% DiffNCfrac12Shuff=sum(CumCueNonBootStruc.DiffShuff12,1)/sum(sum([CumCueNonBootStruc.Sess1CueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2),1);
% boundsDiffNC1 = prctile(MCfrac12Shuff, [2.5, 97.5]);
% DiffNCfrac13Shuff=sum(CumCueNonBootStruc.DiffShuff13,1)/sum(sum([CumCueNonBootStruc.Sess1CueTotal,CumCueNonBootStruc.Sess1NonCueTotal],2),1);
% boundsDiffNC3 = prctile(MCfrac13Shuff, [2.5, 97.5]);

% ECfrac12Shuff=sum(CumCueNonBootStruc.NonShuff12,1)/sum(CumCueNonBootStruc.NonTotal123(:,1));
% boundsEC1 = prctile(ECfrac12Shuff, [2.5, 97.5]);
% ECfrac13Shuff=sum(CumCueNonBootStruc.NonShuff13,1)/sum(CumCueNonBootStruc.NonTotal123(:,3));
% boundsEC3 = prctile(ECfrac13Shuff, [2.5, 97.5]);
% MCfrac12Shuff=sum(CumCueNonBootStruc.NonShuff12,1)/sum(CumCueNonBootStruc.NonTotal123(:,1));
% boundsMC1 = prctile(MCfrac12Shuff, [2.5, 97.5]);
% MCfrac13Shuff=sum(CumCueNonBootStruc.NonShuff13,1)/sum(CumCueNonBootStruc.NonTotal123(:,3));
% boundsMC3 = prctile(MCfrac13Shuff, [2.5, 97.5]);
B1=[boundsShuffMC(1) boundsShuffEC(1) boundsShuffNC(1)];
B2=[boundsShuffMC(2) boundsShuffEC(2) boundsShuffNC(2)];
%%

sz=100;
      Y=[0.25 0.5 0.75];
      %Y2=[0.5 0.55];

     figure; scatter(MidNonfrac123,Y,sz, 'r', 'filled');
     hold on; eb(1) = errorbar (meanMEN,Y,semMEN(1,:), 'horizontal', 'LineStyle', 'none');
     hold on; scatter(meanMEN (2,:),Y2,sz, 'b', 'filled');
     hold on; eb(2) = errorbar (meanMEN (2,:),Y2,semMEN(2,:), 'horizontal', 'LineStyle', 'none');
%     
 set(eb, 'color', 'k', 'LineWidth', 2);
     
     hold on; plot(B1, Y, '--k');
    hold on; plot(B2, Y, '--k');


%%
CellRegAllfrac1= CumCueNonBootStruc.CellReginAll122313(:,1) ./ CumCueNonBootStruc.SegNum123(:,1) ;
meanCellReg1=nanmean(CellRegAllfrac1); semCellReg1= nanstd(CellRegAllfrac1)/sqrt(length(CellRegAllfrac1));

CellRegAllfrac2= CumCueNonBootStruc.CellReginAll122313(:,1) ./ CumCueNonBootStruc.SegNum123(:,2) ;
meanCellReg2=nanmean(CellRegAllfrac2); semCellReg2= nanstd(CellRegAllfrac2)/sqrt(length(CellRegAllfrac2));

CellRegAllfrac3= CumCueNonBootStruc.CellReginAll122313(:,1) ./ CumCueNonBootStruc.SegNum123(:,3) ;
meanCellReg3=nanmean(CellRegAllfrac3); semCellReg3= nanstd(CellRegAllfrac3)/sqrt(length(CellRegAllfrac3));

CellRegFrac12 = CumCueNonBootStruc.CellReginAll122313(:,2) ./ CumCueNonBootStruc.SegNum123(:,1) ;
meanCellReg12=nanmean(CellRegFrac12); semCellReg12= nanstd(CellRegFrac12)/sqrt(length(CellRegFrac12));

CellRegFrac13 = CumCueNonBootStruc.CellReginAll122313(:,4) ./ CumCueNonBootStruc.SegNum123(:,1) ;
meanCellReg13=nanmean(CellRegFrac13); semCellReg13= nanstd(CellRegFrac13)/sqrt(length(CellRegFrac13));

     Y=[1:1:5];
     X= [meanCellReg1,meanCellReg2,meanCellReg3,meanCellReg12,meanCellReg13];
     figure; 
     err=[semCellReg1,semCellReg2,semCellReg3,semCellReg12,semCellReg13];
     errorbar(X,Y,err, 'o','horizontal');
    
