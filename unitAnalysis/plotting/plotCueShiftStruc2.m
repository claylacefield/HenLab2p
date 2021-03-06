function plotCueShiftStruc2(cueShiftStruc, varargin)

% mod of plotCueShiftStruc 2020
% for use with wrapCueShiftTuning

% refLapType, usePC, colormap, normalization, timePlot

% argument parser
argCell = varargin{1};

for i=1:length(argCell)
    eval(argCell{i});
end

if ~exist('normRates')
    normRates = 0;
end
if ~exist('usePC')
    usePC = 1;
end
if ~exist('refLapType')
    refLapType = 0;
end
if ~exist('cmap')
    cmap = jet;
end
if ~exist('timePlot')
    timePlot = 0;
end

%%

numLapTypes = length(cueShiftStruc.PCLappedSessCell); %pksCellCell);

if numLapTypes>1
    if refLapType==0
        lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
        lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
        for i=1:length(cueShiftStruc.pksCellCell)
            numLapType(i) = length(find(lapTypeArr==i));
        end
        [val, refLapType] = max(numLapType); % use ref lap from one with most laps
    end
else
    refLapType=1;
end

% select place cells
pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);
% Now compile PCs from all types
% pc=[];
% for i=1:numLapTypes
%     pcType = find(cueShiftStruc.PCLappedSessCell{i}.Shuff.isPC==1);
%     %pcType = find(cueShiftStruc.PCLappedSessCell{i}.InfoPerSpk>=3.5);
%     pc = [pc; pcType];
% end
% pc = sort(unique(pc));

% find PCs and posRates for reference lap type
posRates = cueShiftStruc.PCLappedSessCell{refLapType}.posRates;

if usePC == 1
    posRates = posRates(pc,:);
end

[maxVal, maxInd] = max(posRates');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;
posRates = posRates(sortInd,:);
posRatesCell{refLapType} = posRates;

% now for all lap types with PCs and sorted based upon reference type 
for i = 1:numLapTypes
    try
        posRates = cueShiftStruc.PCLappedSessCell{i}.posRates;
        if usePC==1
            posRates = posRates(pc,:);
        end
        
        if normRates==1
           for j=1:size(posRates,1)
              posRates(j,:) = posRates(j,:)/max(posRates(j,:)); 
           end
        end
        
        posRatesCell{i} = posRates(sortInd,:);
    catch
        disp(['Prob with lap type ' num2str(i)]);
    end
end

figure('Position', [0 0 1000 800]);

numCols = ceil((numLapTypes+1)/2);

lapTypeList = 1:numLapTypes;
if refLapType~=1
    lapTypeList = [refLapType lapTypeList(lapTypeList~=refLapType)];
end

for i = 1:numLapTypes
    j = lapTypeList(i);
    try
        subplot(2,numCols,i);
        colormap(cmap);
        imagesc(posRatesCell{j});
        %colorbar;
        xlabel('position');
        if i==1
            cl = caxis;
            title(cueShiftStruc.filename(1:strfind(cueShiftStruc.filename,'cueShift')-2));
        else
            caxis(cl);
            title(['LapType '  num2str(j)]);
        end

    catch
    end
    %numCell{i}=num2str(j);
end

% and mean of each
subplot(2,numCols,numLapTypes+1); hold on;
for i = 1:numLapTypes
    try
        plot(nanmean(posRatesCell{i},1));
    catch
    end
    numCell{i}=num2str(i);
end
%title('posRates1=b, posRates2=g');
legend(numCell);



% sorted unit time plot
if timePlot==1
figure;
try
if ~contains(cueShiftStruc.filename, '2P')
load(findLatestFilename('segDict', 'goodSeg'),'C'); % exclude goodSeg files
else
    load(findLatestFilename('seg2P', 'goodSeg'));
    C = seg2P.C2p;
end

try
if usePC==1
cpc = C(pc,:);
else
    cpc = C;
end
catch
    cpc = C(pc,:);
end

for i=1:size(cpc,1); cpc2(i,:) = (cpc(i,:)-min(cpc(i,:)))/(max(cpc(i,:))-min(cpc(i,:))); end
imagesc(cpc2(sortInd,:));
title('C for all PCs');

catch
end
end