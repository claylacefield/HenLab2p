function [pks, amps] = clayCaTransients2(ca, fps, varargin);

% Clay Oct 2017
% 
% New method to detect transient onsets from NMF data
% (not as sensitive to absolute ca levels)
%
% requirements:
% LocalMinima (old script from Buzsaki lab)

defSdThresh = 4; % default threshold and timeout
defTimeoutSec = 3;

if isempty(varargin)
    toPlot = 0;
    sdThresh = defSdThresh;
    timeoutSec = defTimeoutSec;
elseif length(varargin)==1
    toPlot = varargin{1};
    sdThresh = defSdThresh;
    timeoutSec = defTimeoutSec;
elseif length(varargin)==2
    toPlot = varargin{1};
    sdThresh = varargin{2};
    timeoutSec = defTimeoutSec;
elseif length(varargin)==3
    toPlot = varargin{1};
    sdThresh = varargin{2};
    timeoutSec = varargin{3};
end

% sdThresh = 6;
% timeoutSec = 5;

ca(1:30) = ca(31); % sometimes beginning is weird, so set to first good point

rm = runmean(ca, fps); % (orig=4) smooth a little: this averages over 4frames, reducing the impact of short noisy activity

dCa = diff(rm);  % note that in absolute terms, this will be one fr short

thresh = sdThresh*std(dCa);  % threshold, in SD

%pks = LocalMinima(-dCa, timeoutSec*fps, -thresh);   
[amps, pks] = findpeaks(dCa, 1:length(dCa), 'MinPeakProminence', thresh, 'MinPeakDistance', timeoutSec*fps); pks = pks';
%figure; plot(ca);hold on; plot(t(pks), ca(pks), 'r.'); plot(t(pks2),ca(pks2), 'm+');

% now trying iterative re-baselining while subtracting epochs of current
% spikes
for j = 1:3 % # iterations
    for i = 1:length(pks)
        try
            dCa(pks(i)-2*fps:pks(i)+3*fps) = NaN; % blank area around each spike
        catch
        end
    end
    %dCa = dCa(~isnan(dCa));
    thresh = (sdThresh)*nanstd(dCa);  % threshold, in SD
    %pks2 = LocalMinima(-dCa, timeoutSec*fps, -thresh);
    [amps, pks2] = findpeaks(dCa, 1:length(dCa), 'MinPeakProminence', thresh, 'MinPeakDistance', timeoutSec*fps); pks2 = pks2';
    pks = sort([pks; pks2]);
end

for i=1:length(pks)
    try
    [maxs(i),inds] = max(ca(pks(i):pks(i)+timeoutSec*fps));
    pkInds(i) = inds+pks(i);
    mins(i) = min(ca(pks(i)-round(timeoutSec*fps/2):pks(i)));
    amps(i) = maxs(i)-mins(i);
    catch
    end
end

%% Plotting
if toPlot
    figure; 
    subplot(2,2,1);
    t = 1:length(ca);
    plot(ca);
    hold on;
    plot(t(pks), ca(pks), 'r*');
    plot(t(pkInds), ca(pkInds), 'g.');
    
    %figure; hold on;
    subplot(2,2,2); hold on;
    for i = 1:length(pks)
        try
            plot(ca(pks(i)-100:pks(i)+300)-ca(pks(i)-15));
        catch
        end
    end
    
    %figure; hold on; 
    subplot(2,2,3); hold on;
    dPks = diff(pks);
    plot((dPks/max(dPks))*max(amps)); 
    plot(amps);
    legend('1/rate', 'amps');
    xlabel('spk #');
end

