StillWTPlaceInfo{1,1}=StillAllPlaceInfo{1,1};
StillWTPlaceInfo{1,2}=StillAllPlaceInfo{1,2};
StillWTPlaceInfo{1,3}=StillAllPlaceInfo{1,3};
StillWTPlaceInfo{1,4}=StillAllPlaceInfo{1,4};
StillWTPlaceInfo{1,5}=StillAllPlaceInfo{1,5};
StillWTPlaceInfo{1,6}=StillAllPlaceInfo{1,6};
StillWTPlaceInfo{1,7}=StillAllPlaceInfo{1,7};
StillWTPlaceInfo{1,8}=StillAllPlaceInfo{1,8};
StillWTPlaceInfo{1,9}=StillAllPlaceInfo{1,9};
StillWTPlaceInfo{1,10}=StillAllPlaceInfo{1,10};
StillWTPlaceInfo{1,11}=StillAllPlaceInfo{1,11};
StillWTPlaceInfo{1,12}=StillAllPlaceInfo{1,12};

%%%
Sess1ADiPosRatePC=[];
Sess1ADiPosRatePC=[MoveWTPlaceInfo{1, 1}.PosRatePC];
Sess1ADiPosRatePC=[Sess1ADiPosRatePC; MoveWTPlaceInfo{1, 4}.PosRatePC];
Sess1ADiPosRatePC=[Sess1ADiPosRatePC; MoveWTPlaceInfo{1, 7}.PosRatePC];
Sess1ADiPosRatePC=[Sess1ADiPosRatePC; MoveWTPlaceInfo{1, 10}.PosRatePC];
[~, m1] = max(Sess1ADiPosRatePC');
[~, m11] = sort(m1);
figure;
subplot(1, 3, 1);
imagesc(Sess1ADiPosRatePC(m11, :))

Sess2ADiPosRatePC=[];
Sess2ADiPosRatePC=[MoveWTPlaceInfo{1, 2}.PosRatePC];
Sess2ADiPosRatePC=[Sess2ADiPosRatePC; MoveWTPlaceInfo{1, 5}.PosRatePC];
Sess2ADiPosRatePC=[Sess2ADiPosRatePC; MoveWTPlaceInfo{1, 8}.PosRatePC];
Sess2ADiPosRatePC=[Sess2ADiPosRatePC; MoveWTPlaceInfo{1, 11}.PosRatePC];
[~, m2] = max(Sess2ADiPosRatePC');
[~, m22] = sort(m2);
subplot(1, 3, 2);
imagesc(Sess2ADiPosRatePC(m22, :))

Sess3ADiPosRatePC=[];
Sess3ADiPosRatePC=[MoveWTPlaceInfo{1, 3}.PosRatePC];
Sess3ADiPosRatePC=[Sess3ADiPosRatePC; MoveWTPlaceInfo{1, 6}.PosRatePC];
Sess3ADiPosRatePC=[Sess3ADiPosRatePC; MoveWTPlaceInfo{1, 9}.PosRatePC];
Sess3ADiPosRatePC=[Sess3ADiPosRatePC; MoveWTPlaceInfo{1, 12}.PosRatePC];
[~, m3] = max(Sess3ADiPosRatePC');
[~, m33] = sort(m3);
subplot(1, 3, 3);
imagesc(Sess3ADiPosRatePC(m33, :))
%%%

Sess1ADiPosRatePC=[];
Sess1ADiPosRatePC=[MoveADiPlaceInfo{1, 1}.PosRatePC];
Sess1ADiPosRatePC=[Sess1ADiPosRatePC; MoveADiPlaceInfo{1, 4}.PosRatePC];
Sess1ADiPosRatePC=[Sess1ADiPosRatePC; MoveADiPlaceInfo{1, 7}.PosRatePC];
Sess1ADiPosRatePC=[Sess1ADiPosRatePC; MoveADiPlaceInfo{1, 10}.PosRatePC];
[~, m1] = max(Sess1ADiPosRatePC');
[~, m11] = sort(m1);
figure;
subplot(1, 3, 1);
imagesc(Sess1ADiPosRatePC(m11, :))

Sess2ADiPosRatePC=[];
Sess2ADiPosRatePC=[MoveADiPlaceInfo{1, 2}.PosRatePC];
Sess2ADiPosRatePC=[Sess2ADiPosRatePC; MoveADiPlaceInfo{1, 5}.PosRatePC];
Sess2ADiPosRatePC=[Sess2ADiPosRatePC; MoveADiPlaceInfo{1, 8}.PosRatePC];
Sess2ADiPosRatePC=[Sess2ADiPosRatePC; MoveADiPlaceInfo{1, 11}.PosRatePC];
[~, m2] = max(Sess2ADiPosRatePC');
[~, m22] = sort(m2);
subplot(1, 3, 2);
imagesc(Sess2ADiPosRatePC(m22, :))

Sess3ADiPosRatePC=[];
Sess3ADiPosRatePC=[MoveADiPlaceInfo{1, 3}.PosRatePC];
Sess3ADiPosRatePC=[Sess3ADiPosRatePC; MoveADiPlaceInfo{1, 6}.PosRatePC];
Sess3ADiPosRatePC=[Sess3ADiPosRatePC; MoveADiPlaceInfo{1, 9}.PosRatePC];
Sess3ADiPosRatePC=[Sess3ADiPosRatePC; MoveADiPlaceInfo{1, 12}.PosRatePC];
[~, m3] = max(Sess3ADiPosRatePC');
[~, m33] = sort(m3);
subplot(1, 3, 3);
imagesc(Sess3ADiPosRatePC(m33, :))

%test for coding orthoganality 100*99/2=4950 unique bin-wise comparisons
Sess1WTpwPSC = [];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 1}.PosRatePC, 'correlation');
Sess1WTpwPSC = [mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 4}.PosRatePC, 'correlation');
Sess1WTpwPSC = [Sess1WTpwPSC; mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 7}.PosRatePC, 'correlation');
Sess1WTpwPSC = [Sess1WTpwPSC; mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 10}.PosRatePC, 'correlation');
Sess1WTpwPSC = [Sess1WTpwPSC; mean(pairWisePopulationSpatialCorr)];

Sess2WTpwPSC = [];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 2}.PosRatePC, 'correlation');
Sess2WTpwPSC = [mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 5}.PosRatePC, 'correlation');
Sess2WTpwPSC = [Sess2WTpwPSC; mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 8}.PosRatePC, 'correlation');
Sess2WTpwPSC = [Sess2WTpwPSC; mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 11}.PosRatePC, 'correlation');
Sess2WTpwPSC = [Sess2WTpwPSC; mean(pairWisePopulationSpatialCorr)];

