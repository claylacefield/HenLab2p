function deconvCage()

% Clay Dec. 2018
% Function for deconvolving all sessions in a day folder.

cagePath = uigetdir();
cd(cagePath);
cageDir = dir;

for k = 3:length(cageDir)
    try
        mousePath = [cagePath '/' cageDir(k).name];
        cd(mousePath);
        mouseDir = dir;
        
        for j = 3:length(mouseDir)
            try
                dayPath = [mousePath '/' mouseDir(j).name];
                cd(dayPath);
                
                dayDir = dir;
                
                for i = 3:length(dayDir) % for all sessions in dayDir
                    try
                        if strfind(dayDir(i).name, '18') % 'TSeries')
                            cd([dayPath '/' dayDir(i).name]);
                            %sessDir = dir;
                            if ~isempty(findLatestFilename('_deconvC_'))

                                segDictFilename = findLatestFilename('_segDict_', 'goodSeg');
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
                    cd(dayPath);
                end
                
            catch
                disp(['Some problem processing ' mouseDir(j).name ' so skipping']);
            end
            cd(mousePath);
            
        end  % end FOR loop for all days in mouseFolder
        
    catch
        disp(['Some problem processing ' cageDir(k).name ' so skipping']);
    end
    cd(cagePath);
    
end % end FOR loop for all mice in cageFolder
