% variables from cueShiftStruc
% cumCOMbin1 = []; cumCOMbin2 = []; cumCOMbin3 = [];
% cumZ1 =[]; cumZ2 =[]; cumZ3 =[]; cumP1 =[]; cumP2 =[]; cumP3 =[];
% cumPosRate1 =[];cumPosRate2 =[]; cumPosRate3 =[]; 

PCLappedSess1 = cueShiftStruc.PCLappedSessCell{1,2};
PCLappedSess2 = cueShiftStruc.PCLappedSessCell{1,1};
PCLappedSess3 = cueShiftStruc.PCLappedSessCell{1,3};
pc = find(PCLappedSess1.Shuff.isPC==1);
posRates1 = PCLappedSess1.posRates(pc,:);
posRates2 = PCLappedSess2.posRates(pc,:);
posRates3 = PCLappedSess3.posRates(pc,:);


posRatesCellByLapSess1 = {};
posRatesCellByLapSess2 = {};
posRatesCellByLapSess3 = {};
for i = 1:size(pc,1)
    posRatesCellByLapSess1{i} = cueShiftStruc.PCLappedSessCell{1,2}.ByLap.posRateByLap(pc(i),:, :);
    posRatesCellByLapSess1{i} = squeeze(posRatesCellByLapSess1{i});
    posRatesCellByLapSess2{i} = cueShiftStruc.PCLappedSessCell{1,1}.ByLap.posRateByLap(pc(i),:, :);
    posRatesCellByLapSess2{i} = squeeze(posRatesCellByLapSess2{i});
    posRatesCellByLapSess3{i} = cueShiftStruc.PCLappedSessCell{1,3}.ByLap.posRateByLap(pc(i),:, :);
    posRatesCellByLapSess3{i} = squeeze(posRatesCellByLapSess3{i});
end


COMbin1 = [];
COMbin2 = [];
COMbin3 = [];

