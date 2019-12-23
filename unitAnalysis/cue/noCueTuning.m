function [cueShiftStruc] = noCueTuning()



% load goodSeg if present
try
filename = findLatestFilename('_seg2P_');
load(filename); 
C = seg2P.C2p;
pksCell = seg2P.pksCell;
catch
    disp('Cant find seg2P');
end
disp(['Calculating cue shift tuning for ' filename]);

% load treadBehStruc or create if necessary 
try
    load(findLatestFilename('treadBehStruc'));
catch
    disp('Couldnt find previous treadBehStruc so processing');
    [treadBehStruc] = procHen2pBehav('auto', 'cue');
end

[PCLappedSess] = wrapAndresPlaceFieldsClay(pksCell, 0, treadBehStruc);
%pc = find(PCLappedSess.Shuff.isPC==1);
cueShiftStruc.PCLappedSessCell{1} = PCLappedSess;

% Look at PFs only to look for periodicity of PFs without cues
% PFs of pc's only
[posBinFrac, posInfo, pcRatesBlanked, pcOmitRatesBlanked, pfOnlyRates, pfOnlyRatesOmit] = cuePosInhib(cueShiftStruc, 0, 1, 1);

figure; 
subplot(2,1,2);
plot(nanmean(pfOnlyRates,1));
subplot(2,1,1);
imagesc(pfOnlyRates);
title([filename 'pfOnly rates']);


