function fabShuf(ca, pos);

% Treadmill position shuffling based upon Fabio's suggestion
% on 2/224/18
% Reverses position vector and then shifts by random amount.

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
figure;
hold on;
tic;
for j = 1:100
pos2 = pos(end:-1:1);
pos2 = circshift(pos2, randi(10000), 2);

[binCaAvg] = binByLocation(ca, pos2, numBins);

plot(binCaAvg);
end
toc;
plot(caPosVelStruc.binYcaAvg);
