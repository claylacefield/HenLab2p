function [midCueAllEvCell, midCueAllEvCellZ] = avgCueTrigSigMulti(sameCellCueShiftTuningStruc, eventName)


%% USAGE: [midCueAllEvCell, midCueAllEvCellZ] = avgCueTrigSigMulti(sameCellCueShiftTuningStruc, eventName);
%
% Clay Oct2019
% 

% eventName = 'led' to make 'ledTime', etc.

%cd('/Backup20TB/clay/DGdata');

multSessSegStruc = sameCellCueShiftTuningStruc.multSessSegStruc;
%regMapInd = sameCellCueShiftTuningStruc.regMapInd;
cellsInAll = sameCellCueShiftTuningStruc.cellsInAll;

midCueCellInd1 = multSessSegStruc(1).MidCueCellInd; % find midCueCells for first session

[vals, inds, ib] = intersect(cellsInAll(:,1),midCueCellInd1);

midCueAll = cellsInAll(inds,:);

color = {'r' 'g' 'b'};

for i=1:size(midCueAll,1)  % for each registered midCue cell
    figure; hold on; title(num2str(midCueAll(i,1)));
    for j=1:size(midCueAll,2)  % for each session
        
        % seg calcium
        C = multSessSegStruc(j).C;
        ca = C(midCueAll(i,j),:);
        [caz] = zScoreCa(ca); % zscore ca for this seg
        
        % times for all cues
        treadBehStruc = multSessSegStruc(j).treadBehStruc;
        evTimes = treadBehStruc.([eventName 'TimeStart']);
        frTimes = treadBehStruc.adjFrTimes(1:2:end);
        
        [evTrigSigZ, zeroFr] = eventTrigSig(caz, evTimes, 0, [-30 150], frTimes); % find evTrigSig for that cell
        [evTrigSig, zeroFr] = eventTrigSig(ca, evTimes, 0, [-30 150], frTimes); 
        midCueAllEvCellZ{i,j} = evTrigSigZ;
        midCueAllEvCell{i,j} = evTrigSig;
        
        plotMeanSEMshaderr(evTrigSig, color{j},20:30);

    end
    
end


