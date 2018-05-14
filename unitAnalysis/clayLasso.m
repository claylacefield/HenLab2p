function [B, fitInfo] = clayLasso(C, pos);


% Script to perform lasso GLM on DGC population vs treadmill position

% if input is cell array of peaks
if iscell(C)
    cCell = C;
    C = zeros(length(C),round(length(pos)));
    for i = 1:length(cCell)
        C(i,cCell{i})=1;
    end
end

% perform lassoGLM

tic;
[B, fitInfo] = lassoglm(C',pos);
toc;



