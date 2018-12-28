function [im1b, im2b, dy, dx, max_xc] = xcorrSpat(im1, im2, toPlot)

%% USAGE: [im1b, im2b] = xcorrSpat(im1, im2, toPlot);


% find dimensions
pixY = max([size(im1,1) size(im2,1)]);
pixX = max([size(im1,2) size(im2,2)]);

pixY = pixY + round(pixY/10); % pad a little bit (should I make sure this is even?)
pixX = pixX + round(pixX/10);

% cross-correlation
xc = normxcorr2(im1, im2);

% offset found by correlation
[max_xc, imax] = max(xc(:));
[ypeak, xpeak] = ind2sub(size(xc), imax);

% center of cross-correlation matrix in 2D is [d1, d2]

% distance between the offset and center
dx = (size(xc,2)-1)/2-xpeak;
dy = (size(xc,1)-1)/2-ypeak;


im1b = zeros(pixY, pixX); % initialize new images
im2b = zeros(pixY, pixX);


im1b((pixY-size(im1,1))/2+1:(pixY-size(im1,1))/2+size(im1,1), (pixX-size(im1,2))/2+1:(pixX-size(im1,2))/2+size(im1,2)) = im1;
im2b((pixY-size(im2,1))/2+1+dy:(pixY-size(im2,1))/2+size(im2,1)+dy, (pixX-size(im2,2))/2+1+dx:(pixX-size(im2,2))/2+size(im2,2)+dx) = im2;

if toPlot
figure; 
rgb = zeros(pixY,pixX,3);
ch3 = zeros(pixY, pixX);
rgb(1:pixY,1:pixX,1) = im1b/max(im1b(:));
rgb(1:pixY,1:pixX,2) = im2b/max(im2b(:));
rgb(1:pixY,1:pixX,3) = ch3;

imshow(rgb);

% subplot(1,2,1);
% imagesc(im1b);
% subplot(1,2,2);
% imagesc(im2b);
end