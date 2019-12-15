function plotTreadBeh(treadBehStruc);

%% USAGE: plotTreadBeh(treadBehStruc);
% Plot position, velocity, and rewards for treadmill behavior.

vel = treadBehStruc.vel(1:2:end);
vel = fixVel(vel);

y = treadBehStruc.resampY(1:2:end);
y = y/max(y);
frTimes = treadBehStruc.adjFrTimes(1:2:end);

rewTimes = treadBehStruc.rewTime;
try
[rewInds] = findNearestFr(rewTimes, frTimes);
catch
end

try
lickTimes = treadBehStruc.lickTime;
[lickInds] = findNearestFr(lickTimes, frTimes);
catch
    lickInds = [];
end

% olf led tone tact
cueTimes = sort([treadBehStruc.olfTimeStart treadBehStruc.ledTimeStart treadBehStruc.toneTimeStart treadBehStruc.tactTimeStart]);
[cueInds] = findNearestFr(cueTimes, frTimes);

t = frTimes;

figure; 
plot(t, 5*y, 'LineWidth', 2); 
hold on;
%plot(t, vel);
try
plot(t(lickInds), 5*y(lickInds), 'g+');
catch
end
try
plot(t(rewInds), 5*y(rewInds), 'r*');
catch
end
plot(t(cueInds), 5*y(cueInds), 'k*');
ylabel('vel (cm/sec)');
xlabel('sec');
title(treadBehStruc.tdmlName);
legend('pos','licks', 'rew', 'cue');

% now plot lap numbers also
    [lapFrInds, lapEpochs] = findLaps(y);
    numLaps = length(lapFrInds);
    for i=1:numLaps
        try
        text(frTimes(lapEpochs(i,2)), 5*max(y), num2str(i)); %'Parent', gca, 
        catch
            disp('prob printing lap numbers');
        end
    end
