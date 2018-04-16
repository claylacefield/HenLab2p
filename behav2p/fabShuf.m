function [shufBinCaAvg] = fabShuf(ca, pos, numBins, toPlot);

%% USAGE: [shufBinCaAvg] = fabShuf(ca, pos, numBins, toPlot);
% Treadmill position shuffling based upon Fabio's suggestion
% on 2/224/18
% Reverses position vector and then shifts by random amount.
% Inputs:
% ca = vector of calcium signal, or spikes
% pos = position vector (resampled to frames and downsampled)
% numBins = number of bins in lap

% figure;
% hold on;
% tic;
% for j = 1:100
%     
%     [newBinInd] = shuffleTreadmillPos(treadBehStruc, dsFactor, numBins);
%     
%     for i = 1:numBins
%         spkBin(i) = mean(spks(newBinInd==i));
%     end
%     
%     plot(spkBin);
%     
% end
% toc;
% plot(caPosVelStruc.binYcaAvg);

%% 

ca = ca/max(ca);

tic;
for j = 1:1000
pos2 = pos(end:-1:1);  % reverse position vector
pos2 = circshift(pos2, randi(1000), 2); % shift by random amount (within about a minute)

shufBinCaAvg(:,j) = binByLocation(ca, pos2, numBins);  % bin ca based upon shuffled pos

end
toc;

if toPlot
figure;
hold on;
plotMeanSEM(shufBinCaAvg, 'g');
plot(binByLocation(ca, pos, numBins), 'b', 'LineWidth', 2);
%plot(mean(shufBinCaAvg,2), 'g', 'LineWidth', 2);
end
