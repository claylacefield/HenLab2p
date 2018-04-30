function [yx] = findSegCentroid(A, d1, d2);

%% USAGE: [yx] = findSegCentroid(A, d1, d2);
% Finds Y,X coordinates of segment spatial component
% Clay 2018

A = full(A);


for i = 1:size(A,2)
    a = reshape(A(:,i),d1,d2);
    ay = mean(a,1);
    ax = mean(a,2);
    [val, yx(i,1)] = max(ay);
    [val, yx(i,2)] = max(ax);
end

% and not used right now but distance between centroids
d = squareform(pdist(yx));

