function findCueCells(cueShiftStruc)



pc = find(cueShiftStruc.PCLappedSess1.Shuff.isPC==1);

posRates1 = cueShiftStruc.PCLappedSess1.posRates;
posRates2 = cueShiftStruc.PCLappedSess2.posRates;

com1 = centerOfMass(posRates1);
com2 = centerOfMass(posRates2);

com1=com1(pc); com2=com2(pc);

dcom = com1-com2;



for i=1:length(pc)
   [val, lag] = max(xcorr(posRates1(pc(i),:),posRates2(pc(i),:))); 
   lags(i)=100-lag;
end
figure; plot(lags);

for i = 1:20 %length(dcom)
    
    binInds = find(com1>=((i-1)*5) & com1<(i*5));
    if length(binInds)>0
    binDcom(i)=nanmean(dcom(binInds));
    else
        binDcom(i)=0;
    end
    
end

figure; bar(binDcom);