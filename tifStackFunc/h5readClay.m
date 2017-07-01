function [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename)


%% USAGE: [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);
% This function reads in a selected exported motion-corrected .h5 

%% select data and map it to the RAM
if filename == 0
    [filename, path] = uigetfile('*.h5', 'Select motion-corrected .h5 file to read');
    nam = [path, filename];  % full name of the data file
    cd(path);
else
    path = pwd;
    nam = [path '/' filename];  % full name of the data file
end


%[~, basename, file_type] = fileparts(nam);

% convert the data to mat file

%nam_mat = [path, filename, '.mat'];

disp('reading in SIMA H5 file (exported motion corrected)'); tic;
%endFr = 2000;   % frame to truncate data at (for testing)
info = h5info(filename); %nam);

if endFr == 0
    T = info.Datasets.Dataspace.Size(end);   % number of frames
else
    T = endFr;
end

chunkSize = info.Datasets.ChunkSize;
if length(chunkSize)==5
    ifSima = 1;
    numCh = info.Datasets.Dataspace.Size(1);
else
    ifSima = 0;
end



if ifSima == 1

    d1 = info.Datasets.Dataspace.Size(2);   % height of the image
    d2 = info.Datasets.Dataspace.Size(3);   % width of the image
    Ysiz = [d1, d2, T]';
    
    disp(['Reading ' num2str(T) ' frames from ch' num2str(segCh)]);
    Y = h5read(nam, '/imaging', [segCh 1 1 1 1], [1 d1 d2 1 T], [numCh 1 1 1 1]);
    %Y = squeeze(Y);
    
    % save([basename '_ch' num2str(ch) '.mat'], 'Y', 'Ysiz', '-v7.3');
    % clear Y Ysiz;
    toc;
else
    d1 = info.Datasets.Dataspace.Size(1);   % height of the image
    d2 = info.Datasets.Dataspace.Size(2);   % width of the image
    Ysiz = [d1, d2, T]';
    
    disp(['Reading ' num2str(T) ' frames from ch' num2str(segCh)]);
    Y = h5read(nam, '/imaging'); %, [1 1 1], [d1 d2 T], [numCh 1 1 1 1]);
    %Y = squeeze(Y);
    
    % save([basename '_ch' num2str(ch) '.mat'], 'Y', 'Ysiz', '-v7.3');
    % clear Y Ysiz;
    toc;
    
end

if length(size(Y))>3
    Y = squeeze(Y);
end

