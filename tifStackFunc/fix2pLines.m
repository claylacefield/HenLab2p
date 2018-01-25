function [Y2] = fix2pLines(Y)

% Clay 2018
% This is an attempt to fix some 2p acquisition sessions where
% the line alignment goes off during recording
% like: /data/sebnem/DG_data/917_IR_MM1/1618/917_IR_MM1_1500-001

% NOTE: that now the offsets are determined manually by looking
% at the bad frames, so this is what we have to do right now

initOk = 1;

if initOk == 1  % if initial frames are okay
    badFrStart = 112;
else
    badFrStart = 1;
end

Y = permute(Y,[2 1 3]);

Yinit = Y(:,:,1:badFrStart-10);

figure('Position', [20 20 600 900]);
subplot(3,2,1);
imagesc(mean(Yinit,3));
title('first frames avg');

subplot(3,2,2);
imagesc(mean(Y(:,:,badFrStart+10:end),3));
title('mean of bad frames');

%% fix X line shift

disp('Fixing x axis scan line shift');

shift = 86;

xShift = shift;  % number of pixels to shift scan lines
yShift = shift;   % number of pixels to fix Y (BUT note that the lines collected at the end may be from next frame)

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

clear Y;

subplot(3,2,3);
imagesc(mean(Y2,3));
title(['scan lines adj by ' num2str(xShift) ' px']);

%% trim x borders

disp('Trimming x borders');

Y2 = Y2(:,xShift:size(Y2,2)-xShift,:); % trim line borders

%clear Y3;

subplot(3,2,4);
imagesc(mean(Y2,3));
title('trim x axis');

%% fix Y discontinuity
% BUT NOTE: the bottom of the frame might be from next frame

disp('Fixing Y axis discontinuity');

avYax = mean(mean(Y2,3),2);

yShift = 100;

%Y2 = [Y2(size(Y2,1)-yShift:end,:,:); Y2(1:size(Y2,1)-yShift,:,:)];
% NOTE: to save memory, need to do this frame by frame I think
for fr = 1:size(Y2,3)
    Y2(:,:,fr) = [Y2(size(Y2,1)-yShift:end,:,fr); Y2(1:size(Y2,1)-yShift-1,:,fr)];
end

%clear Y2;

subplot(3,2,5);
imagesc(mean(Y2,3));
title(['Y discont corr (' num2str(yShift) ' pix)']);



