function procMcTiffsDay()

% This function performs procMcH5forCaiman directly from folder of TIFFs
% (before H5 conversion, e.g. when conversion fails)

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;

for i = 3:length(dayDir)
    if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) %'TSeries')
        cd(dayDir(i).name);
        sessDir = dir;
        %try
        if isempty(findLatestFilename('eMC'))
        %catch
            try
            disp(['Cant find previous eMC.h5 so processing tiff sequence: ']);
            procMcH5forCaiman('tiffs');
            catch
                disp('Error processing this file');
            end
        end
    end
    cd(dayPath);
end