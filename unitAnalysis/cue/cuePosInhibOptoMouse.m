function [cueInhibOptoStruc] = cuePosInhibOptoMouse()

toPlot=1;

mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

normRatesBlanked = []; normRatesBlankedCell={};
omitRatesBlanked = []; omitRatesBlankedCell={};
optoRatesBlanked = []; optoRatesBlankedCell={};
omitOptoRatesBlanked = []; omitOptoRatesBlankedCell={};
pfRates = []; pfRatesCell = {};
pfOmitRates = []; pfOmitRatesCell = {};
pfOptoRates = []; pfOptoRatesCell = {};
pfOmitOptoRates = []; pfOmitOptoRatesCell = {};
posRates = []; posRatesCell = {};
omitRates = []; omitRatesCell = {};
optoRates = []; optoRatesCell = {};
omitOptoRates = []; omitOptoRatesCell = {};

pathCell = {}; cueShiftNameCell={};
posBinFracCell={}; posInfoCell={};

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if (~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) || ~isempty(strfind(dayDir(i).name, '20'))) && isfolder(dayDir(i).name) && isempty(strfind(dayDir(i).name, 'Dk11')) && isempty(strfind(dayDir(i).name, 'Mov'))%&& contains(dayDir(i).name, 'mit')
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
                    if (contains(dayDir(i).name, 'cueOmitOlfOpto-') ) && ~contains(dayDir(i).name, 'Dk11') %&& ~contains(dayDir(i).name, '3sens') % || contains(dayDir(i).name, 'hift') && ~isempty(find(lapTypeArr==0))
                        disp(['Processing Omit file ' dayDir(i).name]); tic;
                        toPlot=0; goodSeg = 0; % is PC only % goodSeg = 1; % is all cells
                        %[posBinFrac, posInfo, pcRatesBlanked, pcOmitRatesBlanked, pfOnlyRates, pfOnlyRatesOmit, pcRatesSorted, omitRatesSorted] = cuePosInhib(cueShiftStruc, goodSeg, refLapType, toPlot);
                        %[posBinFrac, posInfo, pcRatesBlanked, pcOmitRatesBlanked, pcOptoRatesBlanked, pfOnlyRates, pfOnlyRatesOmit, pfOnlyRatesOpto, pcRatesSorted, omitRatesSorted, optoRatesSorted] = cuePosInhibOpto(cueShiftStruc, goodSeg, refLapType, toPlot);
                        [posBinFrac, posInfo, pcRatesBlanked, pcOmitRatesBlanked, pcOptoRatesBlanked, pcOmitOptoRatesBlanked, pfOnlyRates, pfOnlyRatesOmit, pfOnlyRatesOpto,  pfOnlyRatesOmitOpto, pcRatesSorted, omitRatesSorted, optoRatesSorted, omitOptoRatesSorted] = cuePosInhibOpto(cueShiftStruc, goodSeg, refLapType, toPlot);
                        normRatesBlanked = [normRatesBlanked; pcRatesBlanked];
                        normRatesBlankedCell = [normRatesBlankedCell pcRatesBlanked];
                        omitRatesBlanked = [omitRatesBlanked; pcOmitRatesBlanked];
                        omitRatesBlankedCell = [omitRatesBlankedCell pcOmitRatesBlanked];
                        optoRatesBlanked = [optoRatesBlanked; pcOptoRatesBlanked];
                        optoRatesBlankedCell = [optoRatesBlankedCell pcOptoRatesBlanked];
                        omitOptoRatesBlanked = [omitOptoRatesBlanked; pcOmitOptoRatesBlanked];
                        omitOptoRatesBlankedCell = [omitOptoRatesBlankedCell pcOmitOptoRatesBlanked];
                        pfRates = [pfRates; pfOnlyRates]; pfRatesCell = [pfRatesCell pfOnlyRates];
                        pfOmitRates = [pfOmitRates; pfOnlyRatesOmit]; pfOmitRatesCell = [pfOmitRatesCell pfOnlyRatesOmit];
                        pfOptoRates = [pfOptoRates; pfOnlyRatesOpto]; pfOptoRatesCell = [pfOptoRatesCell pfOnlyRatesOpto];
                        pfOmitOptoRates = [pfOmitOptoRates; pfOnlyRatesOmitOpto]; pfOmitOptoRatesCell = [pfOmitOptoRatesCell pfOnlyRatesOmitOpto];
                        
                        posRates = [posRates; pcRatesSorted];
                        posRatesCell = [posRatesCell pcRatesSorted];
                        omitRates = [omitRates; omitRatesSorted];
                        omitRatesCell = [omitRatesCell omitRatesSorted];
                        optoRates = [optoRates; optoRatesSorted];
                        optoRatesCell = [optoRatesCell optoRatesSorted];
                        omitOptoRates = [omitOptoRates; omitOptoRatesSorted];
                        omitOptoRatesCell = [omitOptoRatesCell omitOptoRatesSorted];
                        
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

