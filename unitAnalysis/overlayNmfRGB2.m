function overlayNmfRGB2(segStruc)

% Clay 011717
% script to overlay NMF results in stack with green and red channels 
% Req: writeTifStack.m

filename = segStruc.filename;
K = segStruc.K;
A = segStruc.A;
d1 = segStruc.d1;
d2 = segStruc.d2;
goodSeg = segStruc.goodSeg;

rgb(:,:,1) = segStruc.avCh1;
rgb(:,:,2) = segStruc.avCh2;

allSegIm = zeros(d1,d2);
for seg = 1:length(goodSeg)
    allSegIm(:,:,seg) = reshape(A(goodSeg(seg),:),d1,d2);
end

rgb(:,:,3) = allSegIm/max(allSegIm(:));

basename = filename(1:strfind(filename, '_mc')-1);

writeTifStack(rgb, [basename '_rgb.tif']);

