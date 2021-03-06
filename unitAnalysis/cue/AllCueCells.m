function [MidCueCellInd, EdgeCueCellInd, nonCueCellInd, refLapType, shiftLapType] =  AllCueCells(PCLappedSessCell,lapCueStruc,pksCellCell)

%% USAGE: AllCueCells(cueShiftStruc);
% This function finds the identity of putative Edge, middle/variable and
% non cue  cells based upon:

% 1.) position:  place fields overlaps with the range of the cue
% 2.) (for middle cue) omitCue responses: if responses go away when cue not
% present at that location

% Issues:
%
% 8/719
%   - still not clear on what range do we use for cue location (start and middle)
%       - based upon TDML cue location start and end
%   - need to change omit/ shift posRates manually based on the session
%       can we do this automatically? 
%   - is 2Xmean PF good enough for selecting sessions with only shift and
%   no omit?

% select the  PCLappedSess of the refLap type
lapTypeArr =lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:length(pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType);
[val, shiftLapType] = min(numLapType);

PCLappedSessCue = PCLappedSessCell{1,refLapType};
posRatesRef = PCLappedSessCell{refLapType}.posRates;
nCells = length(PCLappedSessCue.Shuff.isPC);
Allpc = find(PCLappedSessCue.Shuff.isPC==1);
posRatesAllpc = PCLappedSessCue.posRates(Allpc,:);
% extract posRates for omit/shift laps

posRatesShift= PCLappedSessCell{shiftLapType}.posRates;
posRatesOmit= PCLappedSessCell{end}.posRates;

%% select MidCuePc and EdgeCuePcs based on place field overlap with cue bins
% single field bins are in PCLappedSess.Shuff.PFInPos (PFInAllPos is for multiple fields)
[N, edges, bin] = histcounts(lapCueStruc.cuePos, lapCueStruc.numLapTypes);
cuePosStart = round(mean((lapCueStruc.cuePos((bin(1:end-1)==refLapType))-[50])/20));
cuePosEnd = round(mean((lapCueStruc.cuePosEnd((bin(1:end-1)==refLapType))+[100])/20));
%cuePosShift = round(mean((cueShiftStruc.lapCueStruc.cuePos(bin==shiftLapType))/20));
%cuePosEndShift = round(mean((cueShiftStruc.lapCueStruc.cuePosEnd(bin==shiftLapType))/20));


MidCueRegion = [cuePosStart, cuePosEnd];
n = 1:100;
inCuebin = n(n >= MidCueRegion(1) & n <= MidCueRegion(2));

pfOverlapsMidCue = []; overlapMidCue=[];
for i = 1:length(PCLappedSessCue.Shuff.PFInPos)
    if isempty(PCLappedSessCue.Shuff.PFInPos{i})
        pfOverlapsMidCue = [pfOverlapsMidCue; 0];
    else
        overlapMidCue = mean(ismember(PCLappedSessCue.Shuff.PFInPos{i}, inCuebin));
        pfOverlapsMidCue = [pfOverlapsMidCue; overlapMidCue > 0];
    end
end

EdgeCueRegion = [90, 10];
n = 1:100;
if EdgeCueRegion(1) < EdgeCueRegion(2)
    inCuebin = n(n >= EdgeCueRegion(1) & n <= EdgeCueRegion(2));
else
    inCuebin = n(n >= EdgeCueRegion(1) | n <= EdgeCueRegion(2));
end
pfOverlapsEdgeCue = []; overlapEdgeCue =[];
for i = 1:length(PCLappedSessCue.Shuff.PFInPos)
    if isempty(PCLappedSessCue.Shuff.PFInPos{i})
        pfOverlapsEdgeCue = [pfOverlapsEdgeCue; 0];
    else
        overlapEdgeCue = mean(ismember(PCLappedSessCue.Shuff.PFInPos{i}, inCuebin));
        pfOverlapsEdgeCue = [pfOverlapsEdgeCue; overlapEdgeCue > 0];
    end
end

