function postProcS2Pday()

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;


for i = 3:length(dayDir)
    try
        if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) % 'TSeries')
            cd(dayDir(i).name);
            %sessDir = dir;
            if isempty(findLatestFilename('_seg2P_'))
                cd('suite2p/plane0');
                [seg2P]= postProcSuite2p();
                basename = dayDir(i).name;
                cd([dayPath '/' dayDir(i).name]);                
                save ([basename '_seg2P_' date '.mat'], 'seg2P');
            end
        end
    catch
        disp(['Some problem processing ' dayDir(i).name ' so skipping']);
    end
    cd(dayPath);
end





