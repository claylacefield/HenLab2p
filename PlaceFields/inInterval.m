function [whichInt, counts] = inInterval(intervals, X)
%function [indexes, counts] = inInterval(intervals, X)

% This is the binning function of treadmill spatial bins
% Inputs:
%   intervals = bin intervals, like an array of running epoch start/stop
%   times ("runTimes")
%   X = e.g. T times of 2p frames
% Outputs:
%   whichInt = which bin each sample is contained in?


if size(intervals, 2) ~= 2 & min(size(X)) > 1
    error('Please format your inputs correctly. Signed Sincerely -The Management');
end

if ~isempty(intervals) & ~isempty(X)
    [~, ind] = sort(mean(intervals, 2));  % sort the array of run epoch start/stop times
    intervals = intervals(ind, :);
    
    h1 = reshape(intervals', 1, []);
    
    [counts, whichInt] = histc(X, h1);
    
    counts(end - 1) = counts(end - 1) + counts(end);
    counts = counts(1:(end - 1));
    
    whichInt(whichInt == length(h1)) = length(h1) - 1;
    
    counts = counts(1:2:end);
    whichInt = (whichInt + 1)/2;
    whichInt(whichInt ~= round(whichInt)) = 0;
    if size(counts, 1) < size(counts, 2)
        counts = counts';
        whichInt = whichInt';
    end
else
    whichInt = [];
    counts = [];
end