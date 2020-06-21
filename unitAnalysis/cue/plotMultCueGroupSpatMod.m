function plotMultCueGroupSpatMod(multCueSpatModStruc)

% Clay 2020
% to plot output from mulCueGroupSpatMod.m
% example data /Backup20TB/clay/DGdata/190517/group struc

%% spatial modulation
a=2;b=5;
%a=1;b=4;
for d = 1:length(multCueSpatModStruc) % for each day
    spatModMouse = []; 
    cue1posRates=[]; noncue1posRates=[]; cue1posRatesLap=[]; 
    cue2posRates=[]; noncue2posRates=[]; cue2posRatesLap=[];
    for m = 1:length(multCueSpatModStruc(d).mouse) % concat spat mod for all mice that day
        spatModMouse = [spatModMouse 1-multCueSpatModStruc(d).mouse(m).cellType(a).spatMod 1-multCueSpatModStruc(d).mouse(m).cellType(b).spatMod];
        
        % concat posRates for cue cells and noncue (by location)
        cue1posRates = [cue1posRates; multCueSpatModStruc(d).mouse(m).cellType(a).posRates];
        noncue1posRates = [noncue1posRates; multCueSpatModStruc(d).mouse(m).cellType(3).posRates];
        cue1posRatesLap(1:100,1:25,m) = multCueSpatModStruc(d).mouse(m).cellType(a).posRatesLap(:,1:25);
        
        cue2posRates = [cue2posRates; multCueSpatModStruc(d).mouse(m).cellType(b).posRates];
        noncue2posRates = [noncue2posRates; multCueSpatModStruc(d).mouse(m).cellType(6).posRates];
        cue2posRatesLap(1:100,1:25,m) = multCueSpatModStruc(d).mouse(m).cellType(b).posRatesLap(:,1:25);
        
        % avg rates for all cells over laps (truncate to min lap length)
        
        % timing of cue cells vs noncue
        % show peak time (and histogram) of each cue/noncue 
        
    end
    cue1posRatesCell{d} = cue1posRates;
    noncue1posRatesCell{d} = noncue1posRates;
    cue1posRatesLapCell{d} = cue1posRatesLap;
    
    cue2posRatesCell{d} = cue2posRates;
    noncue2posRatesCell{d} = noncue2posRates;
    cue2posRatesLapCell{d} = cue2posRatesLap;
    
    spatModDayCell{d} = spatModMouse';
    spatModDayAvg(d) = nanmean(spatModMouse);
    spatModDaySem(d) = nanstd(spatModMouse)/sqrt(length(spatModMouse));
end

% bar plot spatMod over days
figure; 
bar(spatModDayAvg);
hold on; 
errorbar(spatModDayAvg, spatModDaySem,'.');

% bar plot and stats d1v2
figure; 
bar(spatModDayAvg(1:2));
hold on; 
errorbar(spatModDayAvg(1:2), spatModDaySem(1:2),'.');
[p] = ranksum(spatModDayCell{1},spatModDayCell{2});
title(['p=' num2str(p)]);
xlabel('rate nonpref/pref');

% violin plot
figure; 
violin(spatModDayCell);


