StillSess4posRates=[];
StillSess4posRates=[StillAllPlaceInfo{2, 1}.PlaceAnalysis.posRates];
StillSess4posRates=[StillSess1posRates; StillAllPlaceInfo{2, 4}.PlaceAnalysis.posRates];
StillSess4posRates=[StillSess1posRates; StillAllPlaceInfo{2, 7}.PlaceAnalysis.posRates];
StillSess4posRates=[StillSess1posRates; StillAllPlaceInfo{2, 10}.PlaceAnalysis.posRates];
D = StillSess4posRates;
figure; shadedErrorBar([],mean(D), (std(D)/(sqrt(length(D)))), 'lineProps', 'r', 'transparent', 1);
hold on;
StillSess5posRates=[];
StillSess5posRates=[StillAllPlaceInfo{2, 2}.PlaceAnalysis.posRates];
StillSess5posRates=[StillSess5posRates; StillAllPlaceInfo{2, 5}.PlaceAnalysis.posRates];
StillSess5posRates=[StillSess5posRates; StillAllPlaceInfo{2, 8}.PlaceAnalysis.posRates];
StillSess5posRates=[StillSess5posRates; StillAllPlaceInfo{2, 11}.PlaceAnalysis.posRates];
E= StillSess5posRates;
shadedErrorBar([],mean(E), (std(E)/(sqrt(length(E)))), 'lineProps', 'g', 'transparent', 1);
hold on;
StillSess6posRates=[]; 
StillSess6posRates=[StillAllPlaceInfo{2, 3}.PlaceAnalysis.posRates];
StillSess6posRates=[StillSess6posRates; StillAllPlaceInfo{2, 6}.PlaceAnalysis.posRates];
StillSess6posRates=[StillSess6posRates; StillAllPlaceInfo{2, 9}.PlaceAnalysis.posRates];
StillSess6posRates=[StillSess6posRates; StillAllPlaceInfo{2, 12}.PlaceAnalysis.posRates];
F= StillSess6posRates;
shadedErrorBar([],mean(F), (std(F)/(sqrt(length(F)))), 'lineProps', 'b', 'transparent', 1);

%%%%

StillSess1Occupancy=[];
StillSess1Occupancy=[StillAllPlaceInfo{2, 1}.PlaceAnalysis.Occupancy];
StillSess1Occupancy=[StillSess1Occupancy; StillAllPlaceInfo{2, 4}.PlaceAnalysis.Occupancy];
StillSess1Occupancy=[StillSess1Occupancy; StillAllPlaceInfo{2, 7}.PlaceAnalysis.Occupancy];
StillSess1Occupancy=[StillSess1Occupancy; StillAllPlaceInfo{2, 10}.PlaceAnalysis.Occupancy];
D = StillSess1Occupancy;
figure; shadedErrorBar([],mean(D), (std(D)/(sqrt(length(D)))), 'lineProps', 'r', 'transparent', 1);
hold on;
StillSess2Occupancy=[];
StillSess2Occupancy=[StillAllPlaceInfo{2, 2}.PlaceAnalysis.Occupancy];
StillSess2Occupancy=[StillSess2Occupancy; StillAllPlaceInfo{2, 5}.PlaceAnalysis.Occupancy];
StillSess2Occupancy=[StillSess2Occupancy; StillAllPlaceInfo{2, 8}.PlaceAnalysis.Occupancy];
StillSess2Occupancy=[StillSess2Occupancy; StillAllPlaceInfo{2, 11}.PlaceAnalysis.Occupancy];
E= StillSess2Occupancy;
shadedErrorBar([],mean(E), (std(E)/(sqrt(length(E)))), 'lineProps', 'g', 'transparent', 1);
hold on;
StillSess3Occupancy=[]; 
StillSess3Occupancy=[StillAllPlaceInfo{2, 3}.PlaceAnalysis.Occupancy];
StillSess3Occupancy=[StillSess3Occupancy; StillAllPlaceInfo{2, 6}.PlaceAnalysis.Occupancy];
StillSess3Occupancy=[StillSess3Occupancy; StillAllPlaceInfo{2, 9}.PlaceAnalysis.Occupancy];
StillSess3Occupancy=[StillSess3Occupancy; StillAllPlaceInfo{2, 12}.PlaceAnalysis.Occupancy];
F= StillSess3Occupancy;
shadedErrorBar([],mean(F), (std(F)/(sqrt(length(F)))), 'lineProps', 'b', 'transparent', 1);
%%%%%%
MoveSess1Occupancy=[];
MoveSess1Occupancy=[MoveAllPlaceInfo{1, 1}.PlaceAnalysis.Occupancy];
MoveSess1Occupancy=[MoveSess1Occupancy; MoveAllPlaceInfo{1, 4}.PlaceAnalysis.Occupancy];
MoveSess1Occupancy=[MoveSess1Occupancy; MoveAllPlaceInfo{1, 7}.PlaceAnalysis.Occupancy];
MoveSess1Occupancy=[MoveSess1Occupancy; MoveAllPlaceInfo{1, 10}.PlaceAnalysis.Occupancy];
D = MoveSess1Occupancy;
figure; shadedErrorBar([],mean(D), (std(D)/(sqrt(length(D)))), 'lineProps', 'r', 'transparent', 1);
hold on;
MoveSess2Occupancy=[];
MoveSess2Occupancy=[MoveAllPlaceInfo{1, 2}.PlaceAnalysis.Occupancy];
MoveSess2Occupancy=[MoveSess2Occupancy; MoveAllPlaceInfo{1, 5}.PlaceAnalysis.Occupancy];
MoveSess2Occupancy=[MoveSess2Occupancy; MoveAllPlaceInfo{1, 8}.PlaceAnalysis.Occupancy];
MoveSess2Occupancy=[MoveSess2Occupancy; MoveAllPlaceInfo{1, 11}.PlaceAnalysis.Occupancy];
E= MoveSess2Occupancy;
shadedErrorBar([],mean(E), (std(E)/(sqrt(length(E)))), 'lineProps', 'g', 'transparent', 1);
hold on;
MoveSess3Occupancy=[]; 
MoveSess3Occupancy=[MoveAllPlaceInfo{1, 3}.PlaceAnalysis.Occupancy];
MoveSess3Occupancy=[MoveSess3Occupancy; MoveAllPlaceInfo{1, 6}.PlaceAnalysis.Occupancy];
MoveSess3Occupancy=[MoveSess3Occupancy; MoveAllPlaceInfo{1, 9}.PlaceAnalysis.Occupancy];
MoveSess3Occupancy=[MoveSess3Occupancy; MoveAllPlaceInfo{1, 12}.PlaceAnalysis.Occupancy];
F= MoveSess3Occupancy;
shadedErrorBar([],mean(F), (std(F)/(sqrt(length(F)))), 'lineProps', 'b', 'transparent', 1);
%%%

