
[~, Cmad] = nanmadZ(posAndSpkStruct.C');

transMat = zeros(size(Cmad));
A = [];
for i = 1:length(posAndSpkStruct.pksAll)
    if ~isempty(posAndSpkStruct.pksAll{i})
        m = Cmad(:, i);
        putTrans = suprathresh(Cmad(:, i), 2);
        pks = posAndSpkStruct.pksAll{i};
        [~, spikeCountInTrans] = inInterval(putTrans, pks);
        putTrans = putTrans(spikeCountInTrans > 0, :);
        spikeCountInTrans = spikeCountInTrans(spikeCountInTrans > 0);
        transFinal = [];
        for ii = 1:length(spikeCountInTrans)
           if spikeCountInTrans(ii) == 1
              transFinal = [transFinal; putTrans(ii, :)];
           else          
              pksInTrans = pks(pks >= putTrans(ii, 1) & pks <= putTrans(ii, 2));
                            
           end
        end
            
        
        A = [A; size(transFinal, 1), length(posAndSpkStruct.pksAll{i}), max(putTransHasSpike)];        
    end
end