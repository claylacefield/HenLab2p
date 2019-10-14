function compareMidCueAmp(cueCellStruc, mapInd, multSessSegStruc)

numSess = size(mapInd,2);

cellsInAll = mapInd(find(prod(mapInd,2)~=0),:);

%%
% for all sessions
for i = 1:size(mapInd,2)
    
      
    % Calculate Cue shift tuning
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
        bps(i,j) = multSessSegStruc(j).cueShiftStruc.PCLappedSessCell{multSessSegStruc(j).refLapType}.InfoPerSpk(cellsInAll(i,j));
    end
end

[h, p] = ttest2(bps(:,1),bps(:,2));









    