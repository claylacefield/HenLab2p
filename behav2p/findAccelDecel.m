function [accelStruc] = findAccelDecel(treadBehStruc)

% Function to identify times of treadmill acceleration and deceleration
% Clay, May 2018


vel = treadBehStruc.vel;
vel = fixVel(vel);

vel = vel(1:2:end);

v2 = runmean(vel,15);
v2 = rumean(v2,30);

