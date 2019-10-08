function cueTuningS2Pday()

dayPath = uigetdir();
cd(dayPath);
dayDir = dir;


for i = 3:length(dayDir)
    %try
        if ~isempty(strfind(dayDir(i).name, '18')) || ~isempty(strfind(dayDir(i).name, '19')) % 'TSeries')
            cd(dayDir(i).name);
            %sessDir = dir;
            if isempty(findLatestFilename('_2PcueShiftStruc_'))
               lapTypeInfo=[1 4 7 10];
                [cueShiftStruc] = quickTuningS2P(lapTypeInfo);                
            end
        end
    %catch
        disp(['Some problem processing ' dayDir(i).name ' so skipping']);
    %end
    cd(dayPath);
end





