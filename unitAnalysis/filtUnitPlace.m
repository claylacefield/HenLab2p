function [fCaPos2] = filtUnitPlace(goodSegPosPks)

% Filter unit spatial firing (calc with ?)
% Clay 2017

%seg = 1;
segCaPos = [goodSegPosPks goodSegPosPks]; % concat to wrap around

% generate gaussian filter
hsize = [1 20]; sigma = 2;
h = fspecial('gaussian', hsize, sigma);
%figure; plot(h);


% and convolve position tuning with filter
% fCaPos = conv(segCaPos, h, 'same');
% figure; plot(fCaPos);
% hold on;
% plot(segCaPos, 'g');

figure; hold on;
for i = 1:size(goodSegPosPks,1)
fCaPos(i,:) = conv(segCaPos(i,:), h, 'same');
%plot(fCaPos+i);
end


[val, ind] = max(fCaPos');
[sortInd, origInd] = sort(ind);
fCaPos2 = fCaPos(origInd,:);

figure; imagesc(fCaPos2);


