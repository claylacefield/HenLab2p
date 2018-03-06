function [newBinInd] = shuffleTreadmillPos(treadBehStruc, dsFactor, numBins)

% Clay 2018
% shuffle treadmill position, maintaining distribution
% of positions.
% NOTE: abandoned later in favor of Fabio's shuffling suggestion

% Based upon:
% www.mathworks.com/matlabcentral/answers/51897-generate-random-numbers-given-distribution-histogram



% extract position vector
pos = treadBehStruc.resampY;

% downsample
if dsFactor ~=1
    pos = pos(1:dsFactor:end);
end

% calc histogram of positions
[counts, edges, binInd] = histcounts(pos, numBins);

% make a prob distr function (pdf) based upon this
pdf = counts/sum(counts);

% make cumulative pdf
cumPdf = cumsum(pdf);

% choose new bin for all frames based upon session pos pdf
for i=1:length(pos)
r = randi(99)/100;
newBinInd(i) = find(cumPdf>r, 1, 'first');
end

