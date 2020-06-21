function cueCellLinFit(mapInd, cueCellStruc, summStruc)

% Clay 2020
% Take registered cells from one cueOmit session and one randCue session
% (w. same cues), and cueCellStruc from cueOmit session, and linear fit
% output from randCue sess, and find the linear model cue and place coefs 
% for cue cells from the cueOmit sess (and noncue/place, and lapCue)
%
% Entire protocol:
% 1. use wrapMultSessStrucSelect to choose sessions to register
% (sess1=cueOmit, sess2=randCue)
% 2. run cellRegClay to register sessions
% 3. mapInd = cell_registered_struct.cell_to_index_map;
% 4. run findCueCells on omitCue session
% 5. run linearFitCaCueSess.m to get summStruc

%% load in filtered linear model cells (sig R2 and pval)
okCells = summStruc.okCells; % cell indices of cells with ok R2 and some significant params (>0.04)
cueCoef = summStruc.cueCoef;
placeCoef = summStruc.placeCoef;
%summStruc.placeParam = placeParam;


%% find model coefs for cue cells in cueOmit sess
cueInd = cueCellStruc.midCueCellInd3;
%mapInd = cell_registered_struct.cell_to_index_map;
cueMapInd=[]; 
for i=1:length(cueInd) 
    cueMapInd = [cueMapInd find(mapInd(:,1)==cueInd(i))]; % find mapInd row for cueCells in sess1
end
cueRandInd = mapInd(cueMapInd,2); % find sess2 cells registered to cue cells in sess1
okCueCell = intersect(cueRandInd, okCells); % see which of these cells has fit/pval in lin model

% find index of ok/cue cells among okCells
for i=1:length(okCueCell) 
    okCue(i) = find(okCells==okCueCell(i)); 
end

%% find model coefs for lap cue cells in cueOmit sess
lapInd = cueCellStruc.startCueCellInd;
%mapInd = cell_registered_struct.cell_to_index_map;
cueMapInd=[]; 
for i=1:length(lapInd) 
    cueMapInd = [cueMapInd find(mapInd(:,1)==lapInd(i))]; % find mapInd row for cueCells in sess1
end
cueRandInd = mapInd(cueMapInd,2); % find sess2 cells registered to cue cells in sess1
okCueCell = intersect(cueRandInd, okCells); % see which of these cells has fit/pval in lin model

% find index of ok/cue cells among okCells
for i=1:length(okCueCell) 
    okLap(i) = find(okCells==okCueCell(i)); 
end

% find index of ok/cue cells among okCells
for i=1:length(okCueCell) 
    okCue(i) = find(okCells==okCueCell(i)); 
end

%% find model coefs for place cells in cueOmit sess
placeInd = cueCellStruc.placeCellInd;
%mapInd = cell_registered_struct.cell_to_index_map;
cueMapInd=[]; 
for i=1:length(placeInd) 
    cueMapInd = [cueMapInd find(mapInd(:,1)==placeInd(i))]; % find mapInd row for cueCells in sess1
end
cueRandInd = mapInd(cueMapInd,2); % find sess2 cells registered to cue cells in sess1
okCueCell = intersect(cueRandInd, okCells); % see which of these cells has fit/pval in lin model

% find index of ok/cue cells among okCells
for i=1:length(okCueCell) 
    okPlace(i) = find(okCells==okCueCell(i)); 
end

%% find model coefs for cue cells in cueOmit sess
noncueInd = cueCellStruc.nonCueCellInd;
%mapInd = cell_registered_struct.cell_to_index_map;
cueMapInd=[]; 
for i=1:length(noncueInd) 
    cueMapInd = [cueMapInd find(mapInd(:,1)==noncueInd(i))]; % find mapInd row for cueCells in sess1
end
cueRandInd = mapInd(cueMapInd,2); % find sess2 cells registered to cue cells in sess1
okCueCell = intersect(cueRandInd, okCells); % see which of these cells has fit/pval in lin model

% find index of ok/cue cells among okCells
for i=1:length(okCueCell) 
    okNoncue(i) = find(okCells==okCueCell(i)); 
end

%% plot
figure; 
plot(cueCoef, placeCoef,'.');
hold on;
plot(cueCoef(okCue), placeCoef(okCue), 'r*');
%plot(cueCoef(okLap), placeCoef(okLap), 'm*');
plot(cueCoef(okPlace), placeCoef(okPlace), 'g*');
%plot(cueCoef(okNoncue), placeCoef(okNoncue), 'c*');
xlabel('cueCoef'); ylabel('placeCoef');
xl = get(gca,'xlim'); yl = get(gca,'ylim');
line([0 0],yl);
line(xl,[0 0]);

%
%figure; 
barSem({cueCoef(okCue), placeCoef(okCue)});
[p,h] = signrank(cueCoef(okCue), placeCoef(okCue));
[p,h] = ranksum(cueCoef(okCue), placeCoef(okCue));
title(['p=' num2str(p)]);

%
maxVal = ceil(max([cueCoef; placeCoef])*10)/10;
minVal = floor(min([cueCoef; placeCoef])*10)/10;
rang = maxVal-minVal;

figure; 
subplot(2,1,1);
hist(placeCoef,minVal:rang/20:maxVal);
line([mean(placeCoef(okCue)) mean(placeCoef(okCue))], get(gca,'ylim'));
title('placeCoef');
subplot(2,1,2);
hist(cueCoef,minVal:rang/20:maxVal);
line([mean(cueCoef(okCue)) mean(cueCoef(okCue))], get(gca,'ylim'));
title('cueCoef');




