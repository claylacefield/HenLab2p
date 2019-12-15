function [s] = clayDeconvCa(ca, toPlot);

%% USAGE: [s] = clayDeconvCa(ca, toPlot);
% Clay 2018
% Wrapper script for OASIS_matlab from zhoupc github
% (MATLAB implementation of Johannes Friedrich OASIS by PengCheng)
% NOTE: this may produce spurious results for bad units so 
% maybe cull units with more stringent transient detection first.

% 'ar2' model seems to work okay for G6s
model = 'ar2'; %'ar2';  % autoregressive model of convolution kernel

%ca = runmean(ca,10);
ca = ca-min(ca);
%ca = [zeros(1,20) ca(1:end-20)];
ca = double(ca); % added 110719 because I was getting CVX error, because "sparse" doesn't take single (I think this is due to suite2p)

% OASIS deconvolution script
[c, s, options] = deconvolveCa(ca, model); %, varargin);


% plot if you want to check performance
if toPlot
    figure;
    plot(ca);
    hold on;
    plot(c,'g');
    plot(s*20,'r');
    title(model);
end
