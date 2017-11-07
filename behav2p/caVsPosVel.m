function [binYca, binYvel, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins, dsFactor)

%% USAGE: [binYca, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins);

tCa = treadBehStruc.adjFrTimes; % times of 2p frames with respect to behavior TDML
y = treadBehStruc.y;    % each position measurement (when rotary encoder turns)
yTimes = treadBehStruc.yTimes;  % times (TDML) for each position meas

% adjust ca frame times if downsampled
% if length(tCa)/length(ca) > 1.5
%    tCa = tCa(2:2:end); 
% end

tCa = tCa(1:dsFactor:end);  % 2p frame times after downsampling video
tCa = tCa(1:length(ca));    % and trim (is this necessary?)

ca = ca/max(ca); % normalize calcium

% calculate velocity over each frame (at 30hz)
resampY = interp1(yTimes, y, tCa); % interpolate position at times of 2p frames
vel = abs(diff(resampY));
vel(vel>30) = 0;
vel = [0 vel];


yRel = resampY/max(resampY);  % relative position (relative to max rotary encoder reading)

velRel = vel/max(vel);


%numbins = 20;
binSize = 1/numbins;
for i = 1:numbins
    try
   loVal = (i-1)*binSize; 
   hiVal = i*binSize;
   inds = find(yRel>=loVal & yRel<hiVal);
   binYca(i) = mean(ca(inds));
   binYsem(i) = std(ca(inds))/sqrt(length(inds));
   binYvel(i) = mean(velRel(inds));
   
   inds = find(velRel>=loVal & velRel<hiVal);
   binVelCa(i) = mean(ca(inds));
   binVelSem(i) = std(ca(inds))/sqrt(length(inds));
    catch
        disp(['Prob with bin ' num2str(i)]);
    end
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

