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
Y = conv2(Y,yexp, 'same'); 
toc;

Y = reshape(Y, d1,d2, size(Y,2));


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