function [cueOptoInhibPlaceStruc] = cueOptoInhibPlaceMouse(epoch)


%{
Clay 2020
from cueShiftInhibPlaceMouse

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
optoLocNormRatesCell={}; 
optoLocOptoRatesCell = {};
optoLocPcIndCell = {};

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if (~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) || ~isempty(strfind(dayDir(i).name, '20'))) && contains(dayDir(i).name, 'cueOmitOlfOpto-') && isempty(strfind(dayDir(i).name, 'Dk11'))
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
                    
  disp(['Processing cueShift file ' dayDir(i).name]); tic;
                        
                        % firing of place cells normally at shift location
                        % during shift laps
                        toPlot = 0;
                        %[shiftLocNormRates, shiftLocShiftRates, shiftLocPcInd] = cueShiftInhibPlace(cueShiftStruc, toPlot);
                        [optoLocNormRates, optoLocOptoRates, optoLocPcInd] = cueOptoInhibPlace(cueShiftStruc, epoch, toPlot);

                        
                        pathCell = [pathCell cueShiftStruc.path];
                        cueShiftNameCell = [cueShiftNameCell cueShiftStrucName];
                        
                        optoLocNormRatesCell = [optoLocNormRatesCell optoLocNormRates];
                        optoLocOptoRatesCell = [optoLocOptoRatesCell optoLocOptoRates];
                        optoLocPcIndCell = [optoLocPcIndCell optoLocPcInd];
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

cueOptoInhibPlaceStruc.pathCell = pathCell;
cueOptoInhibPlaceStruc.cueShiftNameCell = cueShiftNameCell;
cueOptoInhibPlaceStruc.PFepoch = epoch;
cueOptoInhibPlaceStruc.optoLocPcIndCell = optoLocPcIndCell;
cueOptoInhibPlaceStruc.optoLocNormRatesCell = optoLocNormRatesCell;
cueOptoInhibPlaceStruc.optoLocOptoRatesCell = optoLocOptoRatesCell;


%% save and plot

    
save(['cueOptoInhibPlaceStruc_ep' num2str(epoch(1)) num2str(epoch(2)) '_' date '.mat'], 'cueOptoInhibPlaceStruc');

plotCueOptoInhibPlaceStruc(cueOptoInhibPlaceStruc);



