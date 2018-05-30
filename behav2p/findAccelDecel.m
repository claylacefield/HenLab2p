function [accelPks, decelPks] = findAccelDecel(treadBehStruc, toPlot)

% Function to identify times of treadmill acceleration and deceleration
% Clay, May 2018


vel = treadBehStruc.vel;
vel = fixVel(vel); % fix velocity for lap boundaries, etc.

vel = vel(1:2:end); % downsample

v2 = runmean(vel,15); % smooth velocity 
v2 = runmean(v2,30);

dv = [0 diff(v2)]; % slope of smoothed velocity
sdv = std(dv); % standard dev

[vals, accelPks] = findpeaks(dv, 'MinPeakProminence', sdv*2, 'MinPeakDistance', 100);

[vals, decelPks] = findpeaks(-dv, 'MinPeakProminence', sdv*2, 'MinPeakDistance', 100);

if toPlot
t = 1:length(dv);
figure; plot(dv); 
hold on; 
plot(t(accelPks), dv(accelPks), 'g*');
plot(t(decelPks), dv(decelPks), 'r*');
end




