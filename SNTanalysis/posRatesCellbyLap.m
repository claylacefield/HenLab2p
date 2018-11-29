


%% to get the bins within a cell's place field 
%unpack some variables
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)
placeCellOrigInd = sameCellTuningStruc.placeCellOrigInd;  % ind of place cells (Andres) w. re. to orig C/A
cellsInAll = sameCellTuningStruc.cellsInAll; % orig C/A index of all ziv registered cells present in all sessions
placeCellAllOrigInd = sameCellTuningStruc.placeCellAllOrigInd; % orig C/A index of all cells that are place cells in all sessions
placeCellNoneOrigInd = sameCellTuningStruc.placeCellInNoneOrigInd ;
placeCellAnyOrigInd = sameCellTuningStruc.placeCellInAnyOrigInd;


posRatesCellByLap = {};
posRatesCellByLap = {};
posRatesCell={};
placeCellAnyGoodSegInd = {};
pfInAnyPos = {};
for i = 1:size(placeCellAnyOrigInd,1)
    for j = 1:length(multSessSegStruc)
        placeCellAnyGoodSegInd{i,j} = find(multSessSegStruc(j).goodSeg == placeCellAnyOrigInd(i,j));
        posRatesCellByLap{i,j} = multSessSegStruc(j).PCLapSess.ByLap.posRateByLap(placeCellAnyGoodSegInd{i,j},:, :);
        posRatesCellByLap{i,j} = squeeze(posRatesCellByLap{i,j})';
        posRatesCell{i,j} = multSessSegStruc(j).PCLapSess.posRates(placeCellAnyGoodSegInd{i,j},:);
        pfInAnyPos{i,j} = multSessSegStruc(j).PCLapSess.Shuff.PFInAllPos{placeCellAnyGoodSegInd{i,j}};
    end
end

% then collect items within cell arrays into double across rows and columns
% and get out of field bins
pfInAllPos2 = {};
pfOutAllPos = {};
for i = 1:size(pfInAnyPos,1)
    for j = 1:size(pfInAnyPos, 2)
        pfInAllPos2{i, j}=[];
        for ii = 1:length(pfInAnyPos{i, j})
            pfInAllPos2{i,j}=[pfInAllPos2{i,j}, pfInAnyPos{i, j}{ii}];
            pfOutAllPos{i,j} = setdiff([1:100],pfInAllPos2{i,j});
        end
    end
end

%look at within and out of PC firing (mean vs max), for now PC in all can do for
%placeCellOrigInd for a table of PC properties,
MeanposRatebyLapinPF = {};
MeanposRatebyLapoutPF = {};
PCwidth = {};
COMbin = {};
InfoPerSpkZ = {};%observed spatial information normalized by transient shuffle
InfoPerSpkP = {}; %p value relative to transient shuffle;egs
circbin = 1:100;
circbin = ((circbin - 1)/99)*2*pi() - pi(); 
for i = 1:size (pfInAllPos2, 1)
    for j = 1:size (pfInAllPos2, 2)
        MeanposRatebyLapinPF {i, j} = mean(nanmean(posRatesCellByLap{i,j}(:, pfInAllPos2{i,j}),2),1);
        MeanposRatebyLapoutPF {i, j} = mean(nanmean(posRatesCellByLap{i,j}(:, pfOutAllPos{i,j}),2),1);
        PCwidth {i, j} = 2*(length(pfInAllPos2{i,j}));
        posRatesIn = posRatesCell{i,j};
        c = circ_mean(circbin, posRatesIn, 2);
        COMbin {i, j} = round(((c + pi())/(2*pi()))*99 + 1);
    	InfoPerSpkZ {i, j} = multSessSegStruc(j).PCLapSess.Shuff.InfoPerSpkZ(placeCellAnyGoodSegInd{i,j});
        InfoPerSpkP {i, j} = multSessSegStruc(j).PCLapSess.Shuff.InfoPerSpkP(placeCellAnyGoodSegInd{i,j});

    end
end

%% plotting across all datasets
%first collect all 
MeanposRatebyLapinPFcum = [];
MeanposRatebyLapoutPFcum = [];
PCwidthcum = []; COMbincum =[];
InfoPerSpkZcum = []; InfoPerSpkPcum = [];

MeanposRatebyLapinPFcum = [MeanposRatebyLapinPFcum; MeanposRatebyLapinPF];
MeanposRatebyLapoutPFcum = [MeanposRatebyLapoutPFcum; MeanposRatebyLapoutPF];
PCwidthcum = [PCwidthcum; PCwidth]; COMbincum =[COMbincum; COMbin];
InfoPerSpkZcum = [InfoPerSpkZcum; InfoPerSpkZ]; InfoPerSpkPcum = [InfoPerSpkPcum; InfoPerSpkP];


%% for all the PCsin three sessions
multSessSegStruc = sameCellTuningStruc.multSessSegStruc; % just save orig struc (not too huge)
placeCellOrigInd = sameCellTuningStruc.placeCellOrigInd;  % ind of place cells (Andres) w. re. to orig C/A
cellsInAll = sameCellTuningStruc.cellsInAll; % orig C/A index of all ziv registered cells present in all sessions
placeCellAllOrigInd = sameCellTuningStruc.placeCellAllOrigInd; % orig C/A index of all cells that are place cells in all sessions
placeCellNoneOrigInd = sameCellTuningStruc.placeCellInNoneOrigInd ;
placeCellAnyOrigInd = sameCellTuningStruc.placeCellInAnyOrigInd;

