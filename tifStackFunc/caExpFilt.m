function [Y] = caExpFilt(Y, tau)

% Clay 052317


%tau=20; 
x=1:6*tau; %60; %200; 
yexp=exp(-x/tau);
%figure; plot(yexp);

[d1,d2,t]=size(Y);
Y = reshape(Y,d1*d2,t);

disp(['Filtering calcium data with exponential filter, tau=' num2str(tau)]);
tic; 
%Y = conv2(Y,yexp, 'same');
Y = conv2(Y,yexp);

% but this produces 1fr lag and beginning and end are crap (empirically)
Y = Y(:,1:t);  % trim end frames (which are crap)
toc;

Y = reshape(Y, d1,d2, size(Y,2));

% and just replace first 50 frames with frame 51
Y(:,:,1:50) = repmat(Y(:,:,51), 1, 1, 50);


% outfile = 'ch2ExpFilt.h5';
% Y0=Y;
% Y = Y4;
% Ysiz2 = size(Y);
% 
% Y = reshape(Y, [1,Ysiz2(1), Ysiz2(2), 1, Ysiz2(3)]);
% 
% disp(['Writing H5 file ' outfile]); 
% h5create(outfile, '/imaging', size(Y), 'ChunkSize', [1, Ysiz2(1), Ysiz2(2),1,1]);
% tic;
% h5write(outfile, '/imaging', Y);
% toc;