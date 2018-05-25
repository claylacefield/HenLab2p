%function plotSpatialByTuningColor()

% plot spatial profiles of place cells based upon their tuning (posRates)

%
goodSegPCinds = find(unitTuningStruc.outPC.Shuff.isPC);
origPCinds = goodSeg(goodSegPCinds);

posRates = unitTuningStruc.outPC.posRates(goodSegPCinds,:);
[vals, inds] = max(posRates,[],2);
[B, inds2] = sort(inds); % inds of PCinds

origPCindsSort = origPCinds(inds2);

%% 

subseg = origPCindsSort;
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
figure; image(rgb);
