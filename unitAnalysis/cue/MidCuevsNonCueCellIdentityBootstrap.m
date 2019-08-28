function [MvsNBootstrapStruc] = MidCuevsNonCueCellIdentityBootstrap (sameCellCueShiftTuningStruc)
% shuffle commented out on 8/19/19 to calculate only overlapping cells
% (denominator)-to correct error 
%%
mapInd = sameCellCueShiftTuningStruc.regMapInd;
placeCellInd = sameCellCueShiftTuningStruc.placeCellInd;
MidCueCellInd = sameCellCueShiftTuningStruc.MidCueCellInd;
EdgeCueCellInd = sameCellCueShiftTuningStruc.EdgeCueCellInd;
nonCueCellInd = sameCellCueShiftTuningStruc.nonCueCellInd;
cellsInAll = sameCellCueShiftTuningStruc.cellsInAll;

%to compare 2-3 only
placeCellIndLastTwo ={}; placeCellIndLastTwo{1,1} = placeCellInd {1,2}; placeCellIndLastTwo{1,2} = placeCellInd {1,3};
MidCueCellIndLastTwo ={}; MidCueCellIndLastTwo{1,1} = MidCueCellInd {1,2}; MidCueCellIndLastTwo{1,2} = MidCueCellInd {1,3};
EdgeCueCellIndLastTwo ={}; EdgeCueCellIndLastTwo{1,1} = EdgeCueCellInd {1,2}; EdgeCueCellIndLastTwo{1,2} = EdgeCueCellInd {1,3};
nonCueCellIndLastTwo ={}; nonCueCellIndLastTwo{1,1} = nonCueCellInd {1,2}; nonCueCellIndLastTwo{1,2} = nonCueCellInd {1,3};

% find ziv array cells present in sessions ref session is 2
cellRegIndInAll = find(min(mapInd, [], 2)); % [1,1,1,...] in all col (i.e. none have zeros)
cellsInAll = mapInd(cellRegIndInAll,:);
cellRegIndFirstTwo=find(min(mapInd(:,1:2), [], 2));
cellsInFirstTwo = mapInd(cellRegIndFirstTwo,1:2);
cellRegIndLastTwo=find(min(mapInd(:,2:3), [], 2));
cellsInLastTwo = mapInd(cellRegIndLastTwo,2:3);

MvsNBootstrapStruc =[];
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
%% Overlap of MidCue Cells with NonCueCells
sameCell12CueBool = []; sameCell23CueBool = [];
sameCell12NonCueBool = []; sameCell23NonCueBool = [];
diffTypeCellsInFirstTwoInd =[]; diffTypeCellsInLastTwoInd =[];
NonandMidCuefrac12 =[]; NonandMidCuefrac23 =[];
for i = 1:size(cellsInFirstTwo,1) %each cell in 1-2
    for j = 1:2    % for each session from that cell
        if find(MidCueCellInd{j}== cellsInFirstTwo(i,j)) % see if it's a cue cell
            sameCell12CueBool(i,j) = 1;
        else
            sameCell12CueBool(i,j) = 0;
        end
        if find(nonCueCellInd{j}== cellsInFirstTwo(i,j)) % see if it's a non cue cell
            sameCell12NonCueBool(i,j) = 1;
        else
            sameCell12NonCueBool(i,j) = 0;
        end
    end
end
for i = 1:size(cellsInLastTwo,1) %each cell in 2-3
    for j = 1:2    % for each session from that cell
        if find(MidCueCellIndLastTwo{j}== cellsInLastTwo(i,j)) % cue cell
            sameCell23CueBool(i,j) = 1;
        else
            sameCell23CueBool(i,j) = 0;
        end
        if find(nonCueCellIndLastTwo{j}== cellsInLastTwo(i,j)) % non cue
            sameCell23NonCueBool(i,j) = 1;
        else
            sameCell23NonCueBool(i,j) = 0;
        end
    end
end

