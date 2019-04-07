function plotGroupCueStruc(groupCueStruc, lapTypes)


for i=1:length(lapTypes)
    if ~isempty(strfind(lapTypes{i},'norm'))
        refLapType = i;
    end
end

% compile data from mice/sessions
posRatesCell = cell(length(lapTypes),1);
for j=1:length(groupCueStruc)
    for i = 1:length(lapTypes)
        posRates = groupCueStruc(j).(lapTypes{i}).posRates;
        posRatesCell{i} = [posRatesCell{i}; posRates];
    end
end


% find PCs and posRates for reference lap type
posRates = posRatesCell{refLapType};
[maxVal, maxInd] = max(posRates');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;

% now for all lap types with PCs and sorted based upon reference type 
for i = 1:length(lapTypes)
    posRates = posRatesCell{i};
posRatesCell{i} = posRates(sortInd,:);
end

figure('Position', [0 0 1000 800]);

for i = 1:length(lapTypes)
subplot(2,2,i);
colormap(jet);
imagesc(posRatesCell{i});
%colorbar;
xlabel('position');
title(['LapType '  lapTypes{i}]);
end

% and mean of each
subplot(2,2,4); hold on;
for i = 1:length(lapTypes)
plot(mean(posRatesCell{i},1));
end
%title('posRates1=b, posRates2=r');
legend(lapTypes);

