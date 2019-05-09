function match2pBehavMouse()

%% USAGE: match2pBehavMouse();
% Clay Oct. 2018
% NOTE: this is currently written for one data configuration which might be
% different with other file naming conventions, etc.

mouseFolder = uigetdir();

behavDataFolder = '/home/clay/Documents/data/behavior/behaviorData/4thFloor';

cd(mouseFolder);

mouseDir = dir;

for i = 3:length(mouseDir)
   cd(mouseFolder);
   
   if mouseDir(i).isdir == 1 && ~isempty(strfind(mouseDir(i).name, '18'))
       dayName = mouseDir(i).name;
       dayPath = [mouseFolder '/' dayName];
       cd(dayPath);
       dayDir = dir;
       
       for j = 3:length(dayDir)
           if dayDir(j).isdir == 1 && ~isempty(strfind(dayDir(j).name, '18'))
               try
               sessName = dayDir(j).name;
               sessPath = [dayPath '/' sessName];
               cd(sessPath);
               hyphenInds = strfind(sessName, '-');
               mouseName = sessName(hyphenInds(2)+1:hyphenInds(3)-1);
               %xmlName = findLatestFilename('.xml');
               sessDir = dir;
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
               catch
               end
           end
       end
   end
end