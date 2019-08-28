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
filename = findLatestFilename('.h5');
[Y, Ysiz] = h5readClay(1, 0, filename);

% load cueShiftStruc (for lap info)
load(findLatestFilename('treadBehStruc'));

%lapFrInds = cueShiftStruc.lapCueStruc.lapFrInds;
pos = treadBehStruc.resampY;

if size(Y,3)<length(pos)/1.5 % resize pos if h5 downsampled
    pos = pos(1:2:end);
end

% split out and avg frames for each spatial bin
[N, edges, frPosBin] = histcounts(pos,200);
for i=1:length(N)
    fr = Y(:,:,(frPosBin==i));
    fr = squeeze(mean(fr,3));
    Ypos(:,:,i) = fr;
end

%% save filtered, downsampled stack (in tzyxc order)

Ypos = im2uint16(Ypos/max(Ypos(:))); % change to uint16

basename = filename(1:strfind(filename, '.h5')-1);
outfile = [basename '_posY.h5'];
disp(['Saving filtered, downsampled calcium channel as H5 (tzyxc order):' outfile]);
tic;
saveH5(Ypos, outfile);
toc;



