function [Y, filename] = readTiffSeqSess()

% Reads in all tiffs in a folder

sessDir = dir;

frNum = 0;
tic;
for i = 3:length(sessDir)
   if ~isempty(strfind(sessDir(i).name, '.tif')) && ~isempty(strfind(sessDir(i).name, 'Ch2'))
       frNum = frNum+1;
       if frNum == 1
           filename = sessDir(i).name;
%            fr = imread(sessDir(i).name); 
%            Y = zeros(size(fr,1),size(fr,2),???);
       end
       fr = imread(sessDir(i).name); 
       Y(:,:,frNum) = fr;
   end
    
end
toc;




