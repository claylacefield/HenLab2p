function [CtxBootstrapStruc] = CellinCtxIdentityBootstrap (sameCellTuningStruc)

%%
mapInd = sameCellTuningStruc.regMapInd;
placeCellInd = sameCellTuningStruc.placeCellInd;
cellsInAll = sameCellTuningStruc.cellsInAll;

%to compare 2-3 only
placeCellIndLastTwo ={}; placeCellIndLastTwo{1,1} = placeCellInd {1,2}; placeCellIndLastTwo{1,2} = placeCellInd {1,3};

% find ziv array cells present in sessions ref session is 2
cellRegIndInAll = find(min(mapInd, [], 2)); % [1,1,1,...] in all col (i.e. none have zeros)
cellsInAll = mapInd(cellRegIndInAll,:);
cellRegIndFirstTwo=find(min(mapInd(:,1:2), [], 2));
cellsInFirstTwo = mapInd(cellRegIndFirstTwo,1:2);
cellRegIndLastTwo=find(min(mapInd(:,2:3), [], 2));
cellsInLastTwo = mapInd(cellRegIndLastTwo,2:3);

CtxBootstrapStruc =[];
tic
%% Place Cells
% frac of pcs in sess2 overlapping with sess1 and sess3 pcs
% numPCInFirstTwoAllAnim = [];

sameCell12placeBool=[];
placeCellsFirstTwoInd =[];
PCfrac12 =[];
for i = 1:size(cellsInFirstTwo,1) %each cell in 1-2
    for j = 1:2    % for each session from that cell
        if find(placeCellInd{j}== cellsInFirstTwo(i,j)) % see if it's a place cell
            sameCell12placeBool(i,j) = 1;
        else
            sameCell12placeBool(i,j) = 0;
        end
    end
end
% cellRegInd(cellsInAll) for cells present in all sessions, that are place cells in all
placeCellsInFirstTwo= find(min(sameCell12placeBool, [], 2)); % index in array of only place cells present in all sessions
placeCellsFirstTwoInd = cellsInFirstTwo(placeCellsInFirstTwo,:);
PC1only = find((sameCell12placeBool(:, 1) == 1 & sameCell12placeBool(:, 2) == 0));
PC2onlyin1= find((sameCell12placeBool(:, 1) == 0 & sameCell12placeBool(:, 2) == 1));
PC1= find((sameCell12placeBool(:, 1)==1)); 
PC2in1= find((sameCell12placeBool(:, 2) == 1));
PCfrac12 = length(placeCellsFirstTwoInd)/max(length(PC1), length(PC2in1));

rng('shuffle')
RandCell12placeBool =[];
placeCellsInFirstTwoShuff=[];
PCfrac12Shuff = [];
for sh = 1:10000
    sameCell12placeRand = cellsInFirstTwo;
    sameCell12placeRand(:, 1) = cellsInFirstTwo(randperm(size(cellsInFirstTwo, 1)), 1);
    sameCell12placeRand(:, 2) = cellsInFirstTwo(randperm(size(cellsInFirstTwo, 1)), 2);
    for i = 1:size(cellsInFirstTwo,1) %each cell in 1-2
        for j = 1:2    % for each session from that cell
            if find(placeCellInd{j}== sameCell12placeRand(i,j)) % see if it's a place cell
                RandCell12placeBool(i,j) = 1;
            else
                RandCell12placeBool(i,j) = 0;
            end
        end
    end
    placeCellsInFirstTwoShuff = find(min(RandCell12placeBool, [], 2)); % index in array of only place cells present in all sessions
    if ~isempty(placeCellsInFirstTwoShuff)
        placeCellsInFirstTwoIndShuff = cellsInFirstTwo(placeCellsInFirstTwoShuff,:);
        PCfrac12Shuff(sh) = length(placeCellsInFirstTwoIndShuff)/max(length(PC1), length(PC2in1));
    else
        placeCellsInFirstTwoIndShuff = [];
        PCfrac12Shuff(sh) = 0;
    end
end

