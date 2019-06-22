function popPosInfo(cueShiftStruc, goodSeg)


posRates = cueShiftStruc.PCLappedSessCell{1}.posRates;
if goodSeg==0
pc = find(cueShiftStruc.PCLappedSessCell{1}.Shuff.isPC==1);
else
    pc = goodSeg;
end
pcRates = posRates(pc,:);

[maxs, inds] = max(pcRates'); % find bin of peak firing rate for PCs

numBins = 10;
[counts, edges, binInd] = histcounts(inds, numBins);

figure; 
subplot(2,1,1);
bar(counts);
title('numUnits tuned to pos');

ips = cueShiftStruc.PCLappedSessCell{1}.InfoPerSpk(pc); % for goodSeg

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
posRates2 = cueShiftStruc.PCLappedSessCell{2}.posRates;
pcRates2 = posRates2(pc,:);
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
        
        if pkPos>40 && pkPos<60 % for potential middle-cue cells (PF in pos 40-60)
            j=j+1;
            cuePosRate(j) = mean(pcRatesSorted(i,40:60),2); % mean rate in cue trials
            omitPosRate(j) = mean(omitRatesSorted(i,40:60),2);  % and omit trials
            cuePkPos(j) = pkPos;
        end
        
    end
    pcRatesBlanked(i,:) = rates;
    pcOmitRatesBlanked(i,:) = rates2;
end

% cuePosRate = cuePosRate(cuePosRate~=0); % just elim zeros
% omitPosRate = omitPosRate(omitPosRate~=0);

figure; 
colormap(jet); 
subplot(2,2,1);
imagesc(pcRatesBlanked);
subplot(2,2,2);
imagesc(pcOmitRatesBlanked);
subplot(2,2,3);
plot(nanmean(pcRatesBlanked,1));
hold on;
plot(nanmean(pcOmitRatesBlanked,1),'r');
subplot(2,2,4);
%plot(cuePosRate,omitPosRate,'x');
plot(cuePkPos,cuePosRate-omitPosRate,'x');
hold on; line([0 0.2], [0 0.2]);

figure;
%bar([mean(mean(pcRates(:,40:60),2),1) mean(mean(pcRates2(:,40:60),2),1)]);
bar([nanmean(mean(pcRatesBlanked(:,40:60),2),1) nanmean(mean(pcOmitRatesBlanked(:,40:60),2),1)]);
