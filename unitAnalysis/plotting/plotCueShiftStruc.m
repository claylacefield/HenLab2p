function plotCueShiftStruc(cueShiftStruc, refLapType)

% for use with wrapCueShiftTuning

numLapTypes = length(cueShiftStruc.pksCellCell);

if refLapType==0
    lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
    lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
    for i=1:length(cueShiftStruc.pksCellCell)
        numLapType(i) = length(find(lapTypeArr==i));
    end
    [val, refLapType] = max(numLapType); % use ref lap from one with most laps
end

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
    try
posRates = cueShiftStruc.PCLappedSessCell{i}.posRates(pc,:);
posRatesCell{i} = posRates(sortInd,:);
    catch
    end
end

figure('Position', [0 0 1000 800]);

numCols = ceil((numLapTypes+1)/2);

for i = 1:numLapTypes
    try
        subplot(2,numCols,i);
        colormap(jet);
        imagesc(posRatesCell{i});
        %colorbar;
        xlabel('position');
        if i==1
            title(cueShiftStruc.filename(1:strfind(cueShiftStruc.filename,'cueShift')-2));
        else
            title(['LapType '  num2str(i)]);
        end
    catch
    end
end

% and mean of each
subplot(2,numCols,numLapTypes+1); hold on;
for i = 1:numLapTypes
    try
        plot(mean(posRatesCell{i},1));
    catch
    end
    numCell{i}=num2str(i);
end
%title('posRates1=b, posRates2=g');
legend(numCell);

figure;
load(findLatestFilename('segDict', 'goodSeg'),'C');
cpc = C(pc,:);
for i=1:length(pc); cpc2(i,:) = (cpc(i,:)-min(cpc(i,:)))/(max(cpc(i,:))-min(cpc(i,:))); end
imagesc(cpc2(sortInd,:));

