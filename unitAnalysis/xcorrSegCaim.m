function [corrCoeff] = xcorrSegCaim(segStruc, goodSeg, toNorm)

% clay 051014
% This script calculates cross-correlations for the timecourses of all
% semgmented ROIs (usually dendrites) in a segStruc


% load in segmentation matrices
C = segStruc.C';     % temporal matrix
% A = segStruc.A;     % spatial matrix
% d1 = segStruc.d1;   % dimX?
% d2 = segStruc.d2;   % dimY?
% T = segStruc.T;     % time (num frames)
K = length(goodSeg);

maxLag = 300;

tic;
disp(['Calculating cross-correlations between all ' num2str(K) ' segments...']);

for segNum1 = 1:K
    
    seg1 = C(:,goodSeg(segNum1));
    
    if toNorm == 1
        seg1 = seg1/var(seg1);
    end
    
    for segNum2 = 1:K
        
        seg2 = C(:,goodSeg(segNum2));
        
        if toNorm == 1
           seg2 = seg2/var(seg2); 
        end
        
%         disp(['xcorr: seg#' num2str(goodSeg(segNum1)) ' vs. seg#' num2str(goodSeg(segNum2))]);
%         tic;
        corrCoeff(segNum1, segNum2, :) = xcorr(seg1, seg2, maxLag, 'coeff'); %'unbiased');
%         toc;
        
    end     % end FOR loop for all second seg to xcorr
    
end     % end FOR loop for all first seg to xcorr

toc;

numPlots = K/25;

for j = 1:numPlots
    
    figure;  % plot temporal components
    for i = 1:25
        subplot(5,5,i); plot(squeeze(corrCoeff(i,j,:)));
    end
    
end

figure; imagesc(max(corrCoeff, [], 3));