Sess3WTpwPSC = [];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 3}.PosRatePC, 'correlation');
Sess3WTpwPSC = [mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 6}.PosRatePC, 'correlation');
Sess3WTpwPSC = [Sess3WTpwPSC; mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 9}.PosRatePC, 'correlation');
Sess3WTpwPSC = [Sess3WTpwPSC; mean(pairWisePopulationSpatialCorr)];
pairWisePopulationSpatialCorr = 1 - pdist(MoveAllPlaceInfo{1, 12}.PosRatePC, 'correlation');
Sess3WTpwPSC = [Sess3WTpwPSC; mean(pairWisePopulationSpatialCorr)];

%%% p value for tuning specificity only for cell rate>0
P1 = []; Rates1 = [];
P1 = [MoveAllPlaceInfo{1,1}.PlaceAnalysis.Shuff.InfoPerSpkP];
P1 = [P1; MoveAllPlaceInfo{1,4}.PlaceAnalysis.Shuff.InfoPerSpkP];
P1 = [P1; MoveAllPlaceInfo{1,7}.PlaceAnalysis.Shuff.InfoPerSpkP];
P1 = [P1; MoveAllPlaceInfo{1,10}.PlaceAnalysis.Shuff.InfoPerSpkP];
Rates1 = [mean(MoveAllPlaceInfo{1, 1}.PlaceAnalysis.posRates, 2)];
Rates1 = [Rates1; mean(MoveAllPlaceInfo{1, 4}.PlaceAnalysis.posRates, 2)];
Rates1 = [Rates1; mean(MoveAllPlaceInfo{1, 7}.PlaceAnalysis.posRates, 2)];
Rates1 = [Rates1; mean(MoveAllPlaceInfo{1, 10}.PlaceAnalysis.posRates, 2)];
P1 = P1(Rates1 > 0);

