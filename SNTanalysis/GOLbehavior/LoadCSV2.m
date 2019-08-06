imagingCell = {}

csvNames = dir('*csv');

for i = 1:length(csvNames)
    imagingCell{i}.data = dlmread(csvNames(i).name);
    imagingCell{i}.fileName = csvNames(i).name;
    names{i} = imagingCell{i}.fileName;

end
