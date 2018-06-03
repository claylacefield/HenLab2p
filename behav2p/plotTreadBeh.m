function plotTreadBeh(treadBehStruc);

%% USAGE: plotTreadBeh(treadBehStruc);
% Plot position, velocity, and rewards for treadmill behavior.

vel = treadBehStruc.vel(1:2:end);
vel = fixVel(vel);

y = treadBehStruc.resampY(1:2:end);
y = y/max(y);
frTimes = treadBehStruc.adjFrTimes(1:2:end);

rewTimes = treadBehStruc.rewTime;

[rewInds] = findNearestFr(rewTimes, frTimes);

t = frTimes;

figure; 
plot(t, 5*y, 'LineWidth', 2); 
hold on;
plot(t, vel);
plot(t(rewInds), 5*y(rewInds), 'r*');

