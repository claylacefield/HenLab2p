function [groupCueStruc] = compileCueShiftStruc(groupCueStruc, cueShiftStruc, sessType)

% add new cueShiftStruc from current folder to groupCueStruc (e.g. after
% plotting to check it)

% run out of current cueShiftStruc folder
% sessType 1= omit, 2 = shift, 3 = both (sep, and add to shift and omit)

% ToDo:
% - put in what percent omit/shift (e.g. length 1/2+3)
% - think about integrating measures from sebnem posRatesCellbyLap.m



% select reference lap type for place cell determination (one with most
% laps)
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:length(cueShiftStruc.pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType);

% select place cells
pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);
% % Now compile PCs from all types
% pc=[];
% for i=1:numLapTypes
%     pcType = find(cueShiftStruc.PCLappedSessCell{i}.Shuff.isPC==1);
%     %pcType = find(cueShiftStruc.PCLappedSessCell{i}.InfoPerSpk>=3.5);
%     pc = [pc; pcType];
% end
% pc = sort(unique(pc));



% lapType specific variables
for i = 1:numLapTypes
    posRates = cueShiftStruc.PCLappedSessCell{i}.posRates(pc,:);
    posRateByLap = cueShiftStruc.PCLappedSessCell{i}.ByLap.posRateByLap(pc,:,:);
    pkPos = cueShiftStruc.PCLappedSessCell{i}.Shuff.PFPeakPos(pc);
    
end

tempStruc.normCue.posRates = posRates;
tempStruc.posRateByLap = posRateByLap;
tempStruc.pkPos = pkPos;

% session-specific variables
filename = findLatestFilename('cueShiftStruc');
percNormCue = length(find(lapTypeArr==refLapType))/length(lapTypeArr);
%pc = pc; and lapTypeArr, path
infoPerSpkZ = cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.InfoPerSpkZ(pc);
infoPerSpkP = cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.InfoPerSpkP(pc);

% now put into correct session and lapType part of struc90acflrts
sessTypeString = 'cueOmitSess';
lapTypeString = 'normCueLaps';

% groupCueStruc.cueOmitSess(n).
    
    

    