% avg posRates
figure; 
subplot(2,1,1);
plotMeanSEMshaderr(cue1posRatesCell{1}','b');
hold on; 
plotMeanSEMshaderr(cue1posRatesCell{2}','g');
%plotMeanSEMshaderr(cue1posRatesCell{3}','c');
%plotMeanSEMshaderr(cue1posRatesCell{4}','m');
%plotMeanSEMshaderr(noncue1posRatesCell{1}','r');

subplot(2,1,2);
plotMeanSEMshaderr(cue2posRatesCell{1}','b');
hold on; 
plotMeanSEMshaderr(cue2posRatesCell{2}','g');
%plotMeanSEMshaderr(cue2posRatesCell{3}','c');
%plotMeanSEMshaderr(cue2posRatesCell{4}','m');
%plotMeanSEMshaderr(noncue2posRatesCell{1}','r');

figure; 
subplot(2,1,1);
plotMeanSEMshaderr(noncue1posRatesCell{1}','b');
hold on; 
plotMeanSEMshaderr(noncue1posRatesCell{2}','g');
%plotMeanSEMshaderr(noncue1posRatesCell{3}','c');
%plotMeanSEMshaderr(noncue1posRatesCell{4}','m');
title('noncueCells');
subplot(2,1,2);
plotMeanSEMshaderr(noncue2posRatesCell{1}','b');
hold on; 
plotMeanSEMshaderr(noncue2posRatesCell{2}','g');
%plotMeanSEMshaderr(noncue2posRatesCell{3}','c');
%plotMeanSEMshaderr(noncue2posRatesCell{4}','m');

% normalized
for i=1:4
    for j=1:size(cue1posRatesCell{i},1) % for all cells
        posRates = cue1posRatesCell{i}(j,:);
        cue1posRatesNormCell{i}(j,:) = posRates/max(posRates);
    end
    for j=1:size(cue2posRatesCell{i},1) % for all cells
        posRates = cue2posRatesCell{i}(j,:);
        cue2posRatesNormCell{i}(j,:) = posRates/max(posRates);
    end
end

figure; 
subplot(2,1,1);
plotMeanSEMshaderr(cue1posRatesNormCell{1}','b');
hold on; 
plotMeanSEMshaderr(cue1posRatesNormCell{2}','g');
plotMeanSEMshaderr(cue1posRatesNormCell{3}','c');
plotMeanSEMshaderr(cue1posRatesNormCell{4}','m');
%plotMeanSEMshaderr(noncue1posRatesNormCell{1}','r');

subplot(2,1,2);
plotMeanSEMshaderr(cue2posRatesNormCell{1}','b');
hold on; 
plotMeanSEMshaderr(cue2posRatesNormCell{2}','g');
plotMeanSEMshaderr(cue2posRatesNormCell{3}','c');
plotMeanSEMshaderr(cue2posRatesNormCell{4}','m');
%plotMeanSEMshaderr(noncue2posRatesNormCell{1}','r');

% plot cue cell avg by lap
figure; 
subplot(4,2,1);
imagesc(squeeze(mean(cue1posRatesLapCell{1},3))'); %caxis(cl);
cl = caxis;
subplot(4,2,3);
imagesc(squeeze(mean(cue1posRatesLapCell{2},3))'); caxis(cl);
subplot(4,2,5);
imagesc(squeeze(mean(cue1posRatesLapCell{3},3))'); caxis(cl);
subplot(4,2,7);
imagesc(squeeze(mean(cue1posRatesLapCell{4},3))'); caxis(cl);

%figure; 
subplot(4,2,2);
imagesc(squeeze(mean(cue2posRatesLapCell{1},3))'); caxis(cl);
%cl = caxis;
subplot(4,2,4);
imagesc(squeeze(mean(cue2posRatesLapCell{2},3))'); caxis(cl);
subplot(4,2,6);
imagesc(squeeze(mean(cue2posRatesLapCell{3},3))'); caxis(cl);
subplot(4,2,8);
imagesc(squeeze(mean(cue2posRatesLapCell{4},3))'); caxis(cl);
%

d11 = squeeze(mean(cue1posRatesLapCell{1},3));
d11sm = mean(d11(70:90,:),1)./mean(d11(20:40,:),1);
d12 = squeeze(mean(cue2posRatesLapCell{1},3));
d12sm = mean(d12(20:40,:),1)./mean(d12(70:90,:),1);
figure; plot(mean([d11sm;d12sm],1));

% and avg this over days to find trend for within-session changes



% mean pref rate over days, mean nonpref over days
%for i=1:4
    


% SuppFig.: plot lapType 1 vs 2 and 3 posRates for cueCells
d=1; %a=[2 5]; % for d1 and shuff cueCells
cue1posRates1=[]; cue1posRates2=[]; cue1posRates3=[];
noncue1posRates1=[];noncue1posRates2=[];noncue1posRates3=[];
cue2posRates1=[]; cue2posRates2=[]; cue2posRates3=[];
noncue2posRates1=[];noncue2posRates2=[];noncue2posRates3=[];
for m=1:3
    cue1inds = multCueSpatModStruc(d).mouse(m).cellType(2).inds;
    cue1posRates1 = [cue1posRates1; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{1}.posRates(cue1inds,:)];
    cue1posRates2 = [cue1posRates2; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{2}.posRates(cue1inds,:)];
    cue1posRates3 = [cue1posRates3; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{3}.posRates(cue1inds,:)];
    
    noncue1inds = multCueSpatModStruc(d).mouse(m).cellType(3).inds;
    noncue1posRates1 = [noncue1posRates1; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{1}.posRates(noncue1inds,:)];
    noncue1posRates2 = [noncue1posRates2; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{2}.posRates(noncue1inds,:)];
    noncue1posRates3 = [noncue1posRates3; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{3}.posRates(noncue1inds,:)];
    
    cue2inds = multCueSpatModStruc(d).mouse(m).cellType(5).inds;
    cue2posRates1 = [cue2posRates1; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{1}.posRates(cue2inds,:)];
    cue2posRates2 = [cue2posRates2; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{2}.posRates(cue2inds,:)];
    cue2posRates3 = [cue2posRates3; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{3}.posRates(cue2inds,:)];
    
    noncue2inds = multCueSpatModStruc(d).mouse(m).cellType(6).inds;
    noncue2posRates1 = [noncue2posRates1; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{1}.posRates(noncue2inds,:)];
    noncue2posRates2 = [noncue2posRates2; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{2}.posRates(noncue2inds,:)];
    noncue2posRates3 = [noncue2posRates3; groupCueStrucStruc(1).groupCueStruc(m).PCLappedSessCell{3}.posRates(noncue2inds,:)];
end


figure; 
subplot(2,1,1);
plotMeanSEMshaderr(cue1posRates1','b');
hold on; 
plotMeanSEMshaderr(cue1posRates2','g');
plotMeanSEMshaderr(cue1posRates3','c');

subplot(2,1,2);
plotMeanSEMshaderr(cue2posRates1','b');
hold on; 
plotMeanSEMshaderr(cue2posRates2','g');
plotMeanSEMshaderr(cue2posRates3','c');


% bar plot
cue1lap1pos1=[]; cue1lap1pos2=[];cue1lap2pos1=[]; cue1lap2pos2=[]; cue1lap3pos1=[]; cue1lap3pos2=[];
for i=1:size(cue1posRates1,1)
    cue1lap1pos1 = [cue1lap1pos1 max(cue1posRates1(i,20:40))];
    cue1lap1pos2 = [cue1lap1pos2 max(cue1posRates1(i,70:90))];
    cue1lap2pos1 = [cue1lap2pos1 max(cue1posRates2(i,20:40))];
    cue1lap2pos2 = [cue1lap2pos2 max(cue1posRates2(i,70:90))];
    cue1lap3pos1 = [cue1lap3pos1 max(cue1posRates3(i,20:40))];
    cue1lap3pos2 = [cue1lap3pos2 max(cue1posRates3(i,70:90))];
end

cue2lap1pos1=[]; cue2lap1pos2=[];cue2lap2pos1=[]; cue2lap2pos2=[]; cue2lap3pos1=[]; cue2lap3pos2=[];
for i=1:size(cue2posRates1,1)
    cue2lap1pos1 = [cue2lap1pos1 max(cue2posRates1(i,20:40))];
    cue2lap1pos2 = [cue2lap1pos2 max(cue2posRates1(i,70:90))];
    cue2lap2pos1 = [cue2lap2pos1 max(cue2posRates2(i,20:40))];
    cue2lap2pos2 = [cue2lap2pos2 max(cue2posRates2(i,70:90))];
    cue2lap3pos1 = [cue2lap3pos1 max(cue2posRates3(i,20:40))];
    cue2lap3pos2 = [cue2lap3pos2 max(cue2posRates3(i,70:90))];
end

cueRate = [cue1lap1pos1 cue2lap1pos2]; omitPrefRate = [cue1lap2pos1 cue2lap3pos2]; omitNonprefRate = [cue1lap3pos1 cue2lap2pos2];

barSem({[cue1lap1pos1 cue2lap1pos2] [cue1lap3pos1 cue2lap2pos2] [cue1lap2pos1 cue2lap3pos2] [cue1lap1pos2 cue2lap1pos1] [cue1lap2pos2 cue2lap3pos1] [cue1lap3pos2 cue2lap2pos1]});
[p13,h] = signrank([cue1lap1pos1 cue2lap1pos2],[cue1lap2pos1 cue2lap3pos2]);
[p46,h] = signrank([cue1lap1pos2 cue2lap1pos1], [cue1lap3pos2 cue2lap2pos1]);

%%

% for c = 1:length(cellInds)
%     posRatesN = posRatesAll(cellInds(c),:);
%     cue1rate = max(posRatesN(20:40));
%     cue2rate = max(posRatesN(70:90));
%     if strfind(field,'1')
%         spatMod(c) = cue2rate/cue1rate; % non-preferred/preferred cue loc max rate
%     else
%         spatMod(c) = cue1rate/cue2rate;
%     end
% end

figure; 
plot([cue1lap1pos1 cue2lap1pos2], [cue1lap1pos2 cue2lap1pos1],'.');
hold on; line([0 0.5],[0 0.5]);
plot([cue1lap1pos1 cue2lap1pos2], [cue1lap1pos2 cue2lap1pos1],'.');


%
figure; hold on;
line([0 0.5],[0 0.5]);
for d=1:4
    prefRate{d} = max([cue1posRatesCell{d}(:,20:40); cue2posRatesCell{d}(:,70:90)],[],2);
    nonprefRate{d} = max([cue1posRatesCell{d}(:,70:90); cue2posRatesCell{d}(:,20:40)],[],2);
    plot(prefRate{d}, nonprefRate{d}, '.');
end


%% PF only rates for all PCs (for multCue cue vs omit)

for i=1:length(posRatesCell)
    for j=1:length(posRatesCell{i})
        posRates = posRatesCell{i};
        figure; plotPosRates(posRates, 0, 1);
    end
end


% PF only posRates
pcRates = posRatesCell{1};
[maxs, inds] = max(pcRates'); % find bin of peak firing rate for PCs

[sorted, sortInds] = sort(inds);
pcRatesSorted = pcRates(sortInds,:);
%figure; imagesc(pcRatesSorted);
pcRates2 = posRatesCell{2}; % for Omit laps
omitRates2Sorted = pcRates2(sortInds,:);
pcRates3 = posRatesCell{3}; % for Omit laps
omitRates3Sorted = pcRates3(sortInds,:);

% go through posRates, and blank out time around peak
j=0;
for i = 1:size(pcRatesSorted,1) % for all cells (actually not just pc now)
    rates = pcRatesSorted(i,:);
    rates2 = omitRates2Sorted(i,:);
    rates3 = omitRates3Sorted(i,:);
    pfRates = pcRatesSorted(i,:);
    pfRates2 = omitRates2Sorted(i,:);
    pfRates3 = omitRates3Sorted(i,:);
    pkPos = sorted(i); % pos bin of place field peak
    if pkPos <= 10 % wraparound for units at beginning
        rates(1:pkPos+9) = NaN; % rates(1:pkPos+10) = NaN;
        rates(100-(9-pkPos):100) = NaN; % rates(100-10-pkPos:100) = NaN;
        rates2(1:pkPos+9) = NaN; % rates2(1:pkPos+10) = NaN;
        rates2(100-(9-pkPos):100) = NaN; % rates2(100-10-pkPos:100) = NaN;
        rates3(1:pkPos+9) = NaN; % rates2(1:pkPos+10) = NaN;
        rates3(100-(9-pkPos):100) = NaN; % rates2(100-10-pkPos:100) = NaN;
        
        % place field rates only 
        pfRates(pkPos+10:100-(10-pkPos)) = NaN;
        pfRates2(pkPos+10:100-(10-pkPos)) = NaN;
        pfRates3(pkPos+10:100-(10-pkPos)) = NaN;
        
    elseif pkPos>90 % wraparound for units at end
        rates(pkPos-9:100) = NaN; % changing all 10 to 9 for pfBlanked
        rates(1:9-(100-pkPos)) = NaN;
        rates2(pkPos-9:100) = NaN;
        rates2(1:9-(100-pkPos)) = NaN;
        rates3(pkPos-9:100) = NaN;
        rates3(1:9-(100-pkPos)) = NaN;
        
        % place field rates only 
        pfRates(10-(100-pkPos):pkPos-10) = NaN;
        pfRates2(10-(100-pkPos):pkPos-10) = NaN;
        pfRates3(10-(100-pkPos):pkPos-10) = NaN;
    else % units in middle
        rates(pkPos-9:pkPos+9) = NaN;
        rates2(pkPos-9:pkPos+9) = NaN;
        rates3(pkPos-9:pkPos+9) = NaN;
        
        % place field rates only 
        pfRates(1:pkPos-10) = NaN;
        pfRates(pkPos+10:end) = NaN;
        pfRates2(1:pkPos-10) = NaN;
        pfRates2(pkPos+10:end) = NaN;
        pfRates3(1:pkPos-10) = NaN;
        pfRates3(pkPos+10:end) = NaN;
        
%         if pkPos>45 && pkPos<55 % for potential middle-cue cells (PF in pos 40-60)
%             j=j+1;
%             cuePosRate(j) = mean(pcRatesSorted(i,45:55),2); % mean rate in cue trials
%             omitPosRate(j) = mean(omitRates2Sorted(i,45:55),2);  % and omit trials
%             cuePkPos(j) = pkPos;
%         end
        
    end
    pcRatesBlanked(i,:) = rates;
    pcOmitRates2Blanked(i,:) = rates2;
    pcOmitRates3Blanked(i,:) = rates3;
    pfOnlyRates(i,:) = pfRates;
    pfOnlyRates2Omit(i,:) = pfRates2;   
    pfOnlyRates3Omit(i,:) = pfRates3;  
end

% cuePosRate = cuePosRate(cuePosRate~=0); % just elim zeros
% omitPosRate = omitPosRate(omitPosRate~=0);

figure;
hold on;
plotMeanSEMshaderr(pfOnlyRates','b');
plotMeanSEMshaderr(pfOnlyRates2Omit','c');
plotMeanSEMshaderr(pfOnlyRates3Omit','g');

cuePos1avRates = nanmean(pfOnlyRates(:,20:40),2);

inds2 = inds(sortInds);
cuePos1avRates = nanmean(pfOnlyRates(find(inds2>20 & inds2<=40),20:40),2);
cuePos1omitavRates = nanmean(pfOnlyRates2Omit(find(inds2>20 & inds2<=40),20:40),2);
cuePos2avRates = nanmean(pfOnlyRates(find(inds2>70 & inds2<=90),70:90),2);
cuePos2omitavRates = nanmean(pfOnlyRates3Omit(find(inds2>70 & inds2<=90),20:90),2);

norm = [cuePos1avRates; cuePos2avRates];
omit = [cuePos1omitavRates; cuePos2omitavRates];

[p,h] = signrank(norm, omit);

[p,h] = signrank(spatModDayCell{1}); % significance of first day spatial modulation

%figure; 
barSem({norm, omit});
figure;
boxplot([norm omit]);

figure; hold on;
for i=1:length(norm)
line([1 2], [norm(i) omit(i)]);
end

% figure;
% hold on;
% plotMeanSEMshaderr(pcRatesBlanked','b');
% plotMeanSEMshaderr(pcOmitRates2Blanked','c');
% plotMeanSEMshaderr(pcOmitRates3Blanked','g');

%if toPlot
figure; 
colormap(hot); 
subplot(2,3,1);
imagesc(pcRatesBlanked);
title('pcRatesBlanked');
subplot(2,3,2);
imagesc(pcOmitRatesBlanked);
title('pcOmitRatesBlanked');
subplot(2,3,3);
plot(nanmean(pcRatesBlanked,1));
hold on;
plot(nanmean(pcOmitRatesBlanked,1),'r');
legend('refLaps', 'omitLaps');
subplot(2,3,4);
%plot(cuePosRate,omitPosRate,'x');
plot(cuePkPos,cuePosRate-omitPosRate,'x');
%hold on; line([0 0.2], [0 0.2]);
title('middle cell mean ref lap rate - omit');


%% shuff for significant spatial mod
for d=1:4
    for m=1:3
        sigSm1=[];
        for i=1:length(multCueSpatModStruc(d).mouse(m).cellType(2).inds)
            cue1pos1lap = max(squeeze(multCueSpatModStruc(d).mouse(m).cellType(2).posRatesLapCell(i,20:40,:)));
            cue1pos2lap = max(squeeze(multCueSpatModStruc(d).mouse(m).cellType(2).posRatesLapCell(i,70:90,:)));
            obSm = mean(cue1pos2lap)/mean(cue1pos1lap);
            for j=1:100
               allLaps = [cue1pos1lap cue1pos2lap];
               rn1 = randsample(length(allLaps),length(allLaps));
               resSm(j) = nanmean(allLaps(rn1(1:length(allLaps)/2)))/nanmean(allLaps(rn1(length(allLaps)/2)+1:end));
               
            end
            
            % significant if observed spatMod (nonpref/pref) is less than
            % 95% of shuffled
            if length(find(resSm<obSm))<6
                sigSm1(i) = 1;
            else
                sigSm1(i) = 0;
            end
        end
        sigSpatModCell{d,m,1} = sigSm1;
        
        % cuePos2 cells
        sigSm2=[];
        for i=1:length(multCueSpatModStruc(d).mouse(m).cellType(5).inds)
            cue2pos1lap = max(squeeze(multCueSpatModStruc(d).mouse(m).cellType(5).posRatesLapCell(i,20:40,:)));
            cue2pos2lap = max(squeeze(multCueSpatModStruc(d).mouse(m).cellType(5).posRatesLapCell(i,70:90,:)));
            obSm = mean(cue2pos1lap)/mean(cue2pos2lap);
            for j=1:100
               allLaps = [cue2pos1lap cue2pos2lap];
               rn1 = randsample(length(allLaps),length(allLaps));
               resSm(j) = nanmean(allLaps(rn1(1:length(allLaps)/2)))/nanmean(allLaps(rn1(length(allLaps)/2)+1:end));
               
            end
            
            % significant if observed spatMod (nonpref/pref) is less than
            % 95% of shuffled
            if length(find(resSm<obSm))<6
                sigSm2(i) = 1;
            else
                sigSm2(i) = 0;
            end
        end
        sigSpatModCell{d,m,2} = sigSm2;
    end
end

for d=1:4
   for m=1:3
      percSig(d,m,1) = sum(sigSpatModCell{d,m,1})/length(sigSpatModCell{d,m,1});
      percSig(d,m,2) = sum(sigSpatModCell{d,m,2})/length(sigSpatModCell{d,m,2});
   end
end

figure; plot(mean(percSig(:,:,1),2),'*'); hold on; plot(mean(percSig(:,:,2),2),'g*');

figure; hold on;
plotMeanSEMshaderr(squeeze(percSig(:,:,1)),'b');
plotMeanSEMshaderr(squeeze(percSig(:,:,2)),'g');


figure; hold on;
plotMeanSEMshaderr(squeeze([percSig(:,:,1) percSig(:,:,2)]),'b');

[p,h] = signrank(percSig(1,:,1), percSig(1,:,2)); % stats for d1 cuePos1 vs 2
[p,h] = signrank([percSig(1,:,1) percSig(1,:,2)], [percSig(4,:,1) percSig(4,:,2)]); % stats for d1v4, both cuePos
