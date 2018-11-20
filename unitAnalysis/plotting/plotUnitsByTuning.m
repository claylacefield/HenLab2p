function [sortInd] = plotUnitsByTuning(posRates, toNorm, toPlotNull)


% try
% load(findLatestFilename('treadBehStruc'));
% catch
%     treadBehStruc = procHen2pBehav('auto');
% end
% 
% load(findLatestFilename('segDict'));
% 
% load(findLatestFilename('goodSeg'));
% 
% 
% [unitTuningStruc] = wrapTuningNewClay(pksCell(goodSeg), 15, 1, 0);


if toPlotNull==0
notNullRows = find(sum(posRates,2)~=0);
posRates2 = posRates(notNullRows,:);
else
    posRates2 = posRates;
end

[maxVal, maxInd] = max(posRates2');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;
posRates2 = posRates2(sortInd,:);

if toNorm
    for i = 1:size(posRates,1)
        posRates2(i,:) = posRates2(i,:)/max(posRates2(i,:));
    end
end

figure;
%subplot(2,3,1);
colormap(jet);
imagesc(posRates2);
xlabel('position');

