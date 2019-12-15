function [ca] = unfilterCa(ca)

% Clay 2019
% Just playing around with deconvolving exponential filter from calcium
% signals (if they had been processed with exp filt)


ca2 = runmean(ca,20);

tau = 40; %tau=20; 
x=1:6*tau; %60; %200; 
yexp=exp(-x/tau);

ca3 = deconv(ca2,yexp);
ca3 = 10*ca3(2:end);

figure;
plot(ca);
hold on;
plot(ca3,'g');