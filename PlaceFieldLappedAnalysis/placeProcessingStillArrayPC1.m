StillAllPlaceInfo = {};

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
    lapVec = calcLaps1(treadPos, T);
    
    placeAnalysis = computePlaceTransVectorSTILLLapCircShuffWithEdges4(transMat, treadPos, T, lapVec, 200);
        
    [~, m1] = max(placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :)');
    [~, m2] = sort(m1);
    
    posRatePC = placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :);
    
    numTransients = sum(transMat);
    numTransientsMovement = sum(transMat(~isnan(placeAnalysis.nanedPos), :));

    activeCellsPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 1);
    activeCellsNotPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 0);
    
    StillAllPlaceInfo{end + 1} = [];
    StillAllPlaceInfo{end}.filename= posAndSpkStruct.filename;
    StillAllPlaceInfo{end}.PlaceAnalysis = placeAnalysis;
    StillAllPlaceInfo{end}.PosRatePC = posRatePC;
    StillAllPlaceInfo{end}.numTransients = numTransients;
    StillAllPlaceInfo{end}.numTransientsMovement = numTransientsMovement;
    StillAllPlaceInfo{end}.activeCellsPC = activeCellsPC;
    StillAllPlaceInfo{end}.activeCellsNotPC = activeCellsNotPC;
    
    figure;
%     subplot(1, 3, 1);
%     imagesc(posRatePC(m2, :))
    subplot(1, 2, 1);
    imagesc(mean(placeAnalysis.posRates));
    subplot(1, 2, 2);
    plot(mean(placeAnalysis.posRates));
    title(posAndSpkStruct.filename)
end