sameCell23placeBool = [];
placeCellsLastTwoInd=[];
PCfrac23 =[];
for i = 1:size(cellsInLastTwo,1) % for all cells tracked across last two sessions
    for j = 1:2
        if find(placeCellIndLastTwo{j}== cellsInLastTwo(i,j)) % see if it's a place cell
            sameCell23placeBool(i,j) = 1;
        else
            sameCell23placeBool(i,j) = 0;
        end
    end
end
placeCellsInLastTwo= find(min(sameCell23placeBool, [], 2)); % index in array of only place cells present in all sessions
placeCellsLastTwoInd = cellsInLastTwo(placeCellsInLastTwo,:);
PC2onlyin3 = find((sameCell23placeBool(:, 1) == 1 & sameCell23placeBool(:, 2) == 0));
PC3only= find((sameCell23placeBool(:, 1) == 0 & sameCell23placeBool(:, 2) == 1));
PC2in3= find((sameCell23placeBool(:, 1)==1)); 
PC3= find((sameCell23placeBool(:, 2) == 1));
PCfrac23 = length(placeCellsLastTwoInd)/max(length(PC2in3), length(PC3));

RandCell23placeBool = [];
placeCellsInLastTwoShuff=[];
PCfrac23Shuff = [];
for sh = 1:10000
    sameCell23PlaceRand = cellsInLastTwo;
    sameCell23PlaceRand(:, 1) = cellsInLastTwo(randperm(size(cellsInLastTwo, 1)), 1);
    sameCell23PlaceRand(:, 2) = cellsInLastTwo(randperm(size(cellsInLastTwo, 1)), 2);
    for i = 1:size(cellsInLastTwo,1)
        for j = 1:2
            if find(placeCellIndLastTwo{j}== sameCell23PlaceRand(i,j))
                RandCell23placeBool(i,j) = 1;
            else
                RandCell23placeBool(i,j) = 0;
            end
        end
    end
    placeCellsInLastTwoShuff = find(min(RandCell23placeBool, [], 2));
    if ~isempty(placeCellsInLastTwoShuff)
        placeCellsInLastTwoIndShuff = cellsInLastTwo(placeCellsInLastTwoShuff,:);
        PCfrac23Shuff(sh) = length(placeCellsInLastTwoIndShuff)/max(length(PC2in3), length(PC3));
    else
        placeCellsInLastTwoIndShuff = [];
        PCfrac23Shuff(sh) = 0;
    end
end


figure;
subplot (1,2,1); hist(PCfrac12Shuff, 20);
mean(PCfrac12Shuff < PCfrac12);
hold on; plot([PCfrac12, PCfrac12], [0, 1000], '--r');
bounds = prctile(PCfrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); title('Place Cell Overlap Fraction in Sess12');
PCfrac12P= 1 - mean(PCfrac12Shuff < PCfrac12);
subplot (1,2,2); hist(PCfrac23Shuff, 20);
mean(PCfrac23Shuff < PCfrac23);
hold on; plot([PCfrac23, PCfrac23], [0, 1000], '--r');
bounds = prctile(PCfrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); title('Place Cell Overlap Fraction in Sess23');
PCfrac23P= 1 - mean(PCfrac23Shuff < PCfrac23);

%% Overlap of spatially tuned Cells with Non spatially tuned cells


diffTypeCellsInFirstTwo= find((sameCell12placeBool(:, 1) == 1 & sameCell12placeBool(:, 2) == 0) | ...
    ((sameCell12placeBool(:, 2) == 1 & sameCell12placeBool(:, 1) == 0))); %indices that are place cells in sess1 and non place in 2 or vice versa
diffTypeCellsInFirstTwoInd = cellsInFirstTwo(diffTypeCellsInFirstTwo,:);
diffTypeCellsLastTwo= find((sameCell23placeBool(:, 1) == 1 & sameCell23placeBool(:, 2) == 0) | ...
    ((sameCell23placeBool(:, 2) == 1 & sameCell23placeBool(:, 1) == 0)));
diffTypeCellsInLastTwoInd = cellsInLastTwo(diffTypeCellsLastTwo,:);
NonandPlacefrac12 = length(diffTypeCellsInFirstTwoInd)/length(cellsInFirstTwo);
NonandPlacefrac23 = length(diffTypeCellsInLastTwoInd)/length(cellsInLastTwo);

