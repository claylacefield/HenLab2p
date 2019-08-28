
PCfrac12=sum(AllCtxBootstrapStruc.AllmiceActNumPC12(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumPC12(:,2));
PC12=sum(AllCtxBootstrapStruc.AllmiceActNumPC12(:,1));
PC12Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumPC12,1);
PCfrac12Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumPC12,1)/sum(AllCtxBootstrapStruc.AllmiceActNumPC12(:,2));

PCfrac23=sum(AllCtxBootstrapStruc.AllmiceActNumPC23(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumPC23(:,2));
PC23=sum(AllCtxBootstrapStruc.AllmiceActNumPC23(:,1));
PC23Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumPC23,1);
PCfrac23Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumPC23,1)/sum(AllCtxBootstrapStruc.AllmiceActNumPC23(:,2));

figure;
subplot (1,2,1); hist(PCfrac12Shuff, 20);
mean(PCfrac12Shuff < PCfrac12);
bounds = prctile(PCfrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([PCfrac12, PCfrac12], [0, 1000], '--r'); title('IR PC Overlap Sess12');
PCfrac12P= 1 - mean(PCfrac12Shuff < PCfrac12);
subplot (1,2,2); hist(PCfrac23Shuff, 20);
mean(PCfrac23Shuff < PCfrac23);
bounds = prctile(PCfrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([PCfrac23, PCfrac23], [0, 1000], '--r');title('IR  PC Overlap Sess23');
PCfrac23P= 1 - mean(PCfrac23Shuff < PCfrac23);

%%
MCfrac12=sum(AllCtxBootstrapStruc.AllmiceActNumMC12(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumMC12(:,2));
MCfrac12Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumMC12,1)/sum(AllCtxBootstrapStruc.AllmiceActNumMC12(:,2));
MCfrac23=sum(AllCtxBootstrapStruc.AllmiceActNumMC23(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumMC23(:,2));
MCfrac23Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumMC23,1)/sum(AllCtxBootstrapStruc.AllmiceActNumMC23(:,2));
figure; subplot (1,2,1); hist(MCfrac12Shuff, 20);
mean(MCfrac12Shuff < MCfrac12);
bounds = prctile(MCfrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([MCfrac12, MCfrac12], [0, 1000], '--r'); title(' Ctrl MC Overlap Sess12');
MCfrac12P= 1 - mean(MCfrac12Shuff < MCfrac12);
subplot (1,2,2); hist(MCfrac23Shuff, 20);
mean(MCfrac23Shuff < MCfrac23);
bounds = prctile(MCfrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([MCfrac23, MCfrac23], [0, 1000], '--r'); title('Ctrl MC Overlap Sess23');
MCfrac23P= 1 - mean(MCfrac23Shuff < MCfrac23);


ECfrac12=sum(AllCtxBootstrapStruc.AllmiceActNumEC12(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumEC12(:,2));
ECfrac12Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumEC12,1)/sum(AllCtxBootstrapStruc.AllmiceActNumEC12(:,2));
ECfrac23=sum(AllCtxBootstrapStruc.AllmiceActNumEC23(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumEC23(:,2));
ECfrac23Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumEC23,1)/sum(AllCtxBootstrapStruc.AllmiceActNumEC23(:,2));

figure; subplot (1,2,1); hist(ECfrac12Shuff, 20);
mean(ECfrac12Shuff < ECfrac12);
bounds = prctile(ECfrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([ECfrac12, ECfrac12], [0, 1000], '--r'); title('Ctrl EC Overlap Sess12');
ECfrac12P= 1 - mean(ECfrac12Shuff < ECfrac12);
subplot (1,2,2); hist(ECfrac23Shuff, 20);
mean(ECfrac23Shuff < ECfrac23);
bounds = prctile(ECfrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([ECfrac23, ECfrac23], [0, 1000], '--r'); title('Ctrl EC Overlap Sess23');
ECfrac23P= 1 - mean(ECfrac23Shuff < ECfrac23);


NCfrac12=sum(AllCtxBootstrapStruc.AllmiceActNumNC12(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumNC12(:,2));
NCfrac12Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumNC12,1)/sum(AllCtxBootstrapStruc.AllmiceActNumNC12(:,2));
NCfrac23=sum(AllCtxBootstrapStruc.AllmiceActNumNC23(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumNC23(:,2));
NCfrac23Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumNC23,1)/sum(AllCtxBootstrapStruc.AllmiceActNumNC23(:,2));

figure; subplot (1,2,1); hist(NCfrac12Shuff, 20);
mean(NCfrac12Shuff < NCfrac12);
bounds = prctile(NCfrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([NCfrac12, NCfrac12], [0, 1000], '--r'); title('Ctrl NC Overlap Sess12');
NCfrac12P= 1 - mean(NCfrac12Shuff < NCfrac12);
subplot (1,2,2); hist(NCfrac23Shuff, 20);
mean(NCfrac23Shuff < NCfrac23);
bounds = prctile(NCfrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([NCfrac23, NCfrac23], [0, 1000], '--r'); title('Ctrl NC Overlap Sess23');
NCfrac23P= 1 - mean(NCfrac23Shuff < NCfrac23);

%%

NonandCuefrac12=sum(AllCtxBootstrapStruc.AllmiceActNumNonandPlace12(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumNonandPlace12(:,2));
NonandCuefrac12Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumNonandPlace12,1)/sum(AllCtxBootstrapStruc.AllmiceActNumNonandPlace12(:,2));
NonandCuefrac23=sum(AllCtxBootstrapStruc.AllmiceActNumNonandPlace23(:,1))/sum(AllCtxBootstrapStruc.AllmiceActNumNonandPlace23(:,2));
NonandCuefrac23Shuff=sum(AllCtxBootstrapStruc.AllmiceShuffNumNonandPlace23,1)/sum(AllCtxBootstrapStruc.AllmiceActNumNonandPlace23(:,2));

figure; subplot (1,2,1); hist(NonandCuefrac12Shuff, 20);
mean(NonandCuefrac12Shuff < NonandCuefrac12);
bounds = prctile(NonandCuefrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([NonandCuefrac12, NonandCuefrac12], [0, 1000], '--r'); title('Ctrl non and PC Overlap Sess12');
NonandCuefrac12P= 1 - mean(NonandCuefrac12Shuff < NonandCuefrac12);
subplot (1,2,2); hist(NonandCuefrac23Shuff, 20);
mean(NonandCuefrac23Shuff < NonandCuefrac23);
bounds = prctile(NonandCuefrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([NonandCuefrac23, NonandCuefrac23], [0, 1000], '--r'); title('Ctrl non and PC Overlap Sess23');
NonandCuefrac23P= 1 - mean(NonandCuefrac23Shuff < NonandCuefrac23);
%%
P = [PCfrac12P, PCfrac23P, MCfrac12P, MCfrac23P, ECfrac12P, ECfrac23P, NCfrac12P, NCfrac23P, NonandCuefrac12P, NonandCuefrac23P];
Frac = [PCfrac12, PC23, MCfrac12, MCfrac23, ECfrac12, ECfrac23, NCfrac12, NCfrac23, NonandCuefrac12, NonandCuefrac23];
P=P'; Frac=Frac'; 
total=[P,Frac];
