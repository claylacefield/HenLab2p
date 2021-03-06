function match2pBehavMouse()

%% USAGE: match2pBehavMouse();
% Clay May 2019
% NOTE: this is currently written for one data configuration which might be
% different with other file naming conventions, etc.

mouseFolder = uigetdir('/data/sebnem/DG_data', 'Select mouse folder of 2p data');
disp(['Moving behavior for ' mouseFolder]);

behavDataFolder = uigetdir('/data/sebnem/behaviorData', 'Select behavior folder for this animal');
disp(['Behavior data folder for this mouse ' behavDataFolder]);

%mouseName = mouseFolder(strfind(mouseFolder, 'DG_data/')+8:end);

cd(mouseFolder);

mouseDir = dir;

for i = 3:length(mouseDir)
    cd(mouseFolder);
    
    if mouseDir(i).isdir == 1 && (~isempty(strfind(mouseDir(i).name, '18')) || ~isempty(strfind(mouseDir(i).name, '19')))
        dayName = mouseDir(i).name;
        dayPath = [mouseFolder '/' dayName];
        cd(dayPath);
        dayDir = dir;
        
        for j = 3:length(dayDir)
            if dayDir(j).isdir == 1 && (~isempty(strfind(dayDir(j).name, '18')) || ~isempty(strfind(dayDir(j).name, '19')))
                try
                    sessName = dayDir(j).name;
                    sessPath = [dayPath '/' sessName];
                    cd(sessPath);
%                     lineInds = strfind(sessName, '_');
%                     mouseName = sessName(lineInds(1)+1:lineInds(2)-1);
%                     dotInds = strfind(mouseName, '.');
%                     mouseName(dotInds) = '_';
                    %xmlName = findLatestFilename('.xml');
                    sessDir = dir;
                    
                    if isempty(findLatestFilename('.tdml'))
                        for k = 3:length(sessDir)
                            if ~isempty(strfind(sessDir(k).name, '.xml'))
                                sessDatenum = sessDir(k).datenum; % this is XML datenum, which is at start of 2p acqu.
                                cd(behavDataFolder);
                                filename = findNearestDatenum(sessDatenum);
                                source = [behavDataFolder '/' filename];
                                disp(['Copying ' source ' to ' sessPath]);
                                copyfile(source, sessPath);
                                
                            end
                        end
                    end
                catch
                end % end TRY/CATCH for session
            end % end IF isdir and 2018 or 2019
        end % end FOR loop for sessions in day
        
        cd(dayPath);
    end
    cd(mouseFolder);
end