diffTypeCellsInFirstTwo= find((sameCell12CueBool(:, 1) == 1 & sameCell12NonCueBool(:, 2) == 1) | ...
    ((sameCell12CueBool(:, 2) == 1 & sameCell12NonCueBool(:, 1) == 1))); %indices that are cue cells in sess1 and non cue in 2 or vice versa
diffTypeCellsInFirstTwoInd = cellsInFirstTwo(diffTypeCellsInFirstTwo,:);
diffTypeCellsLastTwo= find((sameCell23CueBool(:, 1) == 1 & sameCell23NonCueBool(:, 2) == 1) | ...
    ((sameCell23CueBool(:, 2) == 1 & sameCell23NonCueBool(:, 1) == 1)));
diffTypeCellsInLastTwoInd = cellsInLastTwo(diffTypeCellsLastTwo,:);
NonandMidCuefrac12 = length(diffTypeCellsInFirstTwoInd)/max(length(PC1), length(PC2in1));
NonandMidCuefrac23 = length(diffTypeCellsInLastTwoInd)/max(length(PC2in3), length(PC3));
Cueonly12 = find((sameCell12CueBool(:, 1) == 1 & sameCell12NonCueBool(:, 2) == 0) | ...
    ((sameCell12CueBool(:, 2) == 1 & sameCell12NonCueBool(:, 1) == 0))); %indices that are cue cells in sess1 and in 2 
nonCueonly12 = find((sameCell12CueBool(:, 1) == 0 & sameCell12NonCueBool(:, 2) == 1) | ...
    ((sameCell12CueBool(:, 2) == 0 & sameCell12NonCueBool(:, 1) == 1))); %indices that are cue cells in sess1 and in 2 
Cueonly23 = find((sameCell23CueBool(:, 1) == 1 & sameCell23NonCueBool(:, 2) == 0) | ...
    ((sameCell23CueBool(:, 2) == 1 & sameCell23NonCueBool(:, 1) == 0))); %indices that are cue cells in sess1 and in 2 
nonCueonly23 = find((sameCell23CueBool(:, 1) == 0 & sameCell23NonCueBool(:, 2) == 1) | ...
    ((sameCell23CueBool(:, 2) == 0 & sameCell23NonCueBool(:, 1) == 1))); %indices that are cue cells in sess1 and in 2 

%shuffle
rng('shuffle')

RandsameCell12CueBool = []; RandsameCell12NonCueBool=[]; RandsameCell23CueBool = []; RandsameCell23NonCueBool=[];
diffTypeCellsInFirstTwoIndShuff=[]; diffTypeCellsInLastTwoIndShuff=[];
NonandCuefrac12Shuff = []; NonandCuefrac23Shuff = [];

for sh = 1:10000
    diffCell12placeRand = cellsInFirstTwo;
    diffCell12placeRand(:, 1) = cellsInFirstTwo(randperm(size(cellsInFirstTwo, 1)), 1);
    diffCell12placeRand(:, 2) = cellsInFirstTwo(randperm(size(cellsInFirstTwo, 1)), 2);
    for i = 1:size(cellsInFirstTwo,1) %each cell in 1-2
        for j = 1:2    % for each session from that cell
            if find(MidCueCellInd{j}== diffCell12placeRand(i,j))
                RandsameCell12CueBool(i,j) = 1;
            else
                RandsameCell12CueBool(i,j) = 0;
            end
            if find(nonCueCellInd{j}== cellsInFirstTwo(i,j))
                RandsameCell12NonCueBool(i,j) = 1;
            else
                RandsameCell12NonCueBool(i,j) = 0;
            end
        end
        
    end
    diffTypeCellsInFirstTwoShuff= find((RandsameCell12CueBool(:, 1) == 1 & RandsameCell12NonCueBool(:, 2) == 1) | ...
        ((RandsameCell12CueBool(:, 2) == 1 & RandsameCell12NonCueBool(:, 1) == 1)));
    if ~isempty(diffTypeCellsInFirstTwoShuff)
        diffTypeCellsInFirstTwoIndShuff = cellsInFirstTwo(diffTypeCellsInFirstTwoShuff,:);
        NonandCuefrac12Shuff(sh) = length(diffTypeCellsInFirstTwoIndShuff)/max(length(PC1), length(PC2in1));
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
            if find(MidCueCellIndLastTwo{j}== diffCell23placeRand(i,j))
                RandsameCell23CueBool(i,j) = 1;
            else
                RandsameCell23CueBool(i,j) = 0;
            end
            if find(nonCueCellIndLastTwo{j}== cellsInLastTwo(i,j))
                RandsameCell23NonCueBool(i,j) = 1;
            else
                RandsameCell23NonCueBool(i,j) = 0;
            end
        end
        
    end
    diffTypeCellsInLastTwoShuff= find((RandsameCell23CueBool(:, 1) == 1 & RandsameCell23NonCueBool(:, 2) == 1) | ...
        ((RandsameCell23CueBool(:, 2) == 1 & RandsameCell23NonCueBool(:, 1) == 1)));
    if ~isempty(diffTypeCellsInLastTwoShuff)
        diffTypeCellsInLastTwoIndShuff = cellsInLastTwo(diffTypeCellsInLastTwoShuff,:);
        NonandCuefrac23Shuff(sh) = length(diffTypeCellsInLastTwoShuff)/max(length(PC2in3), length(PC3));
    else
        diffTypeCellsInLastTwoIndShuff=[];
        NonandCuefrac23Shuff(sh)=0;
    end
