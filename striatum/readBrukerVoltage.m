function [v, vTimes, ttlOn, ttlOff] = readBrukerVoltage()

[filename, path] = uigetfile('*.csv', 'Select Bruker .csv exported voltage recording');
cd(path);

inStruc = importdata(filename);

v = inStruc.data(:,2);
vTimes = inStruc.data(:,1);

[vals, ttlOn] = findpeaks(diff(v), vTimes(2:end), 'MinPeakProminence',3, 'MinPeakDistance', 500);

[vals, ttlOff] = findpeaks(-diff(v), vTimes(2:end), 'MinPeakProminence',3, 'MinPeakDistance', 500);
