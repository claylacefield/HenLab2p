function plotUnitCaTreadBeh(ca, treadBehStruc, eventName);

%% USAGE: plotTreadBeh(treadBehStruc);
% Plot position, velocity, and rewards for treadmill behavior.

vel = treadBehStruc.vel(1:2:end);
vel = fixVel(vel);

y = treadBehStruc.resampY(1:2:end);
y = y/max(y);
frTimes = treadBehStruc.adjFrTimes(1:2:end);

rewTimes = treadBehStruc.rewTime;
[rewInds] = findNearestFr(rewTimes, frTimes);

try
lickTimes = treadBehStruc.lickTime;
[lickInds] = findNearestFr(lickTimes, frTimes);
catch
    lickInds = [];
end

% olf led tone tact
cueTimes = sort([treadBehStruc.olfTimeStart treadBehStruc.ledTimeStart treadBehStruc.toneTimeStart treadBehStruc.tactTimeStart]);
[cueInds] = findNearestFr(cueTimes, frTimes);


if isempty(strfind(eventName, 'rew'))
evTimes = treadBehStruc.([eventName 'TimeStart']);
evPos = treadBehStruc.([eventName 'PosStart']);
else % if for rewards, only look at rewards actually consumed/licked to
    rewZoneStartTimes = treadBehStruc.rewZoneStartTime;
    rewZoneEndTimes = treadBehStruc.rewZoneStopTime;
    rewTimes = treadBehStruc.rewTime;
    evTimes = rewTimes;
%     evTimes = []; evPos = []; goodLaps = [];
%     for i=1:length(rewZoneStartTimes)
%         try
%         if length(find(rewTimes>=rewZoneStartTimes(i) & rewTimes<=rewZoneEndTimes(i)))>2
%             evTimes = [evTimes rewZoneStartTimes(i)];
%             evPos = [evPos treadBehStruc.rewZoneStartPos(i)];
%             goodLaps = [goodLaps i];
%         end
%         catch
%         end
%     end
    
%     evTimes = treadBehStruc.rewZoneStartTime; %rewTime;
%     evPos = treadBehStruc.rewZoneStartPos; %rewPos;
end

%evTimes = treadBehStruc.([eventName 'TimeStart']);
[evInds] = findNearestFr(evTimes, frTimes);

t = frTimes;

figure('Position', [100,100,1200,400]); 
plot(t, 5*y, 'LineWidth', 1, 'Color', [0.5 0.5 0.5]); 
hold on;
%plot(t, vel);
%plot(t(lickInds), 5*y(lickInds), 'g+');
%plot(t(rewInds), 5*y(rewInds), 'r*');
%plot(t(cueInds), 5*y(cueInds), 'k*');
%ylabel('vel (cm/sec)');
xlabel('sec');
title(treadBehStruc.tdmlName);
%legend('pos','licks', 'rew', 'cue');

adjCa = ca-min(ca); 
adjCa = adjCa/max(adjCa);
plot(frTimes, runmean(adjCa*5, 5), 'g', 'LineWidth', 2);

for i=1:length(evInds)
line([t(evInds(i)) t(evInds(i))], [4 5], 'LineWidth', 1, 'Color', 'b');
end

% % now plot lap numbers also
%     [lapFrInds, lapEpochs] = findLaps(y);
%     numLaps = length(lapFrInds);
%     for i=1:numLaps
%         try
%         text(frTimes(lapEpochs(i,2)), 5*max(y), num2str(i)); %'Parent', gca, 
%         catch
%             disp('prob printing lap numbers');
%         end
%     end
