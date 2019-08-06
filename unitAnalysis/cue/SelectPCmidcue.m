% select the  PCLappedSess of the refLap type
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
olfPos = round(mean((treadBehStruc.olfPos)/20));
tonePosEnd = round(mean((treadBehStruc.tonePosEnd)/20));
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

%% get the center of mass for all pcs 
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





%%
% plot cells individually by lap
%modify it to do this automaticaly from sorted pcs
for i = 15:17
    avgCueTrigSig2P(Allpc(i), 'olf');
    figure; imagesc(squeeze(PCLappedSess.ByLap.posRateByLap(Allpc(i), :, :))');
    colormap 'hot'
    title(['seg=' num2str(Allpc(i))]);
end
%%
spatSess.A=seg2P.A2p;
spatSess.d1=seg2P.d12p;
spatSess.d2=seg2P.d22p;
mask = reshape(spatSess.A(:, i), spatSess.d1, spatSess.d2);
figure; imagesc(mask)
mask = reshape(sum(spatSess.A, 2), spatSess.d1, spatSess.d2);
figure; imagesc(mask)
mask = reshape(sum(spatSess.A(:, Allpc(11:13)), 2), spatSess.d1, spatSess.d2);
figure; imagesc(mask)
%%
load(findLatestFilename('_seg2P_'));
load(findLatestFilename('_treadBehStruc_'));
pksCell=seg2P.pksCell;
[PCLappedSess] = wrapAndresPlaceFieldsClay(pksCell, 0);
save ('PCLappedSess.mat' , 'PCLappedSess');

%%
%PCLappedSess=sameCellTuningStruc.multSessSegStruc(2).PCLapSess;

figure; imagesc(squeeze(PCLappedSess.ByLap.posRateByLap(120, :, :))');
colormap 'hot'