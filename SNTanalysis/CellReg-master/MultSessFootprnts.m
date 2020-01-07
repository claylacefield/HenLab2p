load(findLatestFilename('multSessSegStruc'));
for i = 1:length (multSessSegStruc)
temp = multSessSegStruc(i).A;
temp = temp';
temp = full(temp);
footprints = reshape(temp,size(temp,1),multSessSegStruc(i).d1,multSessSegStruc(i).d2);
save(['footprints' num2str(i)],'footprints')
end

%%
%[multSessSegStruc] = wrapMultSessStrucSelectCue2P();
close all; clear all;
load(findLatestFilename('multSessSegStruc')); load(findLatestFilename('cellRegistered')); 
 [sameCellCueShiftTuningStruc] = sameCellCueShiftTuning2P(multSessSegStruc, cell_registered_struct);
save('sameCellCueShiftTuningStruc.mat', 'sameCellCueShiftTuningStruc');
%%
[remapSpatCellStruc] = sameSpatCellRemap2P(sameCellCueShiftTuningStruc);
save('remapSpatCellStruc.mat', 'remapSpatCellStruc');
[remapCueShiftStruc] = CueShiftsameCellRemap2P(sameCellCueShiftTuningStruc);
save('remapCueShiftStruc.mat', 'remapCueShiftStruc');

