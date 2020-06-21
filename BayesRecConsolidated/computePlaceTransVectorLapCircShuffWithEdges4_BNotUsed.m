function [out, ratesAllShuff] = computePlaceTransVectorLapCircShuffWithEdges4(activity, T, treadPos, lapVec, shuffN, varargin)
%function out = computePlaceTransVectorLapCircShuffWithEdges4(activity, sess, treadPos, lapVec, shuffN, excludeVec(opt))

excludeVec = [];
if ~isempty(varargin)
    excludeVec = varargin{1};
end


if size(activity, 1) > size(activity, 2)
    activity = activity';
end
%randomizes the random number generator
rng('shuffle');

%set parameters
RatePerc = 99;
edgeRateMultiple = 2;
trimRunStarts = 0;
trimRunEnds = 0;
minRunTime = 2;
minPFBins = 5;
minVel = 5; %%%

out = [];
out.Params.RatePerc = 99;
out.Params.edgeRateMultiple = edgeRateMultiple;
out.Params.trimRunStarts = trimRunStarts;
out.Params.trimRunEnds = trimRunEnds;
out.Params.minRunTime = minRunTime;
out.Params.minPFBins = minPFBins;
out.Params.minVel = minVel;
out.Params.shuffN = shuffN;


pos = treadPos;

dT = median(diff(T));

g = fspecial('Gaussian',[15, 1], 5);
%g = fspecial('Gaussian',[10, 1], 5);
h1 = linspace(0, 1, 101);
h1(end) = 1.0001;

%determine the valid run epochs (and trim them)
runTimes = calcMovEpochs1(treadPos, T, minVel);
runTimes(:, 2) = runTimes(:, 2) + 0.00001;
runTimes(:, 1) = runTimes(:, 1) + trimRunStarts;
runTimes(:, 2) = runTimes(:, 2) - trimRunEnds;
runTimes = runTimes(diff(runTimes, [], 2) >= minRunTime, :);

kRun = inInterval(runTimes, T);
kRun(~(lapVec > 0)) = 0;
if ~isempty(excludeVec)
    kRun(excludeVec > 0) = 0;
end

out.runTimes = runTimes;

%set non-valid time points to NaN
pos(~(kRun > 0)) = NaN;

actNaN = mean(isnan(activity), 1) == 1;
pos(actNaN) = NaN;

whichLap = lapVec(~isnan(pos));
out.nanedPos = pos;

%keep only the positions and activity correspending to valid samples
activity = activity(:, ~isnan(pos));
pos = pos(~isnan(pos));

%calculate the occupancy
[occ1, whichPlace] = histc(pos, h1);
occ1 = occ1(1:(end - 1));
occ1 = occ1*dT;

out.rawOccupancy = occ1;
rawSums = zeros(size(activity, 1), 100);

%calculate the number of events at each spatial bin for each cell
for i = 1:100
    k = whichPlace == i;
    if sum(k) > 0
        rawSums(:, i) = nansum(activity(:, k), 2);
    end
end
out.posSums = rawSums;

%divide the summed by the occupancy to get rates by position
rawPosRates = rawSums./repmat(occ1, size(rawSums, 1), 1);
out.rawPosRates = rawPosRates;

rawPosRates(isnan(rawPosRates)) = 0;

