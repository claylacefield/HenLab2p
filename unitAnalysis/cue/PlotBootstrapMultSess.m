PCnumtotal= sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumPC12(:,1)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumPC23(:,1))]);
Cellnumtotal = sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumPC12(:,2)),sum(AllCtrlToneMintTactBootstrap.AllmiceActNumPC23(:,2))]);

PCfrac= PCnumtotal/Cellnumtotal;
PCShuff=[sum(AllCtrlIAALEDTactBootstrap.AllmiceShuffNumPC12,1); sum(AllCtrlToneMintTactBootstrap.AllmiceShuffNumPC23,1)];
PCfracShuff=sum(PCShuff,1)/Cellnumtotal;

figure;
subplot (1,5,1); hist(PCfracShuff, 20);
mean(PCfracShuff < PCfrac);
bounds = prctile(PCfracShuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([PCfrac, PCfrac], [0, 1000], '--r'); title('Ctrl PC');
PCfracP= 1 - mean(PCfracShuff < PCfrac);

MCnumtotal= sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumMC12(:,1)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumMC23(:,1))]);
MCellnumtotal = sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumMC12(:,2)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumMC23(:,2))]);

MCfrac= MCnumtotal/MCellnumtotal;
MCShuff=[sum(AllCtrlIAALEDTactBootstrap.AllmiceShuffNumMC12,1);  sum(AllCtrlToneMintTactBootstrap.AllmiceShuffNumMC23,1)];
MCfracShuff=sum(MCShuff,1)/MCellnumtotal;

subplot (1,5,2); hist(MCfracShuff, 20);
mean(MCfracShuff < MCfrac);
bounds = prctile(MCfracShuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([MCfrac, MCfrac], [0, 1000], '--r'); title('Ctrl MC');
MCfracP= 1 - mean(MCfracShuff < MCfrac);

ECnumtotal= sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumEC12(:,1)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumEC23(:,1))]);
ECellnumtotal = sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumEC12(:,2)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumEC23(:,2))]);

ECfrac= ECnumtotal/ECellnumtotal;
ECShuff=[sum(AllCtrlIAALEDTactBootstrap.AllmiceShuffNumEC12,1); sum(AllCtrlToneMintTactBootstrap.AllmiceShuffNumEC23,1)];
ECfracShuff=sum(ECShuff,1)/ECellnumtotal;

subplot (1,5,3); hist(ECfracShuff, 20);
mean(ECfracShuff < ECfrac);
bounds = prctile(ECfracShuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([ECfrac, ECfrac], [0, 1000], '--r'); title('Ctrl EC');
ECfracP= 1 - mean(ECfracShuff < ECfrac);


NCnumtotal= sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumNC12(:,1)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumNC23(:,1))]);
NCellnumtotal = sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumNC12(:,2)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumNC23(:,2))]);

NCfrac= NCnumtotal/NCellnumtotal;
NCShuff=[sum(AllCtrlIAALEDTactBootstrap.AllmiceShuffNumNC12,1); sum(AllCtrlToneMintTactBootstrap.AllmiceShuffNumNC23,1)];
NCfracShuff=sum(NCShuff,1)/NCellnumtotal;

subplot (1,5,4); hist(NCfracShuff, 20);
mean(NCfracShuff < NCfrac);
bounds = prctile(NCfracShuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([NCfrac, NCfrac], [0, 1000], '--r'); title('Ctrl NC');
NCfracP= 1 - mean(NCfracShuff < NCfrac);


Cnumtotal= sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumNonandCue12(:,1)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumNonandCue23(:,1))]);
NCenumtotal = sum([sum(AllCtrlIAALEDTactBootstrap.AllmiceActNumNonandCue12(:,2)), sum(AllCtrlToneMintTactBootstrap.AllmiceActNumNonandCue23(:,2))]);

NonandCuefrac= Cnumtotal/NCenumtotal;
NonandCueShuff=[sum(AllCtrlIAALEDTactBootstrap.AllmiceShuffNumNonandCue12,1); sum(AllCtrlToneMintTactBootstrap.AllmiceShuffNumNonandCue23,1)];
NonandCuefracShuff=sum(NonandCueShuff,1)/NCenumtotal;

subplot (1,5,5); hist(NonandCuefracShuff, 20);
mean(NonandCuefracShuff < NonandCuefrac);
bounds = prctile(NonandCuefracShuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); 
hold on; plot([NonandCuefrac, NonandCuefrac], [0, 1000], '--r'); title('Ctrl Cue and non cue');
NonandCuefracP= 1 - mean(NonandCuefracShuff < NonandCuefrac);


P = [PCfracP, MCfracP, ECfracP, NCfracP, NonandCuefracP];
Frac = [PCfrac, MCfrac, ECfrac, NCfrac, NonandCuefrac];
P=P'; Frac=Frac'; 
totalCtrl=[P,Frac];
