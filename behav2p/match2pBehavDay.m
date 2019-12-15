function match2pBehavDay()

%% USAGE: match2pBehavMouse();
% Clay Oct. 2018
% NOTE: this is currently written for one data configuration which might be
% different with other file naming conventions, etc.


behavDataFolder = uigetdir('/home/clay/Documents/data/behavior/behaviorData/', 'Select behavior folder of animals'); %'/data/sebnem/behaviorData/WT';

% mouseFolder = uigetdir();
% folder = '/data/sebnem/DG_data/121718';
%
% cd(mouseFolder);
%
% mouseDir = dir;
%
% for i = 3:length(mouseDir)
%    cd(mouseFolder);
%
%    if mouseDir(i).isdir == 1 && ~isempty(strfind(mouseDir(i).name, '18'))
%        dayName = mouseDir(i).name;
%        dayPath = [mouseFolder '/' dayName];

dayPath = uigetdir('/Backup20TB/clay/DGdata/', 'Select day folder of sessions to match');

cd(dayPath);
dayDir = dir;

for j = 3:length(dayDir)
    if dayDir(j).isdir == 1 && (~isempty(strfind(dayDir(j).name, '18')) || ~isempty(strfind(dayDir(j).name, '19')))
        try
            sessName = dayDir(j).name;
            sessPath = [dayPath '/' sessName];
            cd(sessPath);
            lineInds = strfind(sessName, '_');
            mouseName = sessName(lineInds(1)+1:lineInds(2)-1);
            dotInds = strfind(mouseName, '.');
            mouseName(dotInds) = '_';
            %xmlName = findLatestFilename('.xml');
            sessDir = dir;
            
            if isempty(findLatestFilename('.tdml'))
                for k = 3:length(sessDir)
                    if ~isempty(strfind(sessDir(k).name, '.xml'))
                        sessDatenum = sessDir(k).datenum;
                        cd([behavDataFolder '/' mouseName]);
                        filename = findNearestDatenum(sessDatenum);
                        source = [behavDataFolder '/' mouseName '/' filename];
                        disp(['Copying ' source ' to ' sessPath]);
                        copyfile(source, sessPath);
                        
                    end
                end
            end
        catch
        end
    end
end

cd(dayPath);

%    end
% end