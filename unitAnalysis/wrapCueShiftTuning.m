function [cueShiftStruc] = wrapCueShiftTuning(varargin); %pksCell, goodSeg, treadBehStruc,lapTypeInfo, )

% % if input is cell array of peaks
% if iscell(C)
%     cCell = C;
%     C = zeros(length(C),round(length(treadBehStruc.resampY)/2));
%     for i = 1:length(cCell)
%         C(i,cCell{i})=1;
%     end
% end

% %% format position vector
% totalFrames = size(C,2);
% resampY = treadBehStruc.resampY;
% downSamp = round(length(resampY)/totalFrames);  % find downsample rate
% treadPos = resampY(1:downSamp:end); % downsample position vector
% treadPos = treadPos/max(treadPos);  % normalize position vector
try
filename = findLatestFilename('_goodSeg_');
load(filename); 
catch
    disp('Cant find goodSeg');
end

disp(['Calculating cue shift tuning for ' filename]);

if nargin==1
    if ischar(varargin{1}) % if arg is char (any letter key), then load latest treadBehStruc
        load(findLatestFilename('treadBehStruc'));
    elseif iscell(varargin{1})  % if cell arr, then its pksCell (for quickTuning)
        pksCell = varargin{1};
        [treadBehStruc] = procHen2pBehav('auto', 'cue');
        goodSeg = 1:length(pksCell);
    else  % or if it's a struc it's treadBehStruc
        treadBehStruc = varargin{1};
    end
else
    treadName = uigetfile('*.mat', 'Select treadBehStruc');
    load(treadName);
end

%% format other stuff
T = treadBehStruc.adjFrTimes(1:2:end);

[pksCellCell, posLapCell, lapFrInds] = sepCueShiftLapSpkTimes(pksCell, goodSeg, treadBehStruc); %, lapTypeInfo);

posLap1 = posLapCell{1}; posLap2 = posLapCell{2};
pksCell1 = pksCellCell{1}; pksCell2 = pksCellCell{2};

posLap1 = posLap1/max(posLap1); posLap2 = posLap2/max(posLap2);

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
    spikes = spikeCell{typeNum};
    treadPos = posLapCell{typeNum}; treadPos = treadPos/max(treadPos);
    disp(['Calculating tuning for lapType ' num2str(typeNum)]); tic;
    PCLappedSessCell{typeNum} = computePlaceCellsLappedWithEdges3(spikes, treadPos, T(1:length(posLapCell{typeNum})), shuffN);
    toc;
end

% disp('Calc lapType2 tuning'); tic;
% spikes = C2; treadPos = posLap2;
% PCLappedSess2 = computePlaceCellsLappedWithEdges3a(spikes, treadPos, T(1:length(posLap2)), shuffN);
% toc;
% 
% cueShiftStruc.PCLappedSess1 = PCLappedSess1;
% cueShiftStruc.PCLappedSess2 = PCLappedSess2;
% cueShiftStruc.pksCell1=pksCell1; cueShiftStruc.posLap1=posLap1; 
% cueShiftStruc.pksCell2=pksCell2; cueShiftStruc.posLap2=posLap2; cueShiftStruc.lapFrInds=lapFrInds;

cueShiftStruc.pksCellCell = pksCellCell;
cueShiftStruc.posLapCell = posLapCell;
cueShiftStruc.lapFrInds = lapFrInds;
cueShiftStruc.PCLappedSessCell = PCLappedSessCell;

% refLapType = 2;
% plotCueShiftStruc(cueShiftStruc, refLapType);

% 
% pc = find(PCLappedSess1.Shuff.isPC==1);
% posRates1 = PCLappedSess1.posRates(pc,:);
% [maxVal, maxInd] = max(posRates1');
% [newInd, oldInd] = sort(maxInd);
% sortInd = oldInd;
% posRates1 = posRates1(sortInd,:);
% 
% posRates2 = PCLappedSess2.posRates(pc,:);
% posRates2 = posRates2(sortInd,:);
% 
% figure('Position', [0 0 800 800]);
% subplot(2,2,1);
% colormap(jet);
% imagesc(posRates1);
% xlabel('position');
% title('LapType1');
% 
% % tuning of lapType2 PCs
% subplot(2,2,2);
% colormap(jet);
% imagesc(posRates2);
% xlabel('position');
% title('LapType2');
% 
% % and mean of each
% subplot(2,2,3);
% plot(mean(posRates1,1));
% hold on;
% plot(mean(posRates2,1),'g');
% title('posRates1=b, posRates2=g');
% 
% 
