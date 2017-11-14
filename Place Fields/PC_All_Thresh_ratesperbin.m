posRatePC_name=[posRatePC1;posRatePC2;posRatePCn];
posRateAll_name=[posRateAll1;posRateAll2;posRateAlln];
A= posRateAll_name;
ind=sum(A,2)>0;
posRateThresh_name=A(ind,:);
figure; bar(A);

figure;
ax1=subplot(2,1,1); bar (ax1,Thresh_single);
ax2=subplot(2,1,2); bar(ax2, Thresh_multi);
*figure out how to set y axis