%smooth the occupancy and the rates
out.Occupancy = convolve2(occ1', g, 'wrap')';
out.posRates = convolve2(rawPosRates', g, 'wrap')';

if shuffN > 1
    rng('shuffle');
    out.Shuff.RatePerc = RatePerc;
    posReal = pos;
    ratesAllShuff = zeros(size(activity, 1), 100, shuffN);
    rawRatesAllShuff = zeros(size(activity, 1), 100, shuffN);
    rawSumsAll = rawRatesAllShuff;
    out.Shuff.whichLap = int16(whichLap);
    uLaps = unique(whichLap);
    circShuffLapN = zeros(length(uLaps), shuffN);
    for i = 1:length(uLaps)
        circShuffLapN(i, :)  = randi(sum(whichLap == uLaps(i)), [1, shuffN]);
    end
    out.Shuff.circShuffLapN = circShuffLapN;
    for sh = 1:shuffN
        pos = posReal;
        %shuffle the position vector
        for i = 1:length(uLaps)
            pos(whichLap == uLaps(i)) = circshift(pos(whichLap == uLaps(i)), [0, circShuffLapN(i, sh)]);
        end
        
        [~, whichPlace] = histc(pos, h1);
        
        rawSums = zeros(size(activity, 1), 100);
        
        for i = 1:100
            k = whichPlace == i;
            if sum(k) > 0
                rawSums(:, i) = nansum(activity(:, k), 2);
            end
        end
        rawSumsAll(:, :, sh) = rawSums;
        
        rawPosRates = rawSums./repmat(out.rawOccupancy, size(rawSums, 1), 1);
        rawRatesAllShuff(:, :, sh) = rawPosRates;
        
        rawPosRates(isnan(rawPosRates)) = 0;
        
        posRates = convolve2(rawPosRates', g, 'wrap')';
        %these are all the shuffled rates by position:
        ratesAllShuff(:, :, sh) = posRates;
    end
    ratesR = out.posRates;
    %these concatinations are to account for the stuff around the edges
    ratesR = [ratesR, ratesR];
    pos = 1:100;
    pos = [pos, pos];
    
    percRate = prctile(ratesAllShuff, RatePerc, 3);
    out.Shuff.shuffMeanRate = nanmean(ratesAllShuff, 3);
    out.Shuff.ThreshRate = percRate;
    percRate = [percRate, percRate];
    
    sigRate = double(ratesR > percRate);
    
    pC = find(sum(sigRate, 2) >= minPFBins);
    out.Shuff.isPC = zeros(size(ratesR, 1), 1);
    out.Shuff.PeakRate = NaN(size(ratesR, 1), 1);
    out.Shuff.PFInPos = {};
    out.Shuff.PFInAllPos = {};
    out.Shuff.PFPeakPos = NaN(size(ratesR, 1), 1);
    for i = 1:size(out.posRates, 1)
        out.Shuff.PFInAllPos{i} = {};
        out.Shuff.PFInPos{i} = [];
    end
    
    %this iterates over cells to determine whethere they are place cells
    for i = 1:length(pC)
        [sigBins, sigBinsL] = suprathresh(sigRate(pC(i), :), 0.5);
        sigBins = sigBins(sigBinsL >= minPFBins, :);
        sigBinsAll = [];
        maxR = [];
        
        if ~isempty(sigBins)
            sigBinsAll = [];
            for ii = 1:size(sigBins, 1)
                sigBinsAll = [sigBinsAll, sigBins(ii, 1):sigBins(ii, 2)];
            end
            
            sBins = ratesR(pC(i), :) > nanmean(ratesR(pC(i), :))*edgeRateMultiple;
            sBins = sBins | sigRate(pC(i), :);
            [pfS, pfL] = suprathresh(double(sBins), 0.5);
            pfS = pfS(pfL >= minPFBins, :);
            pfL = pfL(pfL >= minPFBins, :);
            
            k = [];
            for ii = 1:size(pfS, 1)
                if sum(ismember(sigBinsAll, pfS(ii, 1):pfS(ii, 2))) >= minPFBins
                    k = [k; 1];
                else
                    k = [k; 0];
                end
            end
            pfS = pfS(k > 0, :);
            pfL = pfL(k > 0);
            
            k = sum(pfS > 100, 2) < 2;
            pfS = pfS(k, :);
            pfL = pfL(k, :);
            
            [~, s] = sort(pfL, 'descend');
            pfL = pfL(s, :);
            pfS = pfS(s, :);
            
            inPFAll = zeros(1, 100);
            for ii = 1:length(pfL)
                inPFIn = zeros(1, 100);
                if pfS(ii, 2) > 100
                    inPFIn(1:mod(pfS(ii, 2), 100)) = 1;
                    inPFIn(pfS(ii, 1):end) = 1;
                else
                    inPFIn(pfS(ii, 1):pfS(ii, 2)) =1;
                end
                if sum(inPFAll(inPFIn > 0)) == 0
                    inPFAll(inPFIn > 0) = 1;
                    out.Shuff.PFInAllPos{pC(i)}{end + 1} = find(inPFIn > 0);
                    maxR = [maxR; max(ratesR(pC(i), out.Shuff.PFInAllPos{pC(i)}{end}))];
                end
            end
            out.Shuff.isPC(pC(i)) = 1;
            [out.Shuff.PeakRate(pC(i)), keepF] = max(maxR);
            out.Shuff.PFInPos{pC(i)} = out.Shuff.PFInAllPos{pC(i)}{keepF};
            posIn = pos(out.Shuff.PFInAllPos{pC(i)}{keepF});
            ratesIn = ratesR(pC(i), out.Shuff.PFInAllPos{pC(i)}{keepF});
            
            [~, maxBin] = max(ratesIn);
            out.Shuff.PFPeakPos(pC(i)) = posIn(maxBin);
        end
    end
    out.Shuff.NumPFs = [];
    out.Shuff.PFWidth = [];
    for i = 1:length(out.Shuff.PFInAllPos)
        out.Shuff.NumPFs = [out.Shuff.NumPFs; length(out.Shuff.PFInAllPos{i})];
        if ~isempty(out.Shuff.PFInPos{i})
            out.Shuff.PFWidth = [out.Shuff.PFWidth; length(out.Shuff.PFInPos{i})];
        else
            out.Shuff.PFWidth = [out.Shuff.PFWidth; NaN];
        end
    end
    
end