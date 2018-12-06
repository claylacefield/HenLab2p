%% variables from cueShiftStruc

PCLappedSess1 = cueShiftStruc.PCLappedSess1;
PCLappedSess2 = cueShiftStruc.PCLappedSess2;
pc = find(PCLappedSess1.Shuff.isPC==1);
posRates1 = PCLappedSess1.posRates(pc,:);
posRates2 = PCLappedSess2.posRates(pc,:);

ShiftedposRates1 = [];
ShiftedposRates2 = [];
for i = 1: size (posRates1,1);
newposRate1 = circshift(posRates1(i,:),-20,2);
newposRate2 = circshift(posRates2(i,:),-20,2);
ShiftedposRates1=[ShiftedposRates1; newposRate1];
ShiftedposRates2=[ShiftedposRates2; newposRate2];
end

%% to plot shifted

[maxVal, maxInd] = max(ShiftedposRates1');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;
ShiftedposRates1 = ShiftedposRates1(sortInd,:);

ShiftedposRates2 = ShiftedposRates2(sortInd,:);

figure('Position', [0 0 800 800]);
subplot(2,2,1);
colormap(jet);
imagesc(ShiftedposRates1);
xlabel('position');
title('LapType1');

% tuning of lapType2 PCs
subplot(2,2,2);
colormap(jet);
imagesc(ShiftedposRates2);
xlabel('position');
title('LapType2');

% and mean of each
subplot(2,2,3);
plot(mean(ShiftedposRates1,1));
hold on;
plot(mean(ShiftedposRates2,1),'g');
title('posRates1=b, posRates2=g');


%% get the isPC from PCLappedSess1, this set of laps are over >15 
%so we get at least 3 laps for second set of laps but the spatial tuning
%%for these are not reliable

COMbin1 = [];
COMbin2 = [];

circbin = 1:100;
circbin = ((circbin - 1)/99)*2*pi() - pi();
for i = 1:size (pc, 1)
    posRatesIn1 = ShiftedposRates1(i,:);
    posRatesIn2 = ShiftedposRates2(i,:);
    c1 = circ_mean(circbin, posRatesIn1, 2);
    c2 = circ_mean(circbin, posRatesIn2, 2);
    COMbin1(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
    COMbin2(i) = round(((c2 + pi())/(2*pi()))*99 + 1);
end

COMbin1 = (COMbin1)';
COMbin2 = (COMbin2)';

%cumCOMbin1 = []; cumCOMbin2 = [];
cumCOMbin1 = [cumCOMbin1; COMbin1];
cumCOMbin2 = [cumCOMbin2; COMbin2];


%% remapping between Lap type1 vs type2
rAll = [];
pAll = [];
for i = 1:size(posRates1, 1)
[r, p] = corrcoef(ShiftedposRates1(i, :)', ShiftedposRates2(i, :)');
if isnan(r(1, 2))
r(1, 2) = 0;
end
rAll = [rAll; r(1, 2)];
pAll = [pAll; p(1, 2)];
end

%cumrAll =[]; cumpAll =[];
cumrAll =[cumrAll; rAll]; cumpAll = [cumpAll; pAll];

%% ongoing
pfInAnyPos1 = PCLappedSess1.Shuff.PFInAllPos(pc);

pfInAllPosA = {};
pfOutAllPosA = {};
for i = 1:size(pfInAnyPos1,1)
    for i = 1:size(pfInAnyPos1, 2)
        pfInAllPosA{i, i}=[];
        for ii = 1:length(pfInAnyPos1{i, i})
            pfInAllPosA{i,i}=[pfInAllPosA{i,i}, pfInAnyPos1{i, i}{ii}];
            pfOutAllPosA{i,i} = setdiff([1:100],pfInAllPosA{i,i});
        end
    end
end


InfoPerSpkZ1= PCLappedSess1.Shuff.InfoPerSpkZ(pc);
InfoPerSpkP1= PCLappedSess1.Shuff.InfoPerSpkP(pc);
InfoPerSpkZ2= PCLappedSess2.Shuff.InfoPerSpkZ(pc);
InfoPerSpkP2= PCLappedSess2.Shuff.InfoPerSpkP(pc);

placeCellInd = {};
posRatesCellByLap = {};
for i = 1:size(pc,1)
placeCellInd{i} = find(PCLappedSess1.Shuff.isPC==1);    
posRatesCellByLap{i} = PCLappedSess1.ByLap.posRateByLap(placeCellInd{i},:, :);
posRatesCellByLap{i} = squeeze(posRatesCellByLap{i})';
end