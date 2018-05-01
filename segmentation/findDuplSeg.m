function [dupSegArr] = findDuplSeg(A,C,d1,d2);



[yx, d] = findSegCentroid(A, d1, d2);
[corrCoeff, maxCorr] = xcorrSegTemporal(C, maxLagFr, toPlot, goodSeg);

d(d>10)=NaN;

b = (1-d/max(d(:)))*5+maxCorr;
b2 = b.*(1-eye(300));
figure; imagesc(b2);

seg1 = 155;
seg2 = 176;
figure; 
subplot(2,2,1); 
imagesc(reshape(squeeze(A(:,seg1)),d1,d2));
subplot(2,2,3); 
imagesc(reshape(squeeze(A(:,seg2)),d1,d2));
subplot(2,2,2);
plot(C(seg1,:),'r');
hold on;
plot(C(seg2,:),'g');
