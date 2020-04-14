function [pathCell] = findSessString(tag)


% Clay 2020
% make cell array of all session paths with tag string in name
% (e.g. for compiling all "noCues" sessions in a mouse folder)

mousePath = uigetdir(); % select dir of days folder, e.g. Backup20TB/clay/DGdata
cd(mousePath);
mouseDir = dir;

pathCell = {}; cueShiftNameCell={};

disp(['Compiling all sessions with "' tag '" in name']);

for j=3:length(mouseDir)    % go through all days
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir) % and all sessions
            try
                if (contains(dayDir(i).name, '18') || contains(dayDir(i).name, '19') || contains(dayDir(i).name, '20')) && contains(dayDir(i).name, tag)
                    cd([mousePath '/' dayName '/' dayDir(i).name]);
                    %sessDir = dir;
                    cueShiftStrucName = findLatestFilename('cueShiftStruc'); % load latest cueShiftStruc
                    cueShiftNameCell = [cueShiftNameCell; cueShiftStrucName];
                    currPath = pwd;
                    pathCell = [pathCell; currPath]; % just save path and name for each session used
                    
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

