function [evTrigSig, zeroFr] = eventTrigSig(sig, evTimes, varargin)

%% USAGE: [evTrigSig] = eventTrigSig(sig, evTimes, toPlot, interval, sigTimes);
% Performs event-triggered alignment of signals

%disp(nargin);

% if no times for signal/frames, then just sample index
if length(varargin) >= 1
    toPlot = varargin{1};
    if length(varargin) >= 2
        interval = varargin{2};
        if length(varargin) == 3
            sigTimes = varargin{3};
        else
            sigTimes = 1:length(sig);
        end
    else
        interval = [-10 50];
        sigTimes = 1:length(sig);
    end
    
else
    toPlot = 0;
    sigTimes = 1:length(sig);
    interval = [-10 50];
end

% 
for i = 1:length(evTimes)
    try
    [val, nrstInd] = min(abs(sigTimes-evTimes(i)));
    zeroFr(i) = nrstInd(1);
    evTrigSig(:,i) = sig(nrstInd+interval(1):nrstInd+interval(2));
    catch
        %disp(['Prob with event #' num2str(i)]);
    end
end

if toPlot
    figure; 
    plotMeanSEMshaderr(evTrigSig, 'b');
end
