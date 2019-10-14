function [eventCa, zeroInds] = calcEventTrig2pSig(ca, tCa, eventTimes, toPlot)

%% USAGE: [eventCa] = calcEventTrigFPsig(fpStruc, behavStruc, eventName, toPlot);

% window for event triggered calcium signal extraction
preEvSec = 10;
postEvSec = 30;

ca = ca/max(ca);

% load necessary data
% relFrTimes = treadBehStruc.adjFrTimes; %relFrTimes;
% eventTimes = treadBehStruc.(eventName);

% adjust ca frame times if downsampled
% if length(relFrTimes)/length(ca) > 1.5
%    relFrTimes = relFrTimes(2:2:end); 
%    fps = 15;
% else
%     fps = 30;
% end

fps = 1/mean(diff(tCa));

preEvFr = round(preEvSec*fps); % samples before event to include in ca epoch
postEvFr = round(postEvSec*fps);

eventTimes(eventTimes>(max(tCa)-30))= NaN;
eventTimes(eventTimes<(min(tCa)+10))= NaN;

%% extract calcium window around events
for evNum = 1:length(eventTimes)
    %try
        if ~isnan(eventTimes(evNum))
            evTime = eventTimes(evNum);
            [minVal, zeroInd] = min(abs(tCa-evTime));
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
