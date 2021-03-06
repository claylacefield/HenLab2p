
function plotACByCellType (seg2P, MidCueCellInd, EdgeCueCellInd, nonCueCellInd)


A=seg2P.A2p;
d1=seg2P.d12p;
d2=seg2P.d22p;
C = seg2P.C2p;

%%z score C
Cz = [];
for i =1 :size(C,1)
    z = C(i,:);
    z(~isnan(z)) = zscore(z(~isnan(z)));
    Cz = [Cz;z];
end
% now the spatial factors
avIm = imread(findLatestFilename('avCaChDs.tif'));
Mga = A(:,MidCueCellInd);
Mgc = Cz(MidCueCellInd, :);
m = length(MidCueCellInd);
Mga2 = reshape(full(Mga),d1,d2,m);
Mcolor = jet(m);
Mrgb = zeros(d1,d2,3); % initialize final color matrix (mxnx3)

for i = 1:m
    segSpat = Mga2(:,:,i);
    segSpat = segSpat/max(segSpat(:));
    Mga3(:,:,i) = segSpat;
    for j = 1:3
        segRgb(:,:,j) = segSpat*Mcolor(i,j);
    end
    
    Mrgb = Mrgb + segRgb;
    Mgc2(i,:) = Mgc(i,:)/max(Mgc(i,:));
    
end

figure('Position', [100 100 800 400]);
subplot(1,2,1);
imshow(avIm);
hold on;
h = imshow(Mrgb);

alpha_data = mean(Mga3,3);
alpha_data = alpha_data/max(alpha_data(:));
%alpha_data = alpha_data < 0.2;
set(h, 'AlphaData', alpha_data); title('MidCueCell')

subplot(1,2,2);
[val,inds1] = max(Mgc2,[],2);
[val,inds2] = sort(inds1, 'descend');
Mgc3 = Mgc2(inds2,:);
Mcolor2 = Mcolor(inds2,:);
for i = 1:m
    hold on;
    plot(Mgc3(i,:)+i, 'Color', Mcolor2(i,:));
end

% Edge Cue Cell Total C
Ega = A(:,EdgeCueCellInd);
Egc = Cz(EdgeCueCellInd, :);
e = length(EdgeCueCellInd);
Ega2 = reshape(full(Ega),d1,d2,e);
Ecolor = jet(e);
Ergb = zeros(d1,d2,3); % initialize final color matrix (mxnx3)
for i = 1:e
    segSpat = Ega2(:,:,i);
    segSpat = segSpat/max(segSpat(:));
    Ega3(:,:,i) = segSpat;
    for j = 1:3
        segRgb(:,:,j) = segSpat*Ecolor(i,j);
    end
    
    Ergb = Ergb + segRgb;
    Egc2(i,:) = Egc(i,:)/max(Egc(i,:));
    
end

figure('Position', [100 100 800 400]);
subplot(1,2,1);
imshow(avIm);
hold on;
h = imshow(Ergb);

alpha_data = mean(Ega3,3);
alpha_data = alpha_data/max(alpha_data(:));
%alpha_data = alpha_data < 0.2;
set(h, 'AlphaData', alpha_data); title('EdgeCueCell')

subplot(1,2,2);
[val,inds1] = max(Egc2,[],2);
[val,inds2] = sort(inds1, 'descend');
Egc3 = Egc2(inds2,:);
Ecolor2 = Ecolor(inds2,:);
for i = 1:e
    hold on;
    plot(Egc3(i,:)+i, 'Color', Ecolor2(i,:));
end


%nonCue Cell total C
ga = A(:,nonCueCellInd);
gc = Cz(nonCueCellInd, :);
n = length(nonCueCellInd);
ga2 = reshape(full(ga),d1,d2,n);
colorN = jet(n);
rgbN = zeros(d1,d2,3); % initialize final color matrix (mxnx3)
segSpat=[];
for i = 1:n
    segSpat = ga2(:,:,i);
    segSpat = segSpat/max(segSpat(:));
    ga3(:,:,i) = segSpat;
    for j = 1:3
        segRgb(:,:,j) = segSpat*colorN(i,j);
    end
    
    rgbN = rgbN + segRgb;
    gc2(i,:) = gc(i,:)/max(gc(i,:));
end

figure('Position', [100 100 800 400]);
subplot(1,2,1);
imshow(avIm);
hold on;
h = imshow(rgbN);

alpha_data = mean(ga3,3);
alpha_data = alpha_data/max(alpha_data(:));
%alpha_data = alpha_data < 0.2;
set(h, 'AlphaData', alpha_data); title('nonCueCell')

subplot(1,2,2);
[val,inds1] = max(gc2,[],2);
[val,inds2] = sort(inds1, 'descend');
gc3 = gc2(inds2,:);
color2N = colorN(inds2,:);
for i = 1:n
    hold on;
    plot(gc3(i,:)+i, 'Color', color2N(i,:));
end

