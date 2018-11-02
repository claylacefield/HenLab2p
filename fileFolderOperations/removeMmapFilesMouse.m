function removeMmapFilesMouse()


mousePath = uigetdir();
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
                disp(['Deleting .mmap files from ' dayDir(i).name]);
                delete *.mmap
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