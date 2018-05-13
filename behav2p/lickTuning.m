function [lickPosRate] = lickTuning(treadBehStruc, toPlot);

%% USAGE: [lickPosRate] = lickTuning(treadBehStruc, toPlot);


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
    figure('Position', [100, 100, 800, 300]); 
    subplot(1,2,1);
    plot(lickPosRate);
    title(['Lick tuning for ' treadBehStruc.tdmlName]);
    xlabel('position');
    ylabel('licks/sec');
    subplot(1,2,2);
    [mrl, mra] = clayMRL(lickPosRate,100,0);
    compass(mrl*cos(mra), mrl*sin(mra));
end

%% now circular tuning




