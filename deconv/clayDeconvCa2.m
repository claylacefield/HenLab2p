function [s] = clayDeconvCa2(ca, toPlot);

%% USAGE: [s] = clayDeconvCa(ca, toPlot);
% Clay 2018
% Wrapper script for OASIS_matlab from zhoupc github
% (MATLAB implementation of Johannes Friedrich OASIS by PengCheng)
% NOTE: this may produce spurious results for bad units so 
% maybe cull units with more stringent transient detection first.

% 'ar2' model seems to work okay for G6s
model = 'ar2'; %'ar2';  % autoregressive model of convolution kernel

ca0 = ca;
ca = runmean(ca,10);
ca = ca-runmean(ca, 500);
ca = ca-min(ca);
%ca = [zeros(1,20) ca(1:end-20)];
ca = double(ca); % added 110719 because I was getting CVX error, because "sparse" doesn't take single (I think this is due to suite2p)


%% options

options.type = 'ar1';
% options.pars = [];
% options.sn = [];
% options.b = 0;
% options.lambda = 0; % 0;
options.optimize_b = true; % false;
options.optimize_pars = true; %false;
options.optimize_smin = true; % false;
% options.method = 'constrained';
% options.window = 200;
% options.shift = 100;
% options.smin = 0;
% options.maxIter = 10; % 10;
% options.thresh_factor = 1.0; %1.0;
% options.extra_params = [];
% options.p_noise = 0.9999; 




%% OASIS deconvolution script
[c, s, options] = deconvolveCa(ca, options); %, varargin);


% plot if you want to check performance
if toPlot
    figure;
%     plot(s,'r');
%     hold on;
    plot(ca0/max(ca0(:)));
    hold on;
    %plot(c/max(c(:)),'g');
    plot(s/max(s(:)),'r');
    title(options.type);
end
