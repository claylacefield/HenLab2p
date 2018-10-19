function moveDataForUnitSel()



% Go through a folder of days, and for each session in a day, save only
% .mat and .xml into a folder of the same name into an output directory


mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    try
    cd([mousePath '/' dayName]);
    dayDir = dir;
    
    for i = 3:length(dayDir)
        sessName = dayDir(i).name;
        outPath = [mousePath '/OriMicah/' dayName '/' sessName];
        mkdir([mousePath '/OriMicah/' dayName '/'], sessName);
        try
            if strfind(sessName, '18') % 'TSeries')
                sessPath = [mousePath '/' dayName '/' sessName];
                cd(sessPath);
                sessDir = dir;
                for k = 3:length(sessDir)
                    filename = sessDir(k).name;
                    if ~isempty(strfind(filename, '.mat')) || ~isempty(strfind(filename, '.xml')) || ~isempty(strfind(filename, '.tdml'))
                        copyfile([sessPath '/' filename], [outPath '/' filename]);
                    end
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




