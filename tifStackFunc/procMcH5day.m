function procMcH5day()

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;

for i = 3:length(dayDir)
    if strfind(dayDir(i).name, 'TSeries')
        cd(dayDir(i).name);
        sessDir = dir;
        try
            test = findLatestFilename('eMC');
        catch
            disp(['Cant find previous eMC.h5 so processing raw .h5: ' findLatestFilename('Cycle')]);
            procMcH5forCaiman('auto');
        end
    end
    cd(dayPath);
end