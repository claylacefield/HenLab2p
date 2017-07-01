function plotGoodSegTuning(C, goodSeg, treadBehStruc)

%C = segStruc.C;
%goodSeg = segStruc.goodSeg;

numbins = 40;


for i = 1:length(goodSeg)
    ca = C(goodSeg(i),:);
    [binYca, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins);
    binYca = interp1(0:1/numbins:1-1/numbins, binYca, 0:0.01:1-1/numbins);
    popCaPos(:,i) = binYca;
    popCaPosNorm(:,i) = binYca/max(binYca);
    
end

% figure; 
% imagesc(popCaPos');

[maxPos, maxInds] = max(popCaPos);

[val, sortInds] = sort(maxInds);

popCaPos = popCaPos(:,sortInds);
popCaPosNorm = popCaPosNorm(:,sortInds);

figure; 
subplot(3,1,1);
imagesc(popCaPos');
title('goodSeg ca vs. pos (not normalized)');

subplot(3,1,2);
imagesc(popCaPosNorm');
title('ca vs. pos (normalized)');

subplot(3,1,3);
plot(mean(popCaPos,2));
xlim([1 size(popCaPos,1)]);
title('mean goodSeg ca vs. position (not norm)');

