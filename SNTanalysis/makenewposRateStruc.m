function [posRateStruc] = makenewposRateStruc (sameCellCueShiftTuningStruc)

placeCellInd={};
cellsInAll=sameCellCueShiftTuningStruc.cellsInAll;
for i = 1:size(cellsInAll,2)
cueShiftStruc=sameCellCueShiftTuningStruc.multSessSegStruc(i).cueShiftStruc;
    refLapType=sameCellCueShiftTuningStruc.multSessSegStruc(i).refLapType;
PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};

  placeCellInd{i} = find(PCLappedSessCue.Shuff.isPC==1);

end

sameCellBool=[];
placeCellsOnlyFirstInd =[];
for i = 1:size(cellsInAll,1) %each cell in 1-2
    for j = 1:size(cellsInAll,2)    % for each session from that cell
        if find(placeCellInd{j}== cellsInAll(i,j)) % see if it's a place cell in sess1
            sameCellBool(i,j) = 1;
        else
            sameCellBool(i,j) = 0;
        end
    end
end
% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all

PC1only = find(sameCellBool(:, 1) == 1);
placeCellsOnlyFirstInd = cellsInAll(PC1only,:);
PC2only = find(sameCellBool(:, 2) == 1);
placeCellsOnlySecondInd = cellsInAll(PC2only,:);
PC3only = find(sameCellBool(:, 3) == 1);
placeCellsOnlyThirdInd = cellsInAll(PC3only,:);
%%
for i = 1:size(placeCellsOnlyFirstInd,1)
    for j = 1:size(placeCellsOnlyFirstInd,2)
        refLapType=sameCellCueShiftTuningStruc.multSessSegStruc(j).refLapType;

        posRatesInAll{i,j} = sameCellCueShiftTuningStruc.multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(placeCellsOnlyFirstInd(i,j),:);
    end
end
if exist('posRatesInAll')
    AllposRates1={};
    for i = 1:size(posRatesInAll, 2)
        AllposRates1{i} = [];
        for ii = 1:size(posRatesInAll, 1)
            AllposRates1{i} = [AllposRates1{i}; posRatesInAll{ii, i}];
        end
    end
posRateStruc.posRatesPCinFirst=AllposRates1;
end

for i = 1:size(placeCellsOnlySecondInd,1)
    for j = 1:size(placeCellsOnlySecondInd,2)
        refLapType=sameCellCueShiftTuningStruc.multSessSegStruc(j).refLapType;

        posRatesInAll2{i,j} = sameCellCueShiftTuningStruc.multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(placeCellsOnlySecondInd(i,j),:);
    end
end
if exist('posRatesInAll')
    AllposRates2={};
    for i = 1:size(posRatesInAll2, 2)
        AllposRates2{i} = [];
        for ii = 1:size(posRatesInAll2, 1)
            AllposRates2{i} = [AllposRates2{i}; posRatesInAll2{ii, i}];
        end
    end
posRateStruc.posRatesPCinSecond=AllposRates2;
end

for i = 1:size(placeCellsOnlyThirdInd,1)
    for j = 1:size(placeCellsOnlyThirdInd,2)
        refLapType=sameCellCueShiftTuningStruc.multSessSegStruc(j).refLapType;

        posRatesInAll3{i,j} = sameCellCueShiftTuningStruc.multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{1,refLapType}.posRates(placeCellsOnlyThirdInd(i,j),:);
    end
end
if exist('posRatesInAll')
    AllposRates3={};
    for i = 1:size(posRatesInAll3, 2)
        AllposRates3{i} = [];
        for ii = 1:size(posRatesInAll3, 1)
            AllposRates3{i} = [AllposRates3{i}; posRatesInAll3{ii, i}];
        end
    end
posRateStruc.posRatesPCinThird=AllposRates3;
end

save ('posRateStruc.mat','posRateStruc');
