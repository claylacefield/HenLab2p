function [Y4] = fix2pLines(Y)

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

Y2 = zeros(size(Y,1), size(Y,2)+xShift, size(Y,3));

%tic;
for t = badFrStart:size(Y,3)
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


subplot(3,2,3);
imagesc(mean(Y2,3));
title(['scan lines adj by ' num2str(xShift) ' px']);


%% fix Y discontinuity
% BUT NOTE: the bottom of the frame might be from next frame

disp('Fixing Y axis discontinuity');

avYax = mean(mean(Y2,3),2);

yShift = 100;

Y3 = [Y2(size(Y2,1)-yShift:end,:,:); Y2(1:size(Y2,1)-yShift,:,:)];

subplot(3,2,4);
imagesc(mean(Y3,3));
title(['Y discont corr (' num2str(yShift) ' pix)']);

Y4 = Y3(:,xShift:size(Y3,2)-xShift,:); % trim line borders

subplot(3,2,5);
imagesc(mean(Y4,3));
title('trim x axis');