P2 = []; Rates2=[];
P2 = [MoveAllPlaceInfo{1,2}.PlaceAnalysis.Shuff.InfoPerSpkP];
P2 = [P2; MoveAllPlaceInfo{1,5}.PlaceAnalysis.Shuff.InfoPerSpkP];
P2 = [P2; MoveAllPlaceInfo{1,8}.PlaceAnalysis.Shuff.InfoPerSpkP];
P2 = [P2; MoveAllPlaceInfo{1,11}.PlaceAnalysis.Shuff.InfoPerSpkP];
Rates2 = [mean(MoveAllPlaceInfo{1, 2}.PlaceAnalysis.posRates, 2)];
Rates2 = [Rates2; mean(MoveAllPlaceInfo{1, 5}.PlaceAnalysis.posRates, 2)];
Rates2 = [Rates2; mean(MoveAllPlaceInfo{1, 8}.PlaceAnalysis.posRates, 2)];
Rates2 = [Rates2; mean(MoveAllPlaceInfo{1, 11}.PlaceAnalysis.posRates, 2)];
P2 = P2(Rates2 > 0);

P3 = []; Rates3= [];
P3 = [MoveAllPlaceInfo{1,3}.PlaceAnalysis.Shuff.InfoPerSpkP];
P3 = [P3; MoveAllPlaceInfo{1,6}.PlaceAnalysis.Shuff.InfoPerSpkP];
P3 = [P3; MoveAllPlaceInfo{1,9}.PlaceAnalysis.Shuff.InfoPerSpkP];
P3 = [P3; MoveAllPlaceInfo{1,12}.PlaceAnalysis.Shuff.InfoPerSpkP];
Rates3 = [mean(MoveAllPlaceInfo{1, 3}.PlaceAnalysis.posRates, 2)];
Rates3 = [Rates3; mean(MoveAllPlaceInfo{1, 6}.PlaceAnalysis.posRates, 2)];
Rates3 = [Rates3; mean(MoveAllPlaceInfo{1, 9}.PlaceAnalysis.posRates, 2)];
Rates3 = [Rates3; mean(MoveAllPlaceInfo{1, 12}.PlaceAnalysis.posRates, 2)];
P3 = P3(Rates3 > 0);

P4 = []; Rates4 = [];
P4 = [MoveAllPlaceInfo{2,1}.PlaceAnalysis.Shuff.InfoPerSpkP];
P4 = [P4; MoveAllPlaceInfo{2,4}.PlaceAnalysis.Shuff.InfoPerSpkP];
P4 = [P4; MoveAllPlaceInfo{2,7}.PlaceAnalysis.Shuff.InfoPerSpkP];
P4 = [P4; MoveAllPlaceInfo{2,10}.PlaceAnalysis.Shuff.InfoPerSpkP];
Rates4 = [mean(MoveAllPlaceInfo{2, 1}.PlaceAnalysis.posRates, 2)];
Rates4 = [Rates4; mean(MoveAllPlaceInfo{2, 4}.PlaceAnalysis.posRates, 2)];
Rates4 = [Rates4; mean(MoveAllPlaceInfo{2, 7}.PlaceAnalysis.posRates, 2)];
Rates4 = [Rates4; mean(MoveAllPlaceInfo{2, 10}.PlaceAnalysis.posRates, 2)];
P4 = P4(Rates4 > 0);

