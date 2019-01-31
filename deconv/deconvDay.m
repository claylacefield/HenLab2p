function deconvDay()

% Clay Dec. 2018
% Function for deconvolving all sessions in a day folder.

dayPath = uigetdir();
cd(dayPath);

dayDir = dir;

for i = 3:length(dayDir) % for all sessions in dayDir
    try
        if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19'))% 'TSeries')
            cd([dayPath '/' dayDir(i).name]);
            %sessDir = dir;
            %try findLatestFilename('deconv')
            if isempty(findLatestFilename('_deconvC_'))
            %catch
                segDictFilename = findLatestFilename('_segDict_');
                disp(['Cant find previous deconv so deconvolving ' segDictFilename]); % findLatestFilename('Cycle')]);
                
                load(segDictFilename);
                [deconvC, recon] = deconvAllC(C);  % deconvolution
                
                outFilename = [segDictFilename(1:strfind(segDictFilename, '_eMC')) 'segDict' segDictFilename(strfind(segDictFilename, '.mat')-6:strfind(segDictFilename, '.mat')-1) '_deconvC_' date '.mat'];
                save(outFilename, 'deconvC', 'recon');
            
            end
        end
    catch
        disp(['Some problem processing ' dayDir(i).name ' so skipping']);
    end
    cd(dayPath);
end
