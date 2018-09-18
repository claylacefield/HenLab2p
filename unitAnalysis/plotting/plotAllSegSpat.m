function [allSegIm] = plotAllSegSpat(A, d1, d2, toNorm);

A = full(A);

K = size(A,2);

allSegIm = zeros(d1,d2);
for seg = 1:K
    aUnit = reshape(A(:,seg),d1,d2);
    if toNorm == 1
        aUnit = aUnit/max(aUnit(:));
    end
    allSegIm = allSegIm + aUnit;
end
figure; imagesc(allSegIm);


%allSegIm2 = imresize(allSegIm,4);

