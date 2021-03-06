function [cueSpatModStruc] = cueSpatModMouse()


%{

1. loop through sessions
2. extract treadBehStruc, C, 
3. look at all middle cells
4. see what their normal/shift response amp is

Thoughts
So I have to use shiftOmit sessions because I have to see diff amplitude in only cue
cells, otherwise MEC cells (if there are any) will look like strongly
spatially selective cue cells.

But I don't think sebnem selected these out so I probably have to go back
through and look for these.

%}

%sourcePath = '/Backup20TB/Analysis Aug 2019/Figure1';


mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

avMidCueAmps = []; avMidCueAmpCell={};
avShiftCueAmps = []; avShiftCueAmpCell={};
pathCell = {};

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) % 'TSeries')
                    cd([mousePath '/' dayName '/' dayDir(i).name]);
                    %sessDir = dir;
                    cueShiftStrucName = findLatestFilename('cueShiftStruc');
                    if ~isempty(cueShiftStrucName)
                        load(cueShiftStrucName);
                    else
                        [cueShiftStruc, pksCell] = quickTuning();
                        cueShiftStrucName = findLatestFilename('cueShiftStruc');
                    end
                    %load(cueShiftStrucName);
                    load(findLatestFilename('treadBehStruc'));
                    if contains(cueShiftStrucName, '2P')
                       segDictName =  findLatestFilename('seg2P');
                    else
                        segDictName =  findLatestFilename('segDict');
                    end
                    
                    [cueTypes] = findCueTypes(treadBehStruc); % not using
                    try
                    cueType = cueShiftStruc.lapCueStruc.cueType;
                    catch
                        cueType = cueTypes{1};
                    end
                    
                    try
                    numCuePos = length(cueShiftStruc.lapCueStruc.lapTypeCuePos);
                    catch
                    cueShiftStruc.lapCueStruc = findCueLapTypes();
                    numCuePos = length(cueShiftStruc.lapCueStruc.lapTypeCuePos);
                    end
                    
                    numLapTypes = length(cueShiftStruc.posLapCell);
                    
                    % make sure it's shiftOmit, and not 'led'?
                    if numLapTypes==3 && numCuePos==2 %&& isempty(strfind(cueType, 'led'))
                        disp(['Processing shiftOmit file ' dayDir(i).name]); tic;
                        toPlot=0; eventName = cueType; %toAuto=1; 
                        [cueCellStruc] = findCueCells(cueShiftStruc, eventName, segDictName, toPlot);
                        pathCell = [pathCell cueShiftStruc.path];
                        avMidCueAmps = [avMidCueAmps cueCellStruc.avMidCueAmp];
                        avMidCueAmpCell = [avMidCueAmpCell cueCellStruc.avMidCueAmp];
                        avShiftCueAmps = [avShiftCueAmps cueCellStruc.avShiftCueAmp]; 
                        avShiftCueAmpCell = [avShiftCueAmpCell cueCellStruc.avShiftCueAmp];toc;
                    else
                        disp([dayDir(i).name ' is not shiftOmit']);
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

cueSpatModStruc.pathCell = pathCell;
cueSpatModStruc.avMidCueAmps = avMidCueAmps;
cueSpatModStruc.avMidCueAmpCell = avMidCueAmpCell;
cueSpatModStruc.avShiftCueAmps = avShiftCueAmps; 
cueSpatModStruc.avShiftCueAmpCell = avShiftCueAmpCell;

save(['cueSpatModStruc_' date '.mat'], 'cueSpatModStruc');

try
figure;
plot(avMidCueAmps, avShiftCueAmps, '.');
yl = ylim; xl = xlim;
line(xl,xl);
catch
end
