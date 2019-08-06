% d = dir('*tdml');
% treadBehStruc = {};
% for ii = 1:length(d)
%   treadBehStruc{ii} = readTDML_AG(pwd, d(ii).name);
% end
lickperRew = {};

for i = 1 : length(treadBehStruc) %iterate over sessions
%for i = 1
%set up variables
     d= treadBehStruc{i}.BeCell;
    timeVec = d(:, 1);
     posVec = d(:, 2);
     lickVec = d(:, 3);
    lapVec = calcLapsSeb1(posVec', timeVec');
    nLaps = max(lapVec);
    preRewZone = 200;
    treadSize = [0, max(posVec)];
    treadCenter = mean(treadSize);
    %dt=0.033
    % determine reward zone intervals and store as a boolean vector
    zoneRewardVec = zeros(length(timeVec), 1); %make one column of zeros in the size of timeVec
    zoneIntervals = [treadBehStruc{i}.rewZoneStartTime', (treadBehStruc{i}.rewZoneStopTime (1:end-1))']; %interval vector
%     posVec2 = posVec;
%     posVec2(zoneRewardVec == 0) = NaN;
%     figure; plot(posVec); hold on; plot(posVec2, 'r') plot to see if RZs
%     are registered
    %make the new zoneRewardVec with rew zone intervals equal to the row# of the RZ.
    for ii = 1:size(zoneIntervals, 1)  %go thru the rows of the reward zone interval vector
        kBool = timeVec >= zoneIntervals(ii, 1) & timeVec <= zoneIntervals(ii, 2); %kbool is the indexes of which intervals in timeVec are reward zones
        zoneRewardVec(kBool) = ii; %insert the row number or ii number into zoneRewardVec
    end
    
    %calculate number of licks within different zones
    rewardZoneLaps = [];
    zoneLapsRewardPos = [];
    zoneLapAllLicks = [];
    zoneLapRewLicks = [];
    zoneLapPreRewLicks = [];
    preRewardZone1=[];
    zoneLapHalfRewLicks = [];
    zoneLapOppoRewLicks = [];
    halfRewardZone1 = [];
    
    for ii = 1:nLaps
        boolLap = lapVec == ii; %if lapvec is 2 and 2 has a reward zone
        boolRewZ = zoneRewardVec > 0; %this comes from line 13
        lapAndRewZ = boolLap & boolRewZ'; %create boolean vector for reward zones by taking only if lapvec has reward zone
        if sum(lapAndRewZ) > 0   %if the lapvec has rewardzone sum will be >0
            rewardZoneLaps = [rewardZoneLaps; ii];  % store laps with reward zones as a column
            rewPosStart = min(posVec(lapAndRewZ));
            rewPosEnd = max(posVec(lapAndRewZ));
            rewPosCenter = mean([rewPosStart, rewPosEnd]);
            if rewPosCenter < treadCenter
                halfRewardZone = [0, treadCenter];
            else
                halfRewardZone = [treadCenter, max(posVec)];
            end            
            
            zoneLapsRewardPos = [zoneLapsRewardPos; rewPosStart, rewPosEnd];
            zoneLapAllLicks = [zoneLapAllLicks; sum(lickVec(boolLap))];
            zoneLapRewLicks = [zoneLapRewLicks; sum(lickVec(lapAndRewZ))];
            
            preRewardZone = [rewPosStart - preRewZone, rewPosStart];
            preRewBool = posVec >= preRewardZone(1) & posVec <= preRewardZone(2);
            zoneLapPreRewLicks = [zoneLapPreRewLicks; sum(lickVec(preRewBool & boolLap'))];
            preRewardZone1 = [preRewardZone1; preRewardZone];
            
            %halfRewardZone = [rewPosCenter - (rewHalfZoneSize/2), rewPosCenter + (rewHalfZoneSize/2)];
            halfRewBool =  posVec >= halfRewardZone(1) & posVec <= halfRewardZone(2);
           % halfRewBool = [halfRewBool(1:end); halfRewBool(end)];
           zoneLapHalfRewLicks = [zoneLapHalfRewLicks; sum(lickVec(halfRewBool & boolLap'))];
           halfRewardZone1 = [halfRewardZone1; halfRewardZone];
           zoneLapOppoRewLicks = [zoneLapOppoRewLicks; sum(lickVec(~halfRewBool & boolLap'))];
           
        end
    end

    lickperRew{i}.rewardZoneLaps = rewardZoneLaps; 
    lickperRew {i}.zoneLapsRewardPos  = zoneLapsRewardPos;
    lickperRew{i}. zoneLapAllLicks =  zoneLapAllLicks;
    lickperRew {i}.zoneLapRewLicks  = zoneLapRewLicks;
    lickperRew {i}.zoneLapPreRewLicks = zoneLapPreRewLicks;
    lickperRew{i}.preRewardZone1 = preRewardZone1;
    lickperRew{i}.zoneLapHalfRewLicks = zoneLapHalfRewLicks;
    lickperRew{i}.zoneLapOppoRewLicks = zoneLapOppoRewLicks;
    lickperRew{i}.halfRewardZone1 = halfRewardZone1;
    lickperRew{i}.tdmlname = treadBehStruc{i}.tdmlName;
    
end
 

save ('lickperRew.mat', 'lickperRew');

