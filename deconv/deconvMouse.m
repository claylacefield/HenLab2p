function deconvMouse()

% Clay Dec. 2018
% Function for deconvolving all days/sessions in a mouse folder.

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
                %sessDir = dir;
                if isempty(findLatestFilename('deconv'))
                    segDictFilename = findLatestFilename('_segDict_');
                    disp(['Cant find previous deconv so deconvolving ' segDictFilename]); % findLatestFilename('Cycle')]);
                    
                    load(segDictFilename);
                    [deconvC, recon] = deconvAllC(C);  % deconvolution
                    
                    outFilename = [segDictFilename(1:strfind(segDictFilename, '_eMC')) 'segDict' segDictFilename(strfind(segDictFilename, '.mat')-6:strfind(segDictFilename, '.mat')-1) '_deconvC_' date '.mat'];
                    save(outFilename, 'deconvC');
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