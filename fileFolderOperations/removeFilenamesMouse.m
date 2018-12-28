function removeFilenamesMouse(fileTag)

toDelete = input(['WARNING: will remove all files with input fileTag ' fileTag ' from the subdirectories- ' sprintf('\n') 'Do you want to do this? (y = yes, then Enter): '], 's');

if strfind(toDelete, 'y')
    mousePath = uigetdir();
    cd(mousePath);
    mouseDir = dir;
    
    for j=3:length(mouseDir)
        dayName = mouseDir(j).name;
        dayPath = [mousePath '/' dayName];
        try
            cd(dayPath);
            dayDir = dir;
            
            for i = 3:length(dayDir)
                try
                    if strfind(dayDir(i).name, '18') % 'TSeries')
                        cd([mousePath '/' dayName '/' dayDir(i).name]);
                        disp(['Deleting ' fileTag ' files from ' dayDir(i).name]);
                        delete(['*' fileTag '*']);
                    end
                catch
                    disp(['Some problem processing ' dayDir(i).name ' so skipping']);
                end
                cd(dayPath);
            end
            
        catch
            
        end
        
        cd(mousePath);
        
    end
    
else
    disp('Aborting...');
end