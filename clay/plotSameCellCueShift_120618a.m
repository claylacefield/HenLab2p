% plot sameCellCueShift
% Clay Dec. 2018
% plotting Di-15-1003-002 cells that were place cells in last sess


placeCellAllGoodSegInd = sameCellTuningStruc.placeCellAllGoodSegInd;


pcAllPosRates1 = cueShiftStruc.PCLappedSess1.posRates(placeCellAllGoodSegInd(:,2),:);
pcAllPosRates2 = cueShiftStruc.PCLappedSess2.posRates(placeCellAllGoodSegInd(:,2),:);

[sortInd] = plotUnitsByTuning(pcAllPosRates1, 0, 1);
figure; colormap(jet);
imagesc(pcAllPosRates2(sortInd,:));

figure; plot(mean(pcAllPosRates1,1)); hold on; plot(mean(pcAllPosRates2,1),'g');


% 
% %%
% %save spatial profiles of cells from all sessions, aligned with ziv
% for i = 1:length(unitSpatCell)
%     allCell = mean(unitSpatCell{i},1);
%     rgb(:,:,i) = allCell/max(allCell(:));
% end
% 
% %imwrite(rgb, 'cellRegRGB.tif');
% 
% %cellRegIndInAll
% 
% % mark centroids of place cells in all
% try
% rgb2 = insertMarker(10*rgb, zivCentroids(cellRegIndInAll(placeCellsInAll),:));
% %rgb2 = insertMarker(10*rgb, zivCentroids);
% catch
%     rgb2=rgb;
% end
% 
% figure;
% imshow(rgb2);
% 
