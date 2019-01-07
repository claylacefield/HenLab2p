
cumMeanposRatebyLapinPF1 = []; cumMeanposRatebyLapinPF2 = []; cumMeanposRatebyLapinPF3 = [];
cumMeanposRatebyLapoutPF1 = []; cumMeanposRatebyLapoutPF2 = []; cumMeanposRatebyLapoutPF3 = [];
cumPCwidth1 = []; cumPCwidth2 = []; cumPCwidth3 = [];
cumposRateCOMs1 =[]; cumposRateCOMs2 =[]; cumposRateCOMs3 =[];
cumInfoPerSpkZ1mean = []; cumInfoPerSpkZ2mean = []; cumInfoPerSpkZ3mean = [];
cumInfoPerSpkP1 = []; cumInfoPerSpkP2 = [];  cumInfoPerSpkP3 = []; 

%%
MeanposRatebyLapinPF1 = MeanposRatebyLapinPF{1,1}';
MeanposRatebyLapinPF2 = MeanposRatebyLapinPF{1,2}';
MeanposRatebyLapinPF3 = MeanposRatebyLapinPF{1,3}';
cumMeanposRatebyLapinPF1 = [cumMeanposRatebyLapinPF1; MeanposRatebyLapinPF1];
cumMeanposRatebyLapinPF2 = [cumMeanposRatebyLapinPF2; MeanposRatebyLapinPF2];
cumMeanposRatebyLapinPF3 = [cumMeanposRatebyLapinPF3; MeanposRatebyLapinPF3];


MeanposRatebyLapoutPF1 = MeanposRatebyLapoutPF{1,1}';
MeanposRatebyLapoutPF2 = MeanposRatebyLapoutPF{1,2}';
MeanposRatebyLapoutPF3 = MeanposRatebyLapoutPF{1,3}';
cumMeanposRatebyLapoutPF1 = [cumMeanposRatebyLapoutPF1; MeanposRatebyLapoutPF1];
cumMeanposRatebyLapoutPF2 = [cumMeanposRatebyLapoutPF2; MeanposRatebyLapoutPF2];
cumMeanposRatebyLapoutPF3 = [cumMeanposRatebyLapoutPF3; MeanposRatebyLapoutPF3];


 
PCwidth1 = PCwidth{1,1}';
PCwidth2 = PCwidth{1,2}';
PCwidth3 = PCwidth{1,3}';
cumPCwidth1 = [cumPCwidth1; PCwidth1]; 
cumPCwidth2 = [cumPCwidth2; PCwidth2]; 
cumPCwidth3 = [cumPCwidth3; PCwidth3]; 


%%
cumposRateCOMs1 =[]; cumposRateCOMs2 =[]; cumposRateCOMs3 =[];
cumInfoPerSpkZ1mean = []; cumInfoPerSpkZ2mean = []; cumInfoPerSpkZ3mean = [];
cumInfoPerSpkZ1stdev = []; cumInfoPerSpkZ2mean = []; cumInfoPerSpkZ3mean = [];

cumIRposRatesAll1= []; cumIRposRatesAll2= []; cumIRposRatesAll3= [];
%%
posRateCOMs1 =  posRateCOMs{1,1}';
posRateCOMs2 =  posRateCOMs{1,2}';
posRateCOMs3 =  posRateCOMs{1,3}';
cumposRateCOMs1 =[cumposRateCOMs1;posRateCOMs1];
cumposRateCOMs2 =[cumposRateCOMs2;posRateCOMs2];
cumposRateCOMs3 =[cumposRateCOMs3;posRateCOMs3];

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

InfoPerSpkZ1 = InfoPerSpkZ{1,1}'; Z1 = table2array(cell2table(InfoPerSpkZ1));
InfoPerSpkZ2 = InfoPerSpkZ{1,2}'; Z2 = table2array(cell2table(InfoPerSpkZ2));
InfoPerSpkZ3 = InfoPerSpkZ{1,3}'; Z3 = table2array(cell2table(InfoPerSpkZ3));
cumInfoPerSpkZ1mean = mean([cumInfoPerSpkZ1mean;Z1]); 
cumInfoPerSpkZ2mean = mean([cumInfoPerSpkZ2mean; Z2]); 
cumInfoPerSpkZ3mean = mean([cumInfoPerSpkZ3mean; Z3 ]); 

%%



InfoPerSpkP1 = InfoPerSpkP{1,1}';
InfoPerSpkP2 = InfoPerSpkP{1,2}';
InfoPerSpkP3 = InfoPerSpkP{1,3}';
cumInfoPerSpkP1 = [cumInfoPerSpkP1; InfoPerSpkP1 ]; 
cumInfoPerSpkP2 = [cumInfoPerSpkP2; InfoPerSpkP2 ]; 
cumInfoPerSpkP3 = [cumInfoPerSpkP3; InfoPerSpkP3 ]; 

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
% CtxcumIRPCMatchedAny = {}; CtxcumIRPCAnyCorrCoef121323 = []; CtxcumIRPCanyShuffSig121323 = [];
% CtxcumIRPCMatchedAny1 = []; CtxcumIRPCMatchedAny2 = []; CtxcumIRPCMatchedAny3 = []; 

CtxcumIRPCMatchedAny1 = [CtxcumIRPCMatchedAny1; remapStruc.PCMatchedAny{1,1}];
CtxcumIRPCMatchedAny2 = [CtxcumIRPCMatchedAny2; remapStruc.PCMatchedAny{1,2}];
CtxcumIRPCMatchedAny3 = [CtxcumIRPCMatchedAny3; remapStruc.PCMatchedAny{1,3}];
CtxcumIRPCMatchedAny = {CtxcumIRPCMatchedAny1,CtxcumIRPCMatchedAny2,CtxcumIRPCMatchedAny3};

CtxcumIRPCAnyCorrCoef121323 = [CtxcumIRPCAnyCorrCoef121323; remapStruc.PCAnyCorrCoeff121323];
CtxcumIRPCanyShuffSig121323 = [CtxcumIRPCanyShuffSig121323; remapStruc.PCAnyShuffSig121323];

