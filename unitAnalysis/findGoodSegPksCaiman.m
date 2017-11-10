function [goodSeg, goodSegEvents, goodSegPosPks] = findGoodSegPksCaiman(C, treadBehStruc)

% This script detects transients for all units, selects goodSegs as units
% thathave more than a certain number of events, and calculates their
% spatial tuning.
% Clay 2017

fps = 15;
n=0; goodSeg = []; goodSegEvents={};

for i = 1:size(C,1)
   ca = C(i,:);
   [pks] = clayCaTransients(ca, fps);
   if length(pks) > 5
       n = n+1;
       goodSeg(n) = i;
       goodSegEvents{n}=pks;
       
       ca = zeros(length(ca),1);
       ca(pks) = 1;
       [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, 100, 2);
       goodSegPosPks(n,:) = caPosVelStruc.binYcaSum;
   end
end



