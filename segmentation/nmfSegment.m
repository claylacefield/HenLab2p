function [segStruc] = nmfSegment(K,beta, varargin) 

%% USAGE: [segStruc] = nmfSegment(K,beta, varargin);
% no varargin = select exported motion corrected sima h5 file
% varargin{1} = Y, varargin{2} = 'someBasename'

% Taking eftychios's clay_demo_nmf.m script and allowing GUI file selection
% of motion-corrected TIF stack and saves output to "segStruc" along with
% segmentation parameters.
%
% K = # of factors (putative single units) to separate
%   > make this something like twice the number of units you expect,
%   roughly (try 50 or 100) NOTE: 150-175 for DG
% beta = sparseness penalty (=0:1) - this affects how spatially sparse the factors
%   are (?), i.e. is the variance shared by all pixels, or just a subset
%   NOTE: that high values may separate a single unit into multiple units
%   (try beta = 0.009 for DG data, right now)
% toDownsample = [2 2]; % to downsample stack spatially and temporally by 2x
% each
%
% 052017: making a number of changes
% - option to calculate from variable in memory
% - also can set other options in arguments
% - now toDownsample = [4 2], e.g. (spatial, temporal)

% dependencies: 
% movingvar (MATLAB central)
% h5readClay
% trim2pStack
% caSpatTempFilt
% caExpFilt
% downsampleStack
% nmfv1_4
% findGoodSegsDG
% plotGoodSegs


segStruc.notes = 'using nmfSegment'; %, without mean subtraction before smoothing';

%% Load imaging stack (h5 or Y in workspace)

if length(varargin)>0
    Y = varargin{1};
    filename = varargin{2};
    basename = filename;
    saveRed = 0;
else

% ifSima = 1; numCh = 2; 
segCh = 1; %2; 
endFr = 0;  % to read all frames from Ch2 (GCaMP)
filename = 0; %
[Y, Ysiz, filename] = h5readClay(segCh, endFr, filename);

Y = squeeze(Y);

basename = filename(1:strfind(filename, '.h5')-1);
saveRed = 1;

end

segStruc.filename = filename;

%% trim if necessary

if size(Y,1)>512
    [Y, trimYX] = trim2pStack(Y);
else
    trimYX = 0;
end

segStruc.avCh2 = squeeze(mean(Y,3));    % avg green channel
segStruc.trimYX = trimYX;

%% filter stack
toTrim = 0; % already trimmed in separate step
tau = 10;
sigma = 0;
%Y = caSpatTempFilt(Y, toTrim, tau, sigma);
Y = double(Y);

segStruc.filtParams.tau = tau;
segStruc.filtParams.sigma = sigma;

%% Downsample

if size(Y,1)>256
    toDownsample = [2 2]; %[4 2];
    Y = downsampleStack(Y,toDownsample(1),toDownsample(2));
    segStruc.avCh2ds = squeeze(mean(Y,3));  % avg downsampled green channel
else
    toDownsample = 0;
end

segStruc.toDownsample = toDownsample;

%Y = Y(:,:,1:end-50); % hack to trim off some frames from end because of conv2 

%% NMF segmentation

%% normalize and reshape tif stack
[d1,d2,T] = size(Y);  
d = d1*d2;
nn = min(Y(:));              % normalize
mm = max(Y(:)); 
Y = (Y-nn)/(mm-nn);
Yr = reshape(Y,d,T);

clear Y;

%% Sparse non-negative matrix factorization
disp(['Segmenting: K=' num2str(K) ', beta =' num2str(beta)]); tic;
%K = 50;                            % number of components
opt.beta = beta;                   % sparsity penalty (larger values lead to sparser components)
[C,A] = sparsenmfnnls(Yr',K,opt);  % perform sparse NMF
toc;

clear Yr;

%% Save output into structure
%basename = nam(1:(strfind(nam, '.tif')-1));
%segStruc.filename = filename; % nam;
segStruc.segDate = date;
segStruc.C = C; segStruc.A = A; 
segStruc.d1 = d1; segStruc.d2=d2; segStruc.T=T; 
segStruc.K = K; segStruc.opt=opt; 
segStruc.beta = beta;
% segStruc.smoothed = toDownsample;
%segStruc.toDownsample = toDownsample;

%save([basename '_segStruc_1_' date], 'segStruc');

%% Find goodSegs
%if findGoodSegs
disp('Isolating goodSegs'); tic;
[goodSeg, goodSegParams] = findGoodSegsDG(segStruc);
segStruc.goodSeg = goodSeg;
segStruc.goodSegParams = goodSegParams;
toc;
%end

if saveRed
    disp('Saving red channel average'); tic;
%     ifSima = 1; numCh = 2;
    segCh = 1; % Ch1 (tdTomato)
    endFr = 1000;  % only read some frames
    
    [Y, Ysiz, filename] = h5readClay(segCh, endFr, filename); toc;
    
    if trimYX~=0
        Y = Y(trimYX(1):trimYX(3), trimYX(2):trimYX(4), :);
    end
    
    segStruc.avCh1 = squeeze(mean(Y,3));
    
    if toDownsample
        Y = downsampleStack(Y,toDownsample(1),0);
    end
    segStruc.avCh1ds = squeeze(mean(Y,3));
end
clear Y;

try
%if toSave ~= 0

save([basename '_segStruc_b5_' date], 'segStruc');
    
%end
catch
end

% %% Plot if desired
% try
% if plotSeg
%     
% plotSegmentedFactor(segStruc);

try
plotGoodSegs(segStruc, goodSeg);
catch
end

%     
% end
% catch
% end