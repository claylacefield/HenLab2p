
% e.g. '181211_XIR.1118.09_cueShift-003_Cycle00001_Element00001.h5'

% this circshifts to find right register
a3=a2;
a3(2:2:end,:) = a3(2:2:end, end:-1:1); % reverse every other line for subsequent linearization
a3=a3';
a4 = a3(:);  % linearize (note have to transpose first)
a4b = circshift(a4,512*80-25); % shift by some amount
a4b = reshape(a4b, 512, 512);   % reshape to frame
a4b=a4b';
a4b(2:2:end,:) = a4b(2:2:end, end:-1:1);  % put every other line back in correct direction
figure; imagesc(a4b);

% this xcorrs frame from every other line with other frame
a3 = a2;
a3a = a3(1:2:end,:);
a3b = a3(2:2:end,:);



% another method

avg = mean(Y(:,:,1:1000),3);

tic;
D = abs(diff(Y,1,3));
D(:,:,size(D,3)+1) = zeros(512,512);
sumDiff = sum(reshape(D, 512*512, size(D,3)),1);
toc;

for i = 1:size(Y,3)
    
    

end











