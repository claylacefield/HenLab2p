function [im1, im2] = xcorrGoodSegSpat(allSegIm1, allSegIm2)

%% USAGE: [im1, im2] = xcorrGoodSegSpat(allSegIm1, allSegIm2);

xc = xcorr2(allSegIm1, allSegIm2);

% offset found by correlation
[max_xc, imax] = max(xc(:));
[ypeak, xpeak] = ind2sub(size(xc), imax);

% center of cross-correlation matrix in 2D is [d1, d2]

% distance between the offset and center
dx = (size(xc,2)-1)/2-xpeak;
dy = (size(xc,1)-1)/2-ypeak;


im1 = zeros(560, 560);
im2 = zeros(560, 560);

im1((560-size(allSegIm1,1))/2+1:(560-size(allSegIm1,1))/2+size(allSegIm1,1), (560-size(allSegIm1,2))/2+1:(560-size(allSegIm1,2))/2+size(allSegIm1,2)) = allSegIm1;
im2((560-size(allSegIm2,1))/2+1-dy:(560-size(allSegIm2,1))/2+size(allSegIm2,1)-dy, (560-size(allSegIm2,2))/2+1-dx:(560-size(allSegIm2,2))/2+size(allSegIm2,2)-dx) = allSegIm2;


figure; 
subplot(2,1,1);
imagesc(im1);
subplot(2,1,2);
imagesc(im2);
