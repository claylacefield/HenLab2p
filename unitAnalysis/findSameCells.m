function [sameCellStruc] = findSameCells(A)


% take sum of all goodSeg spatial
% xcorr to find offsets between datasets
% find corresponding cells by looking 


xc = xcorr2(allSegIm1, allSegIm2);

% offset found by correlation
[max_xc, imax] = max(xc(:));
[ypeak, xpeak] = ind2sub(size(xc), imax);

% center of cross-correlation matrix in 2D is [d1, d2]

% distance between the offset and center
dx = (size(xc,2)-1)/2-xpeak;
dy = (size(xc,1)-1)/2-ypeak;