function [pfFirstLaps] = findPFFirstLapClay(cueShiftStruc)
numLapWin = 5;
minLapAct = 3;

refLapType = findRefLapType(cueShiftStruc);
PCLappedSess = cueShiftStruc.PCLappedSessCell{refLapType};

pfFirstLaps = {};
posBins = linspace(0, 1, 101);
posBins(end) = 2;

pcs = find(PCLappedSess.Shuff.isPC == 1);
%pfFirstLaps{S} = [];
pfFirstLaps.nLaps = size(PCLappedSess.ByLap.OccuByLap, 1);
pfFirstLaps.firstLap = NaN(length(PCLappedSess.Shuff.isPC), 1);
%         pfFirstLaps{S}.onsetTime = NaN(length(PCLapped1{S}.Shuff.isPC), 1);
pfFirstLaps.actLaps = {};
%         T = CombTracesRun{S}.CombInfo.LFP.TFrames(~isnan(PCLapped1{S}.nanedPos));
%         treadPos = PCLapped1{S}.nanedPos(~isnan(PCLapped1{S}.nanedPos));
%         [~, treadBin] = histc(treadPos, posBins);
for i = 1:length(length(PCLappedSess.Shuff.isPC))
    pfFirstLaps.actLaps{i} = {};
end
n = 1:100;
for ii = 1:length(pcs)
    i = pcs(ii);
    pfByL = squeeze(PCLappedSess.ByLap.posRateRawByLap(i, :, :))';
    inPF = PCLappedSess.Shuff.PFInPos{i};
    a = nanmean(pfByL(:, inPF), 2) - nanmean(pfByL(:, ~ismember(n, inPF)), 2);
    a = a > 0;
    pfFirstLaps.actLaps{i} = a;
    b = movsum(a, numLapWin,'Endpoints','discard');
    fL = min(find(a(1:length(b)) > 0 & b >= minLapAct));
    if ~isempty(fL)
        pfFirstLaps.firstLap(i) = fL;
        %                 k = ismember(treadBin, inPF) & PCLapped1{S}.Shuff.whichLap == fL;
        %                 pfFirstLaps{S}.onsetTime(i) = nanmedian(T(k));
    end
end