circbin = 1:100;
circbin = ((circbin - 1)/99)*2*pi() - pi();
for i = 1:size (pc, 1)
    posRatesIn1 = posRates1(i,:);
    posRatesIn2 = posRates2(i,:);
    posRatesIn3 = posRates3(i,:);
    c1 = circ_mean(circbin, posRatesIn1, 2);
    c2 = circ_mean(circbin, posRatesIn2, 2);
    c3 = circ_mean(circbin, posRatesIn3, 2);
    COMbin1(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
    COMbin2(i) = round(((c2 + pi())/(2*pi()))*99 + 1);
    COMbin3(i) = round(((c3 + pi())/(2*pi()))*99 + 1);

end

COMbin1 = (COMbin1)';
COMbin2 = (COMbin2)';
COMbin3 = (COMbin3)';

Z1= PCLappedSess1.Shuff.InfoPerSpkZ(pc);
P1= PCLappedSess1.Shuff.InfoPerSpkP(pc);
Z2= PCLappedSess2.Shuff.InfoPerSpkZ(pc);
P2= PCLappedSess2.Shuff.InfoPerSpkP(pc);
Z3= PCLappedSess3.Shuff.InfoPerSpkZ(pc);
P3= PCLappedSess3.Shuff.InfoPerSpkP(pc);


cumCOMbin1 = [cumCOMbin1; COMbin1];
cumCOMbin2 = [cumCOMbin2; COMbin2];
cumCOMbin3 = [cumCOMbin3; COMbin3];

cumZ1 =[cumZ1; Z1]; cumZ2 =[cumZ2; Z2]; cumZ3 =[cumZ3; Z3]; 
cumP1 =[cumP1;P1]; cumP2 =[cumP2;P2]; cumP3 =[cumP3; P3]; 
cumPosRate1 =[cumPosRate1; posRates1];
cumPosRate2 =[cumPosRate2; posRates2]; 
cumPosRate3 =[cumPosRate3; posRates3]; 
%% make struc
IR2D12ShiftOmitCueRewTuningStruc.Z1=cumZ1;
IR2D12ShiftOmitCueRewTuningStruc.Z2=cumZ2;
IR2D12ShiftOmitCueRewTuningStruc.Z3=cumZ3;
IR2D12ShiftOmitCueRewTuningStruc.COM1=cumCOMbin1;
IR2D12ShiftOmitCueRewTuningStruc.COM2=cumCOMbin2;
IR2D12ShiftOmitCueRewTuningStruc.COM3=cumCOMbin3;
IR2D12ShiftOmitCueRewTuningStruc.P1=cumP1;
IR2D12ShiftOmitCueRewTuningStruc.P2=cumP2;
IR2D12ShiftOmitCueRewTuningStruc.P3=cumP3;
IR2D12ShiftOmitCueRewTuningStruc.posRate1=cumPosRate1;
IR2D12ShiftOmitCueRewTuningStruc.posRate2=cumPosRate2;
IR2D12ShiftOmitCueRewTuningStruc.posRate3=cumPosRate3;
IR2D12ShiftOmitCueRewTuningStruc.cueEdge= '0';
IR2D12ShiftOmitCueRewTuningStruc.cueMid1= '50';
IR2D12ShiftOmitCueRewTuningStruc.cueMid2= '0';
IR2D12ShiftOmitCueRewTuningStruc.rew1= 'random';
%IR3ShiftOmitCueRewTuningStruc.rew2= '50';

%% plot cue shift omit:
posRate={};
posRate{1,1}= IR2D12ShiftOmitCueRewTuningStruc.posRate1;
posRate{1,2}= IR2D12ShiftOmitCueRewTuningStruc.posRate3;
[~, s1] = nanmax(posRate{1}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(posRate)
    posRate{i} = posRate{i}(s2, :);
end
figure;
maxRate = Inf;
CLims = [0, 0.5];
for i = 1:2
    subplot(1, 2, i);
    c = posRate{i};
    c(c> maxRate) = maxRate;
    imagesc(c);
    set (gca, 'CLim', CLims)
end
suptitle('nonNormRates');
colormap hot;



%% to plot shifted for Di15
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

tuning of lapType2 PCs
subplot(2,2,2);
colormap(jet);
imagesc(ShiftedposRates2);
xlabel('position');
title('LapType2');

and mean of each
subplot(2,2,3);
plot(mean(ShiftedposRates1,1));
hold on;
plot(mean(ShiftedposRates2,1),'g');
title('posRates1=b, posRates2=g');


% get the isPC from PCLappedSess1, this set of laps are over >15 
so we get at least 3 laps for second set of laps but the spatial tuning
%for these are not reliable

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


% remapping between Lap type1 vs type2
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

cumrAll =[]; cumpAll =[];
cumrAll =[cumrAll; rAll]; cumpAll = [cumpAll; pAll];

% ongoing
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


Z1= PCLappedSess1.Shuff.InfoPerSpkZ(pc);
P1= PCLappedSess1.Shuff.InfoPerSpkP(pc);
Z2= PCLappedSess2.Shuff.InfoPerSpkZ(pc);
P2= PCLappedSess2.Shuff.InfoPerSpkP(pc);

placeCellInd = {};
posRatesCellByLap = {};
for i = 1:size(pc,1)
placeCellInd{i} = find(PCLappedSess1.Shuff.isPC==1);    
posRatesCellByLap{i} = PCLappedSess1.ByLap.posRateByLap(placeCellInd{i},:, :);
posRatesCellByLap{i} = squeeze(posRatesCellByLap{i})';
end
% to plot: 
pcl = cueShiftStruc.PCLappedSessCell{1,1};
posRateLap = pcl.ByLap.posRateByLap;
a1 = greatSeg(9);
pr1 = posRateLap(find(goodSeg==a1),:,:);
pr1 = squeeze(pr1);
figure; imagesc(pr1);



