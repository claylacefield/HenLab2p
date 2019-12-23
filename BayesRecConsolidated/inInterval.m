function [whichInt, counts] = inInterval(intervals, X)
%function [indexes, counts] = inInterval(intervals, X)
if size(intervals, 2) ~= 2 & min(size(X)) > 1
    error('Please format your inputs correctly. Signed Sincerely -The Management');
end

if ~isempty(intervals) & ~isempty(X)
    [~, ind] = sort(mean(intervals, 2));
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
    end
    if size(whichInt, 1) < size(whichInt, 2)
        whichInt = whichInt';
    end
else
    whichInt = [];
    counts = [];
end