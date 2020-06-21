function [groupLinFitStruc] = linFitCaMouse()


% Clay 2020
% Look through all days in a "mouse" folder, find randCue sessions, run
% linearFitCaCueSess.m, and compile cue and place coefs for cells with
% R2>0.1

% choose start directory
mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

% initialize output variables
cueCoefs = []; cueCoefsCell = {};
placeCoefs = []; placeCoefsCell = {};
pathCell = {}; segDictNameCell={};
okCellIndsCell={}; placeParamCell={};

% crawl directories looking for randCue sessions
for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if isfolder(dayDir(i).name) && contains(dayDir(i).name, '_randCue')
                    cd([mousePath '/' dayName '/' dayDir(i).name]);
                    %sessDir = dir;
                    
                    disp(['Processing shift file ' dayDir(i).name]); tic;
                    
                    %% (put analysis in here)
                    
                    toPlot = 0;                    
                    % run linear model on this session
                    [linFitStruc, summStruc] = linearFitCaCueSess(toPlot);
                    
                    pathCell = [pathCell summStruc.path];
                    segDictNameCell = [segDictNameCell summStruc.segDictName];
                    okCellIndsCell = [okCellIndsCell summStruc.okCells]; % cell indices of cells with ok R2 and some significant params (>0.04)
                    cueCoefs = [cueCoefs; summStruc.cueCoef]; cueCoefsCell = [cueCoefsCell summStruc.cueCoef];
                    placeCoefs = [placeCoefs; summStruc.placeCoef]; placeCoefsCell = [placeCoefsCell summStruc.placeCoef];
                    placeParamCell = [placeParamCell summStruc.placeParam];

                end
            catch e
                disp(['Some problem processing ' dayDir(i).name ' so skipping']);
                fprintf(1,'The identifier was:\n%s', e.identifier);
                fprintf(1,', error message:\n%s', e.message);
                disp(' ');
                
            end
            cd([mousePath '/' dayName]);
        end
        
    catch
        disp(['Prob processing ' dayName ' so moving to next directory']);
    end
    
    cd(mousePath);
    
end


%% compile vars into output struc
groupLinFitStruc.pathCell = pathCell; 
groupLinFitStruc.segDictNameCell = segDictNameCell;
groupLinFitStruc.okCellIndsCell = okCellIndsCell; 
groupLinFitStruc.placeParamCell = placeParamCell;
groupLinFitStruc.cueCoefs = cueCoefs; 
groupLinFitStruc.cueCoefsCell = cueCoefsCell;
groupLinFitStruc.placeCoefs = placeCoefs; 
groupLinFitStruc.placeCoefsCell = placeCoefsCell;


%% plotting
toPlot = 1;
if toPlot
    figure; plot(cueCoefs, placeCoefs,'.');
    hold on;
    line([0 0], get(gca,'YLim'));
    line(get(gca,'XLim'),[0 0]);
    xlabel('cueCoef'); ylabel('placeCoef');
end