function [cellTypeLapStruc] = plotCellTypeLapRates()


%% 
% Clay Dec. 2019


cueShiftStrucName = findLatestFilename('cueShiftStruc');
%                     if ~isempty(cueShiftStrucName)
%                         load(cueShiftStrucName);
%                     else
%                         [cueShiftStruc, pksCell] = quickTuning();
%                         cueShiftStrucName = findLatestFilename('cueShiftStruc');
%                     end

load(cueShiftStrucName);

if contains(cueShiftStrucName, '2P')
    segDictName =  findLatestFilename('seg2P', 'goodSeg'); % exclude "goodSeg" files if present
else
    segDictName =  findLatestFilename('segDict');
end

load(findLatestFilename('treadBehStruc'));

%% find lap types
try
    lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
catch
    lapTypeArr = [];
end

refLapType = findRefLapType(cueShiftStruc);

% find lap types
numLaps = length(lapTypeArr);
normLapInds = find(lapTypeArr==refLapType);
omitLapInds = find(lapTypeArr==0);

omitLapInds = omitLapInds(omitLapInds~=1 & omitLapInds<numLaps); % trim omit laps

if refLapType==2
    shiftLapType = 1;
else
    shiftLapType = 2;
end
shiftLapInds = find(lapTypeArr==shiftLapType);


%% find the cue type for eventName
try
    eventName = cueShiftStruc.lapCueStruc.cueType;
catch
    [cueTypes] = findCueTypes(treadBehStruc);
    eventName = cueTypes{1};
end
toPlot = 0;
try
    [cueCellStruc] = findCueCells(cueShiftStruc, eventName, segDictName, toPlot);
    %n=n+1;
    midCueCellInd = cueCellStruc.midCueCellInd3; % 2x normal/omit PF rate
catch e
    disp('Problem finding cue cells');
    fprintf(1,'The identifier was:\n%s', e.identifier);
    fprintf(1,', error message:\n%s', e.message);
    disp(' ');
end



%% plotting
posRatesLap = cueShiftStruc.PCLappedSessCell{refLapType}.ByLap.posRateByLap;

figure('Position', [100, 100, 1200, 400]);
cellInd = cueCellStruc.midCueCellInd3;
subplot(2,6,1);
%colormap(jet);
imagesc(squeeze(mean(posRatesLap(cellInd,:,:),1))');
cl = caxis;
title('midCueCell');
subplot(2,6,7);
plot(squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','g'); hold on; 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))','r'); 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))'-squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','b');
%legend('1st 10laps', 'last 10laps', 'diff');

cellInd = cueCellStruc.startCueCellInd;
subplot(2,6,2);
imagesc(squeeze(mean(posRatesLap(cellInd,:,:),1))'); %caxis(cl);
title('startCueCell');
subplot(2,6,8);
plot(squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','g'); hold on; 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))','r'); 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))'-squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','b');

cellInd = cueCellStruc.nonCueCellInd;
subplot(2,6,3);
imagesc(squeeze(mean(posRatesLap(cellInd,:,:),1))'); %caxis(cl);
title('nonCueMidCell');
subplot(2,6,9);
plot(squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','g'); hold on; 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))','r'); 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))'-squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','b');

pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);
cellInd = setxor(pc, [cueCellStruc.nonCueCellInd; cueCellStruc.startCueCellInd; cueCellStruc.midCueCellInd]);
subplot(2,6,4);
imagesc(squeeze(mean(posRatesLap(cellInd,:,:),1))'); %caxis(cl);
title('all other PCs');
subplot(2,6,10);
plot(squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','g'); hold on; 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))','r'); 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))'-squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','b');

cellInd = setxor(1:size(posRatesLap,1), pc);
subplot(2,6,5);
imagesc(squeeze(mean(posRatesLap(cellInd,:,:),1))'); %caxis(cl);
title('non PCs');
subplot(2,6,11);
plot(squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','g'); hold on; 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))','r'); 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))'-squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','b');

cellInd = 1:size(posRatesLap,1);
subplot(2,6,6);
imagesc(squeeze(mean(posRatesLap(cellInd,:,:),1))'); %caxis(cl);
title('all cells');
subplot(2,6,12);
plot(squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','g'); hold on; 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))','r'); 
plot(squeeze(mean(mean(posRatesLap(cellInd,:,end-10:end),1),3))'-squeeze(mean(mean(posRatesLap(cellInd,:,1:10),1),3))','b');

%% saving output
cellTypeLapStruc.path = pwd;
cellTypeLapStruc.cueShiftStrucName = cueShiftStrucName;
cellTypeLapStruc.segDictName = segDictName;
cellTypeLapStruc.cueCellStruc = cueCellStruc;
cellTypeLapStruc.midCueCellPosRatesLap = posRatesLap(cueCellStruc.midCueCellInd3,:,:);
cellTypeLapStruc.startCueCellPosRatesLap = posRatesLap(cueCellStruc.startCueCellInd,:,:);
cellTypeLapStruc.nonCueCellPosRatesLap = posRatesLap(cueCellStruc.nonCueCellInd,:,:);
cellTypeLapStruc.otherPcPosRatesLap = posRatesLap(setxor(pc, [cueCellStruc.nonCueCellInd; cueCellStruc.startCueCellInd; cueCellStruc.midCueCellInd]),:,:);