end
figure; subplot (1,2,1); hist(NonandCuefrac12Shuff, 20);
mean(NonandCuefrac12Shuff < NonandMidCuefrac12);
hold on; plot([NonandMidCuefrac12, NonandMidCuefrac12], [0, 1000], '--r');
bounds = prctile(NonandCuefrac12Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); title('Non and Cue Overlap Fraction in Sess12');
NonandCuefrac12P= 1 - mean(NonandCuefrac12Shuff < NonandMidCuefrac12);


subplot (1,2,2); hist(NonandCuefrac23Shuff, 20);
mean(NonandCuefrac23Shuff < NonandMidCuefrac23);
hold on; plot([NonandMidCuefrac23, NonandMidCuefrac23], [0, 1000], '--r');
bounds = prctile(NonandCuefrac23Shuff, [2.5, 97.5]);
hold on; plot([bounds(1), bounds(1)], [0, 1000], '--k');
hold on; plot([bounds(2), bounds(2)], [0, 1000], '--k'); title('Non and Cue Overlap Fraction in Sess23');
NonandCuefrac23P= 1 - mean(NonandCuefrac23Shuff < NonandMidCuefrac23);
toc
%%





ActNumNonandCue12 = [length(diffTypeCellsInFirstTwoInd), max(length(PC1), length(PC2in1))];
ShuffNumNonandCue12 = NonandCuefrac12Shuff * max(length(PC1), length(PC2in1));
ActNumNonandCue23 = [length(diffTypeCellsInLastTwoInd), max(length(PC2in3), length(PC3))];
ShuffNumNonandCue23 = NonandCuefrac23Shuff * max(length(PC2in3), length(PC3));
NumNonandCue12  =  [length(diffTypeCellsInFirstTwo), length(Cueonly12), length(nonCueonly12)];
NumNonandCue23 =  [ length(diffTypeCellsInLastTwoInd), length(Cueonly23), length(nonCueonly23)];
dirFull = pwd;
spacer = [find(dirFull == '/'), find(dirFull == '\')];
dirName = dirFull((max(spacer) + 1):end);

MvsNBootstrapStruc.MultSessID = dirName;

MvsNBootstrapStruc.ActNumNonandCue12 = ActNumNonandCue12;
MvsNBootstrapStruc.ShuffNumNonandCue12 = ShuffNumNonandCue12;
MvsNBootstrapStruc.ActNumNonandCue23 = ActNumNonandCue23;
MvsNBootstrapStruc.ShuffNumNonandCue23 = ShuffNumNonandCue23;
MvsNBootstrapStruc.NumNonandCue12 = NumNonandCue12;
MvsNBootstrapStruc.NumNonandCue23 = NumNonandCue23;

