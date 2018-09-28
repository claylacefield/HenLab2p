% plotLapTypeAvg(unitTuningStruc, treadBehavStruc)

numfigs = 0;
for i=1:length(segList)
    if mod(i,25)==1
       figure;
       numfigs=numfigs+1;
    end
    subplot(5,5,i-(numfigs-1)*25);
    imagesc(squeeze(unitTuningStruc.PCLappedSess.ByLap.posRateByLap(i,:,:))');
    title(num2str(segList(i)));
end


rewPos = treadBehStruc.rewZoneStartPos; % note: may not work if last lap is switch
lapList = ones(length(treadBehStruc.lapTime)+1,1);
for lap = 1:length(lapList)
   if mod(lap,5)==0
    lapList(lap)=2; 
   end
end

lapType1ind = find(lapList==1);
lapType2ind = find(lapList==2);

numfigs = 0;
for i=1:length(segList)
    posRateLap = squeeze(unitTuningStruc.PCLappedSess.ByLap.posRateByLap(i,:,:));

    posRateLap1 = posRateLap(:,lapType1ind);
    posRateLap2 = posRateLap(:,lapType2ind);
    
    posRateLap1avg(:,i) = mean(posRateLap1,2)';
    posRateLap2avg(:,i) = mean(posRateLap2,2)';
    
    if mod(i,25)==1
       figure;
       numfigs=numfigs+1;
    end
    subplot(5,5,i-(numfigs-1)*25);
    plot(squeeze(posRateLap1avg(:,i)), 'b'); hold on;
    plot(squeeze(posRateLap2avg(:,i)), 'g'); 
    title(num2str(segList(i)));
end