Placeonly12 = find((sameCell12placeBool(:, 1) == 1 & sameCell12placeBool(:, 2) == 0) | ...
    ((sameCell12placeBool(:, 2) == 1 & sameCell12placeBool(:, 1) == 0))); %indices that are cue cells in sess1 and in 2 
nonPlaceonly12 = find((sameCell12placeBool(:, 1) == 0 & sameCell12placeBool(:, 2) == 1) | ...
    ((sameCell12placeBool(:, 2) == 0 & sameCell12placeBool(:, 1) == 1))); %indices that are cue cells in sess1 and in 2 
Placeonly23 = find((sameCell23placeBool(:, 1) == 1 & sameCell23placeBool(:, 2) == 0) | ...
    ((sameCell23placeBool(:, 2) == 1 & sameCell23placeBool(:, 1) == 0))); %indices that are cue cells in sess1 and in 2 
nonPlaceonly23 = find((sameCell23placeBool(:, 1) == 0 & sameCell23placeBool(:, 2) == 1) | ...
    ((sameCell23placeBool(:, 2) == 0 & sameCell23placeBool(:, 1) == 1))); %indices that are cue cells in sess1 and in 2 

%shuffle
RandsameCell12PlaceBool = []; RandsameCell23PlaceBool = []; 
diffTypeCellsInFirstTwoIndShuff=[]; diffTypeCellsInLastTwoIndShuff=[];
NonandCuefrac12Shuff = []; NonandCuefrac23Shuff = [];

for sh = 1:10000
    diffCell12placeRand = cellsInFirstTwo;
    diffCell12placeRand(:, 1) = cellsInFirstTwo(randperm(size(cellsInFirstTwo, 1)), 1);
    diffCell12placeRand(:, 2) = cellsInFirstTwo(randperm(size(cellsInFirstTwo, 1)), 2);
    for i = 1:size(cellsInFirstTwo,1) %each cell in 1-2
        for j = 1:2    % for each session from that cell
            if find(placeCellInd{j}== diffCell12placeRand(i,j))
                RandsameCell12PlaceBool(i,j) = 1;
            else
                RandsameCell12PlaceBool(i,j) = 0;
            end
        end
    end
    diffTypeCellsInFirstTwoShuff= find((RandsameCell12PlaceBool(:, 1) == 1 & RandsameCell12PlaceBool(:, 2) == 0) | ...
        ((RandsameCell12PlaceBool(:, 2) == 1 & RandsameCell12PlaceBool(:, 1) == 0)));
    if ~isempty(diffTypeCellsInFirstTwoShuff)
        diffTypeCellsInFirstTwoIndShuff = cellsInFirstTwo(diffTypeCellsInFirstTwoShuff,:);
        NonandCuefrac12Shuff(sh) = length(diffTypeCellsInFirstTwoIndShuff)/length(cellsInFirstTwo);
    else
        diffTypeCellsInFirstTwoIndShuff=[];
        NonandCuefrac12Shuff(sh)=0;
    end
end
for sh = 1:10000
    diffCell23placeRand = cellsInLastTwo;
    diffCell23placeRand(:, 1) = cellsInLastTwo(randperm(size(cellsInLastTwo, 1)), 1);
    diffCell23placeRand(:, 2) = cellsInLastTwo(randperm(size(cellsInLastTwo, 1)), 2);
    for i = 1:size(cellsInLastTwo,1) %each cell in 1-2
        for j = 1:2    % for each session from that cell
            if find(placeCellIndLastTwo{j}== diffCell23placeRand(i,j))
                RandsameCell23PlaceBool(i,j) = 1;
            else
                RandsameCell23PlaceBool(i,j) = 0;
            end

        end
        
    end
    diffTypeCellsInLastTwoShuff= find((RandsameCell23PlaceBool(:, 1) == 1 & RandsameCell23PlaceBool(:, 2) == 0) | ...
        ((RandsameCell23PlaceBool(:, 2) == 1 & RandsameCell23PlaceBool(:, 1) == 0)));
    if ~isempty(diffTypeCellsInLastTwoShuff)
        diffTypeCellsInLastTwoIndShuff = cellsInLastTwo(diffTypeCellsInLastTwoShuff,:);
        NonandCuefrac23Shuff(sh) = length(diffTypeCellsInLastTwoShuff)/max(length(PC2in3), length(PC3));
    else
        diffTypeCellsInLastTwoIndShuff=[];
        NonandCuefrac23Shuff(sh)=0;
    end
