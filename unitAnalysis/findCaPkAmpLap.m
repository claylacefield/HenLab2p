function [lapAvAmp, lapRate, lapCa] = findCaPkAmpLap(ca, toPlot)

% find the amplitude of peaks identified in pksCell

% pseudocode
% pksCell might be from subset of laps
% and from subset of cells
% so have to find the correct cells and laps in C

%ca = C(seg,:);

load(findLatestFilename('treadBehStruc'));

pks = clayCaTransients(ca,15,toPlot,2);  % (ca,fps,toPlot,sdThresh)

numFr = length(ca); %size(C,2);
y = treadBehStruc.resampY;
frTimes = treadBehStruc.adjFrTimes;
if length(y)>numFr*1.5
    y = y(1:2:end);
    frTimes = frTimes(1:2:end);
end

[lapFrInds, lapEpochs] = findLaps(y); % NOTE: lapEpochs is in frInds


% find lap types
[lapCueStruc] = findCueLapTypes(0);
lapTypeArr = lapCueStruc.lapTypeArr;


for i=1:size(lapEpochs,1) % for each lap
    lapPks = pks(find(pks>lapEpochs(i,1) & pks<lapEpochs(i,2))); % find spikes in that lap
    for j=1:length(lapPks)  % for each spike
        try
        pkAmp(j) = max(ca(lapPks(j):lapPks(j)+100)); % find its amplitude
        catch
        end
    end
    if ~isempty(lapPks)
        lapAvAmp(i) = mean(pkAmp); % take mean of spike amplitudes in this lap
    else
        lapAvAmp(i) = 0; %[];
    end
    
    lapCaCell{i} = ca(lapEpochs(i,1):lapEpochs(i,2)); % find spikes in that lap
    
end

if toPlot
% event amplitudes (avg per lap)
figure;
subplot(2,1,1);
plot(lapAvAmp);
xlabel('lap');
ylabel('lapAvAmp');

% sigmoidal fit of lapAvAmp
%figure; 
subplot(2,1,2);
[paramAmp] = sigm_fit(1:length(lapAvAmp), runmean(lapAvAmp,4),[],[],[]);
title('lapAvAmp (smoothed)');
end

%% lap calcium
for i=1:length(lapCaCell)
   lapLen(i) = length(lapCaCell{i}); % length of ca epoch for each lap
   lapCa(:,i) = interp1(1:lapLen(i),lapCaCell{i},linspace(1,lapLen(i),300)); % interpolate each lap ca epoch to 300 (will be wrong for ends, see below)
end

% fix ends
avLapLen1 = round(mean(lapLen(2:5))); % mean lap length for first few laps
lapCaTemp = ones(avLapLen1,1)*lapCa(1,1); %min(lapCaCell{1});
lapCaTemp(avLapLen1-lapLen(1)+1:end) = lapCaCell{1};
lapCa(:,1) = interp1(1:avLapLen1,lapCaTemp,linspace(1,avLapLen1,300)); 

avLapLen2 = round(mean(lapLen(end-6:end-1))); % mean lap length for last few laps
if length(lapCaCell{end}) <= avLapLen2
lapCaTemp = ones(avLapLen2,1)*lapCa(end,end); %min(lapCaCell{end});
lapCaTemp(1:lapLen(end)) = lapCaCell{end};
lapCa(:,end) = interp1(1:avLapLen2,lapCaTemp,linspace(1,avLapLen2,300)); 
else
    lapCaTemp = lapCaCell{end};
    lapCa(:,end) = lapCaTemp(1:length(avLapLen2));
end

%%
if toPlot
figure; 
imagesc(lapCa');
title('lapCa');
end

%% lap rate
rateFr = interp1(pks(1:end-1),runmean(diff(pks),3), 1:pks(end)); % interpolate smoothed rate to frames

for i=1:size(lapEpochs,1) % for each lap
    try
    lapRate(i) = mean(rateFr(lapEpochs(i,1):lapEpochs(i,2)));
    catch
    end

end

lapRate(isnan(lapRate))=[];

% sigmoidal fit of lapAvAmp
if toPlot
figure; 
subplot(2,1,1);
plot(lapRate);
subplot(2,1,2);
[paramRate] = sigm_fit(1:length(lapRate), lapRate',[],[],[]); % param = [Vmin, Vmax, V1/2, slope]
title('lapAvRate (smoothed)');
end
