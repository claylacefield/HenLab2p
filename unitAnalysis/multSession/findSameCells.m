function [sameCellStruc] = findSameCells(multSessTuningStruc)

% NOTE: this is a draft script- not for use
% (supplanted by Ziv CellReg (see cellRegClay.m)

% take sum of all goodSeg spatial
% xcorr to find offsets between datasets
% find corresponding cells by looking 


A1 = reshape(full(multSessTuningStruc(1).A), multSessTuningStruc(1).d1, multSessTuningStruc(1).d2, size(multSessTuningStruc(1).A,2));
A2 = reshape(full(multSessTuningStruc(2).A), multSessTuningStruc(2).d1, multSessTuningStruc(2).d2, size(multSessTuningStruc(2).A,2));
A3 = reshape(full(multSessTuningStruc(3).A), multSessTuningStruc(3).d1, multSessTuningStruc(3).d2, size(multSessTuningStruc(3).A,2));

A1b = A1(:,:,multSessTuningStruc(1).goodSegPosPkStruc.goodSeg);
A2b = A2(:,:,multSessTuningStruc(2).goodSegPosPkStruc.goodSeg);

A1c = mean(A1b,3); 
A2c = mean(A2b,3);

xc = xcorr2(A1c, A2c);

% offset found by correlation
[max_xc, imax] = max(xc(:));
[ypeak, xpeak] = ind2sub(size(xc), imax);

% center of cross-correlation matrix in 2D is [d1, d2]

% distance between the offset and center
dx = (size(xc,2)-1)/2-xpeak;
dy = (size(xc,1)-1)/2-ypeak;