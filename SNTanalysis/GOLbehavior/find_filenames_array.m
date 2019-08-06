behaviorCell = {}
csvNames = dir('*csv');
names = {};
for i = 1:length(csvNames)
    behaviorCell{i}.data = dlmread(csvNames(i).name);
    behaviorCell{i}.fileName = csvNames(i).name;

names{i} = behaviorCell{i}.fileName;
end
names


