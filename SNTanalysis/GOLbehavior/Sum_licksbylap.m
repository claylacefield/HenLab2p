Mean_Lapnumber_IR = [];
for i = 1:length(licksByPosLap)
C = licksByPosLap{i}.counts;
a = sum(C, 2); %across columns (summing all columns in one row)  is done as funct(matrix, 2)
m = mean (a, 1); % across rows(mean of all rows in one column) is funct(matrix, 1)
nLaps = size(C, 1);
Mean_nLaps = [m, nLaps];
Mean_Lapnumber_IR = [Mean_Lapnumber_IR; Mean_nLaps] %for each iteration get mean_lapnumber and
%Mean_Lapnumber_sham = [Mean_Lapnumber_sham; Mean_nLaps]





end