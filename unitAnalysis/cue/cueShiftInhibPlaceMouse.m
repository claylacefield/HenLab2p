function [cueShiftInhibPlaceStruc] = cueShiftInhibPlaceMouse()


%{


110919
look at response during shift for place cells normally at that
location

%}

%sourcePath = '/Backup20TB/Analysis Aug 2019/Figure1';


%toPlot=1;

mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

pathCell = {}; cueShiftNameCell={};
shiftLocNormRatesCell={}; 
shiftLocShiftRatesCell = {};
shiftLocPcIndCell = {};

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) && contains(dayDir(i).name, 'hift')
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
                    
                    if contains(cueShiftStrucName, '2P')
                       segDictName =  findLatestFilename('seg2P');
                    else
                        segDictName =  findLatestFilename('segDict');
                    end
                    
  disp(['Processing shift file ' dayDir(i).name]); tic;
                        
                        % firing of place cells normally at shift location
                        % during shift laps
                        toPlot = 0;
                        [shiftLocNormRates, shiftLocShiftRates, shiftLocPcInd] = cueShiftInhibPlace(cueShiftStruc, toPlot);

                        
                        pathCell = [pathCell cueShiftStruc.path];
                        cueShiftNameCell = [cueShiftNameCell cueShiftStrucName];
                        
                        shiftLocNormRatesCell = [shiftLocNormRatesCell shiftLocNormRates];
                        shiftLocShiftRatesCell = [shiftLocShiftRatesCell shiftLocShiftRates];
                        shiftLocPcIndCell = [shiftLocPcIndCell shiftLocPcInd];
%                     else
%                         disp([dayDir(i).name ' is not Omit']);
%                     end
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

cueShiftInhibPlaceStruc.pathCell = pathCell;
cueShiftInhibPlaceStruc.cueShiftNameCell = cueShiftNameCell;
cueShiftInhibPlaceStruc.shiftLocPcIndCell = shiftLocPcIndCell;
cueShiftInhibPlaceStruc.shiftLocNormRatesCell = shiftLocNormRatesCell;
cueShiftInhibPlaceStruc.shiftLocShiftRatesCell = shiftLocShiftRatesCell;


%% save and plot

    
save(['cueShiftInhibPlaceStruc_' date '.mat'], 'cueShiftInhibPlaceStruc');

% try
% if toPlot
% figure; 
% %plot(nanmean(normRatesBlanked,1));
% plotMeanSEMshaderr(normRatesBlanked','b');
% hold on;
% %plot(nanmean(omitRatesBlanked,1),'r');
% plotMeanSEMshaderr(omitRatesBlanked','r');
% legend('refLaps', 'omitLaps');
% end
% 
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
% 
% if toPlot
% figure; 
% %plot(nanmean(normRatesBlanked,1));
% plotMeanSEMshaderr(pfRates','b');
% hold on;
% %plot(nanmean(omitRatesBlanked,1),'r');
% plotMeanSEMshaderr(pfOmitRates','r');
% legend('refLaps', 'omitLaps');
% title('place field rate only');
% end
% 
% catch
% end



