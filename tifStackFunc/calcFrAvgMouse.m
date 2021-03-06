function calcFrAvgMouse()

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
                try
                    test = findLatestFilename('frAvg');
                catch
                    filename = findLatestFilename('eMC_caChExpDs.h5');
                    disp(['Cant find previous frAvg so calc from ' filename]); % findLatestFilename('Cycle')]);
                    segCh = 1; endFr = 0;
                    [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);
                    frAvg = squeeze(mean(mean(Y,1),2));
                    basename = filename(1:strfind(filename, '_eMC_')-1);
                    [relFrTimes, absFrTimes, frInds] = get2pFrTimes('auto');
                    frTimes = relFrTimes(1:2:end);
                    save([basename '_frAvg_' date], 'frAvg', 'frTimes');
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