P5 = []; Rates2=[];
P5 = [MoveAllPlaceInfo{2,2}.PlaceAnalysis.Shuff.InfoPerSpkP];
P5 = [P5; MoveAllPlaceInfo{2,5}.PlaceAnalysis.Shuff.InfoPerSpkP];
P5 = [P5; MoveAllPlaceInfo{2,8}.PlaceAnalysis.Shuff.InfoPerSpkP];
P5 = [P5; MoveAllPlaceInfo{2,11}.PlaceAnalysis.Shuff.InfoPerSpkP];
Rates5 = [mean(MoveAllPlaceInfo{2, 2}.PlaceAnalysis.posRates, 2)];
Rates5 = [Rates5; mean(MoveAllPlaceInfo{2, 5}.PlaceAnalysis.posRates, 2)];
Rates5 = [Rates5; mean(MoveAllPlaceInfo{2, 8}.PlaceAnalysis.posRates, 2)];
Rates5 = [Rates5; mean(MoveAllPlaceInfo{2, 11}.PlaceAnalysis.posRates, 2)];
P5 = P5(Rates5 > 0);

P6 = []; Rates6= [];
P6 = [MoveAllPlaceInfo{2,3}.PlaceAnalysis.Shuff.InfoPerSpkP];
P6 = [P6; MoveAllPlaceInfo{2,6}.PlaceAnalysis.Shuff.InfoPerSpkP];
P6 = [P6; MoveAllPlaceInfo{2,9}.PlaceAnalysis.Shuff.InfoPerSpkP];
P6 = [P6; MoveAllPlaceInfo{2,12}.PlaceAnalysis.Shuff.InfoPerSpkP];
Rates6 = [mean(MoveAllPlaceInfo{2, 3}.PlaceAnalysis.posRates, 2)];
Rates6 = [Rates6; mean(MoveAllPlaceInfo{2, 6}.PlaceAnalysis.posRates, 2)];
Rates6 = [Rates6; mean(MoveAllPlaceInfo{2, 9}.PlaceAnalysis.posRates, 2)];
Rates6 = [Rates6; mean(MoveAllPlaceInfo{2, 12}.PlaceAnalysis.posRates, 2)];
P6 = P6(Rates6 > 0);

bin=0:0.01:1;
P1Frac=cumsum(histc(P1,bin)/length(P1));
P2Frac=cumsum(histc(P2,bin)/length(P2));
P3Frac=cumsum(histc(P3,bin)/length(P3));
figure;plot(bin,P1Frac,'r-','LineWidth',2);
hold on;plot(bin,P2Frac,'g-','LineWidth',2);
hold on;plot(bin,P3Frac,'b-','LineWidth',2);
set(gca,'FontSize',16);
xlabel('Tuning Specificity','FontSize',16);
ylabel('Fraction of cells','FontSize',16)


P1Frac = []; P2Frac = []; P3Frac = [] ;P4Frac = []; P5Frac = []; P6Frac = [];
for i = 0:0.01:1
P1Frac = [P1Frac; mean(P1 <= i)];
P2Frac = [P2Frac; mean(P2 <= i)];
P3Frac = [P3Frac; mean(P3 <= i)];
P4Frac = [P4Frac; mean(P4 <= i)];
P5Frac = [P5Frac; mean(P5 <= i)];
P6Frac = [P6Frac; mean(P6 <= i)];
end
bin = 0:0.01:1;
figure;plot(bin,P1Frac,'r-','LineWidth',2); hold on;plot(bin,P4Frac,'r:','LineWidth',2);
hold on;plot(bin,P2Frac,'g-','LineWidth',2);hold on;plot(bin,P5Frac,'g:','LineWidth',2);
hold on;plot(bin,P3Frac,'b-','LineWidth',2);hold on;plot(bin,P6Frac,'b:','LineWidth',2);
hold on; plot([0.05, 0.05], [0, 1], '--k')

PAll = [P1; P2; P3];
PGroup = [zeros(length(P1), 1) + 1; zeros(length(P2), 1) + 2; zeros(length(P2), 1) + 3];
PAll = [P1; P2; P3];
PGroup = [zeros(length(P1), 1) + 1; zeros(length(P2), 1) + 2; zeros(length(P3), 1) + 3];
[p,tbl,stats] = kruskalwallis(PAll, PGroup)
c = multcompare(stats)
