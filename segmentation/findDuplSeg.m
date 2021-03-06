function [dupPairs] = findDuplSeg(A,C,d1,d2, toPlot);


% find segment locations
[yx, d] = findSegCentroid(A, d1, d2);

% xcorr temporal components (takes a while)
maxLagFr = 300;
[corrCoeff, maxCorr] = xcorrSegTemporal(C, maxLagFr, 0, 0); %toPlot, goodSeg);

d(d>10)=NaN;

b = (1-d/max(d(:))).*maxCorr;
%b2 = b.*(1-eye(size(A,2)));

if toPlot
colormap(jet);
figure; imagesc(b);
end

inds = find(b>0.2);
[dup2, dup1] = ind2sub(size(b), inds);

dupPairs = [dup1, dup2];

% seg1 = 10;
% seg2 = 179;
% figure; 
% subplot(2,2,1); 
% imagesc(reshape(squeeze(A(:,seg1)),d1,d2));
% subplot(2,2,3); 
% imagesc(reshape(squeeze(A(:,seg2)),d1,d2));
% subplot(2,2,2);
% plot(C(seg1,:),'r');
% hold on;
% plot(C(seg2,:),'g');
