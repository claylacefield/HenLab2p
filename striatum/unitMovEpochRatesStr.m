function [movRate, nonmovRate] = unitMovEpochRatesStr()

[goodSegFilename, path] = uigetfile('*.mat', 'Select goodSeg file');
cd(path);
load(goodSegFilename);
pksCell = pksCell(goodSeg);
disp(['Calculating unit mov/nonmov epoch rates for ' goodSegFilename]);
basename = goodSegFilename(1:strfind(goodSegFilename, 'eMC')-1);

treadBehStrucFilename = findLatestFilename('treadBehStruc');
try
    load(treadBehStrucFilename);
catch
    treadBehStruc = procHen2pBehav('auto');
end

vel = fixVel(treadBehStruc.vel);
vel = vel(1:2:end);
rmVel = runmean(vel, 30); % smooth velocity

% find vel threshold for movement epochs
[meanRunVel, runVelThresh] = findRunVel(rmVel, 0);

y = treadBehStruc.resampY; y = y(1:2:end);
frTimes = treadBehStruc.adjFrTimes; frTimes = frTimes(1:2:end);

% treadPos = y; T = frTimes;
% minVel = runVelThresh; minEpochDur = 1;
% [movEpochs, velocity] = calcMovEpochs1(treadPos, T, minVel, minEpochDur);

movInds = find(rmVel>=runVelThresh/2); % indices of movement epochs
nonmovInds = find(rmVel<=1);

% for each unit, find spike inds in mov/nonmov epochs, and calc rates
for i = 1:length(pksCell)
    spkInds = pksCell{i};
    movRate(i) = length(intersect(spkInds, movInds))/length(movInds)*15;
    nonmovRate(i) = length(intersect(spkInds, nonmovInds))/length(nonmovInds)*15;
end

movRate = movRate'; nonmovRate = nonmovRate';

% plot rate distributions
figure;
subplot(2,1,1);
hist(movRate,20);
xlabel('movRate, ev/sec');
title(basename);

subplot(2,1,2);
hist(nonmovRate,20);
xlabel('nonmovRate, ev/sec');

% and save output to csv

outFilename = [basename 'unitMovRates_' date '.csv'];
disp(['Saving .csv output as ' outFilename]);
csvwrite(outFilename, [movRate, nonmovRate]);