function [bayesRec] = bayesReconstructionWithinSession(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells)
%function bayesReconstructionWithinSession(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells)

bayesRec = [];

if ~isempty(useCells)
    spikes = spikes(:, useCells);
end


tic;
binCenters = linspace(-pi, pi, 101);
binCenters = binCenters(1:(end - 1)) + mean(diff(binCenters))/2;

movEpochs = calcMovEpochs1(treadPos, T);
movK = inInterval(movEpochs, T);
% [lapVec, lapInts] = calcLaps1(treadPos, T);
lapVec(movK == 0) = NaN;
spikes(movK == 0) = NaN;
treadPos(movK == 0) = NaN;

treadPosCirc = treadPos*2*pi() - pi();
fRate = 1/mean(diff(T));



[transMatOut, TOut, treadPosCircOut] = binEveryNCircPos(binEveryNFrames, spikes, T, treadPosCirc');
[whichFramesInBin, lapVecOut, kBins] = binEveryNFramesFunc(binEveryNFrames, lapVec',  ~isnan(treadPosCirc)');
kBins = kBins > 0 & lapVecOut == round(lapVecOut) & ~isnan(treadPosCircOut');
% treadPosCircOut(~kBins) = NaN;
% transMatOut(~kBins, :) = NaN;
transMatOut = transMatOut(kBins, :);
TOut = TOut(kBins);
treadPosCircOut = treadPosCircOut(kBins);
lapVecOut = lapVecOut(kBins);
kW = ismember(whichFramesInBin, find(kBins));
[~, ~, w] = unique(whichFramesInBin(kW));
whichFramesInBin = NaN(length(kW), 1);
whichFramesInBin(kW) = w;

transMatOut = transMatOut/(binEveryNFrames/fRate);
bayesRec.treadPosCircOut = treadPosCircOut;
bayesRec.TOut = TOut;
bayesRec.lapVecOut = lapVecOut;
bayesRec.predPos = NaN(size(treadPosCircOut));
bayesRec.whichFold = NaN(size(treadPosCircOut));
bayesRec.meanBinFR = nanmean(transMatOut, 2);
bayesRec.BayesPost = NaN(length(treadPosCircOut), 100);

for i = 0:(kFolds - 1)
    treadPos2 = treadPos;
    compBins = find(mod(lapVecOut, kFolds) == i);
    treadPos2(mod(lapVec, kFolds) == i)  = NaN;
    treadPos2(ismember(whichFramesInBin, treadPos2)) = NaN;
    PCLapped = computePlaceTransVectorLapCircShuffWithEdges4(spikes, treadPos2, T, lapVec, 0);
    
    if ~isempty(compBins)
        bayesRec.whichFold(compBins) = i;
        [Pr, prMax] = placeBayesLogBuffered1(transMatOut(compBins, :), PCLapped.posRates, binEveryNFrames/fRate);
        bayesRec.BayesPost(compBins, :) = Pr;
        bayesRec.predPos(compBins) = binCenters(prMax);
    end
end
d1 = circ_dist(bayesRec.treadPosCircOut, bayesRec.predPos);
bayesRec.errorInCm = 100*d1/pi();
bayesRec.treadPosCircOut = (bayesRec.treadPosCircOut + pi)/(2*pi);
bayesRec.predPos = (bayesRec.predPos + pi)/(2*pi);

%         end
%     end
%     toc
% end