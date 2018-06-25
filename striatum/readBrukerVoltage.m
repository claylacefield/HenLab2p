function [v, vTimes, ttlOnInds, ttlOffInds] = readBrukerVoltage()

[filename, path] = uigetfile('*.csv', 'Select Bruker .csv exported voltage recording');
cd(path);

inStruc = readtable(filename); % importdata(filename);

v = inStruc{:,2}; % inStruc.data(:,2);
vTimes = inStruc{:,1}; % inStruc.data(:,1);

% compensate for first frame time
v = v(34:end);
vTimes = vTimes(1:end-33);

[vals, ttlOnInds] = findpeaks(diff(v), vTimes(2:end), 'MinPeakProminence',3, 'MinPeakDistance', 500);

[vals, ttlOffInds] = findpeaks(-diff(v), vTimes(2:end), 'MinPeakProminence',3, 'MinPeakDistance', 500);
