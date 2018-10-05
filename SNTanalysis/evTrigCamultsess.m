function [evTrigStruc] = evTrigCamultsess(sameCellTuningStruc);

%%uses rewTrigCa to calculate z scored reward/lap triggered activity from sameCellTuningStruc
%Sept 2018
%% unpack variables
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)


%% for place cells
for i = 1:length(multSessSegStruc)
    pcInds = multSessSegStruc(i).goodSeg(find(multSessSegStruc(i).PCLapSess.Shuff.isPC));
    periEvent = lapTrigCa(multSessSegStruc(i).C(pcInds,:), multSessSegStruc(i).treadBehStruc);
    unitEvCaAv =  nanmean(periEvent,3);
    
    unitCaZ = [];
    for j=1:size(unitEvCaAv,1)
        evCa = unitEvCaAv(j,:);
        unitCaZ(j,:) = zscore(evCa);
    end

    % save to output struc
    evTrigStruc(i).PCperiEvent = periEvent;
    evTrigStruc(i).PCunitEvCaAv = unitEvCaAv;
    evTrigStruc(i).PCunitCaZ = unitCaZ;
end


%% for reward cells
for i = 1:length(multSessSegStruc)
    RewLoc =[(round(mean((multSessSegStruc(i).treadBehStruc.rewZoneStartPos)/20)):1:(round(mean((multSessSegStruc(i).treadBehStruc.rewZoneStopPos)/20))))];
    rewInds = multSessSegStruc(i).goodSeg(find(nanmean(multSessSegStruc(i).outNonPC.posRates(:,RewLoc),2)>0));
    periEvent = lapTrigCa(multSessSegStruc(i).C(rewInds,:), multSessSegStruc(i).treadBehStruc);
    unitEvCaAv =  nanmean(periEvent,3);
    
    unitCaZ = [];
    for j=1:size(unitEvCaAv,1)
        evCa = unitEvCaAv(j,:);
        unitCaZ(j,:) = zscore(evCa);
    end

    % save to output struc
    evTrigStruc(i).RCperiEvent = periEvent;
    evTrigStruc(i).RCunitEvCaAv = unitEvCaAv;
    evTrigStruc(i).RCunitCaZ = unitCaZ;
end