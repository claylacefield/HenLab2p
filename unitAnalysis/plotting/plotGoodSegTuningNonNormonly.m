function [popCaPos, popCaPosNorm] = plotGoodSegTuningNonNormonly(C, goodSeg, treadBehStruc, dsFactor, forRate);

%C = segStruc.C;
%goodSeg = segStruc.goodSeg;

numbins = 100;

fps = 30/dsFactor;

tic;

for i = 1:length(goodSeg)
    ca = C(goodSeg(i),:);
    
    if forRate
       [pks] = clayCaTransients(ca, fps); 
       ca = zeros(length(ca),1);
       ca(pks) = 1;
    end
    
    
    [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, numbins, dsFactor);
    if forRate
        binYca = caPosVelStruc.binYcaSum;
    else
        binYca = caPosVelStruc.binYcaAvg;
    end
    
    %binYca = interp1(0:1/numbins:1-1/numbins, binYca, 0:0.01:1-1/numbins);
    popCaPos(:,i) = binYca;
    popCaPosNorm(:,i) = binYca/max(binYca);
    
end

binYvel = caPosVelStruc.binYvel;

% figure; 
% imagesc(popCaPos');

% Find rewZone
% NOTE: this currently only works with single rewZone (092617)
rewZone = treadBehStruc.rewZoneStartPos;
%[cts, cntrs] = hist(rewZone);
relRewPos = round(100*mean(rewZone)/max(treadBehStruc.y));


%% sort the units by time
[maxPos, maxInds] = max(popCaPos);
[val, sortInds] = sort(maxInds);

popCaPos = popCaPos(:,sortInds);
popCaPosNorm = popCaPosNorm(:,sortInds);


%% Plot
figure('pos', [50 50 400 800]); 
subplot(1,1,1);
imagesc(popCaPos');
hold on;
line([relRewPos relRewPos], [0 size(popCaPos,2)], 'Color','r');
title('goodSeg ca vs. pos (not normalized)');

% subplot(4,1,2);
% imagesc(popCaPosNorm');
% hold on;
% line([relRewPos relRewPos], [0 size(popCaPos,2)], 'Color','r');
% title('ca vs. pos (normalized)');
% 
% subplot(4,1,3);
% plot(mean(popCaPos,2));
% xlim([1 size(popCaPos,1)]);
% %ylim([min(mean(popCaPos,2)-0.001) max(mean(popCaPos,2)+0.001)]);
% hold on;
% line([relRewPos relRewPos], [min(mean(popCaPos,2)-0.01) max(mean(popCaPos,2)+0.01)], 'Color','r');
% title('mean goodSeg ca vs. position (not norm)');
% 
% subplot(4,1,4);
% plot(binYvel);
% xlim([1 length(binYvel)]);
% hold on;
% line([relRewPos relRewPos], [0 1], 'Color','r');
% title('vel');
% 
% toc;
% 
reordC = C(goodSeg(sortInds),:);
resampY = treadBehStruc.resampY;
figure; hold on;
%y = decimate(resampY,2);
y = resampY(1:2:end);
y = y/max(y);
plot((y+1)/20);
for i = 1:length(goodSeg)
    plot(reordC(i,:)-i/15);
end
title('goodSegs sorted by tuning pos (abs pos at top)');

for i=1:size(reordC,1)
    reordC2(i,:)=reordC(i,:)/max(reordC(i,:));
end
figure; %colormap(jet); 
imagesc(reordC2);
title('units ordered by tuning');