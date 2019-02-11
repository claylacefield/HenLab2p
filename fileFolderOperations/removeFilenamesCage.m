function removeFilenamesCage(fileTag)

toDelete = input(['WARNING: will remove all files with input fileTag ' fileTag ' from the subdirectories- ' sprintf('\n') 'Do you want to do this? (y = yes, then Enter): '], 's');

if strfind(toDelete, 'y')
    cagePath = uigetdir();
    
    cd(cagePath);
    
    cageDir = dir;
    
    for k=3:length(cageDir)
        try
            mouseName = cageDir(k).name;
            mousePath = [cagePath '/' mouseName];
            cd(mousePath);
            mouseDir = dir;
            
            for j=3:length(mouseDir)
                dayName = mouseDir(j).name;
                try
                    cd([mousePath '/' dayName]);
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
                        cd([mousePath '/' dayName]);
                    end
                    
                catch
                    
                end
                
                cd(mousePath);
                
            end
            
        catch
        end
        
        cd(cagePath);
    end
    
else
    disp('Aborting...');
end