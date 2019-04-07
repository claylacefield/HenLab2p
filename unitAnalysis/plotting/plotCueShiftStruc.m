function plotCueShiftStruc(cueShiftStruc, refLapType)

% for use with wrapCueShiftTuning

numLapTypes = length(cueShiftStruc.pksCellCell);

% select place cells
pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);
% Now compile PCs from all types
% pc=[];
% for i=1:numLapTypes
%     pcType = find(cueShiftStruc.PCLappedSessCell{i}.Shuff.isPC==1);
%     %pcType = find(cueShiftStruc.PCLappedSessCell{i}.InfoPerSpk>=3.5);
%     pc = [pc; pcType];
% end
% pc = sort(unique(pc));

% find PCs and posRates for reference lap type
posRates = cueShiftStruc.PCLappedSessCell{refLapType}.posRates(pc,:);
[maxVal, maxInd] = max(posRates');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;
posRates = posRates(sortInd,:);
posRatesCell{refLapType} = posRates;

% now for all lap types with PCs and sorted based upon reference type 
for i = 1:numLapTypes
posRates = cueShiftStruc.PCLappedSessCell{i}.posRates(pc,:);
posRatesCell{i} = posRates(sortInd,:);
end

figure('Position', [0 0 1000 800]);

for i = 1:numLapTypes
subplot(2,2,i);
colormap(jet);
imagesc(posRatesCell{i});
%colorbar;
xlabel('position');
if i==1
    title(cueShiftStruc.filename(1:strfind(cueShiftStruc.filename,'cueShift')-2));
else
title(['LapType '  num2str(i)]);
end
end

% and mean of each
subplot(2,2,4); hold on;
for i = 1:numLapTypes
plot(mean(posRatesCell{i},1));
end
title('posRates1=b, posRates2=g');


