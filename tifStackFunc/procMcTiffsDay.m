function procMcTiffsDay()

% This function performs procMcH5forCaiman directly from folder of TIFFs
% (before H5 conversion, e.g. when conversion fails)

dayPath = uigetdir('/DataRoller2/clay/dgData'); % sebnem/DG_data');
cd(dayPath);
dayDir = dir;

slashInds = strfind(dayPath, '/');
dayName = dayPath(slashInds(end)+1:end);

for i = 3:length(dayDir)
    if isfolder(dayDir(i).name) %, '18')) || ~isempty(strfind(dayDir(i).name, '19')) %'TSeries')
        cd(dayDir(i).name);
        sessDir = dir;
        %try
        if length({sessDir.name})>50 && isempty(findLatestFilename('eMC'))
        %catch
            try
            disp(['Cant find previous eMC.h5 so processing tiff sequence: ']);
            procMcH5forCaiman('tiffs');
            
            disp('Copying files to Backup20TB');
            outfolder = ['/data/clay/dgData/' dayName '/' dayDir(i).name '/'];
            mkdir(outfolder);
            envName = [dayDir(i).name '.env'];
            copyfile(envName, outfolder);
            xmlName = [dayDir(i).name '.xml'];
            copyfile(xmlName, outfolder);
            mcName = [dayDir(i).name '_eMC_caChExpDs.h5'];
            copyfile(mcName, outfolder);
            tif1Name = [dayDir(i).name '_eMC_avCaCh.tif'];
            copyfile(tif1Name, outfolder);
            tif2Name = [dayDir(i).name '_eMC_avCaChDs.tif'];
            copyfile(tif2Name, outfolder);
            
            catch
                disp('Error processing this file');
            end
        end
    end
    cd(dayPath);
end