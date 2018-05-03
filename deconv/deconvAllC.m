function [recon, sAll] = deconvAllC(C);

%% USAGE: [recon, sAll] = deconvAllC(C);
% Clay 2018
% Perform OASIS deconvolution on all neurons in NMF C matrix.
% NOTE: this takes a long time because it's single threaded
%
% Outputs:
%   recon = recontructed calcium signal after deconvolution
%   sAll = s deconv spikes for all neurons
%
% NOTE: you can run OASIS deconvCa on all neurons at once, but it 
%   concatenates them and it looks like values for some cells don't work
%   for others, so this runs one by one.
%
% Dependencies:
% OASIS_matlab (from zhoupc github)

recon = zeros(size(C));
sAll = zeros(size(C));

for seg = 1:size(C,1)
%seg = 26; %88; %100; %185;
ca = C(seg,:);
disp(['Deconvolving seg#' num2str(seg)]);
tic;
[c,s,options] = deconvolveCa(ca, 'ar2');
toc;
recon(seg,:) = c;
sAll(seg,:) = s;
end

