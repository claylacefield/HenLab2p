%function plotOverlayGreatSegSpatTemp_180524a()


avIm = imread(findLatestFilename('avCh2ds.tif'));

subseg = greatSeg;

ga = A(:,subseg);
gc = C(subseg, :); gc = gc/max(gc(:));
k = length(subseg);


ga2 = reshape(full(ga),d1,d2,k);

color = jet(k);

rgb = zeros(d1,d2,3); % initialize final color matrix (mxnx3)

for i = 1:k
    segSpat = ga2(:,:,i);
    segSpat = segSpat/max(segSpat(:));
    ga3(:,:,i) = segSpat;
    for j = 1:3
    segRgb(:,:,j) = segSpat*color(i,j);
    end
    
    rgb = rgb + segRgb;
    
    gc2(i,:) = gc(i,:)/max(gc(i,:));
    
end

figure('Position', [100 100 800 400]); 
subplot(1,2,1);
imshow(avIm);
hold on;
h = imshow(rgb);

alpha_data = mean(ga3,3);
alpha_data = alpha_data/max(alpha_data(:));
%alpha_data = alpha_data < 0.2;
set(h, 'AlphaData', alpha_data);

subplot(1,2,2);
[val,inds1] = max(gc2,[],2);
[val,inds2] = sort(inds1, 'descend');
gc3 = gc2(inds2,:);
color2 = color(inds2,:);
for i = 1:k
    hold on; 
    plot(gc3(i,:)+i, 'Color', color2(i,:));
end
