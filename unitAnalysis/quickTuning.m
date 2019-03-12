function [cueShiftStruc, pksCell] = quickTuning() % lapTypeInfo)

% Quickly performs rough peak detection post-Caiman and looks at tuning

[segDictName, path] = uigetfile('*.mat', 'Choose segDict to perform quick tuning (curr for cue task)');
cd(path);
load([path '/' segDictName]);

fps = 15;

disp('Calculating transients');
sdThresh = 3;
timeout = 3;
toPlot = 0;
tic;
for seg = 1:size(C,1)
pksCell{seg} = clayCaTransients(C(seg,:), fps, toPlot, sdThresh, timeout);
end
toc;


% toPlot = 2; % to plot only PCs
% calcPvals = 0;
% [unitTuningStruc] = wrapTuningNewClay(pksCell, fps, toPlot, calcPvals);


[cueShiftStruc] = wrapCueShiftTuning(pksCell); % (lapTypeInfo, 
