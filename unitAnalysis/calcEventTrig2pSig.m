function [eventCa] = calcEventTrig2pSig(ca, treadBehStruc, eventName, toPlot)

%% USAGE: [eventCa] = calcEventTrigFPsig(fpStruc, behavStruc, eventName, toPlot);

% window for event triggered calcium signal extraction
preEvSec = 10;
postEvSec = 30;

% load necessary data
relFrTimes = treadBehStruc.relFrTimes;
eventTimes = treadBehStruc.(eventName);

% adjust ca frame times if downsampled
if length(relFrTimes)/length(ca) > 1.5
   relFrTimes = relFrTimes(2:2:end); 
   fps = 15;
else
    fps = 30;
end

preEvFr = preEvSec*fps; % samples before event to include in ca epoch
postEvFr = postEvSec*fps;

eventTimes(eventTimes>(max(relFrTimes)-30))= NaN;
eventTimes(eventTimes<(min(relFrTimes)+10))= NaN;

%% extract calcium window around events
for evNum = 1:length(eventTimes)
    %try
        if ~isnan(eventTimes(evNum))
            evTime = eventTimes(evNum);
            [minVal, zeroInd] = min(abs(relFrTimes-evTime));
            eventCa(:, evNum) = ca(zeroInd-preEvFr:zeroInd+postEvFr);
            zeroInds(evNum) = zeroInd;
        else
            eventCa(:, evNum) = NaN([length(-preEvFr:postEvFr) 1], 'single');
            zeroInds(evNum) = NaN;
        end
%     catch
%         disp(['Problem with event # ' num2str(evNum) ' of type ' eventName]);
%     end
end

%% plotting
try
    if toPlot
        figure;
        if size(eventCa,2)>1
            %plotMeanSEM(eventCa, 'b');
            plotFPeventShade(eventCa, [-preEvSec postEvSec]);
        elseif size(eventCa,2)==1
            plot(eventCa);
        end
        title([treadBehStruc.tdmlName ' ' eventName ' on ' date]);
    end
catch
    %eventCa = [];
    disp(['No events of type "' eventName '" within FP recording period']);
end
