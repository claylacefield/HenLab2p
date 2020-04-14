function [noCueGroupStruc] = noCueTuningGroup(pathCell)

% Clay 2020
% Look at tuning for all noCue sessions in pathCell (using
% findSessString('noCue') on clay/DGdata

for i = 1:length(pathCell)
    try
        cd(pathCell{i});
        disp(['Processing ' pathCell{i}]);
        if length(findLatestFilename('cueShiftStruc'))<1
            [cueShiftStruc] = noCueTuning();
        else
            load(findLatestFilename('cueShiftStruc'));
        end
        noCueGroupStruc(i) = cueShiftStruc;
    catch
        disp(['Problem processing ' pathCell{i}]);
    end
end