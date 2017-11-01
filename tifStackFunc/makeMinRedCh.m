function [avgRedWinMin] = makeMinRedCh(Y)

% [avgRedWinMin] = makeMinRedCh(Y);
% Clay Lacefield, Oct. 21, 2017
% This function takes a stack of redCh/Ch1/tdTomato imaging, takes averages
% over 1000 frame windows, then takes the min of each pixel.
% This is to get an idea about the true red Ch signal, minimizing the
% bleedthrough from GCaMP.

disp('Creating minRedCh image, to minimize bleedthrough from GCaMP/grn channel');

tic;

d1 = size(Y,1);
d2 = size(Y,2);
t = size(Y,3);

winSize = 100; % window size to compute avgs

Y2 = reshape(Y,d1*d2, t);  % linearize frames

% take average of all frames in each window epoch
for i = 1:ceil(t/winSize)
    try
    yWin(:,i) = mean(Y2(:,(i-1)*winSize+1:winSize*i),2);
    catch
        yWin(:,i) = mean(Y2(:,(i-1)*winSize+1:end),2); % just for last segment
    end
end

yMin = min(yWin'); 

avgRedWinMin = reshape(yMin, d1, d2);

avgRedWinMin = avgRedWinMin';

figure; 
imagesc(avgRedWinMin);

toc;