cueInhibOptoStruc.pathCell = pathCell;
cueInhibOptoStruc.cueShiftNameCell = cueShiftNameCell;
cueInhibOptoStruc.posBinFracCell = posBinFracCell;
cueInhibOptoStruc.posInfoCell = posInfoCell;
cueInhibOptoStruc.normRatesBlanked = normRatesBlanked;
cueInhibOptoStruc.normRatesBlankedCell = normRatesBlankedCell;
cueInhibOptoStruc.omitRatesBlanked = omitRatesBlanked;
cueInhibOptoStruc.omitRatesBlankedCell = omitRatesBlankedCell;
cueInhibOptoStruc.optoRatesBlanked = optoRatesBlanked;
cueInhibOptoStruc.optoRatesBlankedCell = optoRatesBlankedCell;
cueInhibOptoStruc.omitOptoRatesBlanked = omitOptoRatesBlanked;
cueInhibOptoStruc.omitOptoRatesBlankedCell = omitOptoRatesBlankedCell;
cueInhibOptoStruc.pfRates = pfRates;
cueInhibOptoStruc.pfRatesCell = pfRatesCell;
cueInhibOptoStruc.pfOmitRates = pfOmitRates;
cueInhibOptoStruc.pfOmitRatesCell = pfOmitRatesCell; 
cueInhibOptoStruc.pfOptoRates = pfOptoRates;
cueInhibOptoStruc.pfOptoRatesCell = pfOptoRatesCell; 
cueInhibOptoStruc.pfOmitOptoRates = pfOmitOptoRates;
cueInhibOptoStruc.pfOmitOptoRatesCell = pfOmitOptoRatesCell; 

cueInhibOptoStruc.posRates = posRates;
cueInhibOptoStruc.posRatesCell = posRatesCell;
cueInhibOptoStruc.omitRates = omitRates;
cueInhibOptoStruc.omitRatesCell = omitRatesCell;
cueInhibOptoStruc.optoRates = optoRates;
cueInhibOptoStruc.optoRatesCell = optoRatesCell;
cueInhibOptoStruc.omitOptoRates = omitOptoRates;
cueInhibOptoStruc.omitOptoRatesCell = omitOptoRatesCell;

%% save and plot
try
    
save(['cueInhibOptoStruc_' date '.mat'], 'cueInhibOptoStruc');

if toPlot
figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(normRatesBlanked','b');
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(omitRatesBlanked','g');
plotMeanSEMshaderr(optoRatesBlanked','r');
plotMeanSEMshaderr(omitOptoRatesBlanked','c');
legend('refLaps', 'omitLaps', 'opto laps', 'omitOpto');
end

% nonEp1 = 20:45; %11:50; %11:44;
% nonEp2 = 65:85; %61:89; %56:89;
% startEp1 = 1:10; 
% startEp2 = 90:100;
% midEp = 51:60; %45:55;
% 
% if toPlot
% figure;
% %bar([mean(mean(pcRates(:,40:60),2),1) mean(mean(pcRates2(:,40:60),2),1)]);
% bar([mean([nanmean(mean(normRatesBlanked(:,nonEp1),2),1) nanmean(mean(normRatesBlanked(:,nonEp2),2),1)]) mean([nanmean(mean(normRatesBlanked(:,startEp1),2),1) nanmean(mean(normRatesBlanked(:,startEp2),2),1)]) nanmean(mean(normRatesBlanked(:,midEp),2),1) nanmean(mean(omitRatesBlanked(:,midEp),2),1)]);
% title('pkPos blanked non-cue, startCue, middleCue, omitCue');
% %legend('startCueBlanked', 'middleCueBlanked', 'middleOmitBlanked');
% ylabel('mean rate');
% end

if toPlot
figure; 
%plot(nanmean(normRatesBlanked,1));
plotMeanSEMshaderr(pfRates','b');
hold on;
%plot(nanmean(omitRatesBlanked,1),'r');
plotMeanSEMshaderr(pfOmitRates','g');
plotMeanSEMshaderr(pfOptoRates','r');
plotMeanSEMshaderr(pfOmitOptoRates','c');
legend('refLaps', 'omitLaps', 'optoLaps');
title('place field rate only');
end

catch
end









