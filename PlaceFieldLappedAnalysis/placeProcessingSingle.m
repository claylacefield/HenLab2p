transMat = zeros(size(Cds'));

for i = 1:length(pksCell)
    pks = pksCell{i};
    if ~isempty(pks)
        transMat(pks, i) = 1;
    end
end

numTransients = sum(transMat);

T = treadBehStruc.adjFrTimes(1:2:end);
treadPos = treadBehStruc.resampY(1:2:end);
treadPos = treadPos/max(treadPos);

placeAnalysis = computePlaceCellsLappedWithEdges2(transMat, treadPos, T, 1000);

[~, m1] = max(placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :)');
[~, m2] = sort(m1);
posRatePC = placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :);
figure; imagesc(posRatePC(m2, :))

numTransients = sum(transMat);
numTransientsMovement = sum(transMat(~isnan(placeAnalysis.nanedPos), :));

activeCellsPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 1);
activeCellsNotPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 0);