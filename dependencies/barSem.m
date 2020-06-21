function barSem(data)

% Clay 2020
% Function to make bar plots w. sem errorbars

if ~iscell(data)
    dataCell{1} = data;
else
    dataCell = data;
end


for i=1:length(dataCell)
    avg(i) = mean(dataCell{i});
    sem(i) = std(dataCell{i})/sqrt(length(dataCell{i}));
end


figure;
hold on;
bar(avg);
errorbar(avg, sem, '.');
title(['means= ' num2str(avg) ', sem= ' num2str(sem)]);








    