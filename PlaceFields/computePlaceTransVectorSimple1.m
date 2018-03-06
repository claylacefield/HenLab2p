function out = computePlaceTransVectorSimple1(activity, T, treadPos, shuffN)
%function out = computePlaceTransVectorSimple1(activity, sess, treadPos, shuffN)

% by Andres

% Output:
%   out = structure of output fields
%       .runTimes = start(1)/stop(2) times of running epochs
%       .nandPos = pos vector with NaNs when animal isn't running
%       .
%       .
%       .
% Inputs:
% activity = bool of spikes for each neuron for each time
% T = vector of frame times
% treadPos = vector of position, interpolated to frame times (and normalized)
% shuffN = ? (number of shuffles)

if size(activity, 1) > size(activity, 2)
    activity = activity';
end

minPFBins = 5;
RatePerc = 97.5;

trimRunStarts = 1;
trimRunEnds = 0;
minRunTime = 2;
minPFBins = 5;
RatePerc = 95;  %for each bin its the 99th precentile of the shuffled firing rates 

out = [];

% clay: normalize pos if necessary
if max(treadPos)>2
    treadPos = treadPos/max(treadPos);
end

pos = treadPos;

dT = median(diff(T));  % frame interval?

g = fspecial('Gaussian',[10 1], 1); % compute gaussian kernel
h1 = linspace(0, 1, 101);   % vector of spatial bins, from 0:1 (i.e. normalized)
h1(end) = 1.0001; % yeah I don't know why to do this

runTimes = calcMovEpochs1(treadPos, T); % start/stop times of running epochs >5cm/sec, >3sec long?
runTimes(:, 2) = runTimes(:, 2) + 0.00001; % do some modif/trimming of running epochs?
runTimes(:, 1) = runTimes(:, 1) + trimRunStarts;
runTimes(:, 2) = runTimes(:, 2) - trimRunEnds;
runTimes = runTimes(diff(runTimes, [], 2) > minRunTime, :);

kRun = inInterval(runTimes, T); % indices of times 
kRun = kRun ~= 0;

out.runTimes = runTimes;
pos(~kRun) = NaN;   % NaN pos vector at times when animal isn't running

out.nanedPos = pos;
%    activity(:, ~isnan(pos)) = NaN;
activity = activity(:, ~isnan(pos)); % get activity only at times when animal is running
pos = pos(~isnan(pos));

% occupancy
[occ1, whichPlace] = histc(pos, h1); % distribution of indices when animal is in a particular spatial bin
occ1 = occ1(1:(end - 1));
occ1 = occ1*dT; % now make this times, from indices

out.rawOccupancy = occ1;
rawSums = zeros(size(activity, 1), 100);

for i = 1:100   % for all neurons/segments
    k = whichPlace == i;
    if sum(k) > 0
        rawSums(:, i) = nansum(activity(:, k), 2);  % sum of spikes for each spatial bin?
    end
end
out.posSums = rawSums;
out.rawPosRates = rawSums./repmat(occ1, size(rawSums, 1), 1); % rates = sumSpks/pos / occupancy for that bin

Q = [occ1', rawSums'];

Qs = convolve2(Q, g, 'wrap')';  % convolve spikes and rates with gaussian

out.Occupancy = Qs(1, :);
out.posRates = Qs(2:end, :)./repmat(out.Occupancy, size(rawSums, 1), 1); % gaussian filtered rates / occupancy

if shuffN > 1
    rng('shuffle');
    out.Shuff.RatePerc = RatePerc;
    posReal = pos;
    ratesAllShuff = zeros(size(activity, 1), 100, shuffN);
    for sh = 1:shuffN
        pos = posReal(randperm(length(posReal)));
        
        [~, whichPlace] = histc(pos, h1);
        
        rawSums = zeros(size(activity, 1), 100);
        
        for i = 1:100
            k = whichPlace == i;
            if sum(k) > 0
                rawSums(:, i) = nansum(activity(:, k), 2);
            end
        end
        Q = [occ1', rawSums'];
        Qs = convolve2(Q, g, 'wrap')';
        ratesAllShuff(:, :, sh) = Qs(2:end, :)./repmat(out.Occupancy, size(rawSums, 1), 1);
    end
    
    edgeSize = length(g);
    
    ratesR = out.posRates;
    ratesR = [ratesR(:, (end - (edgeSize - 1)):end), ratesR, ratesR(:, 1:edgeSize)];
    pos = 1:100;
    pos = [pos(:, (end - (edgeSize - 1)):end), pos, pos(:, 1:edgeSize)];   
    
    percRate = prctile(ratesAllShuff, RatePerc, 3);
    out.Shuff.ThreshRate = percRate;
    percRate = [percRate(:, (end - (edgeSize - 1)):end), percRate, percRate(:, 1:edgeSize)];
    
    sigRate = double(ratesR > percRate);
    
    pC = find(sum(sigRate, 2) >= minPFBins);
    out.Shuff.isPC = zeros(size(ratesR, 1), 1);
    out.Shuff.PeakRate = NaN(size(ratesR, 1), 1);
    out.Shuff.PFPos = NaN(size(ratesR, 1), 2);
    out.Shuff.PFAllPos = {};
    out.Shuff.PFPeakPos = NaN(size(ratesR, 1), 1);
    
    for i = 1:length(pC)
        [pfS, pfL] = suprathresh(sigRate(pC(i), :), 0.5);
        pfS = pfS(pfL >= minPFBins, :);
        pfL = pfL(pfL >= minPFBins, :);
        maxR = [];
        if ~isempty(pfL)
            out.Shuff.PFAllPos{pC(i)} = [];
            for ii = 1:length(pfL)
                out.Shuff.PFAllPos{pC(i)} = [out.Shuff.PFAllPos{pC(i)}; pos(pfS(ii, 1)), pos(pfS(ii, 2))];
                maxR = [maxR; max(ratesR(pC(i), pfS(ii, 1):pfS(ii, 2)))];
            end
            out.Shuff.isPC(pC(i)) = 1;
            [out.Shuff.PeakRate(pC(i)), keepF] = max(maxR);
            pf = pfS(keepF, :);
            
            out.Shuff.PFPos(pC(i), :) = [pos(pf(1)), pos(pf(2))];
            posIn = pos(pf(1):pf(2));
            ratesIn = ratesR(pC(i), pf(1):pf(2));
            
            [~, maxBin] = max(ratesIn);
            out.Shuff.PFPeakPos(pC(i)) = posIn(maxBin);
        end
    end
end
