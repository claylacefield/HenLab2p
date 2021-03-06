function [posBinNumCells, pcRatesBlanked, pcOmitRatesBlanked] = cuePosInhib2P(cueShiftStruc);

lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:length(cueShiftStruc.pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType);
[val, shiftLapType] = min(numLapType);

PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
posRates = cueShiftStruc.PCLappedSessCell{refLapType}.posRates;
pc = find(PCLappedSessCue.Shuff.isPC==1);
pcRates = PCLappedSessCue.posRates(pc,:);


[maxs, inds] = max(pcRates'); % find bin of peak firing rate for PCs

numBins = 10;
[counts, edges, binInd] = histcounts(inds, numBins);

figure; 
subplot(2,1,1);
bar(counts);
title('numUnits tuned to pos');

posBinNumCells = counts;

ips = cueShiftStruc.PCLappedSessCell{refLapType}.InfoPerSpk(pc); % for goodSeg

% avg infoPerSpk/Sec for units with similar tuning
for i = 1:numBins
    unitInds = find(binInd==i);
    posInfo(i) = mean(ips(unitInds));
end

subplot(2,1,2); 
bar(posInfo);
title('pos mean info per spk');

%% look at cue inhibition

[sorted, sortInds] = sort(inds);
pcRatesSorted = pcRates(sortInds,:);
%figure; imagesc(pcRatesSorted);
posRatesOmit = cueShiftStruc.PCLappedSessCell{end}.posRates; % for Omit laps
pcRates2 = posRatesOmit(pc,:);
omitRatesSorted = pcRates2(sortInds,:);

% go through posRates, and blank out time around peak
j=0;
for i = 1:size(pcRatesSorted,1)
    rates = pcRatesSorted(i,:);
    rates2 = omitRatesSorted(i,:);
    pkPos = sorted(i); % pos bin of place field peak
    if pkPos <= 10
        rates(1:pkPos+10) = NaN;
        rates(100-10-pkPos:100) = NaN;
        rates2(1:pkPos+10) = NaN;
        rates2(100-10-pkPos:100) = NaN;
    elseif pkPos>90
        rates(pkPos-10:100) = NaN;
        rates(1:10-(100-pkPos)) = NaN;
        rates2(pkPos-10:100) = NaN;
        rates2(1:10-(100-pkPos)) = NaN;
    else
        rates(pkPos-10:pkPos+10) = NaN;
        rates2(pkPos-10:pkPos+10) = NaN;
        
        if pkPos>45 && pkPos<55 % for potential middle-cue cells (PF in pos 40-60)
            j=j+1;
            cuePosRate(j) = mean(pcRatesSorted(i,45:55),2); % mean rate in cue trials
            omitPosRate(j) = mean(omitRatesSorted(i,45:55),2);  % and omit trials
            cuePkPos(j) = pkPos;
        end
        
    end
    pcRatesBlanked(i,:) = rates;
    pcOmitRatesBlanked(i,:) = rates2;
end


figure; 
colormap(jet); 
subplot(2,2,1);
imagesc(pcRatesBlanked);
title('pcRatesBlanked');
subplot(2,2,2);
imagesc(pcOmitRatesBlanked);
title('pcOmitRatesBlanked');
subplot(2,2,3);
plot(nanmean(pcRatesBlanked,1));
hold on;
plot(nanmean(pcOmitRatesBlanked,1),'r');
legend('refLaps', 'omitLaps');
% subplot(2,2,4);
% %plot(cuePosRate,omitPosRate,'x');
% plot(cuePkPos,cuePosRate-omitPosRate,'x');
% %hold on; line([0 0.2], [0 0.2]);
% title('middle cell mean ref lap rate - omit');

figure;
%bar([mean(mean(pcRates(:,40:60),2),1) mean(mean(pcRates2(:,40:60),2),1)]);
bar([mean([nanmean(mean(pcRatesBlanked(:,11:44),2),1) nanmean(mean(pcRatesBlanked(:,56:89),2),1)]) mean([nanmean(mean(pcRatesBlanked(:,1:10),2),1) nanmean(mean(pcRatesBlanked(:,90:100),2),1)]) nanmean(mean(pcRatesBlanked(:,45:55),2),1) nanmean(mean(pcOmitRatesBlanked(:,45:55),2),1)]);
title('pkPos blanked non-cue, startCue, middleCue, omitCue');
%legend('startCueBlanked', 'middleCueBlanked', 'middleOmitBlanked');
ylabel('mean rate');
