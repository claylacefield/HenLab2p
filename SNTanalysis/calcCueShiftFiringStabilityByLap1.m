function out = calcCueShiftFiringStabilityByLap1(PCLappedSessCue, PCLappedSessOmit, whichCells)
%function out = calcCueShiftFiringStabilityByLap1(PCLappedSessCue, PCLappedSessOmit, whichCells (optional))


out = [];
if isempty(whichCells)
    whichCells = 1:size(PCLappedSessCue.posRates, 1);
end
if islogical(whichCells)
    whichCells = find(whichCells);
end
PCLappedSessCue.ByLap.posRateByLap(isnan(PCLappedSessCue.ByLap.posRateByLap)) = 0;
PCLappedSessOmit.ByLap.posRateByLap(isnan(PCLappedSessOmit.ByLap.posRateByLap)) = 0;

nLapsCue = size(PCLappedSessCue.ByLap.OccuByLap, 1);
nLapsOmit = size(PCLappedSessOmit.ByLap.OccuByLap, 1);
warning('off');
out.PVCorrCueCue = NaN(nLapsCue*(nLapsCue - 1)*0.5, 100);
for i = 1:100
    a = 1 - pdist(squeeze(PCLappedSessCue.ByLap.posRateByLap(whichCells, i, :))', 'correlation');
    if length(a) == size(out.PVCorrCueCue, 1)
        out.PVCorrCueCue(:, i) = a;
    end
end

out.PVCorrOmitOmit = NaN(nLapsOmit*(nLapsOmit - 1)*0.5, 100);
for i = 1:100
     a = 1 - pdist(squeeze(PCLappedSessOmit.ByLap.posRateByLap(whichCells, i, :))', 'correlation');
     if length(a) == size(out.PVCorrOmitOmit, 1)
         out.PVCorrOmitOmit(:, i) = a;
     end
end

out.PVCorrCueOmit = NaN(nLapsCue*nLapsOmit, 100);
for i = 1:100
    a = 1 - pdist2(squeeze(PCLappedSessCue.ByLap.posRateByLap(whichCells, i, :))', ...
        squeeze(PCLappedSessOmit.ByLap.posRateByLap(whichCells, i, :))', 'correlation');
    a = a(:);
    if length(a) == size(out.PVCorrCueOmit, 1)
        out.PVCorrCueOmit(:, i) = a;
    end
end

%%PerCell

out.PerCellCueCue = NaN(nLapsCue*(nLapsCue - 1)*0.5, length(whichCells));
for i = 1:length(whichCells)
    out.PerCellCueCue(:, i) = 1 - pdist(squeeze(PCLappedSessCue.ByLap.posRateByLap(whichCells(i), :, :))', 'correlation');
end

out.PerCellOmitOmit = NaN(nLapsOmit*(nLapsOmit - 1)*0.5, length(whichCells));
for i = 1:length(whichCells)
    out.PerCellOmitOmit(:, i) = 1 - pdist(squeeze(PCLappedSessOmit.ByLap.posRateByLap(whichCells(i), :, :))', 'correlation');
end

out.PerCellCueOmit = NaN(nLapsCue*nLapsOmit, length(whichCells));
for i = 1:length(whichCells)
    a = 1 - pdist2(squeeze(PCLappedSessCue.ByLap.posRateByLap(whichCells(i), :, :))', ...
        squeeze(PCLappedSessOmit.ByLap.posRateByLap(whichCells(i), :, :))', 'correlation');
    out.PerCellCueOmit(:, i) = a(:);
end

warning('on');