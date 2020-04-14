function [optoLocNormRates, optoLocOptoRates, optoLocPcInd] = cueOptoInhibPlace(cueShiftStruc, epoch, toPlot);


% Clay 2020 (from cueShiftInhibPlace)
% Look at effect of shifted cue on place cells normally at that location
% 1. find cells with PF in location to which cue is shifted
% 2. look at mean rate in normal vs. shift laps

% epoch = (e.g.) [30 45];

refLapType = findRefLapType(cueShiftStruc);
pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);

normPosRates = cueShiftStruc.PCLappedSessCell{refLapType}.posRates(pc,:);

% if refLapType==1
%     shiftLapType=2;
% else
%     shiftLapType=1;
% end

optoLapType=3;

optoPosRates = cueShiftStruc.PCLappedSessCell{optoLapType}.posRates(pc,:);

[maxVal, maxInd] = max(normPosRates');
% [newInd, oldInd] = sort(maxInd);
% sortInd = oldInd;

% look at peaks of 25:40

optoLocInd = find(maxInd>=epoch(1) & maxInd<=epoch(2)); % cells (pc) with PF around shift location

optoLocNormRates = normPosRates(optoLocInd,:);
optoLocOptoRates = optoPosRates(optoLocInd,:);

optoLocPcInd = pc(optoLocInd);

if toPlot
figure; 
plot(mean(optoLocNormRates,1)); 
hold on; 
plot(mean(optoLocOptoRates,1),'g');
plot(mean(optoLocOptoRates,1)-mean(optoLocNormRates,1),'r'); 
yl = ylim;
%line([25 25], yl);
end
