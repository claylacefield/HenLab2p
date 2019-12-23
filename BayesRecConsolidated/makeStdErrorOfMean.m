function out = makeStdErrorOfMean(V)
%function out = makeStdErrorOfMean(V)
%standard error of mean of a vector

out = nanstd(V)./sqrt(sum(~isnan(V)) - 1);
    