function [shufPos] = shuffleTreadmillPos(treadBehStruc, dsFactor, numbins)

% extract position vector
pos = treadBehStruc.resampY;

% downsample
if dsFactor ~=1
    pos = pos(1:dsFactor:end);
end

% calc histogram of positions
[counts, edges, binInd] = histcounts(pos, numbins);

% make a prob distr function based upon this
pdf = counts/sum(counts);






