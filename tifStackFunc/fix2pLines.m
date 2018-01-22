function [Y] = fix2pLines(Y)

% Clay 2018
% This is an attempt to fix some 2p acquisition sessions where
% the line alignment goes off during recording
% like: /data/sebnem/DG_data/917_IR_MM1/1618/917_IR_MM1_1500-001

if initOk == 1  % if initial frames are okay
    badFrStart = 112;
else
    badFrStart = 1;
end

shift = 86;

 xShift = shift;  % number of pixels to shift scan lines
 yShift = shift;   % number of pixels to fix Y (BUT note that the lines collected at the end may be from next frame)
 
 Y2 = zeros(size(Y,1), size(Y,2)+xShift, size(Y,3));
 
 tic;
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
 toc;
 
 figure;
 imagesc(mean(Y2,3));