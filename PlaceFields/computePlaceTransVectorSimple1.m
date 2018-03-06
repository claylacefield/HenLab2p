function out = computePlaceTransVectorSimple1(activity, T, treadPos, shuffN)

%% USAGE: out = computePlaceTransVectorSimple1(activity, T, treadPos, shuffN);
%function out = computePlaceTransVectorSimple1(activity, sess, treadPos, shuffN)

% by Andres
% (annotated by sebnem and clay 2018)

% Output:
%   out = structure of output fields:
%       .runTimes = start(1)/stop(2) times of running epochs (after various
%       adjustments, e.g. min run epoch duration)
%       .nandPos = pos vector with NaNs when animal isn't running
%       .rawOccupancy = for each position bin, #frames*frameInterval (dT)
%       .posSums = sum of spikes for each neuron, for each spatial bin
%       .rawPosRates = sum of apikes/bin / occupancy of that bin
%       .Occupancy = gaussian filtered occupancy of spatial bins
%       .posRates = gaussian filtered spikes/bin / gaussian filtered
%       occupancy
%       .

% Inputs:
% activity = bool of spikes for each neuron for each time (single neuron or
% multiple, also can be something other than spikes, e.g. deconv.)
% T = vector of frame times
% treadPos = vector of position, interpolated to frame times (and normalized)
% shuffN = ? (number of shuffles)

if size(activity, 1) > size(activity, 2)
    activity = activity';
end

% clay: normalize pos if necessary
if max(treadPos)>2
    treadPos = treadPos/max(treadPos);
end

pos = treadPos;

%% set trim vars, etc.
minPFBins = 5;
RatePerc = 97.5;

trimRunStarts = 1; % sec delay after start of running
trimRunEnds = 0;
minRunTime = 2; % min run time in sec
minPFBins = 5;
RatePerc = 95;  %for each bin its the 99th precentile of the shuffled firing rates 

% calc some initial stuff for use later
out = [];

dT = median(diff(T));  % frame interval (sec)

g = fspecial('Gaussian',[10 1], 1); % compute gaussian kernel
h1 = linspace(0, 1, 101);   % vector of spatial bins, from 0:1 (i.e. normalized)
h1(end) = 1.0001; % yeah I don't know why to do this

%% calc running epochs (and only analyze these)
runTimes = calcMovEpochs1(treadPos, T); % start/stop times of running epochs >5cm/sec, >3sec long?
runTimes(:, 2) = runTimes(:, 2) + 0.00001; % do some modif/trimming of running epochs?
runTimes(:, 1) = runTimes(:, 1) + trimRunStarts;
runTimes(:, 2) = runTimes(:, 2) - trimRunEnds;
runTimes = runTimes(diff(runTimes, [], 2) > minRunTime, :); % only take run epochs over a certain length

kRun = inInterval(runTimes, T); % indices of times (gives array length of samples, with #=#runEpoch, or 0 if not running)
kRun = kRun ~= 0; % now just ones if in run epoch

out.runTimes = runTimes;
pos(~kRun) = NaN;   % NaN pos vector at times when animal isn't running

out.nanedPos = pos;
%    activity(:, ~isnan(pos)) = NaN;
activity = activity(:, ~isnan(pos)); % get activity only at times when animal is running
pos = pos(~isnan(pos)); % and now only take pos vector for running epochs

%% calc occupancy
% occupancy
[occ1, whichPlace] = histc(pos, h1); % distribution of indices when animal is in a particular spatial bin (occ1), and spatial bin for each frame (whichPlace)
occ1 = occ1(1:(end - 1)); % trim last value (because usually overrun from rotary enc)
occ1 = occ1*dT; % now make this times, from indices (#fr/frRate)
out.rawOccupancy = occ1;

%% sum spikes in each spatial bin
rawSums = zeros(size(activity, 1), 100);

for i = 1:100   % for all neurons/segments NO: for all spatial bins
    k = whichPlace == i; % indices of all frames for a spatial bin
    if sum(k) > 0
        rawSums(:, i) = nansum(activity(:, k), 2);  % sum of spikes for each spatial bin?
    end
end
out.posSums = rawSums; % sum spikes in each spatial bin (only run epochs)
out.rawPosRates = rawSums./repmat(occ1, size(rawSums, 1), 1); % rates = sumSpks/pos / occupancy for that bin

%% gaussian filtered versions
Q = [occ1', rawSums'];  % nbins x 2 array of occupancy rates and spike#s (for gaussian filt)

Qs = convolve2(Q, g, 'wrap')';  % convolve spikes and rates with gaussian

out.Occupancy = Qs(1, :);
out.posRates = Qs(2:end, :)./repmat(out.Occupancy, size(rawSums, 1), 1); % gaussian filtered rates / occupancy


%% Shuffle statistics

if shuffN > 1
    rng('shuffle'); % reset random number generator
    out.Shuff.RatePerc = RatePerc;
    posReal = pos;
    ratesAllShuff = zeros(size(activity, 1), 100, shuffN);
    
    % for each shuffle iteration
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
