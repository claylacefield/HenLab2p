%wrapper to calculate place fields in still epochs, makes a cell array
%same way as BigPosAndSpkArray
StillAllPlaceInfo = {};

for II = 1:size (BigposAndSpkArray, 1)
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
            lapVec = calcLaps1(treadPos, T);
            
            placeAnalysis = computePlaceTransVectorSTILLLapCircShuffWithEdges4(transMat, treadPos, T, lapVec, 200);
            
            [~, m1] = max(placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :)');
            [~, m2] = sort(m1);
            
            posRatePC = placeAnalysis.posRates(placeAnalysis.Shuff.isPC > 0, :);
            
            numTransients = sum(transMat);
            numTransientsMovement = sum(transMat(~isnan(placeAnalysis.nanedPos), :));
            
            activeCellsPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 1);
            activeCellsNotPC = find(numTransients' >= 4 & placeAnalysis.Shuff.isPC == 0);
            isStill=zeros(length(posAndSpkStruct.pksgoodSeg), 1);
            isStill(activeCellsNotPC)=1;
            
            StillAllPlaceInfo{II, I} = [];
            StillAllPlaceInfo{II, I}.filename= posAndSpkStruct.filename;
            StillAllPlaceInfo{II, I}.PlaceAnalysis = placeAnalysis;
            StillAllPlaceInfo{II, I}.PosRatePC = posRatePC;
            StillAllPlaceInfo{II, I}.numTransients = numTransients;
            StillAllPlaceInfo{II, I}.numTransientsMovement = numTransientsMovement;
            StillAllPlaceInfo{II, I}.activeCellsPC = activeCellsPC;
            StillAllPlaceInfo{II, I}.activeCellsNotPC = activeCellsNotPC;
            StillAllPlaceInfo{II, I}.isStill = isStill;
            
            figure;
            %     subplot(1, 3, 1);
            %     imagesc(posRatePC(m2, :))
            subplot(1, 2, 1);
            imagesc(mean(placeAnalysis.posRates));
            subplot(1, 2, 2);
            plot(mean(placeAnalysis.posRates));
            title(posAndSpkStruct.filename)
        end
    end
end
