d = dir('*tdml');
treadBehStruc = {};
for ii = 1:length(d)
  treadBehStruc{ii} = readTDML_AG(pwd, d(ii).name);
end