MidCuePc = find(pfOverlapsMidCue == 1);
EdgeCuePc = find(pfOverlapsEdgeCue == 1); 
nonCuePc = find (PCLappedSessCue.Shuff.isPC==1 & pfOverlapsMidCue == 0 & pfOverlapsEdgeCue == 0);

%% select MidCuePc and EdgeCuePcs based on shift and omit responses
% find mean firing rate for cue area
try
for i=1:length(MidCuePc)
    midFieldRateRef(i) = mean(posRatesRef(MidCuePc(i),MidCueRegion),2);
    midFieldRateOmit(i) = mean(posRatesOmit(MidCuePc(i),MidCueRegion),2);
end
% quick and dirty for now: midCueCellInd = twice as big response to cue as omit
MidCueCellInd = MidCuePc(find((midFieldRateRef./midFieldRateOmit)>2));
catch
    warning ('no midCueCells');
    MidCueCellInd=[];
end
    
for i=1:length(EdgeCuePc)
    edgeFieldRateRef(i) = mean(posRatesRef(EdgeCuePc(i),EdgeCueRegion),2);
    edgemidFieldRateOmit(i) = mean(posRatesOmit(EdgeCuePc(i),EdgeCueRegion),2);
end

% quick and dirty for now: EdgeCueCellInd = stable responses to both ref
% and shift/omit
EdgeCueCellInd = EdgeCuePc(find(0.5<(edgeFieldRateRef./edgemidFieldRateOmit)<2));

nonCueCellInd = find(PCLappedSessCue.Shuff.isPC==1 & ~ismember((1:nCells)', EdgeCueCellInd) & ~ismember((1:nCells)', MidCueCellInd));





%% plot to check posRates that follow criteria 1 and 2
figure('Position',[200,50,400,1200]);
subplot(3,2,1);
[sortInd] = plotUnitsByTuning(posRatesRef(EdgeCueCellInd,:), 0, 1);
cl = caxis; title('EdgeCueInd');
subplot(3,2,2); 
colormap(jet); imagesc(posRatesOmit(EdgeCueCellInd(sortInd),:));  caxis(cl);
title('omit/shift laps');

% plot to check Mid
%maxVal = max(max(posRatesRef(midCellInd,:)));
subplot(3,2,3);
[sortInd] = plotUnitsByTuning(posRatesRef(MidCueCellInd,:), 0, 1);
cl = caxis;
title('MidCueInd');
subplot(3,2,4); 
colormap(jet); imagesc(posRatesOmit(MidCueCellInd(sortInd),:));  caxis(cl);
title('omit/shift laps');

subplot(3,2,5);
[sortInd] = plotUnitsByTuning(posRatesRef(nonCueCellInd,:), 0, 1);
cl = caxis;
title('nonCueInd');
subplot(3,2,6); 
colormap(jet); imagesc(posRatesOmit(nonCueCellInd(sortInd),:));  caxis(cl);
title('omit/shift laps');

%% plot to check posRates without criteria 2
% figure('Position',[200,50,400,1200]);
% subplot(3,2,1);
% [sortInd] = plotUnitsByTuning(posRatesRef(EdgeCuePc,:), 0, 1);
% cl = caxis; title('EdgeCuePc');
% subplot(3,2,2); 
% colormap(jet); imagesc(posRatesOmit(EdgeCuePc(sortInd),:));  caxis(cl);
% title('omit/shift laps');
% 
% % plot to check Mid
% %maxVal = max(max(posRatesRef(midCellInd,:)));
% subplot(3,2,3);
% [sortInd] = plotUnitsByTuning(posRatesRef(MidCuePc,:), 0, 1);
% cl = caxis;
% title('MidCuePc');
% subplot(3,2,4); 
% colormap(jet); imagesc(posRatesOmit(MidCuePc(sortInd),:));  caxis(cl);
% title('omit/shift laps');
% 
% subplot(3,2,5);
% [sortInd] = plotUnitsByTuning(posRatesRef(nonCuePc,:), 0, 1);
% cl = caxis;
% title('nonCuePc');
% subplot(3,2,6); 
% colormap(jet); imagesc(posRatesOmit(nonCuePc(sortInd),:));  caxis(cl);
% title('omit/shift laps');