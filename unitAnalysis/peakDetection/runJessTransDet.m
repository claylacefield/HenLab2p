function [jessTransStruc] = runJessTransDet(C, fps, thresh, toPlot);

%% USAGE: [jessTransStruc] = runJessTransDet(C, fps);

% params
%thresh = 2;  % minimum amplitude size of ca transient in s.d.
baseline = 1; % s.d. offset value of ca transient
t_half = 3; % half life of gcamp type used (s), G6s = 3, G6f = 0.2
FR = fps;

% raw_cell = nFr x nCells
raw_cell = [];
for i = 1:size(C,1)
    ca = C(i,:);
    %ca = ca - runmean(ca, 240*fps);  % just subtract slow component of signal
    %cutoff = 0.05; % 
    %filt = butter(10, cutoff*2/fps, 'high');
    %filt = designfilt('highpassiir', 'FilterOrder', 3, 'HalfPowerFrequency', 0.001);
    %ca = filtfilt(filt, ca);
    %ca = ca - min(ca);
    raw_cell(:,i) = ca;
end

[zscored_cell,cell_transients,cell_events, cell_AUC]=detect_ca_transients(raw_cell,thresh,baseline,t_half,FR, toPlot);

jessTransStruc.zscored_cell = zscored_cell;
jessTransStruc.cell_transients = cell_transients;
jessTransStruc.cell_events = cell_events;
jessTransStruc.cell_AUC = cell_AUC;