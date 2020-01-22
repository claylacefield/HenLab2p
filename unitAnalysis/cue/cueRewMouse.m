function [cueOmitPairStruc] = cueOmitPairingMouse()


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
                        
                        % put analysis in here
                        % 1. find middle cells (not just cue?)
                        %   - so have to be from shiftOmit bec. need omit
                        %   to find cue cells, then shift to look at
                        %   pairing response
                        %   - also, just use midCueCells (2x omit rate)
                        %   because I just want to make sure that the cells
                        %   have some response to cues (i.e. not place
                        %   cells)
                        % 2. look at shift laps
                        %   - find shift laps (from lapTypeArr?)
                        % 3. find lap ca for shift laps -1:+2 (if not omit) 
                        
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
                            midCueCellInd = cueCellStruc.midCueCellInd3; % 2x normal/omit PF rate; NO shuff cells
                        catch e
                            disp('Problem finding cue cells');
                            fprintf(1,'The identifier was:\n%s', e.identifier);
                            fprintf(1,', error message:\n%s', e.message);
                            disp(' ');
                        end
                        
                        % find rew cells (still not working great, maybe
                        % due to goodLaps)
%                         try
%                         [randCueCellStruc] = findRandCueCells('rew', 0, segDictName);
%                         cueCellStruc.rewCueCellInd = randCueCellStruc.isCueCell;
%                         catch
%                         end
%                         
                        % loop through all these cells
                        
                        load(segDictName);
                        if ~isempty(strfind(segDictName, 'seg2P'))
                            C = seg2P.C2p;
                        end
                        
                        %preLap = []; omitLap = []; postLap = [];
                        for seg=1:length(midCueCellInd)
                            preLapSeg = []; omitLapSeg = []; postLapSeg = [];
                            toPlot = 0;
                            try
                                % calc interp lap calcium for each
                                % midCueCell 
                                [lapAvAmp, lapRate, lapCa] = findCaPkAmpLap(C(midCueCellInd(seg),:), toPlot);
                                lapCa2 = lapCa; %(lapCa-min(lapCa(:)))./max(lapCa(:)-min(lapCa(:))); % option to normalize
                                
                                
                                %try
                                for omit=1:length(omitLapInds) % have to go lap-by-lap because of end cases
                                    try
                                        preLapSeg = [preLapSeg lapCa2(:,omitLapInds(omit)-1)]; % lapCa(:,omitLapInds-1);%
                                        omitLapSeg = [omitLapSeg lapCa2(:,omitLapInds(omit))]; % lapCa(:,omitLapInds); %
                                        postLapSeg = [postLapSeg lapCa2(:,omitLapInds(omit)+1)]; % lapCa(:,omitLapInds+1); %
                                    catch e
                                        disp('Problem tabulating lap ca');
                                        fprintf(1,'The identifier was:\n%s', e.identifier);
                                        fprintf(1,', error message:\n%s', e.message);
                                        disp(' ');
                                    end
                                end
                                
                                preLap = [preLap mean(preLapSeg,2)]; % just average all laps for each cell and add to list
                                omitLap = [omitLap mean(omitLapSeg,2)];
                                postLap = [postLap mean(postLapSeg,2)];
                                
                            catch e
                                disp('Problem calculating seg lap ca');
                                fprintf(1,'The identifier was:\n%s', e.identifier);
                                fprintf(1,', error message:\n%s', e.message);
                                disp(' ');
                            end
                            
                            %figure; plotMeanSEMshaderr(omitLap,'r'); hold on; plotMeanSEMshaderr(preLap,'g');plotMeanSEMshaderr(postLap,'b'); title(midCueCellInd(seg));
                        end
                        
                        %figure; plotMeanSEMshaderr(omitLap,'r'); hold on; plotMeanSEMshaderr(preLap,'g');plotMeanSEMshaderr(postLap,'b');
                        
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

cueOmitPairStruc.pathCell = pathCell;
cueOmitPairStruc.cueShiftNameCell = cueShiftNameCell;

cueOmitPairStruc.omitLap = omitLap;
cueOmitPairStruc.preLap = preLap;
cueOmitPairStruc.postLap = postLap;


%% save and plot

try    
save(['cueOmitPairStruc_omitPrePost_' date '.mat'], 'cueOmitPairStruc');
catch
end
try
figure; 
plotMeanSEMshaderr(cueOmitPairStruc.omitLap,'r'); 
hold on; 
plotMeanSEMshaderr(cueOmitPairStruc.preLap,'g');
plotMeanSEMshaderr(cueOmitPairStruc.postLap,'b');
catch
end

