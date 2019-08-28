
cumIRMeanposRatebyLapinPF1 = []; cumIRMeanposRatebyLapinPF2 = []; cumIRMeanposRatebyLapinPF3 = [];
cumIRMeanposRatebyLapoutPF1 = []; cumIRMeanposRatebyLapoutPF2 = []; cumIRMeanposRatebyLapoutPF3 = [];
cumIRPCwidth1 = []; cumIRPCwidth2 = []; cumIRPCwidth3 = [];
cumIRposRateCOMs1 =[]; cumIRposRateCOMs2 =[]; cumIRposRateCOMs3 =[];
cumInfoPerSpkZ1 = []; cumInfoPerSpkZ2 = []; cumInfoPerSpkZ3 = [];
cumIRInfoPerSpkP1 = []; cumIRInfoPerSpkP2 = [];  cumIRInfoPerSpkP3 = []; 
cumIRposRatesAll1= []; cumIRposRatesAll2= []; cumIRposRatesAll3= [];
%%
MeanposRatebyLapinPF1 = MeanposRatebyLapinPF{1,1}';
MeanposRatebyLapinPF2 = MeanposRatebyLapinPF{1,2}';ast
MeanposRatebyLapinPF3 = MeanposRatebyLapinPF{1,3}';
cumIRMeanposRatebyLapinPF1 = [cumIRMeanposRatebyLapinPF1; MeanposRatebyLapinPF1];
cumIRMeanposRatebyLapinPF2 = [cumIRMeanposRatebyLapinPF2; MeanposRatebyLapinPF2];
cumIRMeanposRatebyLapinPF3 = [cumIRMeanposRatebyLapinPF3; MeanposRatebyLapinPF3];


MeanposRatebyLapoutPF1 = MeanposRatebyLapoutPF{1,1}';
MeanposRatebyLapoutPF2 = MeanposRatebyLapoutPF{1,2}';
MeanposRatebyLapoutPF3 = MeanposRatebyLapoutPF{1,3}';
cumIRMeanposRatebyLapoutPF1 = [cumIRMeanposRatebyLapoutPF1; MeanposRatebyLapoutPF1];
cumIRMeanposRatebyLapoutPF2 = [cumIRMeanposRatebyLapoutPF2; MeanposRatebyLapoutPF2];
cumIRMeanposRatebyLapoutPF3 = [cumIRMeanposRatebyLapoutPF3; MeanposRatebyLapoutPF3];

PCwidth1 = PCwidth{1,1}';
PCwidth2 = PCwidth{1,2}';
PCwidth3 = PCwidth{1,3}';
cumIRPCwidth1 = [cumIRPCwidth1; PCwidth1]; 
cumIRPCwidth2 = [cumIRPCwidth2; PCwidth2]; 
cumIRPCwidth3 = [cumIRPCwidth3; PCwidth3]; 

posRateCOMs1 =  posRateCOMs{1,1}';
posRateCOMs2 =  posRateCOMs{1,2}';
posRateCOMs3 =  posRateCOMs{1,3}';
cumIRposRateCOMs1 =[cumIRposRateCOMs1;posRateCOMs1];
cumIRposRateCOMs2 =[cumIRposRateCOMs2;posRateCOMs2];
cumIRposRateCOMs3 =[cumIRposRateCOMs3;posRateCOMs3];


InfoPerSpkP1 = InfoPerSpkP{1,1}';
InfoPerSpkP2 = InfoPerSpkP{1,2}';
InfoPerSpkP3 = InfoPerSpkP{1,3}';
cumIRInfoPerSpkP1 = [cumIRInfoPerSpkP1; InfoPerSpkP1 ]; 
cumIRInfoPerSpkP2 = [cumIRInfoPerSpkP2; InfoPerSpkP2 ]; 
cumIRInfoPerSpkP3 = [cumIRInfoPerSpkP3; InfoPerSpkP3 ]; 
%%
cumInfoPerSpkZ1 = []; cumInfoPerSpkZ2 = []; cumInfoPerSpkZ3 = [];
InfoPerSpkZ1 = InfoPerSpkZ{1,1}'; Z1 = table2array(cell2table(InfoPerSpkZ1));
InfoPerSpkZ2 = InfoPerSpkZ{1,2}'; Z2 = table2array(cell2table(InfoPerSpkZ2));
InfoPerSpkZ3 = InfoPerSpkZ{1,3}'; Z3 = table2array(cell2table(InfoPerSpkZ3));
cumInfoPerSpkZ1 = [cumInfoPerSpkZ1;Z1]; 
cumInfoPerSpkZ2 = [cumInfoPerSpkZ2; Z2]; 
cumInfoPerSpkZ3 = [cumInfoPerSpkZ3; Z3]; 

%%

