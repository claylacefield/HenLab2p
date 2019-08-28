function procMcH5forCaiman(varargin)

%% USAGE: procMcH5forCaiman(varargin);
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

endFr = 0;  % to read all frames from Ch2 (GCaMP)
%filename = 0; %

if length(varargin)>0
    if length(varargin)==1
        if isnumeric(varargin{1})
            if length(varargin{1})==1
                segCh = varargin{1}; % if varargin{1} is numeric, it's segCh
                filename = 0;
                [Y, Ysiz, filename, info] = h5readClay(segCh, endFr, filename);
                Y = squeeze(Y);
                Y = permute(Y, [2 1 3]);
            else
                Y = varargin{1};
                filename = findLatestFilename('Cycle');
                segCh=1;
            end
        else
            flag = varargin{1};
            segCh = 1;
            if isempty(strfind(flag, 'tiffs'))
                if strfind(flag, 'auto')
                    filename = findLatestFilename('Cycle');
                else
                    filename = flag;
                end
                [Y, Ysiz, filename, info] = h5readClay(segCh, endFr, filename);
                Y = squeeze(Y);
                Y = permute(Y, [2 1 3]);
            else
                [Y, filename] = readTiffSeqSess();
            end
        end
        
    elseif length(varargin)==2
        if isstring(varargin{1})
            flag = varargin{1};
            if strfind(flag, 'auto')
                filename = findLatestFilename('Cycle');
            
            else
                filename = flag;
            end
            segCh = varargin{2};
            
            [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);
            Y = squeeze(Y);
            Y = permute(Y, [2 1 3]);
        else
            Y = varargin{1};
            filename = varargin{2};
            segCh=1;
        end
    end
    
else
    %filename = findLatestFilename('Cycle');
    [filename, path] = uigetfile('*.h5', 'Select orig TSeries H5 file to process');
    cd(path);
    segCh = 1;
    
    [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);
    Y = squeeze(Y);
    Y = permute(Y, [2 1 3]);
end

if segCh ==2
    saveRed = 1;
else
    saveRed = 0;
end




% Y = squeeze(Y);
% Y = permute(Y, [2 1 3]);

%basename = filename(1:strfind(filename, '.h5')-1);
basename = filename(1:strfind(filename, '_Cycle')-1);
basename = [basename '_eMC'];

%saveRed = 1;

%% motion correct (with Eftychios's NoRMCorr)
disp('motion correct (with Eftychios NoRMCorr)');
max_shift = 30; % 15;
options = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'bin_width',50,'max_shift',max_shift,'us_fac',50);

tic; 
[Y,shifts,template] = normcorre(Y,options); 
toc;



%% trim if necessary
try
    if size(Y,1)>510 %510
        [Y, trimYX] = trim2pStack(Y);
    else
        trimYX = 0;
    end
catch
    trimYX = 0;
end

disp('Saving Calcium channel avg tif');
avCh2 = squeeze(nanmean(Y,3));    % avg green channel
imwrite(double(avCh2/max(avCh2(:))), [basename '_avCaCh.tif']); % save tif

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

Y = im2uint16(Y/max(Y(:)));

%segStruc.toDownsample = toDownsample;

%Y = Y(:,:,1:end-50); % hack to trim off some frames from end because of conv2

disp('Saving filtered, downsampled calcium channel avg tif');
avCh2ds = squeeze(nanmean(Y,3));    % avg green channel
imwrite(double(avCh2ds/max(avCh2ds(:))), [basename '_avCaChDs.tif']); % save tif

%% save filtered, downsampled stack (in tzyxc order)
outfile = [basename '_caChExpDs.h5'];
disp(['Saving filtered, downsampled calcium channel as H5 (tzyxc order):' outfile]);
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
    
    disp('Saving Ch1/red avg tif');
    %segStruc.avCh1 = squeeze(mean(Y,3));
    avCh1 = squeeze(nanmean(Y,3));    % avg green channel
    imwrite(double(avCh1/max(avCh1(:))), [basename '_avRedCh.tif']); % save tif
    
    if toDownsample
        Y = downsampleStack(Y,toDownsample(1),0);
        
        disp('Saving downsampled Ch1/red avg tif');
        %segStruc.avCh1ds = squeeze(mean(Y,3));
        avCh1ds = squeeze(nanmean(Y,3));    % avg green channel
        imwrite(double(avCh1ds/max(avCh1ds(:))), [basename '_avRedChDs.tif']); % save tif
    end
end
clear Y;