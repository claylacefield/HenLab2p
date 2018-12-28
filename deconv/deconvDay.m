function deconvDay()

% Clay Dec. 2018
% Function for deconvolving all sessions in a day folder.

dayPath = uigetdir();
cd(dayPath);

dayDir = dir;

for i = 3:length(dayDir) % for all sessions in dayDir
    try
        if strfind(dayDir(i).name, '18') % 'TSeries')
            cd([dayPath '/' dayDir(i).name]);
            %sessDir = dir;
            try findLatestFilename('deconv')
            % isempty(findLatestFilename('deconv'))
            catch
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
    cd(dayPath);
end
