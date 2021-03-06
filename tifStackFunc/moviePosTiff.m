function moviePosTiff()


% pseudocode
% 1. find laps
% 2. strip out frames for those laps (to cell array of frames for each lap)
% 3. resample activity in laps (over each pixel? this might take a while)
% 4. average over laps (or select out laps of diff types)
%
% alt method
% 1. take all A segments
% 2. mult each by its posRate
% 3. add them together
%
% OR (CURRENT STATE)
% histogram of positions with respect to frames. Then average frames from
% within each bin (I think this might be a lot faster than first method)


% load tiff stack
filename = findLatestFilename('.h5', 'posY');
[Y, Ysiz] = h5readClay(1, 0, filename);

Y = squeeze(Y);
Y = permute(Y, [2 1 3]);

% load cueShiftStruc (for lap info)
load(findLatestFilename('treadBehStruc'));


pos = treadBehStruc.resampY;

if size(Y,3)<length(pos)/1.5 % resize pos if h5 downsampled
    pos = pos(1:2:end);
end

%% split out and avg frames for each spatial bin
% [N, edges, frPosBin] = histcounts(pos,200);
% for i=1:length(N)
%     fr = Y(:,:,(frPosBin==i));
%     fr = squeeze(mean(fr,3));
%     Ypos(:,:,i) = fr;
% end
% 
% 
% 
% %% save filtered, downsampled stack (in tzyxc order)
% 
% Ypos = im2uint16(Ypos/max(Ypos(:))); % change to uint16
% 
% basename = filename(1:strfind(filename, '.h5')-1);
% outfile = [basename '_posY.h5'];
% disp(['Saving posY as H5 (tzyxc order):' outfile]);
% tic;
% saveH5(Ypos, outfile);
% toc;

%% Now stripping out all but normal laps

load(findLatestFilename('cueShiftStruc'));

lapFrInds = cueShiftStruc.lapCueStruc.lapFrInds;
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:max(lapTypeArr)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType); % use ref lap from one with most laps
lapTypeArr = lapTypeArr(2:end-1);
refLaps = find(lapTypeArr==refLapType);


minLapFr = min(diff(lapFrInds(1:end-1)));

%lapFrInds = [1 lapFrInds];
tic;
for i=1:length(lapFrInds)-1
    try
    lapY = Y(:,:,lapFrInds(i):lapFrInds(i+1)-1);
    lapY = lapY(:,:,1:minLapFr); % just truncate to smallest for now (but cuts out a few frames from some, <3)
    YposLap(:,:,:,i+1) = lapY;
    catch
    end
end
toc;


Ypos = squeeze(mean(YposLap(:,:,:,refLaps),4));

% save H5
Ypos = im2uint16(Ypos/max(Ypos(:))); % change to uint16

basename = filename(1:strfind(filename, '.h5')-1);
outfile = [basename '_posY2.h5'];
disp(['Saving posY as H5 (tzyxc order):' outfile]);
tic;
saveH5(Ypos, outfile);
toc;


%% Now from posRates and C/A

load(findLatestFilename('cueShiftStruc'));
load(findLatestFilename('segDict'));

lapFrInds = cueShiftStruc.lapCueStruc.lapFrInds;
lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
for i=1:max(lapTypeArr)
    numLapType(i) = length(find(lapTypeArr==i));
end
[val, refLapType] = max(numLapType); % use ref lap from one with most laps
lapTypeArr = lapTypeArr(2:end-1);
refLaps = find(lapTypeArr==refLapType);

pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC==1);

tic;
Ypos3 = zeros(d1*d2,100);
for i=1:length(pc)
    try
    posRateSeg = cueShiftStruc.PCLappedSessCell{refLapType}.posRates(pc(i),:);
    posRateSeg = posRateSeg/max(posRateSeg);
    aSeg = A(:,pc(i)); aSeg = aSeg/max(aSeg(:));
    posRateA = aSeg*posRateSeg;
    Ypos3 = Ypos3+posRateA;
    catch
    end
end
toc;


Ypos3 = reshape(Ypos3, d1, d2, 100);

% save H5
Ypos3 = im2uint16(Ypos3/max(Ypos3(:))); % change to uint16

basename = filename(1:strfind(filename, '.h5')-1);
outfile = [basename '_posY3.h5'];
disp(['Saving posY as H5 (tzyxc order):' outfile]);
tic;
saveH5(Ypos3, outfile);
toc;