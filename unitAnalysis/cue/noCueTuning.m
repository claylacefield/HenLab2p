function [cueShiftStruc] = noCueTuning()

% USAGE: [cueShiftStruc] = noCueTuning(); % to be run within session folder
% Clay Fall 2019


path = pwd;
slashInds = strfind(path,'/');
basename = path(slashInds(end)+1:end);


% load goodSeg if present
try
segDictName = findLatestFilename('_seg2P_');
load(segDictName); 
C = seg2P.C2p;
pksCell = seg2P.pksCell;
filename = [basename '_noCueShiftStrucQuick2p_' date '.mat'];
catch
    disp('Cant find seg2P so using CNMF');
    segDictName = findLatestFilename('_segDict_', 'goodSeg');
    load(segDictName);
    %fps = 15;
    [fps, numCh] = find2pScanParams();
    
    disp('Calculating transients');
    sdThresh = 3;
    timeout = 3;
    toPlot = 0;
    tic;
    for seg = 1:size(C,1)
        pksCell{seg} = clayCaTransients(C(seg,:), fps, toPlot, sdThresh, timeout);
    end
    toc;
    filename = [basename '_noCueShiftStrucQuickTuning_' date '.mat'];
end
disp(['Calculating cue shift tuning for ' segDictName]);

% load treadBehStruc or create if necessary 
try
    load(findLatestFilename('treadBehStruc'));
catch
    disp('Couldnt find previous treadBehStruc so processing');
    [treadBehStruc] = procHen2pBehav('auto', 'cue');
end


cueShiftStruc.filename = filename;
cueShiftStruc.path = path;
cueShiftStruc.segDictName = segDictName;

% just do PC calculation for all laps
[PCLappedSess] = wrapAndresPlaceFieldsClay(pksCell, 0, treadBehStruc);
%pc = find(PCLappedSess.Shuff.isPC==1);
cueShiftStruc.PCLappedSessCell{1} = PCLappedSess;

% Look at PFs only to look for periodicity of PFs without cues
% PFs of pc's only
try
[posBinFrac, posInfo, pcRatesBlanked, pcOmitRatesBlanked, pfOnlyRates, pfOnlyRatesOmit] = cuePosInhib(cueShiftStruc, 0, 1, 1);
catch
end
%cueShiftStruc.


% figure; 
% subplot(2,1,2);
% plot(nanmean(pfOnlyRates,1));
% subplot(2,1,1);
% imagesc(pfOnlyRates);
% title([segDictName 'pfOnly rates']);

plotCueShiftStruc(cueShiftStruc,1,1);

save(filename, 'cueShiftStruc');
