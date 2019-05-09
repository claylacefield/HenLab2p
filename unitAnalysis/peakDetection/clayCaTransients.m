function [pks] = clayCaTransients(ca, fps, varargin);

% Clay Oct 2017
% 
% New method to detect transient onsets from NMF data
% (not as sensitive to absolute ca levels)
%
% requirements:
% LocalMinima (old script from Buzsaki lab)

defSdThresh = 3;
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

pks = LocalMinima(-dCa, timeoutSec*fps, -thresh);       

% now trying iterative re-baselining while subtracting epochs of current
% spikes
for j = 1:3
    for i = 1:length(pks)
        try
            dCa(pks(i)-3*fps:pks(i)+2*fps) = NaN;
        catch
        end
    end
    %dCa = dCa(~isnan(dCa));
    thresh = (sdThresh)*nanstd(dCa);  % threshold, in SD
    pks2 = LocalMinima(-dCa, timeoutSec*fps, -thresh);
    pks = sort([pks; pks2]);
end

% figure; t = 1:length(ca);
%     plot(ca);
%     hold on;
%     plot(t(pks), ca(pks), 'r*');

% Plotting
if toPlot
    figure; t = 1:length(ca);
    plot(ca);
    hold on;
    plot(t(pks), ca(pks), 'r*');
    
    figure; hold on;
    for i = 1:length(pks)
        try
            plot(ca(pks(i)-100:pks(i)+300)-ca(pks(i)-15));
        catch
        end
    end
end