pfInAllPos = {}; pcGoodSegInd = {}; pfOutAllPos = {}; MeanposRatebyLapinPF = {};
MeanposRatebyLapoutPF = {}; PCwidth = {}; InfoPerSpkZ = {}; InfoPerSpkP = {};
posRateCOMs = {};
for j = 1:3
    isPC = find(multSessSegStruc(j).PCLapSess.Shuff.isPC);
    pcGoodSegInd{j} = isPC;
    pfInAllPos{j} = {};
    posRateCOMs{j} = [];
    circbin = 1:100;
    circbin = ((circbin - 1)/99)*2*pi() - pi();
    for i = 1:length(isPC)
        inPF = multSessSegStruc(j).PCLapSess.Shuff.PFInAllPos{isPC(i)};
        
        posRatesIn = multSessSegStruc(j).PCLapSess.posRates(isPC(i), :);
        c = circ_mean(circbin, posRatesIn, 2);
        posRateCOMs{j}(i) = round(((c + pi())/(2*pi()))*99 + 1);
        
        pfInAllPos{j}{i} = [];
        for ii = 1:length(inPF)
            pfInAllPos{j}{i} = [pfInAllPos{j}{i}, inPF{ii}];
            pfOutAllPos{j}{i} = setdiff([1:100],pfInAllPos{j}{i});
            MeanposRatebyLapinPF{j}{i} = nanmean(multSessSegStruc(j).PCLapSess.ByLap.posRateByLap(pcGoodSegInd{j}(i), pfInAllPos{j}{i}, :), 2);
            MeanposRatebyLapinPF{j}{i} = mean(squeeze (MeanposRatebyLapinPF{j}{i}),1);
            MeanposRatebyLapoutPF{j}{i} = nanmean(multSessSegStruc(j).PCLapSess.ByLap.posRateByLap(pcGoodSegInd{j}(i), pfOutAllPos{j}{i}, :), 2);
            MeanposRatebyLapoutPF{j}{i} = mean(squeeze (MeanposRatebyLapoutPF{j}{i}),1);
            PCwidth {j}{i} = 2*(length(pfInAllPos{j}{i}));
            InfoPerSpkZ{j}{i} = multSessSegStruc(j).PCLapSess.Shuff.InfoPerSpkZ(pcGoodSegInd{j}(i));
            InfoPerSpkP {j}{i} = multSessSegStruc(j).PCLapSess.Shuff.InfoPerSpkP(pcGoodSegInd{j}(i));
        end
    end
end


%% variability of firing for a cell within session
posRateLapDiff = {};
posRateLapZ = {};
posRateLapZinPF = {};
for i = 1:size (pfInAllPos2, 1)
    for j = 1:size (pfInAllPos2, 2)
        posRateLapDiff{i,j}= posRatesCellByLap{i, j} - repmat(posRatesCell{i, j}, [size(posRatesCellByLap{i, j}, 1), 1]);
        posRateLapZ{i,j} =  posRateLapDiff{i,j}./repmat(sqrt(posRatesCell{i, j}), [size(posRatesCellByLap{i, j}, 1), 1]);
        posRateLapZinPF {i, j} = (posRateLapZ{i,j}(:, pfInAllPos2{i,j}));
    end
end
% collect all the sess1 2, 3 cells within 3 seperate arrays
%and then plot the 
% P1 = []; P2=[]; P3=[]; V1 = []; V2=[]; V3=[];
for i = 1:size(pfInAllPos2, 1)
    p1= reshape(posRateLapZinPF{i,1}, [], 1);
    var1 = nanvar(p1);
    p2= reshape(posRateLapZinPF{i,2}, [], 1);
    var2 = nanvar(p2);
    p3= reshape(posRateLapZinPF{i,3}, [], 1);
    var3 = nanvar(p3);
    P1 = [P1; p1]; P2 = [P2; p2]; P3 = [P3; p3];
    V1 = [V1; var1]; V2 = [V2; var2]; V3 = [V3; var3];
end

figure; histogram(P1, 15, 'Normalization', 'probability');
hold on 
histogram(P2, 15, 'Normalization', 'probability');
hold on 
histogram(P3, 15, 'Normalization', 'probability');


bin = -1:0.01:max(P2);
P1Frac = cumsum(histc(P1,bin)/length(P1));
P2Frac = cumsum(histc(P2,bin)/length(P2));
P3Frac = cumsum(histc(P3,bin)/length(P3));
figure; 
subplot(1,2,1);
plot(bin, P1Frac, 'r-', 'LineWidth', 2);
hold on; plot(bin, P2Frac, 'g-', 'LineWidth', 2);
hold on; plot(bin, P3Frac, 'b-', 'LineWidth', 2);
title('PC discharge variability');

subplot(1,2,2);
bar([nanmean(V1) nanmean(V2) nanmean(V3)]); hold on;
sem1 = nanstd(V1)/sqrt(length(V1));
sem2 = nanstd(V2)/sqrt(length(V2));
sem3 = nanstd(V3)/sqrt(length(V3));
errorbar([nanmean(V1) nanmean(V2) nanmean(V3)],[sem1 sem2 sem3], '.');
title('Varience of standardized firing rates ');

%% correlation of within field firing across cells in a session
 mean(posRatesCellByLap{1, 1}(:, pfInAllPos2{1, 1}), 2);
 a = mean(posRatesCellByLap{1, 1}(:, pfInAllPos2{1, 1}), 2);
a = mean(posRatesCellByLap{1, 1}(:, pfInAllPos2{1, 1}), 2);
a = [];
j = 1;
for i = 1:size(pfInAllPos2, 1)
a = [a, mean(posRatesCellByLap{i, j}(:, pfInAllPos2{i, j}), 2)];
end
corrcoef(a);
corrcoef(tiedrank(a));
a(1:10, :)
a(11:19)