function [caz] = zScoreCa(ca, varargin)

%% USAGE: [caz] = zScoreCa(ca, varargin);
% Clay Sep.2019
% Zscore based upon relatively quiet epochs in unit calcium signal
% - find times just before events
% - take mean and std for these
% - pick epochs with low mean and std (but not zero! because sometimes NMF
% produces zeros, e.g. when it splits nuclear signal out)
% - average these epoch mean/std and use these for Zscoring

% varargin for imaging fps (or default to 15fps)
if length(varargin)==1
    fps = varargin{1};
else
    fps = 15;
end

[pks] = clayCaTransients(ca,fps); % detect transients

% find mean/std for epochs just before transients
for i=1:length(pks)
    try
        epochCa = ca(pks(i)-299:pks(i)-100);
        epochMean(i) = mean(epochCa);
        epochStd(i) = std(epochCa);
    catch
        epochMean(i) = 0; % just make =0 if epoch error (these will be filtered out later)
        epochStd(i) = 0;
    end
end

% throw out epochs with std=0 (only happens in weird cases)
epochStd = epochStd(epochStd~=0);
epochMean = epochMean(epochStd~=0);

% histogram of epoch stdevs
[N, edges, bin] = histcounts(epochStd, 10);

% take mean and std from lowest std bin (thus quietest epochs)
caMeanBaseline = mean(epochMean(bin==1));
caStdBaseline = mean(epochStd(bin==1));

% use these to zscore calcium
caz = (ca-caMeanBaseline)/caStdBaseline;

