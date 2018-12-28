function procMcH5day()

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;

for i = 3:length(dayDir)
<<<<<<< HEAD
    if strfind(dayDir(i).name,'18') %, 'TSeries')
=======
    if strfind(dayDir(i).name, '18') %'TSeries')
>>>>>>> 6af074432fe2bdaa557c4ec3830ba3788fd9f520
        cd(dayDir(i).name);
        sessDir = dir;
        try
            test = findLatestFilename('eMC');
        catch
            try
            disp(['Cant find previous eMC.h5 so processing raw .h5: ' findLatestFilename('Cycle')]);
            procMcH5forCaiman('auto');
            catch
                disp('Error processing this file');
            end
        end
    end
    cd(dayPath);
end