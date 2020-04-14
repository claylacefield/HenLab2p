function [Y, filename] = readTiffSeqSess()

% Reads in all tiffs in a folder

sessDir = dir;

frNum = 0;
tic;
disp(['Reading in TIFF sequence from ' pwd]);
fileInds = intersect(find(contains({sessDir.name}, 'ome.tif')), find(contains({sessDir.name}, 'Ch2')));
for i = 1:length(fileInds)
   %if ~isempty(strfind(sessDir(fileInds(i)).name, '.tif')) && ~isempty(strfind(sessDir(fileInds(i)).name, 'Ch2'))
       frNum = frNum+1;
       if frNum == 1
           filename = sessDir(fileInds(i)).name;
           basename = filename(1:strfind(filename, '_Cycle')-1);
            fr = imread(sessDir(fileInds(i)).name); 
            Y = zeros(size(fr,1),size(fr,2),length(fileInds));
       end
       fr = imread(sessDir(fileInds(i)).name); 
       Y(:,:,frNum) = fr;
   %end
    
end
toc;

%mkdir('tiffs');



