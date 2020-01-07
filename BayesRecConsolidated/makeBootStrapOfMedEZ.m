function [out, errBars] = makeBootStrapOfMedEZ(values, prcts, varargin)
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