end
figure; subplot (1,2,1); hist(NonandCuefrac12Shuff, 20);
mean(NonandCuefrac12Shuff < NonandPlacefrac12);
hold on; plot([NonandPlacefrac12, NonandPlacefrac12], [0, 1000], '--r');
bounds = prctile(NonandCuefrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); title('Non and Cue Overlap Fraction in Sess12');
NonandCuefrac12P= 1 - mean(NonandCuefrac12Shuff < NonandPlacefrac12);


subplot (1,2,2); hist(NonandCuefrac23Shuff, 20);
mean(NonandCuefrac23Shuff < NonandPlacefrac23);
hold on; plot([NonandPlacefrac23, NonandPlacefrac23], [0, 1000], '--r');
bounds = prctile(NonandCuefrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); title('Non and Cue Overlap Fraction in Sess23');
NonandCuefrac23P= 1 - mean(NonandCuefrac23Shuff < NonandPlacefrac23);
toc
%%
OverlapFrac = [PCfrac12, PCfrac23, NonandPlacefrac12, NonandPlacefrac23];
Pvalues = [PCfrac12P, PCfrac23P, NonandCuefrac12P, NonandCuefrac23P];
PC12= [max(mapInd(:,1)), max(mapInd(:,2)), length(placeCellInd{1,1}), length(placeCellInd{1,2}), length(cellsInFirstTwo), length(placeCellsFirstTwoInd), length(PC1only), length(PC2onlyin1)];
ActNumPC12 = [length(placeCellsFirstTwoInd), max(length(PC1), length(PC2in1))];
ShuffNumPC12 = PCfrac12Shuff * max(length(PC1), length(PC2in1));
PC23= [max(mapInd(:,2)), max(mapInd(:,3)), length(placeCellInd{1,2}), length(placeCellInd{1,3}), length(cellsInLastTwo), length(placeCellsLastTwoInd), length(PC2onlyin3), length(PC3only)];
ActNumPC23 = [length(placeCellsLastTwoInd), max(length(PC2in3), length(PC3))];
ShuffNumPC23 = PCfrac23Shuff * max(length(PC2in3), length(PC3));



ActNumNonandPlace12 = [length(diffTypeCellsInFirstTwoInd),  length(cellsInFirstTwo)];
ShuffNumNonandPlace12 = NonandCuefrac12Shuff *  length(cellsInFirstTwo);
ActNumNonandPlace23 = [length(diffTypeCellsInLastTwoInd),  length(cellsInLastTwo)];
ShuffNumNonandPlace23 = NonandCuefrac23Shuff * length(cellsInLastTwo);
NumNonandPlace12  =  [length(diffTypeCellsInFirstTwo), length(Placeonly12), length(nonPlaceonly12)];
NumNonandPlace23 =  [ length(diffTypeCellsInLastTwoInd), length(Placeonly23), length(nonPlaceonly23)];


CtxBootstrapStruc.OverlapFrac = OverlapFrac;
CtxBootstrapStruc.ActNumPC12 = ActNumPC12;
CtxBootstrapStruc.ShuffNumPC12 = ShuffNumPC12;
CtxBootstrapStruc.PC12 = PC12;
CtxBootstrapStruc.PC23 = PC23;
CtxBootstrapStruc.ActNumPC23 = ActNumPC23;
CtxBootstrapStruc.ShuffNumPC23 = ShuffNumPC23;

CtxBootstrapStruc.ActNumNonandPlace12 = ActNumNonandPlace12;
CtxBootstrapStruc.ShuffNumNonandPlace12 = ShuffNumNonandPlace12;
CtxBootstrapStruc.ActNumNonandPlace23 = ActNumNonandPlace23;
CtxBootstrapStruc.ShuffNumNonandPlace23 = ShuffNumNonandPlace23;
CtxBootstrapStruc.NumNonandPlace12 = NumNonandPlace12;
CtxBootstrapStruc.NumNonandPlace23 = NumNonandPlace23;

