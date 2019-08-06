function [cueShiftStruc] = wrapCueShiftTuningMultSess(varargin) %pksCell, goodSeg, treadBehStruc,lapTypeInfo, )

% Examples
% [cueShiftStruc] = wrapCueShiftTuning(); % processes current folder, all
% segs in folder segDict (but only plots isPC?)
% [cueShiftStruc] = wrapCueShiftTuning(pksCell); % input pksCell (e.g. from
% quickTuning)
% [cueShiftStruc] = wrapCueShiftTuning(rewOmit); % for cue sessions with
% rewOmit trials
% [cueShiftStruc] = wrapCueShiftTuning(lapTypeInfo); % to input lap
% sequence or lapTypeArr
% [cueShiftStruc] = wrapCueShiftTuning(pksCell, rewOmit, lapTypeInfo); %
% (or any combinations of these?) 

% parse arguments (and fill in rest with defaults)
if length(varargin) ==1
    if iscell(varargin{1})  % if cell arr, then its pksCell (for quickTuning)
        pksCell = varargin{1};
        goodSeg = 1:length(pksCell);
        rewOmit = 0;
    elseif length(varargin{1})==1
        rewOmit = varargin{1};
    else
        lapTypeInfo = varargin{1};
        rewOmit = 0;
    end
elseif length(varargin)==2
    if iscell(varargin{1})  % if cell arr, then its pksCell (for quickTuning)
        pksCell = varargin{1};
        goodSeg = 1:length(pksCell);
        treadBehStruc = varargin{2};
        rewOmit = 0;
%         if length(varargin{2})==1
%             rewOmit = varargin{2};
%         else
%             lapTypeInfo = varargin{2};
%             rewOmit = 0;
%         end
    else
        if length(varargin{1})==1
            rewOmit = varargin{1};
            lapTypeInfo = varargin{2};
        else
            lapTypeInfo = varargin{1};
            rewOmit = varargin{2};
        end
    end
elseif length(varargin)==3
    pksCell = varargin{1};
    goodSeg = 1:length(pksCell);
    if length(varargin{2})==1
        rewOmit = varargin{2};
        lapTypeInfo = varargin{3};
    else
        lapTypeInfo = varargin{2};
        rewOmit = varargin{3};
    end
    
else
    rewOmit=0;
    
end


%% format other stuff
T = treadBehStruc.adjFrTimes(1:2:end);

if exist('lapTypeInfo')==0
[pksCellCell, posLapCell, lapCueStruc] = sepCueShiftLapSpkTimesMulti(pksCell, goodSeg, treadBehStruc, rewOmit); %, lapTypeInfo);
else
    [pksCellCell, posLapCell, lapCueStruc] = sepCueShiftLapSpkTimesMulti(pksCell, goodSeg, treadBehStruc, rewOmit, lapTypeInfo);
end



% build spike arrays from spk times
for typeNum = 1:length(pksCellCell)
    spikeCell{typeNum} = zeros(length(pksCellCell{typeNum}),length(posLapCell{typeNum}));
    for i = 1:length(pksCellCell{typeNum})
        spikeCell{typeNum}(i,pksCellCell{typeNum}{i})=1;
    end
end

% Calculate tuning for each lap type (and concat struc in cell array)
shuffN = 1000;
for typeNum = 1:length(pksCellCell)
    try
    spikes = spikeCell{typeNum};
    treadPos = posLapCell{typeNum}; treadPos = treadPos/max(treadPos);
    disp(['Calculating tuning for lapType ' num2str(typeNum)]); tic;
    PCLappedSessCell{typeNum} = computePlaceCellsLappedWithEdges3(spikes, treadPos, T(1:length(posLapCell{typeNum})), shuffN);
    toc;
    catch
        PCLappedSessCell{typeNum} = [];
        disp(['Prob with lapType ' num2str(typeNum)]);
    end
end


cueShiftStruc.filename = findLatestFilename('.h5');  %doesn't work need to change
cueShiftStruc.pksCellCell = pksCellCell;
cueShiftStruc.posLapCell = posLapCell;
cueShiftStruc.lapCueStruc = lapCueStruc;
cueShiftStruc.PCLappedSessCell = PCLappedSessCell;


