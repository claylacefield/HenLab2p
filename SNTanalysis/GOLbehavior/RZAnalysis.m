

%generalize averaging of session halves, across all sessions in licksByPosLap:
RZAnalysisStruct = [];


tdmlName = [];
NumLaps = [];
NumLicks = [];
normLickingRZ = [];
normLickingRZFirstHalfAvg = [];
normLickingRZSecHalfAvg = [];
normLickingPre = [];
normLickingPreFirstHalfAvg = [];
normLickingPreSecHalfAvg = [];
normLickingOppo = [];
normLickingOppoFirstHalfAvg = [];
normLickingOppoSecHalfAvg = [];
normLickingTarg = [];
normLickingTargFirstHalfAvg = [];
normLickingTargSecHalfAvg = [];

for i = 1:length(lickperRew)
All = lickperRew{i}.zoneLapAllLicks;
Rew = lickperRew{i}.zoneLapRewLicks;
Pre = lickperRew{i}.zoneLapPreRewLicks;
Oppo = lickperRew{i}.zoneLapOppoRewLicks;
Targ = lickperRew{i}.zoneLapHalfRewLicks;
filename = lickperRew{i}.tdmlname;
% tdmlName = [tdmlName; filename];
tdmlName{i} = filename;

%1) #laps per animal
Laps = length(All);
NumLaps = [NumLaps; Laps];
% mean total licks per lap
AllLicks = mean(All);
NumLicks = [NumLicks; AllLicks];
% perc licks in reward zone, first half second half of sess
D = Rew./All;
D(~isfinite(D)) = 0;
normLickingRZ = [normLickingRZ; mean(D)];
firstHalfOfLaps = D(1:floor(size(D, 1)/2)); %indexing the first half of laps
secHalfOfLaps =  D((floor(size(D, 1)/2) + 1):end);
firstHalfOfLaps = mean (firstHalfOfLaps);
secHalfOfLaps = mean (secHalfOfLaps);
normLickingRZFirstHalfAvg = [normLickingRZFirstHalfAvg; firstHalfOfLaps];
normLickingRZSecHalfAvg = [normLickingRZSecHalfAvg; secHalfOfLaps];

%perc nonrewarded licks in pre zone, first and second half of sess
N = All - Rew; 
P = Pre./N;
P(~isfinite(P)) = 0;
normLickingPre = [normLickingPre; mean(P)];
firstHalfOfLaps = P(1:floor(size(P, 1)/2)); %indexing the first half of laps
secHalfOfLaps =  P((floor(size(P, 1)/2) + 1):end);
firstHalfOfLaps = mean (firstHalfOfLaps);
secHalfOfLaps = mean (secHalfOfLaps);
normLickingPreFirstHalfAvg = [normLickingPreFirstHalfAvg; firstHalfOfLaps];
normLickingPreSecHalfAvg = [normLickingPreSecHalfAvg; secHalfOfLaps];

%perc of all licks in oppo zone, first and second half of sess
%change All to N for non rewarded licks
O = sum(Oppo)/sum(All);
O(~isfinite(O))=0; %instead of isnan cathces both NaN and Inf
normLickingOppo = [normLickingOppo; O];
firstHalfOfLaps = sum(Oppo(1:floor(size(Oppo, 1)/2)))/sum(All(1:floor(size(All, 1)/2))); %indexing the first half of laps
secHalfOfLaps = sum(Oppo((floor(size(Oppo, 1)/2) + 1):end))/sum (All((floor(size(All, 1)/2) + 1):end));
normLickingOppoFirstHalfAvg = [normLickingOppoFirstHalfAvg; firstHalfOfLaps];
normLickingOppoSecHalfAvg = [normLickingOppoSecHalfAvg; secHalfOfLaps];

%perc nonrewarded licks in rewhalf zone, first and second half of sess

H = sum(Targ)/sum (All);
H(~isfinite(H))=0;
normLickingTarg = [normLickingTarg; H];
firstHalfOfLaps = sum(Targ(1:floor(size(Targ, 1)/2)))/sum(All(1:floor(size(All, 1)/2))); %indexing the first half of laps
secHalfOfLaps = sum(Targ((floor(size(Targ, 1)/2) + 1):end))/sum (All((floor(size(All, 1)/2) + 1):end));
normLickingTargFirstHalfAvg = [normLickingTargFirstHalfAvg; firstHalfOfLaps];
normLickingTargSecHalfAvg = [normLickingTargSecHalfAvg; secHalfOfLaps];


end

RZAnalysisStruct.Filename = tdmlName;
RZAnalysisStruct.NumLaps=NumLaps; 
RZAnalysisStruct.NumLicks=NumLicks;
RZAnalysisStruct.normLickingRZ=normLickingRZ;
RZAnalysisStruct.normLickingRZFirstHalfAvg=normLickingRZFirstHalfAvg;
RZAnalysisStruct.normLickingRZSecHalfAvg=normLickingRZSecHalfAvg;
RZAnalysisStruct.normLickingPre=normLickingPre;
RZAnalysisStruct.normLickingPreFirstHalfAvg=normLickingPreFirstHalfAvg;
RZAnalysisStruct.normLickingPreSecHalfAvg=normLickingPreSecHalfAvg;
RZAnalysisStruct.normLickingOppo=normLickingOppo;
RZAnalysisStruct.normLickingOppoFirstHalfAvg=normLickingOppoFirstHalfAvg;
RZAnalysisStruct.normLickingOppoSecHalfAvg=normLickingOppoSecHalfAvg;
RZAnalysisStruct.normLickingTarg=normLickingTarg;
RZAnalysisStruct.normLickingTargFirstHalfAvg=normLickingTargFirstHalfAvg;
RZAnalysisStruct.normLickingTargSecHalfAvg=normLickingTargSecHalfAvg;

T = NestedStruct2table(RZAnalysisStruct);
FileName='RZAnalysisStruct.xls';
%writetable(T, FileName, 'Delimiter', '\t');
writetable(T, FileName);

save ('RZAnalysisStruct.mat', 'RZAnalysisStruct');





