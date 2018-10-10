function [Y2, badFrStart] = fix2pLines(); %, tag)

% Clay 2018
% This is an attempt to fix some 2p acquisition sessions where
% the line alignment goes off during recording
% like: /data/sebnem/DG_data/917_IR_MM1/1618/917_IR_MM1_1500-001
% or: /data/sebnem/DG_data/Di_0918_15/092818/92818_Di.0918.15_CtxA-002

% NOTE: that now the offsets are determined manually by looking
% at the bad frames, so this is what we have to do right now
% UPDATE: now finds shifts automatically but need to test on multiple
% datasets

% ToDo:
% - if it seems to work in general case, make it save corrected H5
% - may be able to save data at edges because it seems to be bidirectional
% scan offset (i.e. end of one line is tacked onto previous)

% initOk = 1;
% 
% if initOk == 1  % if initial frames are okay
%     badFrStart = 112;
% else
%     badFrStart = 1;
% end
tic;

filename = uigetfile('*.h5', 'Select raw .h5 data to fix scan lines');
[Y, Ysiz, filename] = h5readClay(1,0,filename);

Y = permute(Y,[2 1 3]); % now should look like original imaging frame

% find start of bad section by big discontinuity in middle of frame (faster
% than computing frame xcorr for all)
% BUT WAIT- this won't work for just line shifts (only frame split)
midsection = squeeze(mean(mean(Y(250:300,:,:),1),2));
dMid = [0; diff(midsection)];
dMid(end-100:end) = 0; % zero frames at end because there is sometimes bad data
dMid = abs(dMid-mean(dMid));
[val, badFrStart] = max(dMid);
%figure; plot(dMid);

Yinit = Y(:,:,1:badFrStart-10);

Ybad = Y(:,:,badFrStart:end);
avBadFr = mean(Ybad,3);
frAvgBadFr = squeeze(mean(mean(Ybad,1),2));
avBadFrY = mean(avBadFr,2);

% find bright point to use for shift
[val, maxYind] = max(avBadFrY);
xShift = round(avBadFrY(maxYind) - avBadFrY(maxYind+1));

xc = xcorr(avBadFr(maxYind,:), avBadFr(maxYind+1,:));
%figure; plot(xc);
[val, maxShift] = max(xc);
xShift = round(length(xc)/2 - abs(maxShift))+4;


%% fix X line shift

disp('Fixing x axis scan line shift');

%shift = 215; %86;

%xShift = shift;  % number of pixels to shift scan lines
%yShift = shift;   % number of pixels to fix Y (BUT note that the lines collected at the end may be from next frame)

Y2 = zeros(size(Y,1), size(Y,2)+xShift, size(Y,3), 'uint16');

%tic;
for t = badFrStart+1:size(Y,3)
    for y = 1:size(Y,1)
        % even to the left of odd lines
        
        if mod(y,2)==0 % for odd lines
            Y2(y, xShift:size(Y,1)+xShift-1,t) = Y(y,:,t);
        else
            Y2(y,1:size(Y,1),t) = Y(y,:,t);
        end
    end
end
%toc;

%clear Y;

figure('Position', [20 20 600 900]);
subplot(3,2,1);
imagesc(mean(Yinit,3));
title('first frames avg');

subplot(3,2,2);
imagesc(avBadFr);
title('mean of bad frames');


subplot(3,2,3);
imagesc(mean(Y2,3));
title(['scan lines adj by ' num2str(xShift) ' px']);

%% trim x borders
% NOTE: may be able to rescue some data from edges because it seems some
% recopying of data at 

disp('Trimming x borders');

Y2 = Y2(:,xShift:size(Y2,2)-xShift,:); % trim line borders

%clear Y3;

subplot(3,2,4);
imagesc(mean(Y2,3));
title('trim x axis');

%% fix Y discontinuity
% BUT NOTE: the bottom of the frame might be from next frame

disp('Fixing Y axis discontinuity');

% need to make this automatic but manual for now
%yShift = 215; %100;

% auto
avYax = mean(mean(Y2,3),2);
[val, yShift] = max([0; diff(avYax)]);

%Y2 = [Y2(size(Y2,1)-yShift:end,:,:); Y2(1:size(Y2,1)-yShift,:,:)];
% NOTE: to save memory, need to do this frame by frame I think
for fr = 1:size(Y2,3)
    Y2(:,:,fr) = [Y2(yShift:end,:,fr); Y2(1:yShift-1,:,fr)];
    %Y2(:,:,fr) = [Y2(size(Y2,1)-yShift:end,:,fr); Y2(1:size(Y2,1)-yShift-1,:,fr)];
end

%clear Y2;

subplot(3,2,5);
imagesc(mean(Y2,3));
title(['Y discont corr (' num2str(yShift) ' pix)']);

toc;

