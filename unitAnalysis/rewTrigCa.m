function [periEvent] = rewTrigCa(C, treadBehStruc); %, event)

%% USAGE: [periEvent] = rewTrigCa(C, treadBehStruc);


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
rewTime = treadBehStruc.rewTime;
frTimes = treadBehStruc.adjFrTimes(1:2:end);
vel = treadBehStruc.vel(1:2:end);
vel = fixVel(vel);

rewStartTimes = rewTime([1 find(diff(rewTime)>10)+1]);

frInds = knnsearch(frTimes', rewStartTimes'); % don't know why but must transpose both

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
subplot(1,2,1);
plotMeanSEMshaderr(pe,'b'); 
hold on; line([10*fps 10*fps], [0.5e4 1e4]);
xlim([0 30*fps]);
subplot(1,2,2);
plot(pe);
%hold on; line([0 0], [-2e4 16e4]);




