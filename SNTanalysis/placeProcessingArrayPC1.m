%wrapper to calculate place fields in moving epochs, makes a cell array
%same way as BigPosAndSpkArray
MoveAllPlaceInfo = {};
for II = 1:size(BigposAndSpkArray, 1)
    for I= 1:size(BigposAndSpkArray, 2)
        if ~isempty(BigposAndSpkArray{II, I})
            posAndSpkStruct = BigposAndSpkArray{II, I};
            transMat = zeros(size(posAndSpkStruct.C'));
            
            
            for i = 1:length(posAndSpkStruct.pksgoodSeg)
                pks = posAndSpkStruct.pksgoodSeg{i};
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
            
            MoveAllPlaceInfo{II, I} = [];
            MoveAllPlaceInfo{II, I}.filename= posAndSpkStruct.filename;
            MoveAllPlaceInfo{II, I}.PlaceAnalysis = placeAnalysis;
            MoveAllPlaceInfo{II, I}.PosRatePC = posRatePC;
            MoveAllPlaceInfo{II, I}.numTransients = numTransients;
            MoveAllPlaceInfo{II, I}.numTransientsMovement = numTransientsMovement;
            MoveAllPlaceInfo{II, I}.activeCellsPC = activeCellsPC;
            MoveAllPlaceInfo{II, I}.activeCellsNotPC = activeCellsNotPC;
            
            
            
            
            figure;
            subplot(1, 3, 1);
            imagesc(posRatePC(m2, :))
            subplot(1, 3, 2);
            imagesc(mean(placeAnalysis.posRates));
            subplot(1, 3, 3);
            plot(mean(placeAnalysis.posRates));
            title(posAndSpkStruct.filename)
        end
    end
end