MoveSess4posRates=[];
MoveSess4posRates=[MoveAllPlaceInfo{2, 1}.PlaceAnalysis.posRates];
MoveSess4posRates=[MoveSess4posRates; MoveAllPlaceInfo{2, 4}.PlaceAnalysis.posRates];
MoveSess4posRates=[MoveSess4posRates; MoveAllPlaceInfo{2, 7}.PlaceAnalysis.posRates];
MoveSess4posRates=[MoveSess4posRates; MoveAllPlaceInfo{2, 10}.PlaceAnalysis.posRates];
D = MoveSess4posRates;
figure; shadedErrorBar([],mean(D), (std(D)/(sqrt(length(D)))), 'lineProps', 'r', 'transparent', 1);
hold on;
MoveSess5posRates=[];
MoveSess5posRates=[MoveAllPlaceInfo{2, 2}.PlaceAnalysis.posRates];
MoveSess5posRates=[MoveSess5posRates; MoveAllPlaceInfo{2, 5}.PlaceAnalysis.posRates];
MoveSess5posRates=[MoveSess5posRates; MoveAllPlaceInfo{2, 8}.PlaceAnalysis.posRates];
MoveSess5posRates=[MoveSess5posRates; MoveAllPlaceInfo{2, 11}.PlaceAnalysis.posRates];
E= MoveSess5posRates;
shadedErrorBar([],mean(E), (std(E)/(sqrt(length(E)))), 'lineProps', 'g', 'transparent', 1);
hold on;
MoveSess6posRates=[]; 
MoveSess6posRates=[MoveAllPlaceInfo{2, 3}.PlaceAnalysis.posRates];
MoveSess6posRates=[MoveSess6posRates; MoveAllPlaceInfo{2, 6}.PlaceAnalysis.posRates];
MoveSess6posRates=[MoveSess6posRates; MoveAllPlaceInfo{2, 9}.PlaceAnalysis.posRates];
MoveSess6posRates=[MoveSess6posRates; MoveAllPlaceInfo{2, 12}.PlaceAnalysis.posRates];
F= MoveSess6posRates;
shadedErrorBar([],mean(F), (std(F)/(sqrt(length(F)))), 'lineProps', 'b', 'transparent', 1);

%to determine the fraction of cells that are PC, active during still,
%active during movement
StillADiRate = []; MovADiRate = []; MovADiIsPC = [];
for i = 1:length(StillADiPlaceInfo)
stillSums = sum(StillADiPlaceInfo{i}.PlaceAnalysis.posSums, 2);
stillTime = sum(diff(StillADiPlaceInfo{i}.PlaceAnalysis.runTimes, [], 2));
stillADiRates = stillSums/stillTime;
StillADiRate = [StillADiRate; stillADiRates];

movSums = sum(MoveADiPlaceInfo{i}.PlaceAnalysis.posSums, 2);
movTime = sum(diff(MoveADiPlaceInfo{i}.PlaceAnalysis.runTimes, [], 2));
movRates = movSums/movTime;
MovADiRate = [MovADiRate; movRates];

MovADiIsPC = [MovADiIsPC; MoveADiPlaceInfo{i}.PlaceAnalysis.Shuff.isPC];
end
%then get the fractions as mean of a logical vector will give you the
%fraction
mean(MovADiIsPC>0) % fraction of PC
mean(StillADiRate(MovADiIsPC==0)==0) % fraction of nonplacecells that are silent during still
mean(StillADiRate(MovADiIsPC>0)==0)%fract of place cells that are silent during still

%to plot moving vs still rates 
sz=30;
figure; scatter(MovADiRate, StillADiRate, sz, 'filled' ,'b');
%to get correlation of the moving vs still
[r,p]=corrcoef(MovADiRate, StillADiRate);
r(1,2) % is the correlation coefficient value
p(1,2) % is the p value

%to correlate mean event rates of  
E=StillAllPlaceInfo{1,1}.PlaceAnalysis.posRates;
D=StillAllPlaceInfo{1,2}.PlaceAnalysis.posRates;
F=StillAllPlaceInfo{1,3}.PlaceAnalysis.posRates;
a = nanmean(E); % corcoeff doesn't work wt NaNs
b  = nanmean(D);
[r, p] = corrcoef(a', b');
%or
k = ~isnan(a) & ~isnan(b);
[r, p] = corrcoef(a(k)', b(k)'); %to make sure to get rid of NaNs
r(1,2); p(1,2) %are the coefficient and p value
[r, p] = corrcoef(E'); % to look at correlation within cells?