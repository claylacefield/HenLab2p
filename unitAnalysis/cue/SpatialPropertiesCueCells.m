% select the  PCLappedSess of the refLap type
load(findLatestFilename('2PcueShiftStruc'));
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:length(cueShiftStruc.pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType);

PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
Allpc = find(PCLappedSessCue.Shuff.isPC==1);
posRates = PCLappedSessCue.posRates(Allpc,:);
% select MidCuePc and EdgeCuePcs based on place field overlap with cue bins
% single field bins are in PCLappedSess.Shuff.PFInPos (PFInAllPos is for multiple fields)

load(findLatestFilename('treadBehStruc'));
olfPos = round(mean((treadBehStruc.olfPos([1:2, 4:6, 8:10, 12:14, 16:18, 20:22, 24:26]))/20));
tonePosEnd = round(mean((treadBehStruc.olfPosEnd([1:2, 4:6, 8:10, 12:14, 16:18, 20:22, 24:26])+[100])/20));
MidCueRegion = [olfPos, tonePosEnd];
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

MidCuePcposRates = PCLappedSessCue.posRates(MidCuePc,:); 
EdgeCuePcposRates = PCLappedSessCue.posRates(EdgeCuePc,:);
nonCuePcposRates = PCLappedSessCue.posRates(nonCuePc,:);

MidSpkZ = PCLappedSessCue.Shuff.InfoPerSpkZ(MidCuePc,:);
EdgeSpkZ = PCLappedSessCue.Shuff.InfoPerSpkZ(EdgeCuePc,:);
nonSpkZ = PCLappedSessCue.Shuff.InfoPerSpkZ(nonCuePc,:);

MidSpkP = PCLappedSessCue.Shuff.InfoPerSpkP(MidCuePc,:);
EdgeSpkP = PCLappedSessCue.Shuff.InfoPerSpkP(EdgeCuePc,:);
nonSpkP = PCLappedSessCue.Shuff.InfoPerSpkP(nonCuePc,:);

% consistency of place fields first and last 10 laps (only normal cue laps)
rMid = []; pMid = []; rEdge = []; pEdge = [];
rNon = []; pNon = [];

for i= 1:length(MidCuePc)
ByLapRate = squeeze(PCLappedSessCue.ByLap.posRateByLap(MidCuePc(i),:,:))';
EndRate = nanmean(ByLapRate (end-9:end,:),1);
BeginRate = nanmean(ByLapRate (1:10,:),1);
[r, p] = corrcoef(BeginRate', EndRate');
if isnan(r(1, 2))
r(1, 2) = 0;
end
rMid = [rMid; r(1, 2)];
pMid = [pMid; p(1, 2)];
end
for i= 1:length(EdgeCuePc)
ByLapRate = squeeze(PCLappedSessCue.ByLap.posRateByLap(EdgeCuePc(i),:,:))';
EndRate = nanmean(ByLapRate (end-9:end,:),1);
BeginRate = nanmean(ByLapRate (1:10,:),1);
[r, p] = corrcoef(BeginRate', EndRate');
if isnan(r(1, 2))
r(1, 2) = 0;
end
rEdge = [rEdge; r(1, 2)];
rEdge = [rEdge; p(1, 2)];
end
for i= 1:length(nonCuePc)
ByLapRate = squeeze(PCLappedSessCue.ByLap.posRateByLap(nonCuePc(i),:,:))';
EndRate = nanmean(ByLapRate (end-9:end,:),1);
BeginRate = nanmean(ByLapRate (1:10,:),1);
[r, p] = corrcoef(BeginRate', EndRate');
if isnan(r(1, 2))
r(1, 2) = 0;
end
rNon = [rNon; r(1, 2)];
rNon = [rNon; p(1, 2)];
end

% get the center of mass for all pcs 
MidCueCOMbin = []; EdgeCueCOMbin = []; nonCueCOMbin = []; 
circbin = 1:100;
circbin = ((circbin - 1)/99)*2*pi() - pi();

for i = 1:size (MidCuePc, 1)
    posRatesIn1 = MidCuePcposRates(i,:);
    c1 = circ_mean(circbin, posRatesIn1, 2);
    MidCueCOMbin(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
end
for i = 1:size (EdgeCuePc, 1)
    posRatesIn1 = EdgeCuePcposRates(i,:);
    c1 = circ_mean(circbin, posRatesIn1, 2);
    EdgeCueCOMbin(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
end
for i = 1:size (nonCuePc, 1)
    posRatesIn1 = nonCuePcposRates(i,:);
    c1 = circ_mean(circbin, posRatesIn1, 2);
    nonCueCOMbin(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
end
MidCueCOMbin = MidCueCOMbin';
EdgeCueCOMbin = EdgeCueCOMbin';
nonCueCOMbin = nonCueCOMbin';


sz=60;
figure; scatter(MidCueCOMbin, MidSpkZ, sz, 'filled', 'r');
hold on; scatter(EdgeCueCOMbin, EdgeSpkZ, sz, 'filled', 'g');
hold on; scatter(nonCueCOMbin, nonSpkZ, sz, 'filled', 'k');

% collect all variables in a table/struc
midCue=MidCueRegion;
edgeCue= EdgeCueRegion;
numSeg = length(PCLappedSessCue.InfoPerSpk);
NumNon = length(nonCueCOMbin); NumMid = length(MidCueCOMbin); NumEdge = length(EdgeCueCOMbin); 
RateNon = mean(mean(nonCuePcposRates,2)); RateMid = mean(mean(MidCuePcposRates,2)); RateEdge = mean(mean(EdgeCuePcposRates,2));
stdNon = std(mean(nonCuePcposRates,2)); stdMid = std(mean(MidCuePcposRates,2)); stdEdge = std(mean(EdgeCuePcposRates,2));

SpkZNon = nanmean(nonSpkZ); SpkZMid = nanmean(MidSpkZ); SpkZEdge = mean(EdgeSpkZ);
stdZNon = nanstd(nonSpkZ); stdZMid = nanstd(MidSpkZ); stdZEdge = nanstd(EdgeSpkZ);
CorrRNon = nanmean(rNon); CorrRMid = nanmean(rMid); CorrREdge = nanmean(rEdge);
stdRNon = nanstd(rNon); stdRMid = nanstd(rMid); stdREdge = nanstd(rEdge);

%PCAll =[]; TuningAll=[]; 
%CvsZStruc = {};
 
PCMice =[]; TuningMice =[];
PCMice = [midCue, edgeCue, numSeg, NumNon, NumMid, NumEdge, RateNon, stdNon, RateMid, stdMid, RateEdge, stdEdge ];
PCAll = [PCAll; PCMice];
TuningMice = [SpkZNon, stdZNon, SpkZMid, stdZMid, SpkZEdge, stdZEdge, CorrRNon, stdRNon, CorrRMid, stdRMid, CorrREdge, stdREdge]; 
TuningAll= [TuningAll;TuningMice];


CvsZStruc {16,1} = [MidCueCOMbin, MidSpkZ];
CvsZStruc {16,2} = MidCueRegion; 
CvsZStruc {16,3} = [EdgeCueCOMbin, EdgeSpkZ];
CvsZStruc {16,4} = EdgeCueRegion; 
CvsZStruc {16,5} = [nonCueCOMbin, nonSpkZ];