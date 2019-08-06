L=[];
for i=1:length(lickRatebyBin);
lick=lickRatebyBin{i}.Lickrate;
L=[L lick];

end
L=L';

save L
