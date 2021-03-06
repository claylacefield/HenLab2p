function readTiffSeqSaveH5(numCh);

%% USAGE: readTiffSeqSaveH5();
% Reads in a folder of tiffs, and saves H5 in 'tzyxc' order

folderpath = uigetdir('Select folder of tiffs');

cd(folderpath);

tifDir = dir;

%numFrames = sum(contains({tifDir.name}, '.ome.tif'));
numFrames = sum(~cellfun('isempty', strfind({tifDir.name}, '.ome.tif')));
firstFrame = 1;
frNum = 0;
frNum2 = 0;

tic;
for i = 1:length(tifDir)
    if numCh == 1
        if ~isempty(strfind(tifDir(i).name, '.ome.tif'))
            frNum = frNum + 1;
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
            Y(:,:,frNum)= tif;  % no, need actual frame number, not dir index
        end
        
    elseif numCh == 2
        if ~isempty(strfind(tifDir(i).name, '.ome.tif'))
            if ~isempty(strfind(tifDir(i).name, 'Ch1'))
                frNum = frNum + 1;
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
                Y(:,:,frNum)= tif;  % no, need actual frame number, not dir index
            elseif ~isempty(strfind(tifDir(i).name, 'Ch2'))
                frNum2 = frNum2 + 1;
                tif = imread(tifDir(i).name);
                if firstFrame == 1
                    d1 = size(tif,1);
                    d2 = size(tif, 2);
                    firstFrame = 0;
                    Y2 = zeros(d1,d2,numFrames);
                    filename = tifDir(i).name;
                    basename = filename(1:strfind(filename, '_Cycle')-1);
                    disp(['Reading ' basename]);
                end
                Y2(:,:,frNum2)= tif;  % no, need actual frame number, not dir index
            end
        end
        
    end
    
end

toc;

outfile = [basename '.h5'];
disp(['Saving ' outfile]);
saveH5(Y, outfile);