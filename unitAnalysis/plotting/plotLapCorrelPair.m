function plotLapCorrelPair(seg1, seg2, goodSeg, C, A, d1, d2, varargin);

if ~isempty(varargin)
PCLappedSess = varargin{1};
end

if isempty(goodSeg)
    goodSeg = 1:size(C,1);
end

% seg1 = 30;
% seg2 = 4;

figure; 
plot(C(goodSeg(seg1),:)); 
title([num2str(seg1) ' vs ' num2str(seg2)]);
hold on; 
plot(C(goodSeg(seg2),:), 'g');

figure; 
subplot(1,2,1); 
imagesc(reshape(A(:,goodSeg(seg1)), d1,d2)); 
title(num2str(seg1));
subplot(1,2,2); 
imagesc(reshape(A(:,goodSeg(seg2)), d1,d2));
title(num2str(seg2));

try
figure; 
subplot(1,2,1); 
imagesc(squeeze(PCLappedSess.ByLap.posRateByLap(seg1,:,:))');
title(num2str(seg1));
subplot(1,2,2); 
imagesc(squeeze(PCLappedSess.ByLap.posRateByLap(seg2,:,:))');
title(num2str(seg2));
catch
end

