function plotCellTypeLapGroupStruc(cellTypeLapGroupStruc)

% from output of plotCellTypeLapRates,
% compiled with cellTypeLapGroupStruc = [cellTypeLapGroupStruc cellTypeLapStruc];

% create output arrays of NaNs

midCell = NaN(100,100,45);


midCells = [];
startCells = [];
nonCells = [];
otherCells = [];

% concatenate cells by type from each session
for i=1:length(cellTypeLapGroupStruc)
    % extract posRateLap for each cell type
    midCell = cellTypeLapGroupStruc(i).midCueCellPosRatesLap;
    startCell = cellTypeLapGroupStruc(i).startCueCellPosRatesLap;
    nonCell = cellTypeLapGroupStruc(i).nonCueCellPosRatesLap;
    otherCell = cellTypeLapGroupStruc(i).otherPcPosRatesLap;
    nLaps = size(midCell,3);
    
    % pad laps
    midCell = cat(3, midCell, repmat(NaN,size(midCell,1), 100, 42-nLaps));
    startCell = cat(3, startCell, repmat(NaN,size(startCell,1), 100, 42-nLaps));
    nonCell = cat(3, nonCell, repmat(NaN,size(nonCell,1), 100, 42-nLaps));
    otherCell = cat(3, otherCell, repmat(NaN,size(otherCell,1), 100, 42-nLaps));
    
    midCells = cat(1,midCells, midCell);
    startCells = cat(1,startCells, startCell);
    nonCells = cat(1,nonCells, nonCell);
    otherCells = cat(1,otherCells, otherCell);
    
end

midCellAv = squeeze(nanmean(midCells,1))';
startCellAv = squeeze(nanmean(startCells,1))';
nonCellAv = squeeze(nanmean(nonCells,1))';
otherCellAv = squeeze(nanmean(otherCells,1))';

% plot cell type avgs
figure('Position', [100, 100, 1200, 400]);
dim1 = 2; dim2 = 4; range1 = 1:10; range2 = 20:30;
subplot(dim1,dim2,1);
colormap(jet);
imagesc(midCellAv(2:30,:));
cl = caxis;
title('midCueCell');
subplot(dim1,dim2,dim2+1);
plot(mean(midCellAv(range1,:),1),'g');
hold on; 
plot(mean(midCellAv(range2,:),1),'r');
plot(mean(midCellAv(range2,:),1)-mean(midCellAv(range1,:),1),'b');
ylim([-0.05, 0.2]);

subplot(dim1,dim2,2);
imagesc(startCellAv(2:30,:)); caxis(cl);
title('startCueCell');
subplot(dim1,dim2,dim2+2);
plot(mean(startCellAv(range1,:),1),'g');
hold on; 
plot(mean(startCellAv(range2,:),1),'r');
plot(mean(startCellAv(range2,:),1)-mean(startCellAv(range1,:),1),'b');
ylim([-0.05, 0.2]);

subplot(dim1,dim2,3);
imagesc(nonCellAv(2:30,:)); caxis(cl);
title('nonCueCell');
subplot(dim1,dim2,dim2+3);
plot(mean(nonCellAv(range1,:),1),'g');
hold on; 
plot(mean(nonCellAv(range2,:),1),'r');
plot(mean(nonCellAv(range2,:),1)-mean(nonCellAv(range1,:),1),'b');
ylim([-0.05, 0.2]);

subplot(dim1,dim2,4);
imagesc(otherCellAv(2:30,:)); caxis(cl);
title('otherPC');
subplot(dim1,dim2,dim2+4);
plot(mean(otherCellAv(range1,:),1),'g');
hold on; 
plot(mean(otherCellAv(range2,:),1),'r');
plot(mean(otherCellAv(range2,:),1)-mean(otherCellAv(range1,:),1),'b');
ylim([-0.05, 0.2]);