posRatesAll1 = [];
for i = 1:length(posRatesAll{1})
posRatesAll1 =  [posRatesAll1; posRatesAll{1}{i}];
end
posRatesAll2 = [];
for i = 1:length(posRatesAll{2})
posRatesAll2 =  [posRatesAll2; posRatesAll{2}{i}];
end 
posRatesAll3 = [];
for i = 1:length(posRatesAll{3})
posRatesAll3 =  [posRatesAll3; posRatesAll{3}{i}];
end 
cumIRposRatesAll1 =[cumIRposRatesAll1;posRatesAll1];
cumIRposRatesAll2 =[cumIRposRatesAll2;posRatesAll2];
cumIRposRatesAll3 =[cumIRposRatesAll3;posRatesAll3];




%% to get animal by animal number of PCs with COM within the cue vs reward zones
%%first plot
posRateCOMs1 =  posRateCOMs{1,1}';
posRateCOMs2 =  posRateCOMs{1,2}';
posRateCOMs3 =  posRateCOMs{1,3}';
Z1= InfoPerSpkZ{1,1}'; Z1 = table2array(cell2table(Z1));
Z2= InfoPerSpkZ{1,2}'; Z2 = table2array(cell2table(Z2));
Z3= InfoPerSpkZ{1,3}'; Z3 = table2array(cell2table(Z3));
sz = 60;
figure; scatter (posRateCOMs1, Z1, sz, 'filled', 'r');
figure; scatter (posRateCOMs2, Z2, sz, 'filled', 'r');
figure; scatter (posRateCOMs3, Z3, sz, 'filled', 'r');
%% to get animal by animal number of PCs with COM within the cue vs reward zones
bin = 0:99;

NumCOM1 = histc(posRateCOMs1,bin);
NumCOM2 = histc(posRateCOMs2,bin);
NumCOM3 = histc(posRateCOMs3,bin);

MidCue1 = sum(NumCOM1(45:55))/sum(NumCOM1);
MidCue2 = sum(NumCOM2(45:55))/sum(NumCOM2);
MidCue3 = sum(NumCOM3(45:55))/sum(NumCOM3);
MidCue = [MidCue1 MidCue2 MidCue3];

EdgeCue1 = sum([sum(NumCOM1(1:5)); sum(NumCOM1(95:99))])/sum(NumCOM1);
EdgeCue2 = sum([sum(NumCOM2(1:5)); sum(NumCOM2(95:99))])/sum(NumCOM2);
EdgeCue3 = sum([sum(NumCOM2(1:5)); sum(NumCOM2(95:99))])/sum(NumCOM2);
EdgeCue = [EdgeCue1 EdgeCue2 EdgeCue3];

Rew15001 = sum(NumCOM1(70:80))/sum(NumCOM1);
Rew15002 = sum(NumCOM2(70:80))/sum(NumCOM2);
Rew15003 = sum(NumCOM3(70:80))/sum(NumCOM3);
Rew1500 = [Rew15001 Rew15002 Rew15003];

Rew5001 = sum(NumCOM1(20:30))/sum(NumCOM1);
Rew5002 = sum(NumCOM2(20:30))/sum(NumCOM2);
Rew5003 = sum(NumCOM3(20:30))/sum(NumCOM3);
Rew500 = [Rew5001 Rew5002 Rew5003];

FracCOM=[];
FracCOM = [FracCOM [MidCue; EdgeCue; Rew1500; Rew500]];

%%
%remap struc by animals
 omitrewshiftcumPCMatchedAny = {}; omitrewshiftPCAnyCorrCoef121323 = []; omitrewshiftPCAnyShuffSig121323 = [];
 omitrewshiftcumPCMatchedAny1 = []; omitrewshiftcumPCMatchedAny2 = []; omitrewshiftcumPCMatchedAny3 = []; 


omitrewshiftcumPCMatchedAny1 = [omitrewshiftcumPCMatchedAny1; remapStruc.PCMatchedAny{1,1}];
omitrewshiftcumPCMatchedAny2 = [omitrewshiftcumPCMatchedAny2; remapStruc.PCMatchedAny{1,2}];
omitrewshiftcumPCMatchedAny3 = [omitrewshiftcumPCMatchedAny3; remapStruc.PCMatchedAny{1,3}];
omitrewshiftcumPCMatchedAny = {omitrewshiftcumPCMatchedAny1,omitrewshiftcumPCMatchedAny2,omitrewshiftcumPCMatchedAny3};

omitrewshiftPCAnyCorrCoef121323 = [omitrewshiftPCAnyCorrCoef121323; remapStruc.PCAnyCorrCoeff121323];
omitrewshiftPCAnyShuffSig121323 = [omitrewshiftPCAnyShuffSig121323; remapStruc.PCAnyShuffSig121323];

