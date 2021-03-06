function [cueInhibStruc] = cuePosInhibMouse()

toPlot=1;

mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

normRatesBlanked = []; normRatesBlankedCell={};
omitRatesBlanked = []; omitRatesBlankedCell={};
pfRates = []; pfRatesCell = {};
pfOmitRates = []; pfOmitRatesCell = {};

posRates = []; posRatesCell = {};
omitRates = []; omitRatesCell = {};

pathCell = {}; cueShiftNameCell={};
posBinFracCell={}; posInfoCell={};

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) %&& contains(dayDir(i).name, 'mit')
                    cd([mousePath '/' dayName '/' dayDir(i).name]);
                    %sessDir = dir;
                    cueShiftStrucName = findLatestFilename('cueShiftStruc');
%                     if ~isempty(cueShiftStrucName)
%                         load(cueShiftStrucName);
%                     else
%                         [cueShiftStruc, pksCell] = quickTuning();
%                         cueShiftStrucName = findLatestFilename('cueShiftStruc');
%                     end
                    
                    load(cueShiftStrucName);
                    
                    try
                    lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
                    catch
                        lapTypeArr = [];
                    end
                    
                    for k=1:length(cueShiftStruc.posLapCell)
                        numLapType(k) = length(cueShiftStruc.posLapCell{k});
                    end
                    [val, refLapType] = max(numLapType); % use ref lap from one with most laps
                    
                    
                    % make sure it's shiftOmit, and not 'led'?
                    if (contains(dayDir(i).name, 'mit') ) && ~contains(dayDir(i).name, 'one') && ~contains(dayDir(i).name, '3sens') % || contains(dayDir(i).name, 'hift') && ~isempty(find(lapTypeArr==0))
                        disp(['Processing Omit file ' dayDir(i).name]); tic;
                        toPlot=0; goodSeg = 0; % is PC only % goodSeg = 1; % is all cells
                        [posBinFrac, posInfo, pcRatesBlanked, pcOmitRatesBlanked, pfOnlyRates, pfOnlyRatesOmit, pcRatesSorted, omitRatesSorted] = cuePosInhib(cueShiftStruc, goodSeg, refLapType, toPlot);
                        normRatesBlanked = [normRatesBlanked; pcRatesBlanked];
                        normRatesBlankedCell = [normRatesBlankedCell pcRatesBlanked];
                        omitRatesBlanked = [omitRatesBlanked; pcOmitRatesBlanked];
                        omitRatesBlankedCell = [omitRatesBlankedCell pcOmitRatesBlanked];
                        pfRates = [pfRates; pfOnlyRates]; pfRatesCell = [pfRatesCell pfOnlyRates];
                        pfOmitRates = [pfOmitRates; pfOnlyRatesOmit]; pfOmitRatesCell = [pfOmitRatesCell pfOnlyRatesOmit];
                        
                        posRates = [posRates; pcRatesSorted];
                        posRatesCell = [posRatesCell pcRatesSorted];
                        omitRates = [omitRates; omitRatesSorted];
                        omitRatesCell = [omitRatesCell omitRatesSorted];
                        
                        pathCell = [pathCell cueShiftStruc.path];
                        cueShiftNameCell = [cueShiftNameCell cueShiftStrucName];
                        posBinFracCell = [posBinFracCell posBinFrac];
                        posInfoCell = [posInfoCell posInfo];
                    else
                        disp([dayDir(i).name ' is not Omit']);
                    end
                end
            catch
                disp(['Some problem processing ' dayDir(i).name ' so skipping']);
            end
            cd([mousePath '/' dayName]);
        end
        
    catch
        disp(['Prob processing so moving to next directory']);
    end
    
    cd(mousePath);
    
end

cueInhibStruc.pathCell = pathCell;
cueInhibStruc.cueShiftNameCell = cueShiftNameCell;
cueInhibStruc.posBinFracCell = posBinFracCell;
cueInhibStruc.posInfoCell = posInfoCell;
cueInhibStruc.normRatesBlanked = normRatesBlanked;
cueInhibStruc.normRatesBlankedCell = normRatesBlankedCell;
cueInhibStruc.omitRatesBlanked = omitRatesBlanked;
cueInhibStruc.omitRatesBlankedCell = omitRatesBlankedCell;
cueInhibStruc.pfRates = pfRates;
cueInhibStruc.pfRatesCell = pfRatesCell;
cueInhibStruc.pfOmitRates = pfOmitRates;
cueInhibStruc.pfOmitRatesCell = pfOmitRatesCell;

cueInhibStruc.posRates = posRates;
cueInhibStruc.posRatesCell = posRatesCell;
cueInhibStruc.omitRates = omitRates;
cueInhibStruc.omitRatesCell = omitRatesCell;

%% save and plot
try
    
save(['cueInhibStruc_' date '.mat'], 'cueInhibStruc');

if toPlot
figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(normRatesBlanked','b');
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(omitRatesBlanked','r');
legend('refLaps', 'omitLaps');
end

nonEp1 = 20:45; %11:50; %11:44;
nonEp2 = 65:85; %61:89; %56:89;
startEp1 = 1:10; 
startEp2 = 90:100;
midEp = 51:60; %45:55;

if toPlot
figure;
%bar([mean(mean(pcRates(:,40:60),2),1) mean(mean(pcRates2(:,40:60),2),1)]);
bar([mean([nanmean(mean(normRatesBlanked(:,nonEp1),2),1) nanmean(mean(normRatesBlanked(:,nonEp2),2),1)]) mean([nanmean(mean(normRatesBlanked(:,startEp1),2),1) nanmean(mean(normRatesBlanked(:,startEp2),2),1)]) nanmean(mean(normRatesBlanked(:,midEp),2),1) nanmean(mean(omitRatesBlanked(:,midEp),2),1)]);
title('pkPos blanked non-cue, startCue, middleCue, omitCue');
%legend('startCueBlanked', 'middleCueBlanked', 'middleOmitBlanked');
ylabel('mean rate');
end

if toPlot
figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(pfRates','b');
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(pfOmitRates','r');
legend('refLaps', 'omitLaps');
title('place field rate only');
end

catch
end









