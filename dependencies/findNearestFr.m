function [frInds] = findNearestFr(evTimes, frTimes);

%% USAGE: [inds] = findNearest(evTimes, frTimes);
% Clay 2018
% Finally making a simple script to calculate nearest frame times to an
% array of event times.

for i = 1:length(evTimes)
    [val, ind] = min(abs(frTimes-evTimes(i)));
    frInds(i) = ind;
end