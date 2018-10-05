

posRatesCellByLap = {};
for i = 1:size(placeCellAllOrigInd,1)
    for j = 1:length(multSessSegStruc)
        placeCellAllGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == placeCellAllOrigInd(i,j));
        posRatesCellByLap{i,j} = multSessSegStruc(j).PCLapSess.ByLap.posRateByLap(placeCellAllGoodSegInd(i,j),:, :);
        posRatesCellByLap{i,j} = squeeze(posRatesCellByLap{i,j})';
    end
end

posRatesCell={};
for i = 1:size(placeCellAllOrigInd,1)
    for j = 1:length(multSessSegStruc)
        placeCellAllGoodSegInd(i,j) = find(multSessSegStruc(j).goodSeg == placeCellAllOrigInd(i,j));
        posRatesCell{i,j} = multSessSegStruc(j).PCLapSess.posRates(placeCellAllGoodSegInd(i,j),:);
    end
end

posRateLapDiff = posRatesCellByLap{i, j} - repmat(posRatesCell{i, j}, [size(posRatesCellByLap{i, j}, 1), 1]);
posRateLapZ = posRateLapDiff./repmat(sqrt(posRatesCell{i, j}), [size(posRatesCellByLap{i, j}, 1), 1]);
% first reshape posRateLapZ and then (figure out) how to collect posRateLapZ from Sess1 into one array and so on
%to calculate nanvar(p) and plot probability dist
figure; hist(reshape(posRateLapZ, [], 1), 15) 
p = reshape(posRateLapZ, [], 1);
varience = nanvar(p);r
figure; histogram(reshape(posRateLapDiff, [], 1), 15, 'Normalization', 'probability')


%to get the within field and out of field activity
a.Shuff(1).PFInAllPos{8}
a.Shuff(1).PFInAllPos{8}{1}