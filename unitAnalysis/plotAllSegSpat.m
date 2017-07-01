function [allSegIm] = plotAllSegSpat(A, d1, d2);

A = full(A);

K = size(A,2);

allSegIm = zeros(d1,d2);
for seg = 1:K
    allSegIm = allSegIm + reshape(A(:,seg),d1,d2);
end
figure; imagesc(allSegIm);


allSegIm2 = imresize(allSegIm,4);