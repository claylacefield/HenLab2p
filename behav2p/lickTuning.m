function [lickPosRate, mrl, mra, pval] = lickTuning(treadBehStruc, toPlot);

%% USAGE: [lickPosRate, mrl, mra, pval] = lickTuning(treadBehStruc, toPlot);


lickTime = treadBehStruc.lickTime;
lickPos = treadBehStruc.lickPos;

frTimes = treadBehStruc.adjFrTimes(1:2:end);
pos = treadBehStruc.resampY(1:2:end);
pos = pos/max(pos);


inds = dsearchn(frTimes', lickTime');

lickSig = zeros(1,length(pos));
lickSig(inds) = 1;

% binned lick rates
lickPosRate = binByLocation(lickSig, pos, 100)*15;

% lick circular tuning
[mrl, mra] = clayMRL(lickPosRate,100,0);
[pval] = unitCircTuningClay(lickSig, pos, 100, 0);

if toPlot
    figure('Position', [100, 100, 800, 300]); 
    subplot(1,2,1);
    plot(lickPosRate);
    title(['Lick tuning for ' treadBehStruc.tdmlName]);
    xlabel('position');
    ylabel('licks/sec');
    subplot(1,2,2);
    compass(mrl*cos(mra), mrl*sin(mra));
    title(['p= ' num2str(pval)]);
end



