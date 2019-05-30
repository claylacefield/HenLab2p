function postProcS2Pmouse()

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
            if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '17')) % 'TSeries')
                cd([mousePath '/' dayName '/' dayDir(i).name]);
                %sessDir = dir;
                if isempty(findLatestFilename('_seg2P_'))
                    cd('suite2p/plane0');
                    [seg2P]= postProcSuite2p();
                    basename = dayDir(i).name;
                    cd([mousePath '/' dayName '/' dayDir(i).name]);
                    save ([basename '_seg2P_' date '.mat'], 'seg2P');
                end
            end
        catch
            disp(['Some problem processing ' dayDir(i).name ' so skipping']);
        end
        cd([mousePath '/' dayName]);
    end
    
    catch
       disp(['Prob processing so moving to next directory']); 
    end
    
    cd(mousePath);
    
end