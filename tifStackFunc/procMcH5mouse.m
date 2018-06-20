function procMcH5mouse()

mousePath = uigetdir();
cd(mousePath);
mouseDir = dir;

for j=3:length(mouseDir)
    dayName = mouseDir(j).name;
    cd(dayName);
    dayDir = dir;
    
    for i = 3:length(dayDir)
        try
            if strfind(dayDir(i).name, 'TSeries')
                cd(dayDir(i).name);
                %sessDir = dir;
                try
                    test = findLatestFilename('eMC');
                catch
                    disp(['Cant find previous eMC.h5 so processing raw .h5: ' findLatestFilename('Cycle')]);
                    procMcH5forCaiman('auto');
                end
            end
        catch
            disp(['Some problem processing ' dayDir(i).name ' so skipping']);
        end
        cd([mousePath '/' dayName]);
    end
    
    cd(mousePath);
    
end