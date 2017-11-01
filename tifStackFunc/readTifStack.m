function [tifStack1] = readTifStack(numCh)

%% 
%  This is a script to import TIFF stacks of 2photon data
%  into the MATLAB workspace for analysis
%
%  Clay Lacefield
%  Oct. 23, 2017
%
%  Modified from impTifStack_042113: 
%  


[filename, pathname] = uigetfile('*.tif');
tifpath = [pathname filename];

disp(['Loading image stack for ' filename]);
tic;
% see how big the image stack is
stackInfo = imfinfo(tifpath);  % create structure of info for TIFF stack
numFrames = length(stackInfo);  % no. frames in stack (all channels)
width = stackInfo(1).Width; % width of the first frame (and all others)
height = stackInfo(1).Height;  % height of the first frame (and all others)

clear stackInfo;    % clear this because it might be big

frameNum = 0;

for i=1:numCh:numFrames
    frame = imread(tifpath, 'tif', i); % open the TIF frame
    frameNum = frameNum + 1;
    tifStack1(:,:,frameNum)= frame;  % make into a TIF stack
    %imwrite(frame*10, 'outfile.tif')
end
% 
% frameNum = 0;
% 
% if numCh == 2
%     for i=2:numCh:numFrames
%         frame = imread(tifpath, 'tif', i); % open the TIF frame
%         frameNum = frameNum + 1;
%         tifStack2(:,:,frameNum)= frame;  % make into a TIF stack
%         %imwrite(frame*10, 'outfile.tif')
%     end
% else
%     tifStack2 = 0;
%     caRefCorr = 0;
% end
% 
% 
% % tifAvg = uint16(mean(tifStack, 3)); % calculate the mean image (and convert to uint16)
% % 
% 
% frameAvg1 = mean(mean(tifStack1,1),2);  % take average for each frame
% frameAvg1 = squeeze(frameAvg1);  % just remove singleton dimensions
% frameAvgDf1 = (frameAvg1 - mean(frameAvg1, 1))/mean(frameAvg1,1);    % just subtract mean
% 
% % % now doing this with the running mean (runmean from Matlab
% % % Cntrl)
% % 
% % runAvg = runmean(frameAvg, 100);    % using large window to get only shift in baseline
% % 
% % frameAvgDf = (frameAvg - runAvg)./runAvg;
% 
% if numCh ==2 
%     frameAvg2 = mean(mean(tifStack2,1),2);  % take average for each frame
%     frameAvg2 = squeeze(frameAvg2);
%     frameAvgDf2 = (frameAvg2 - mean(frameAvg2, 1))/mean(frameAvg2,1);
%     
% end
% 
% % % figure; plot(frameAvgDf);
toc;