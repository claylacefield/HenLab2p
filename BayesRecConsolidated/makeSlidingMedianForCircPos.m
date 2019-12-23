function [out, bins] = makeSlidingMedianForCircPos(pos, vals, edgeWidth, varargin)
% function makeSlidingMedianForCircPos(pos, vals, edgeWidth, nShuffles (def = 200)

rng('shuffle');
nShuff = 200;
if ~isempty(varargin)
    nShuff = varargin{1};
end

out = [];
out.vals = [];
out.binCenters = [];
out.numVals = [];
bins = [];
n = 1:100;
out.confInt = [];
out.errBars = [];
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
    %      if size(vals, 2) > 1
    %         out.vals = [out.vals; nanmedian(vals(kIn, :), 1)];
    %         [confInt, erBar] = makeBootStrapOfMedIn1(vals(kIn, :), [97.5, 2.5], nShuff);
    %         out.confInt = [out.confInt, confInt];
    %         out.errBars = [];
    %      else
    out.vals = [out.vals; nanmedian(vals(kIn, :), 1)];
    [confInt, erBar] = makeBootStrapOfMedIn1(vals(kIn, :), [97.5, 2.5], nShuff);
    out.confInt = [out.confInt, confInt];
    out.errBars = [out.errBars, erBar];
    %      end
    out.binCenters = [out.binCenters; D1];
    out.numVals = [out.numVals; sum(kIn)];
end



function [out, errBars] = makeBootStrapOfMedIn1(values, prcts, varargin)
%function makeBootStrapOfMedEz1(values, prcts, shuffN(def = 200))

rng('shuffle');
nShuff = 200;
if ~isempty(varargin)
    nShuff = varargin{1};
end

h = zeros(nShuff, size(values, 2));

for i = 1:nShuff
    h(i, :) = nanmedian(values(randi(size(values, 1), [size(values, 1), 1]), :), 1);
end

out = prctile(h, prcts, 1);

errBars = abs(out - repmat(nanmedian(values,1), [length(prcts), 1]));