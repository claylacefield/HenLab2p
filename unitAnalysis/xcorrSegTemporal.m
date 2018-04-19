function [corrCoeff, maxCorr] = xcorrSegTemporal(C, maxLagFr, toPlot, goodSeg);

% clay 2018
% This script calculates cross-correlations for the timecourses of all
% semgmented ROIs 

% transpose C if necessary
if size(C,1) < size(C,2)
    C = C';
end

if goodSeg ~= 0
C = C(:,goodSeg);
end

K = size(C,2);

%tic;
disp('Calculating cross-correlations between all segments...');

for segNum1 = 1:K
    
    seg1 = C(:,segNum1);
    %seg1 = seg1/var(seg1);
    
    disp(['xcorr: seg#' num2str(segNum1) ' out of ' num2str(K)]);
        tic;
    
    for segNum2 = 1:K
        
        seg2 = C(:,segNum2);
        %seg2 = seg2/var(seg2);
        
        
        xc = xcorr(seg1, seg2, maxLagFr, 'coeff'); %'unbiased');
        corrCoeff(segNum1, segNum2, :) = xc;
        maxCorr(segNum1, segNum2) = max(xc);
        
        
    end     % end FOR loop for all second seg to xcorr
    toc;
end     % end FOR loop for all first seg to xcorr

%toc;

if toPlot
    figure; 
    colormap(jet);
    imagesc(maxCorr);
end


% figure;
% 
% numPlots = K/25;
% 
% for j = 1:numPlots
%     
%     figure;  % plot temporal components
%     for i = 1:25
%         subplot(5,5,i); plot(squeeze(corrCoeff(i,j,:)));
%     end
%     
% end