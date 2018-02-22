transMat = zeros(size(posAndSpkStruct.C'));

for i = 1:length(posAndSpkStruct.pksAll)
    pks = posAndSpkStruct.pksAll{i};
    if ~isempty(pks)
        transMat(pks, i) = 1;
    end
end

numTransients = sum(transMat);

T = posAndSpkStruct.treadBehStruct.adjFrTimes(1:2:end);
treadPos = posAndSpkStruct.treadBehStruct.resampY(1:2:end);
treadPos = treadPos/max(treadPos);

placeAnalysis = computePlaceCellsLappedWithEdges2(transMat, treadPos, T, 200);

[~, m1] = max(placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :)');
[~, m2] = sort(m1);
posRatePC = placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :);
figure; imagesc(posRatePC(m2, :))

numTransients = sum(transMat);
numTransientsMovement = sum(transMat(~isnan(placeAnalysis.nanedPos), :));

activeCellsPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 1);
activeCellsNotPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 0);