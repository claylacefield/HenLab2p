function [vel] = fixVel(vel);

%% USAGE: [vel] = fixVel(vel);

% This function fixes problems with the velocity measurements at the belt
% transition (just makes equal to previous good value)

disp('Fixing vel for belt transitions, NaNs');


lastGoodVal = 0;
tic;
for i = 1:length(vel)
    try
        if vel(i)>nanstd(vel) || isnan(vel(i))
            vel(i) = lastGoodVel;
        else
            lastGoodVel = vel(i);
        end
    catch
        vel(i) = 0;
    end
end
toc;