function [pkShiftPC, pkPosPC] = xcorrSameCellPosRates(multSessSegStruc, mapInd, toPlot)

%% USAGE: [pkShift, pkPosSeg] = xcorrSameCellPosRates(cueShiftStruc, toPlot);
% FROM: [pkShift, pkPosSeg] = xcorrPosRates(cueShiftStruc, toPlot);
% Clay April 2020
% For CONTEXT data originally. Xcorr posRates for tuned cells in contexts A
% & B.
% Example data: '/Backup20TB/Analysis cuePaper/shCombCtx.mat'


filename = multSessSegStruc.filename;
posRates1 = multSessSegStruc(2).PCLapSess.posRates; % this should be the second of the two same context sessions
posRates2 = multSessSegStruc(3).PCLapSess.posRates;    % this should be the other context
%mapInd = ShCombCtx{1}.regMapInd;

% find cells in oboth of these sessions
cellsInBoth = intersect(find(mapInd(:,2)~=0), find(mapInd(:,3)~=0)); % Note: index of mapInd row
pc1 = find(multSessSegStruc(2).PCLapSess.Shuff.isPC==1);
pc2 = find(multSessSegStruc(3).PCLapSess.Shuff.isPC==1);
pc1both = intersect(pc1, mapInd(cellsInBoth,2)); % seg num of pc1 also in 2
for j=1:length(pc1both)
pc1bInd(j,1)= find(mapInd(:,2)==pc1both(j));
end
cellsInBoth = pc1bInd; % now this is cells in both, which are PCs in sess 1

figure('Position', [200, 200, 800, 400]); 
subplot(1,2,1);
[sortInd] = plotPosRates(posRates1(mapInd(cellsInBoth,2),:),0,1);
posRates2b = posRates2(mapInd(cellsInBoth,3),:);
subplot(1,2,2);
colormap(jet); imagesc(posRates2b(sortInd,:));

n=0;
for i = 1:length(cellsInBoth) % for all cells registered in both sessions
    %% center pk to middle (mainly helps w edge cells)
    % (prob not neces for same session?)
    % shift shiftCue laps the same amount as normal ones
    if ~isempty(find(pc1both==mapInd(cellsInBoth(i),2)))
        n = n+1;
    posRates1seg = posRates1(mapInd(cellsInBoth(i),2),:);
    posRates2seg = posRates2(mapInd(cellsInBoth(i),3),:);
    
    [val, pkPosSeg] = max(posRates1seg); % find peak rate pos
    pkPos(i) = pkPosSeg;
    if pkPosSeg<50
        posRates1s = circshift(posRates1seg, 50-pkPosSeg); % and shift to middle
        posRates2s = circshift(posRates2seg, 50-pkPosSeg);
    else
        posRates1s = circshift(posRates1seg, -(pkPosSeg-50));
        posRates2s = circshift(posRates2seg, -(pkPosSeg-50));
    end
    
%     figure; hold on;
%     plot(posRates1(i,:)); plot(posRates2(i,:),'r');
%     plot(posRates1s,'c'); plot(posRates2s,'m');
    
    %% xcorr centered posRates
    xc = xcorr(posRates1s, posRates2s);  % xcorr centered
    
    [val, offset] = max(xc); % xcorr peak
    
    pkShift(n) = offset - 100;  % calc pkDiff from xcorr offset
    end
end

pkShift(abs(pkShift)>50)=NaN; % sometimes shift doesn't exist so NaN it

%%
posRates1same = posRates1(mapInd(cellsInBoth,2),:);
posRates2same = posRates2(mapInd(cellsInBoth,3),:);


pc = find(multSessSegStruc(3).PCLapSess.Shuff.isPC==1);
pkPosPC = pkPos(pc); 
pkShiftPC = pkShift(pc); % just take PCs

%% plotting
% [sortInd] = plotPosRates(posRates, toNorm, toPlotNull);
if toPlot==1
       
    figure; plot(pkPosPC, pkShiftPC,'.');
    try title(filename); catch; end
    xlabel('pkPos'); ylabel('pkShift');
    
    
    nBins = 20;
    [N, edges, bins] = histcounts(pkPosPC,nBins);
    for j=1:nBins
        binPkShift = pkShiftPC(bins==j);
        avShift(j) = nanmean(binPkShift);
        semShift(j) = std(binPkShift)/sqrt(length(avShift));
    end
    figure; bar(avShift); 
    xlabel('posBin'); ylabel('xcorr pk shift (bins out of 100)');
    try title(filename); catch; end
end
