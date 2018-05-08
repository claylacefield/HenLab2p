

%%% sort all place cells detected in sess1 of all animals
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

%test for coding orthoganality 100*99/2=4950 unique bin-wise comparisons,
%can use PosRatePC or PosRatePC' both are ok but transposed is more common
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

