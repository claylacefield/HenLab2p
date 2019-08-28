function procS2PCueShiftday()

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;


for i = 3:length(dayDir)
    try
        if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) % 'TSeries')
            cd(dayDir(i).name);
            %sessDir = dir;
            if isempty(findLatestFilename('_2PcueShiftStruc_'))
                [cueShiftStruc] = quickTuningS2P() ;
                basename = dayDir(i).name;
                cd([dayPath '/' dayDir(i).name]);
                save ([basename '_2PcueShiftStruc_' date '.mat'], 'cueShiftStruc');
            end
            
        end
    catch
        disp(['Some problem processing ' dayDir(i).name ' so skipping']);
    end
    cd(dayPath);
end





