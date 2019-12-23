function [out, bins] = makeSlidingMeanForCircPos(pos, vals, edgeWidth)
% function makeSlidingMeanForCircPos(pos, vals, edgeWidth)

out = [];
out.vals = [];
out.binCenters = [];
out.numVals = [];
bins = [];
n = 1:100;
out.stdError = [];
out.stdDev = [];
for D1 = 1:100
    D2 = [D1 - edgeWidth, D1 + edgeWidth];
     if D2(1) < 1
        kIn = (pos >= (100 + D2(1)) | pos <= (D2(2)));
        bins = [bins; n >= (100 + D2(1)) | n <= D2(2)];
    else
        if D2(2) > 100
            kIn = (pos >= D2(1) | pos <= (D2(2) - 100));
            bins = [bins; n >= D2(1) | n <= (D2(2) - 100)];
        else
            kIn = pos >= D2(1) & pos <= D2(2);
            bins = [bins; n >= D2(1) & n <= D2(2)];
        end
     end
     if size(vals, 2) > 1
        out.vals = [out.vals; nanmean(vals(kIn, :), 1)];
        out.stdError = [out.stdError; makeStdErrorOfMean(vals(kIn, :))];
        out.stdDev = [out.stdDev; nanstd(vals(kIn, :), [], 1)];
     else
         out.vals = [out.vals; nanmean(vals(kIn), 1)];
         out.stdError = [out.stdError; makeStdErrorOfMean(vals(kIn))];
         out.stdDev = [out.stdDev; nanstd(vals(kIn))];
     end
    out.binCenters = [out.binCenters; D1];
    out.numVals = [out.numVals; sum(kIn)];    
    
end
