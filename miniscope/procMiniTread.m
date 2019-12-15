function procMiniTread()

% Clay 2019
% To process TDML data of treadmill behavior along with Jack Berry's CNMF
% output from miniscope imaging.

%% load CNMF data
load(uigetfile('*.mat', 'Select MAT file with C struc'));
fps = Fs; % imaging sample freq
numFrames = size(C,2);
%sessDur = numFrames/fps;

%% process behav
if ~isempty(findLatestFilename('treadBehStruc'))
    load(findLatestFilename('treadBehStruc'));
else
    [treadBehStruc] = procHenMiniBehav(numFrames,fps);
end

%%
disp('Calculating transients');
sdThresh = 3;
timeout = 3;
toPlot = 0;
tic;
for seg = 1:size(C,1)
    pksCell{seg} = clayCaTransients(C_raw(seg,:), fps, toPlot, sdThresh, timeout);
end
toc;


disp('Running wrapCueShiftTuning based upon quick pksCell');
rewOmit = 0;
% if exist('lapTypeInfo')==0
[cueShiftStruc] = wrapCueShiftTuning(pksCell, rewOmit); % (lapTypeInfo, 
% else
%     [cueShiftStruc] = wrapCueShiftTuning(pksCell, rewOmit,lapTypeInfo);
% end


%%

tbsName = findLatestFilename('treadBehStruc');
undScor = strfind(tbsName, '_');
basename = tbsName(1:undScor(3));
save([basename 'cueShiftStrucQuickTuning_' date '.mat'], 'cueShiftStruc');

try
plotCueShiftStruc(cueShiftStruc,0,0);
catch
    disp('Prob plotting');
end


