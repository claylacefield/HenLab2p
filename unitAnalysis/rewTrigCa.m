function [periEvent] = rewTrigCa(ca, treadBehStruc); %, event)

rewTime = treadBehStruc.rewTime;
frTimes = treadBehStruc.adjFrTimes(1:2:end);
vel = treadBehStruc.vel(1:2:end);
vel = fixVel(vel);

rewStartTimes = rewTime([1 find(diff(rewTime)>10)+1]);

frInds = knnsearch(frTimes', rewStartTimes'); % don't know why but must transpose both

for i = 1:length(frInds)
    for j = 1:size(ca,1)
    try
    periEvent(j,:,i) = ca(j,frInds(i)-5*fps:frInds(i)+10*fps);
    
    catch
    end
    end
    try
    periEventVel(:,i) = vel(frInds(i)-5*fps:frInds(i)+10*fps);
    catch
    end
end


squeeze(periEvent);

pe = nanmean(periEvent,3)';
figure('Position', [0 0 1000 400]); 
subplot(1,2,1);
plotMeanSEMshaderr(pe,'b'); 
%hold on; line([76 76], [0.5e4 2e4]);
xlim([0 226]);
subplot(1,2,2);
plot(x,pe);
%hold on; line([0 0], [-2e4 16e4]);




