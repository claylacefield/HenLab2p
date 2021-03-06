function [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, numbins, dsFactor)

%% USAGE: [binYca, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins);

tCa = treadBehStruc.adjFrTimes;
y = treadBehStruc.y;
yTimes = treadBehStruc.yTimes;

% adjust ca frame times if downsampled
% if length(tCa)/length(ca) > 1.5
%    tCa = tCa(2:2:end); 
% end


ca = ca/max(ca); % normalize calcium

% calculate velocity over each frame (at 30hz)
% tCa = tCa(1:dsFactor:end);
% tCa = tCa(1:length(ca));
% resampY = interp1(yTimes, y, tCa);
% vel = abs(diff(resampY));
% vel(vel>30) = 0;
% vel = [0 vel];
vel = treadBehStruc.vel(1:dsFactor:end);
vel = fixVel(vel);

resampY = treadBehStruc.resampY(1:dsFactor:end);
yRel = resampY/max(resampY);

velRel = vel/max(vel);


%numbins = 20;
binSize = 1/numbins;
for i = 1:numbins
    %try
        loVal = (i-1)*binSize;
        hiVal = i*binSize;
        inds = find(yRel>=loVal & yRel<hiVal);
        caPosVelStruc.binYcaAvg(i) = mean(ca(inds)); % mean ca value in this spatial bin
        caPosVelStruc.binYcaSum(i) = sum(ca(inds));
        caPosVelStruc.numBinFr(i) = length(inds);  % num of frames acquired in this spatial bin
        caPosVelStruc.binYsem(i) = std(ca(inds))/sqrt(length(inds));
        caPosVelStruc.binYvel(i) = mean(velRel(inds));
        
        inds = find(velRel>=loVal & velRel<hiVal);
        caPosVelStruc.binVelCaAvg(i) = mean(ca(inds));
        caPosVelStruc.binVelCaSum(i) = sum(ca(inds));
        caPosVelStruc.numVelBinFr(i) = length(inds);
        caPosVelStruc.binVelSem(i) = std(ca(inds))/sqrt(length(inds));
%     catch
%         disp(['Prob with bin ' num2str(i)]);
%     end
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

