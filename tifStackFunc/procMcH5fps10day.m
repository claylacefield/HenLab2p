function procMcH5fps10day()

% This is just a wrapper script for procMcH5forCaiman
% clay2019


dayPath = uigetdir();
cd(dayPath);
dayDir = dir;

for i = 3:length(dayDir)
    if isfolder(dayDir(i).name)%~isempty(strfind(dayDir(i).name, '18')) ||  ~isempty(strfind(dayDir(i).name, '19'))%'TSeries')
        cd(dayDir(i).name);
        sessDir = dir;
        %try
        if isempty(findLatestFilename('eMC'))
        %catch
            try
            disp(['Cant find previous eMC.h5 so processing 10fps raw .h5: ' findLatestFilename('Cycle')]);
            procMcH5fps10sess();
            catch
                disp('Error processing this file');
            end
        end
    end
    cd(dayPath);
end