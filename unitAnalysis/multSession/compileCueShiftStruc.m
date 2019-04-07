function [groupCueStruc] = compileCueShiftStruc(groupCueStruc, cueShiftStruc, lapTypes)


% run out of current cueShiftStruc folder
% sessType 1= omit, 2 = shift, 3 = both (sep, and add to shift and omit)

% ToDo:
% - put in what percent omit/shift (e.g. length 1/2+3)
% - think about integrating measures from sebnem posRatesCellbyLap.m

%lapTypes = {'normCue' 'omitRew' 'omitCue'}; 'shiftCue' 

n = length(groupCueStruc);
try groupCueStruc(1).filename
    n = n+1;
catch
end


groupCueStruc(n).filename = findLatestFilename('cueShiftStruc');
groupCueStruc(n).path = pwd;


% select reference lap type for place cell determination (one with most
% laps)
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:length(cueShiftStruc.pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType);

groupCueStruc(n).lapTypeArr = lapTypeArr;

groupCueStruc(n).percNormCue = length(find(lapTypeArr==refLapType))/length(lapTypeArr);

% select place cells
pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);
groupCueStruc(n).pc = pc;
% % Now compile PCs from all types
% pc=[];
% for i=1:numLapTypes
%     pcType = find(cueShiftStruc.PCLappedSessCell{i}.Shuff.isPC==1);
%     %pcType = find(cueShiftStruc.PCLappedSessCell{i}.InfoPerSpk>=3.5);
%     pc = [pc; pcType];
% end
% pc = sort(unique(pc));

groupCueStruc(n).infoPerSpkZ = cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.InfoPerSpkZ(pc);
groupCueStruc(n).infoPerSpkP = cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.InfoPerSpkP(pc);


% lapType specific variables
for i = 1:length(numLapType)
    lapTypeString = lapTypes{i};
    
    groupCueStruc(n).(lapTypeString).posRates = cueShiftStruc.PCLappedSessCell{i}.posRates(pc,:);
    groupCueStruc(n).(lapTypeString).posRateByLap = cueShiftStruc.PCLappedSessCell{i}.ByLap.posRateByLap(pc,:,:);
    groupCueStruc(n).(lapTypeString).pkPos = cueShiftStruc.PCLappedSessCell{i}.Shuff.PFPeakPos(pc);
end



    