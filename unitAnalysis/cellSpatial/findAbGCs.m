function [avSegRed, abA] = findAbGCs(segStruc, goodSeg, abThresh)

avCh1 = segStruc.avCh1;
avCh1b = avCh1/max(avCh1(:));
A = segStruc.A;
K = size(A,1);
d1 = segStruc.d1;
d2 = segStruc.d2;
%A = reshape(A,segStruc.d1, segStruc.d2, size(A,3), K);

if size(A,1) > size(A,2)
    A = A';
end

if goodSeg == 0
    goodSeg = 1:size(A,1);
end

Ag = A(goodSeg,:);

abA = zeros(size(avCh1b,1),size(avCh1b,2));

tic;
for i=1:length(goodSeg)
   seg = reshape(Ag(i,:),d1, d2); 
   seg = full(seg); % make not sparse
   seg2 = imresize(seg,4);
   seg2 = seg2(1:size(avCh1b,1), 1:size(avCh1b,2));
   seg3 = seg2>max(seg2(:))/8; % threshold segment spatial
   %figure; imagesc(seg3);
   sumPix = sum(seg3(:));   % # pixels in seg
   segMask = avCh1b.*seg3;
   avSegRed(i) = sum(segMask(:))/sumPix;
   
   if avSegRed(i) > abThresh
       abA = abA+seg3;
   end
   
end

abA = abA>0;

toc;

figure; imagesc(abA);