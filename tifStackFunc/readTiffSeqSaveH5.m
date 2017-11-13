function [Y] = readTiffSeq()


folderpath = uigetdir();

cd(folderpath);

tifDir = dir;

numFrames = sum(contains({tifDir.name}, '.ome.tif'));
firstFrame = 1;

tic;
for i = 1:length(tifDir)
    if ~isempty(strfind(tifDir(i).name, '.ome.tif'))
        tif = imread(tifDir(i).name);
        if firstFrame == 1
            d1 = size(tif,1);
            d2 = size(tif, 2);
            firstFrame = 0;
            Y = zeros(d1,d2,numFrames);
            filename = tifDir(i).name;
            basename = filename(1:strfind(filename, '_Cycle')-1);
            disp(['Reading ' basename]);
        end
        Y(:,:,i)= tif;  % no, need actual frame number, not dir index
    end
    
end

toc;

outfile = [basename '.h5'];
disp(['Saving ' outfile]);
saveH5(Y, outfile);