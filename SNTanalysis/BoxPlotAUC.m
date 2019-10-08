
AUCmidCueRef=[];
for i=1:length(posRate{1,1})
    sumMid= sum(posRate{1,1}(i,45:55));
    sumMid = sumMid*2;
    AUCmidCueRef=[AUCmidCueRef;sumMid];
end
AUCmidCueOmit=[];
for i=1:length(posRate{1,1})
    sumMidOmit= sum(posRate{1,3}(i,45:55));
    sumMidOmit = sumMidOmit*2;
    AUCmidCueOmit=[AUCmidCueOmit;sumMidOmit];
end


AUCCueShiftRef=[];
for i=1:length(posRate{1,1})
    sumMidS= sum(posRate{1,1}(i,20:30));
    sumMidS = sumMidS*2;
    AUCCueShiftRef=[AUCCueShiftRef;sumMidS];
end

AUCmidCueShift=[];
for i=1:length(posRate{1,1})
    sumMidShift= sum(posRate{1,2}(i,20:30));
    sumMidShift = sumMidShift*2;
    AUCmidCueShift=[AUCmidCueShift;sumMidShift];
end


% 
% x=[AUCmidCue,AUCmidCueOmit];
% figure; boxplot(x, 'Notch', 'on', 'Labels', {'AUCmidCue','AUCmidCueOmit'}, 'Whisker', 1)
% figure; violin (x);
%%
%Stats={};
PAll = [AUCmidCueRef; AUCmidCueOmit];
PGroup = [zeros(length(AUCmidCueRef), 1) + 1; zeros(length(AUCmidCueOmit), 1) + 2];

[p,tbl,stats] = kruskalwallis(PAll, PGroup);
cIAAomit = multcompare(stats);
Stats.cIAAomit=cIAAomit;