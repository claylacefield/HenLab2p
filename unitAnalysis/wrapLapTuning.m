function [caLapBin] = wrapLapTuning(C,treadBehStruc)


pos = treadBehStruc.resampY(1:2:end);
[lapFrInds] = findLaps(pos);

pos = pos/max(pos);

ca = C(160,:);
[caLapBin] = binCaPosByLap(ca, pos, lapFrInds);
