function [cueRewPairStruc] = cueRewPairingMouse()


%{

See if pairing of a shift stimulus with that location causes a persistent
effect at that location.

110919
Also look at response during shift for place cells normally at that
location

%}

%sourcePath = '/Backup20TB/Analysis Aug 2019/Figure1';


toPlot=1;

mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;


pfOmitRates = []; pfOmitRatesCell = {};
pathCell = {}; cueShiftNameCell={};
posBinFracCell={}; posInfoCell={};
preLap = []; omitLap = []; postLap = [];

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir)
             try
                if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) && contains(dayDir(i).name, 'mit') && contains(dayDir(i).name, 'hift') %&& contains(dayDir(i).name, 'mit')
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
                       segDictName =  findLatestFilename('seg2P', 'goodSeg'); % exclude "goodSeg" files if present
                    else
                        segDictName =  findLatestFilename('segDict');
                    end
                    
                    load(findLatestFilename('treadBehStruc'));
                    
                    %% find lap types
                    try
                    lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
                    catch
                        lapTypeArr = [];
                    end
                    
                    refLapType = findRefLapType(cueShiftStruc);
                    
                    % find lap types
                    numLaps = length(lapTypeArr);
                    normLapInds = find(lapTypeArr==refLapType);
                    omitLapInds = find(lapTypeArr==0);
                    
                    omitLapInds = omitLapInds(omitLapInds~=1 & omitLapInds<numLaps); % trim omit laps
                    
%                     if refLapType==2
%                         shiftLapType = 1;
%                     else
%                         shiftLapType = 2;
%                     end
%                     shiftLapInds = find(lapTypeArr==shiftLapType);
                    
                    
                    % make sure it's shiftOmit, and not 'led'?
                    %if contains(dayDir(i).name, 'hift') %contains(dayDir(i).name, 'mit') || && ~isempty(find(lapTypeArr==0))
                        disp(['Processing shift file ' dayDir(i).name]); tic;
                        
                        
                        %% find the cue type for eventName
                        try
                        eventName = cueShiftStruc.lapCueStruc.cueType; 
                        catch
                            [cueTypes] = findCueTypes(treadBehStruc);
                            eventName = cueTypes{1};
                        end
                        toPlot = 0;
                        try
                            [cueCellStruc] = findCueCells(cueShiftStruc, eventName, segDictName, toPlot);
                            %n=n+1;
                            midCueCellInd = cueCellStruc.midCueCellInd2; %3; % 2x normal/omit PF rate; NO shuff cells
                        catch e
                            disp('Problem finding cue cells');
                            fprintf(1,'The identifier was:\n%s', e.identifier);
                            fprintf(1,', error message:\n%s', e.message);
                            disp(' ');
                        end
                        
                     
                        % loop through all these cells and find middle cue
                        % response with and without reward
                        % BUT
                        % need to check and make sure animal got reward/s
                        
                        for seg=1:length(midCueCellInd)
                            [cueTrigSigStruc] = avgCueTrigSigRew(seg, eventName);
                            
                        end
                        

                        % firing of place cells normally at shift location
                        % during shift laps

                        
%                         pathCell = [pathCell cueShiftStruc.path];
%                         cueShiftNameCell = [cueShiftNameCell cueShiftStrucName];
% 
%                     cueCellStrucCell = [cueCellStrucCell cueCellStruc];

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
        disp(['Prob processing so moving to next directory']);
    end
    
    cd(mousePath);
    
end

cueRewPairStruc.pathCell = pathCell;
cueRewPairStruc.cueShiftNameCell = cueShiftNameCell;

cueRewPairStruc.omitLap = omitLap;
cueRewPairStruc.preLap = preLap;
cueRewPairStruc.postLap = postLap;


%% save and plot

try    
save(['cueRewPairStruc_omitPrePost_' date '.mat'], 'cueRewPairStruc');
catch
end
try
figure; 
plotMeanSEMshaderr(cueRewPairStruc.omitLap,'r'); 
hold on; 
plotMeanSEMshaderr(cueRewPairStruc.preLap,'g');
plotMeanSEMshaderr(cueRewPairStruc.postLap,'b');
catch
end

