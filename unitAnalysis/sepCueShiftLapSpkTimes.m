function [pksCell1, posLap1, pksCell2, posLap2, lapFrInds] = sepCueShiftLapSpkTimes(pksCell, goodSeg, treadBehStruc)

% Clay Nov. 2018
% 
% ToDo:
% - integ this with wrapAndresPlaceFieldsClay
% - BUG: need to adjust pks because of diff times when excerpted
% - need to add last lap (it's not in loop)


%[caLapBin] = wrapLapTuning(C,treadBehStruc);


pos = treadBehStruc.resampY(1:2:end);
[lapFrInds] = findLaps(pos);

pksCellGood = pksCell(goodSeg);

disp('Separating spikes and pos by lap type');
posLap1=pos(1:lapFrInds(1)); posLap2=[];
pksCell1 = cell(1,length(pksCellGood)); pksCell2=cell(1,length(pksCellGood));
for i=1:length(lapFrInds)-1
    if mod(i+1,5)~=0
        lapType=1;
    else
        lapType=2;
    end
    
    for j=1:length(pksCellGood)
        unitPks = pksCellGood{j};
        lapPks = unitPks(find(unitPks>=lapFrInds(i) & unitPks<lapFrInds(i+1)));
        
        if lapType==1
            pksCell1{j} = [pksCell1{j} lapPks'-lapFrInds(i)+length(posLap1)+1];
        else
            pksCell2{j} = [pksCell2{j} lapPks'-lapFrInds(i)+length(posLap2)+1];
        end
    end
    
    if lapType==1
        posLap1 = [posLap1 pos(lapFrInds(i):lapFrInds(i+1))];
    else
        posLap2 = [posLap2 pos(lapFrInds(i):lapFrInds(i+1))];
    end
    
end