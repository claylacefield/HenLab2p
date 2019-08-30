function [cueShiftStruc] = quickTuningS2P(varargin) % lapTypeInfo)

% Quickly performs rough peak detection post-Caiman and looks at tuning

if length(varargin)==1
    if length(varargin{1})==1
        rewOmit = varargin{1};
    else
        lapTypeInfo = varargin{1};
        rewOmit = 0;
    end
elseif length(varargin)==2
    if length(varargin{1})==1
        rewOmit = varargin{1};
        lapTypeInfo = varargin{2};
    else
        lapTypeInfo = varargin{1};
        rewOmit = varargin{2};
    end
    
else
    rewOmit = 0;
end



% load in goodSeg if present?
try 
    load(findLatestFilename('seg2P'));
    disp('Loading latest seg2P');
catch
[seg2PName, path] = uigetfile('*.mat', 'Choose seg2P to perform quick tuning (curr for cue task)');
cd(path);
load([path '/' seg2PName]);
end

C = seg2P.C2p;
A = seg2P.A2p;
d1 = seg2P.d12p;
d2 = seg2P.d22p;
pksCell = seg2P.pksCell;
fps = 15;



% toPlot = 2; % to plot only PCs
% calcPvals = 0;
% [unitTuningStruc] = wrapTuningNewClay(pksCell, fps, toPlot, calcPvals);

disp('Running wrapCueShiftTuning based upon pksCell');
if exist('lapTypeInfo')==0
[cueShiftStruc] = wrapCueShiftTuning(pksCell, rewOmit); % (lapTypeInfo, 
else
    [cueShiftStruc] = wrapCueShiftTuning(pksCell, rewOmit,lapTypeInfo);
end

% make filename and save to output struc
basename = findLatestFilename('.xml');
basename = basename(1:strfind(basename, '.xml')-1);
filename = [basename '_2PcueShiftStruc_' date '.mat'];
cueShiftStruc.filename = filename;
cueShiftStruc.path = pwd;

% save output struc to current folder
save(filename, 'cueShiftStruc');

%% Plotting
% Try to sort lapTypes based upon "normal" lap type (if possible)
%posLapCell = cueShiftStruc.posLapCell;
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:length(cueShiftStruc.pksCellCell)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType); % use ref lap from one with most laps 

plotCueShiftStruc(cueShiftStruc, refLapType,1);