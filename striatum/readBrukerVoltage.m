function [v, vTimes, ttlOnInds, ttlOffInds] = readBrukerVoltage()

[filename, path] = uigetfile('*.csv', 'Select Bruker .csv exported voltage recording');
cd(path);

inStruc = importdata(filename);

v = inStruc.data(:,2);
vTimes = inStruc.data(:,1);

[vals, ttlOnInds] = findpeaks(diff(v), vTimes(2:end), 'MinPeakProminence',3, 'MinPeakDistance', 500);

[vals, ttlOffInds] = findpeaks(-diff(v), vTimes(2:end), 'MinPeakProminence',3, 'MinPeakDistance', 500);
