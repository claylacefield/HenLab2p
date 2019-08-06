function procMcH5S2Pday()

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;

    
    for i = 3:length(dayDir)
        try
            if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) % 'TSeries')
                cd(dayDir(i).name);
                %sessDir = dir;
                if isempty(findLatestFilename('_nMC_'))
                    disp('Cant find previous nMC.h5 so processing raw .h5'); % findLatestFilename('Cycle')]);
                    procH5forSuite2p('auto');
                end
            end
        catch
            disp(['Some problem processing ' dayDir(i).name ' so skipping']);
        end
    cd(dayPath);
    end
    
       disp(['Prob processing so moving to next directory']); 
    end
    
    
