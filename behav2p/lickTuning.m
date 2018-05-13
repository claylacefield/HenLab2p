function [lickPosRate] = lickTuning(treadBehStruc, toPlot);

%% USAGE: [lickPosRate] = lickTuning(treadBehStruc);


lickTime = treadBehStruc.lickTime;
lickPos = treadBehStruc.lickPos;

frTimes = treadBehStruc.adjFrTimes(1:2:end);
pos = treadBehStruc.resampY(1:2:end);
pos = pos/max(pos);


inds = dsearchn(frTimes', lickTime');

lickSig = zeros(1,length(pos));
lickSig(inds) = 1;

lickPosRate = binByLocation(lickSig, pos, 100)*15;

if toPlot
    figure; plot(lickPosRate);
    title(['Lick tuning for ' treadBehStruc.tdmlName]);
    xlabel('position');
    ylabel('licks/sec');
end
