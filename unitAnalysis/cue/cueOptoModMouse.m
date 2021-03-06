function [cueOptoModStruc] = cueOptoModMouse()


%{

1. loop through sessions
2. extract treadBehStruc, C, 
3. look at all middle cells
4. see what their normal/Opto response amp is

Thoughts
So I have to use OptoOmit sessions because I have to see diff amplitude in only cue
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
avOptoCueAmps = []; avOptoCueAmpCell={};
pathCell = {};
segDictCell = {};
cueCellIndsCell = {};

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
            try
                if (~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) || ~isempty(strfind(dayDir(i).name, '20'))) && contains(dayDir(i).name, 'cueOmitOlfOpto-') && isempty(strfind(dayDir(i).name, 'Dk11')) && isempty(strfind(dayDir(i).name, 'Mov'))% 'TSeries')
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
                    
                    % make sure it's OptoOmit, and not 'led'?
                    %if numLapTypes==3 && numCuePos==2 %&& isempty(strfind(cueType, 'led'))
                        disp(['Processing OptoOmit file ' dayDir(i).name]); tic;
                        toPlot=0; eventName = cueType; %toAuto=1; 
                        [cueCellStruc] = findCueCells(cueShiftStruc, eventName, segDictName, toPlot);
                        cueCellInds = cueCellStruc.midCueCellInd;
                        pathCell = [pathCell; cueShiftStruc.path];
                        segDictCell = [segDictCell; segDictName];
                        cueCellIndsCell = [cueCellIndsCell cueCellInds];
                        
                        % now look back through and calculate avgCueTrigSig
                        toPlot = 0; toZ = 0;
                        for segNum=1:length(cueCellInds)
                            [cueTrigSigStruc] = avgCueTrigSigNew(cueCellInds(segNum), eventName, toPlot, segDictName, toZ);
                            midCueSigs = cueTrigSigStruc.evTrigSigCell{1};
                            optoCueSigs = cueTrigSigStruc.evTrigSigCell{3};
                            midCueAmp(segNum) = max(mean(midCueSigs(35:116,:),2));
                            optoCueAmp(segNum) = max(mean(optoCueSigs(35:116,:),2));
                        end
                        
                        avMidCueAmps = [avMidCueAmps midCueAmp];
                        avMidCueAmpCell = [avMidCueAmpCell midCueAmp];
                        avOptoCueAmps = [avOptoCueAmps optoCueAmp]; 
                        avOptoCueAmpCell = [avOptoCueAmpCell optoCueAmp];toc;
%                     else
%                         disp([dayDir(i).name ' is not OptoOmit']);
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

cueOptoModStruc.pathCell = pathCell;
cueOptoModStruc.avMidCueAmps = avMidCueAmps;
cueOptoModStruc.avMidCueAmpCell = avMidCueAmpCell;
cueOptoModStruc.avOptoCueAmps = avOptoCueAmps; 
cueOptoModStruc.avOptoCueAmpCell = avOptoCueAmpCell;

save(['cueOptoModStruc_' date '.mat'], 'cueOptoModStruc');

try
figure;
plot(avMidCueAmps, avOptoCueAmps, '.');
yl = ylim; xl = xlim;
line(xl,xl);
catch
end
