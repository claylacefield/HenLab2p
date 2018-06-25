function led2pSyncTest_180625()

[v, vTimes, ttlOnInds, ttlOffInds] = readBrukerVoltage();
v = v/max(v);

path = uigetdir();
cd(path);
[relFrTimes, absFrTimes, frInds] = get2pFrTimes('auto');
currDir = dir;

disp('Calculating frame avg.');
tic;
frAvg = []; 
for i = 3:length(currDir) 
    if strfind(currDir(i).name, '.ome.tif') 
        frame = imread(currDir(i).name); 
        frAvg = [frAvg mean(frame(:))]; 
    end
end
toc;
frAvg = frAvg/max(frAvg);

relFrTimes2 = relFrTimes;
relFrTimes2(1) = 0.001;
figure; 
plot(v); 
hold on; 
plot(vTimes(round(relFrTimes2*1000)), frAvg, 'g.-', 'MarkerSize', 18);

