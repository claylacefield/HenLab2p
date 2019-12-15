function [bps,mrl] = compareMidCueAmp(cueCellStruc, mapInd, multSessSegStruc)


% Clay Oct.2019
% To look at plasticity during experience with a cue.
% Originally this was going to look at the cue-triggered event amplitude
% for midCueCells, but currently it just looks at InfoPerSpk for all cells
% (PCs at least)
% 1. find cells in all the sessions
% 2. calc. cueShiftStruc for each sess
% 3. get InfoPerSpk for each of these cells

numSess = size(mapInd,2);   % number of sessions

cellsInAll = mapInd(find(prod(mapInd,2)~=0),:); % cells found in all sessions

%%
% for all sessions
for i = 1:size(mapInd,2)
    
      
    % Calculate Cue shift tuning for registered sessions
    [cueShiftStruc] = wrapCueShiftTuningMultSess(multSessSegStruc(i).pksCell, multSessSegStruc(i).treadBehStruc);
    [refLapType] = findRefLapType(cueShiftStruc);
    % Find CueCells based on position and 2XPF omit/shift response
%     [MidCueCellInd, EdgeCueCellInd, nonCueCellInd,  refLapType] =  AllCueCells(cueShiftStruc);
%     PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
%     placeCellInd{i} = find(PCLappedSessCue.Shuff.isPC==1);
    multSessSegStruc(i).cueShiftStruc = cueShiftStruc;
    multSessSegStruc(i).refLapType = refLapType;
%     multSessSegStruc(i).MidCueCellInd = MidCueCellInd;
%     multSessSegStruc(i).EdgeCueCellInd = EdgeCueCellInd;
%     multSessSegStruc(i).nonCueCellInd = nonCueCellInd;
end

for i=1:size(cellsInAll,1) % for all registered cells
    for j=1:size(cellsInAll,2) % for each session
        bps(i,j) = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{multSessSegStruc(j).refLapType}.InfoPerSec(cellsInAll(i,j));
        mrl(i,j) = clayMRL(multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{multSessSegStruc(j).refLapType}.posRates(cellsInAll(i,j),:), 0);
    end
end

[h, p] = ttest2(bps(:,1),bps(:,2));
[h, p] = ttest2(mrl(:,1),mrl(:,2));

% figure; 
% plot(bps(ciaInd,1),bps(ciaInd,2),'.'); 
% hold on; 
% line(get(gca,'xlim'), get(gca,'ylim'));

%for i=1:length(cueCells); ciaInd(i) = find(cellsInAll(:,1)==cueCells(i)); end






    