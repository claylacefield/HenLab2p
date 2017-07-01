function [binYca, binYvel, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins)

%% USAGE: [binYca, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins);

tCa = treadBehStruc.relFrTimes;
y = treadBehStruc.y;
yTime = treadBehStruc.yTime;

% adjust ca frame times if downsampled
if length(tCa)/length(ca) > 1.5
   tCa = tCa(2:2:end); 
end

ca = ca/max(ca); % normalize calcium

% calculate velocity over each frame (at 30hz)
resampY = interp1(yTime, y, tCa);
vel = abs(diff(resampY));
vel(vel>30) = 0;
vel = [0 vel];


yRel = resampY/max(resampY);

velRel = vel/max(vel);


%numbins = 20;
binSize = 1/numbins;
for i = 1:numbins
   loVal = (i-1)*binSize; 
   hiVal = i*binSize;
   inds = find(yRel>=loVal & yRel<hiVal);
   binYca(i) = mean(ca(inds));
   binYsem(i) = std(ca(inds))/sqrt(length(inds));
   binYvel(i) = mean(velRel(inds));
   
   inds = find(velRel>=loVal & velRel<hiVal);
   binVelCa(i) = mean(ca(inds));
   binVelSem(i) = std(ca(inds))/sqrt(length(inds));
    
end

% figure;
% subplot(1,2,1);
% errorbar(0:binSize:1-binSize, binYca, binYsem);
% xlim([0 1-binSize]);
% title('Ca relative to position');
% subplot(1,2,2);
% errorbar(0:binSize:1-binSize, binVelCa, binVelSem);
% title('Ca relative to velocity');
% xlim([0 1-binSize]);

