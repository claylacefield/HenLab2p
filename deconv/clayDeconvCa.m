function [s] = clayDeconvCa(ca, toPlot);

%% USAGE: [s] = clayDeconvCa(ca, toPlot);
% Clay 2018
% Wrapper script for OASIS_matlab from zhoupc github
% (MATLAB implementation of Johannes Friedrich OASIS by PengCheng)
% NOTE: this may produce spurious results for bad units so 
% maybe cull units with more stringent transient detection first.

% 'ar2' model seems to work okay for G6s
model = 'ar2';  % autoregressive model of convolution kernel

% OASIS deconvolution script
[c, s, options] = deconvolveCa(ca, model); %, varargin);


% plot if you want to check performance
if toPlot
    figure;
    plot(ca);
    hold on;
    plot(c,'g');
    plot(s*20,'r');
end