function procH5forCaiman(varargin)

%% USAGE: procH5forCaiman(varargin);
%This is based upon nmfSegment and calls some of the preprocessing
% functions and saves a single channel H5 file for use in CaImAn
%
% - also can set other options in arguments
% - now toDownsample = [4 2], e.g. (spatial, temporal)

% dependencies:
% movingvar (MATLAB central)
% h5readClay
% trim2pStack
% caSpatTempFilt
% caExpFilt
% downsampleStack



%segStruc.notes = 'preprocessing file for CaImAn'; %, without mean subtraction before smoothing';

%% Load imaging stack (h5 or Y in workspace)

if length(varargin)>0
    segCh = varargin{1};
    %     filename = varargin{2};
    %     basename = filename;
    if segCh ==2
        saveRed = 1;
    else
        saveRed = 0;
    end
else
    
    %     segCh = 1; endFr = 1000;  % to read 1000 frames from Ch1 (red)
    %     filename = 0; %
    %     [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);
    
    segCh = 1;
    saveRed = 0;
end

%segCh = 2;
endFr = 0;  % to read all frames from Ch2 (GCaMP)
filename = 0; %
[Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);

Y = squeeze(Y);

basename = filename(1:strfind(filename, '.h5')-1);

%saveRed = 1;



%% trim if necessary

if size(Y,1)>512
    [Y, trimYX] = trim2pStack(Y);
else
    trimYX = 0;
end

disp('Saving Ch2 avg tif');
avCh2 = squeeze(mean(Y,3));    % avg green channel
imwrite(double(avCh2/max(avCh2(:))), [basename '_avCh2.tif']); % save tif

%% filter stack
toTrim = 0; % already trimmed in separate step
tau = 10; % 10 yields xcorr offset of 10fr (but this gets downsampled)
sigma = 0;
Y = caSpatTempFilt(Y, toTrim, tau, sigma);

% segStruc.filtParams.tau = tau;
% segStruc.filtParams.sigma = sigma;

%% Downsample

if size(Y,1)>256
    toDownsample = [2 2];  % spatial/temporal, [4 2]
    Y = downsampleStack(Y,toDownsample(1),toDownsample(2));
    %segStruc.avCh2ds = squeeze(mean(Y,3));  % avg downsampled green channel
else
    toDownsample = [0 2]; %0;
    Y = downsampleStack(Y,toDownsample(1),toDownsample(2));
end

%segStruc.toDownsample = toDownsample;

%Y = Y(:,:,1:end-50); % hack to trim off some frames from end because of conv2

disp('Saving Ch2ds avg tif');
avCh2ds = squeeze(mean(Y,3));    % avg green channel
imwrite(double(avCh2ds/max(avCh2ds(:))), [basename '_avCh2ds.tif']); % save tif

%% save filtered, downsampled stack (in tzyxc order)
outfile = [basename '_ch2expDs.h5'];
disp(['Saving filtered, downsampled ch2 as H5 (tzyxc order):' outfile]);
tic;
saveH5(Y, outfile);
toc;

if saveRed
    disp('Saving red channel average'); tic;
    %     ifSima = 1; numCh = 2;
    segCh = 1; % Ch1 (tdTomato)
    endFr = 1000;  % only read some frames
    
    [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename); toc;
    
    if trimYX~=0
        Y = Y(trimYX(1):trimYX(3), trimYX(2):trimYX(4), :);
    end
    
    disp('Saving Ch1 avg tif');
    %segStruc.avCh1 = squeeze(mean(Y,3));
    avCh1 = squeeze(mean(Y,3));    % avg green channel
    imwrite(double(avCh1/max(avCh1(:))), [basename '_avCh1.tif']); % save tif
    
    if toDownsample
        Y = downsampleStack(Y,toDownsample(1),0);
        
        disp('Saving Ch1ds avg tif');
        %segStruc.avCh1ds = squeeze(mean(Y,3));
        avCh1ds = squeeze(mean(Y,3));    % avg green channel
        imwrite(double(avCh1ds/max(avCh1ds(:))), [basename '_avCh1ds.tif']); % save tif
    end
end
clear Y;