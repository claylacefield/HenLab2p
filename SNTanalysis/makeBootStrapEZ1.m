function [percOut, errBars] = makeBootStrapEZ1(IN, percs, shuffN)
%function out = makeBootStrapEZ1(IN, percs, shuffN)

rng('shuffle');

M = NaN(shuffN, size(IN, 2));

for i = 1:shuffN
    M(i, :) = nanmean(IN(randi(size(IN, 1), [size(IN, 1), 1]), :), 1);
end

percOut = prctile(M, percs, 1);
    
errBars = abs(percOut - repmat(nanmean(M), [length(percs), 1]));