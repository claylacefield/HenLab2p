function plotCueCellSpatial(C, A, d1, d2, T, fps, goodSeg);

%% USAGE: plotCueCellSpatial(C, A, d1, d2, T, fps, goodSeg);

%ray2 = find(circStatStruc.uniform(:,1)<0.98);

% if input is cell array of peaks, make matrix
if iscell(C)
    cCell = C;
    C = zeros(length(C),round(length(T)/(30/fps)));
    for i = 1:length(cCell)
        C(i,cCell{i})=1;
    end
end

C = C(goodSeg,:);

[out, PCLappedSess] = wrapAndresPlaceFieldsClay(C, 0);
posRates = out.posRates;


% find the peak position for each cell
[vals, maxInds] = max(posRates,[],2);
%figure; hist(maxInds);

startInds = find(maxInds>=90 | maxInds<=10);
midInds = find(maxInds>=40 & maxInds<=60);

midInds = goodSeg(midInds);
startInds = goodSeg(startInds);

figure('Position', [100 100 800 400]);
subplot(1,2,1);
imagesc(reshape(squeeze(mean(A(:,startInds),2)),d1,d2));
title('start cue cells');
subplot(1,2,2);
imagesc(reshape(squeeze(mean(A(:,midInds),2)),d1,d2));
title('middle cue cells');


