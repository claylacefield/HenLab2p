
cumDiMeanposRatebyLapinPF1 = []; cumDiMeanposRatebyLapinPF2 = []; cumDiMeanposRatebyLapinPF3 = [];
cumDiMeanposRatebyLapoutPF1 = []; cumDiMeanposRatebyLapoutPF2 = []; cumDiMeanposRatebyLapoutPF3 = [];
cumDiPCwidth1 = []; cumDiPCwidth2 = []; cumDiPCwidth3 = [];
cumDiposRateCOMs1 =[]; cumDiposRateCOMs2 =[]; cumDiposRateCOMs3 =[];
cumDiInfoPerSpkZ1 = []; cumDiInfoPerSpkZ2 = []; cumDiInfoPerSpkZ3 = [];
cumDiInfoPerSpkP1 = []; cumDiInfoPerSpkP2 = [];  cumDiInfoPerSpkP3 = []; 

%%
MeanposRatebyLapinPF1 = MeanposRatebyLapinPF{1,1}';
MeanposRatebyLapinPF2 = MeanposRatebyLapinPF{1,2}';
MeanposRatebyLapinPF3 = MeanposRatebyLapinPF{1,3}';
cumDiMeanposRatebyLapinPF1 = [cumDiMeanposRatebyLapinPF1; MeanposRatebyLapinPF1];
cumDiMeanposRatebyLapinPF2 = [cumDiMeanposRatebyLapinPF2; MeanposRatebyLapinPF2];
cumDiMeanposRatebyLapinPF3 = [cumDiMeanposRatebyLapinPF3; MeanposRatebyLapinPF3];


MeanposRatebyLapoutPF1 = MeanposRatebyLapoutPF{1,1}';
MeanposRatebyLapoutPF2 = MeanposRatebyLapoutPF{1,2}';
MeanposRatebyLapoutPF3 = MeanposRatebyLapoutPF{1,3}';
cumDiMeanposRatebyLapoutPF1 = [cumDiMeanposRatebyLapoutPF1; MeanposRatebyLapoutPF1];
cumDiMeanposRatebyLapoutPF2 = [cumDiMeanposRatebyLapoutPF2; MeanposRatebyLapoutPF2];
cumDiMeanposRatebyLapoutPF3 = [cumDiMeanposRatebyLapoutPF3; MeanposRatebyLapoutPF3];


 
PCwidth1 = PCwidth{1,1}';
PCwidth2 = PCwidth{1,2}';
PCwidth3 = PCwidth{1,3}';
cumDiPCwidth1 = [cumDiPCwidth1; PCwidth1]; 
cumDiPCwidth2 = [cumDiPCwidth2; PCwidth2]; 
cumDiPCwidth3 = [cumDiPCwidth3; PCwidth3]; 


posRateCOMs1 =  posRateCOMs{1,1}';
posRateCOMs2 =  posRateCOMs{1,2}';
posRateCOMs3 =  posRateCOMs{1,3}';
cumDiposRateCOMs1 =[cumDiposRateCOMs1;posRateCOMs1];
cumDiposRateCOMs2 =[cumDiposRateCOMs2;posRateCOMs2];
cumDiposRateCOMs3 =[cumDiposRateCOMs3;posRateCOMs3];

 
InfoPerSpkZ1 = InfoPerSpkZ{1,1}';
InfoPerSpkZ2 = InfoPerSpkZ{1,2}';
InfoPerSpkZ3 = InfoPerSpkZ{1,3}';
cumDiInfoPerSpkZ1 = [cumDiInfoPerSpkZ1; InfoPerSpkZ1 ]; 
cumDiInfoPerSpkZ2 = [cumDiInfoPerSpkZ2; InfoPerSpkZ2 ]; 
cumDiInfoPerSpkZ3 = [cumDiInfoPerSpkZ3; InfoPerSpkZ3 ]; 


InfoPerSpkP1 = InfoPerSpkP{1,1}';
InfoPerSpkP2 = InfoPerSpkP{1,2}';
InfoPerSpkP3 = InfoPerSpkP{1,3}';
cumDiInfoPerSpkP1 = [cumDiInfoPerSpkP1; InfoPerSpkP1 ]; 
cumDiInfoPerSpkP2 = [cumDiInfoPerSpkP2; InfoPerSpkP2 ]; 
cumDiInfoPerSpkP3 = [cumDiInfoPerSpkP3; InfoPerSpkP3 ]; 

%% to get animal by animal number of PCs with COM within the cue vs reward zones

posRateCOMs1 =  posRateCOMs{1,1}';
posRateCOMs2 =  posRateCOMs{1,2}';
posRateCOMs3 =  posRateCOMs{1,3}';

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

%DiFracCOM=[];
DiFracCOM = [DiFracCOM [MidCue; EdgeCue; Rew1500; Rew500]];

