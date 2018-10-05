function [periEvent] = lapTrigCa(C, treadBehStruc); %, event)

%% USAGE: [periEvent] = rewTrigCa(C, treadBehStruc);
% pcs = find(~(sameCellTuningStruc.multSessSegStruc(2).outPC.Shuff.isPC));
%[periEvent] = rewTrigCa(multSessSegStruc(2).C(pcs,:), multSessSegStruc(2).treadBehStruc);
%[periEvent] = rewTrigCa(multSessSegStruc(2).C(multSessSegStruc(2).goodSeg,:), multSessSegStruc(2).treadBehStruc);

fps=15;

% if input is cell array of peaks
if iscell(C)
    cCell = C;
    C = zeros(length(C),round(length(treadBehStruc.resampY)/2));
    for i = 1:length(cCell)
        C(i,cCell{i})=1;
    end
end

% behav vars
lapTime = treadBehStruc.lapTime;
frTimes = treadBehStruc.adjFrTimes(1:2:end);
vel = treadBehStruc.vel(1:2:end);
vel = fixVel(vel);

lapStartTimes = lapTime([1 find(diff(lapTime)>10)+1]);

frInds = knnsearch(frTimes', lapStartTimes'); % don't know why but must transpose both

for i = 1:length(frInds)
    for j = 1:size(C,1)
    try
    periEvent(j,:,i) = C(j,frInds(i)-10*fps:frInds(i)+20*fps);
    
    catch
    end
    end
    try
    periEventVel(:,i) = vel(frInds(i)-10*fps:frInds(i)+20*fps);
    catch
    end
end


squeeze(periEvent);

pe = nanmean(periEvent,3)';
figure('Position', [0 0 1000 400]); 
subplot(1,3,1);
plotMeanSEMshaderr(pe,'b'); 
hold on; line([10*fps 10*fps], [min(pe(:)) max(pe(:))]);
xlim([0 30*fps]);
title('Lap trig av over cells');

subplot(1,3,2);
plot(pe);
hold on; line([10*fps 10*fps], [min(pe(:)) max(pe(:))]);
xlim([0 30*fps]);
title('Lap trig activity in indiv cells');

subplot(1,3,3);
plotMeanSEMshaderr(periEventVel,'g'); 
hold on; line([10*fps 10*fps], [-1 10]);
xlim([0 30*fps]);
title('Lap trig velocity');




