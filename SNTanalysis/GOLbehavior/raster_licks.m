behaviorCell = {}

csvNames = dir('*csv');

for i = 1:length(csvNames)
    behaviorCell{i}.data = dlmread(csvNames(i).name);
    behaviorCell{i}.fileName = csvNames(i).name;


% corresponding position with lick times
d= behaviorCell{i}.data;  
k= dsearchn ((d(:,1)), d(:,3));  %create a list of indexes after finding the closests point in column 1 for each point in column 3
                                % ie row 3, 6,7,8, has closest points in
                                % column 1 and 3
                          
Y = zeros (size(d,1),1);  %create new column with all zeros with the row size of cell d
Y(k)=1; % puts one for all the rows in column Y as indexed from k from dsearchn
lick = d((Y == 1),2)  % this gives you all the positions in column 2 rows that has licks
nolick = d((Y == 0),2)  % this gives you all the positions in column 2 row locations that has no licks

figure; histogram(lick)  % gives you the histogram of licks by automatically detecting the x linspace 

bins = linspace(min(d(:, 2)), max(d(:, 2)), 51);
h = histc(lick, bins);
figure; plot(bins, h)     
end