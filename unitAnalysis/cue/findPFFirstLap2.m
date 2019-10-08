function [pfFirstLaps] = findPFFirstLap2(NoCueStruc)
numLapWin = 5;
minLapAct = 3;

pfFirstLaps = {};
posBins = linspace(0, 1, 101);
posBins(end) = 2;
for S = 1:length(NoCueStruc)
     PCLapped1{S}=NoCueStruc{S}.PCLappedSess;
    for I = 1:length(PCLapped1{S})
        pcs = find(PCLapped1{S}.Shuff.isPC == 1);
        pfFirstLaps{S} = [];
        pfFirstLaps{S}.nLaps = size(PCLapped1{S}.ByLap.OccuByLap, 1);
        pfFirstLaps{S}.firstLap = NaN(length(PCLapped1{S}.Shuff.isPC), 1);
%         pfFirstLaps{S}.onsetTime = NaN(length(PCLapped1{S}.Shuff.isPC), 1);
        pfFirstLaps{S}.actLaps = {};
%         T = CombTracesRun{S}.CombInfo.LFP.TFrames(~isnan(PCLapped1{S}.nanedPos));
%         treadPos = PCLapped1{S}.nanedPos(~isnan(PCLapped1{S}.nanedPos));
%         [~, treadBin] = histc(treadPos, posBins);
        for i = 1:length(length(PCLapped1{S}.Shuff.isPC))
            pfFirstLaps{S}.actLaps{i} = {};
        end
        n = 1:100;
        for ii = 1:length(pcs)
            i = pcs(ii);
            pfByL = squeeze(PCLapped1{S}.ByLap.posRateRawByLap(i, :, :))';
            inPF = PCLapped1{S}.Shuff.PFInPos{i};
            a = nanmean(pfByL(:, inPF), 2) - nanmean(pfByL(:, ~ismember(n, inPF)), 2);
            a = a > 0;
            pfFirstLaps{S}.actLaps{i} = a;
            b = movsum(a, numLapWin,'Endpoints','discard');
            fL = min(find(a(1:length(b)) > 0 & b >= minLapAct));
            if ~isempty(fL)
                pfFirstLaps{S}.firstLap(i) = fL;
%                 k = ismember(treadBin, inPF) & PCLapped1{S}.Shuff.whichLap == fL;
%                 pfFirstLaps{S}.onsetTime(i) = nanmedian(T(k));
            end            
        end
    end
end