function [dir, pval] = bootUnitPkTuning(goodSegEvents);

binranges = 1:100;


for i = 1:length(goodSegEvents)
    numPks = length(goodSegEvents{i});
    for j = 1:1000
        r(j,1:numPks) = randi([1 100], 1, numPks);  % generate random position bins for each spike
        bincounts = histcounts(r,100);
    end
    
    % m = bootstrp(100, @?, y);
end


