function [B, fitInfo] = clayLasso(C, pos);


% Script to perform lasso GLM on DGC population vs treadmill position

tic;
[B, fitInfo] = lassoglm(C',pos);
toc;



