%collect everything in a structure
% PlotStruc = {};
% TotalCell={};
% TotalCell{1}=pwd;
% TotalCell{2}=treadBehStruc;
% TotalCell{3}=seg2P;
% TotalCell{4}=cueShiftStruc;

 load(findLatestFilename('treadBehStruc'));
 load(findLatestFilename('_seg2P_'));
load(findLatestFilename('2PcueShiftStruc'));
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

%% format position vector
totalFrames = size(C,2);
resampY = treadBehStruc.resampY;
downSamp = round(length(resampY)/totalFrames);  % find downsample rate
treadPos = resampY(1:downSamp:end); % downsample position vector
treadPos = treadPos/max(treadPos);  % normalize position vector

% format other stuff
T = treadBehStruc.adjFrTimes(1:downSamp:end);

% calculate laps 
[lapVec, lapInts] = calcLaps1(treadPos, T);
%% identify cell types
[MidCueCellInd, EdgeCueCellInd, nonCueCellInd, refLapType] =  AllCueCells(cueShiftStruc);


%% plot z scored C for MidCueCells
for j= 1: length(MidCueCellInd)
a = Cz(MidCueCellInd(j), :);
figure; % lap numbers top to bottom
for i = 1:length(treadBehStruc.lapNum)
hold on;
x = linspace(0, 1, sum(lapVec == i));
plot(x, a(lapVec == i) + 1.5*(10 - i)) % to modify the spacing btwn transients
title(['MidCueCellInd' num2str(j)]);
end
end

% plot z scored C Edge Cue Cell
for j= 1: length(EdgeCueCellInd)
a = Cz(EdgeCueCellInd(j), :);
figure; % lap numbers top to bottom
for i = 1:length(treadBehStruc.lapNum)
hold on;
x = linspace(0, 1, sum(lapVec == i));
plot(x, a(lapVec == i) + 1.5*(10 - i)) % to modify the spacing btwn transients
title(['EdgeCueCellInd' num2str(j)]);
end
end

% plot z scored C n Cue Cell
for j= 1: length(nonCueCellInd)
a = Cz(nonCueCellInd(j), :);
figure; % lap numbers top to bottom
for i = 1:length(treadBehStruc.lapNum)
hold on;
x = linspace(0, 1, sum(lapVec == i));
plot(x, a(lapVec == i) + 1.5*(10 - i)) % to modify the spacing btwn transients
title(['nonCueCellInd' num2str(j)]);
end
end

%% now the spatial factors
avIm = imread(findLatestFilename('avCaChDs.tif'));
ga = A(:,MidCueCellInd);
gc = Cz(MidCueCellInd, :);
k = length(MidCueCellInd);
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
set(h, 'AlphaData', alpha_data); title('MidCueCell')

subplot(1,2,2);
[val,inds1] = max(gc2,[],2);
[val,inds2] = sort(inds1, 'descend');
gc3 = gc2(inds2,:);
color2 = color(inds2,:);
for i = 1:k
    hold on; 
    plot(gc3(i,:)+i, 'Color', color2(i,:));
end

% Edge Cue Cell Total C
ga = A(:,EdgeCueCellInd);
gc = Cz(EdgeCueCellInd, :);
k = length(EdgeCueCellInd);
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
set(h, 'AlphaData', alpha_data); title('EdgeCueCell')

subplot(1,2,2);
[val,inds1] = max(gc2,[],2);
[val,inds2] = sort(inds1, 'descend');
gc3 = gc2(inds2,:);
color2 = color(inds2,:);
for i = 1:k
    hold on; 
    plot(gc3(i,:)+i, 'Color', color2(i,:));
end


% nonCue Cell total C
ga = A(:,nonCueCellInd);
gc = Cz(nonCueCellInd, :);
k = length(nonCueCellInd);
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
set(h, 'AlphaData', alpha_data); title('nonCueCell')

subplot(1,2,2);
[val,inds1] = max(gc2,[],2);
[val,inds2] = sort(inds1, 'descend');
gc3 = gc2(inds2,:);
color2 = color(inds2,:);
for i = 1:k
    hold on; 
    plot(gc3(i,:)+i, 'Color', color2(i,:));
end

% mask = reshape(sum(spatSess.A(:, Allpc(11:13)), 2), spatSess.d1, spatSess.d2);
% figure; imagesc(mask)

%% to get firing rates by lap since cueshift parses laps need to run PCLappedSess
% load(findLatestFilename('_seg2P_'));
% load(findLatestFilename('_treadBehStruc_'));
% pksCell=seg2P.pksCell;
% [PCLappedSess] = wrapAndresPlaceFieldsClay(pksCell, 0);
% save ('PCLappedSess.mat' , 'PCLappedSess');
% %PCLappedSess=sameCellTuningStruc.multSessSegStruc(2).PCLapSess;
% 
% figure; imagesc(squeeze(PCLappedSess.ByLap.posRateByLap(120, :, :))');
% colormap 'hot'

% avgCueTrigSig- try at last
% for i = 15:17
%     avgCueTrigSig2P(Allpc(i), 'olf');
%     figure; imagesc(squeeze(PCLappedSess.ByLap.posRateByLap(Allpc(i), :, :))');
%     colormap 'hot'
%     title(['seg=' num2str(Allpc(i))]);
% end
