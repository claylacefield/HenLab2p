behaviorCell = {}

csvNames = dir('*csv');

for i = 1:length(csvNames)
    behaviorCell{i}.data = dlmread(csvNames(i).name);
    behaviorCell{i}.fileName = csvNames(i).name;
end