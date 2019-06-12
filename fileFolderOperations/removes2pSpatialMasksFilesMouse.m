function removes2pSpatialMasksFilesMouse()


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
            if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) % 'TSeries')
                cd([mousePath '/' dayName '/' dayDir(i).name '/' 'suite2p' '/' 'plane0']);
                disp(['Deleting .s2pSpatialMasks files from ' dayDir(i).name]);
                delete *s2pSpatialMasks.mat;
                
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