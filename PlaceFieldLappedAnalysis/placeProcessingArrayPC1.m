
MoveAllPlaceInfo = {};
for I=1:length(BigposAndSpkArray)
    posAndSpkStruct = BigposAndSpkArray{I};
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
    
    numTransients = sum(transMat);
    numTransientsMovement = sum(transMat(~isnan(placeAnalysis.nanedPos), :));

    activeCellsPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 1);
    activeCellsNotPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 0);
    
    MoveAllPlaceInfo{end + 1} = [];
    MoveAllPlaceInfo{end}.filename= posAndSpkStruct.filename;
    MoveAllPlaceInfo{end}.PlaceAnalysis = placeAnalysis;
    MoveAllPlaceInfo{end}.PosRatePC = posRatePC;
    MoveAllPlaceInfo{end}.numTransients = numTransients;
    MoveAllPlaceInfo{end}.numTransientsMovement = numTransientsMovement;
    MoveAllPlaceInfo{end}.activeCellsPC = activeCellsPC;
    MoveAllPlaceInfo{end}.activeCellsNotPC = activeCellsNotPC;


    
    
    figure;
    subplot(1, 3, 1);
    imagesc(posRatePC(m2, :))
    subplot(1, 3, 2);
    imagesc(mean(placeAnalysis.posRates));
    subplot(1, 3, 3);
    plot(mean(placeAnalysis.posRates));
    title(posAndSpkStruct.filename)
end
