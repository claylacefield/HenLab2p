function [goodSeg, goodSegEvents, goodSegPosPks] = findGoodSegPksCaiman(C, treadBehStruc);

% This script detects transients for all units, selects goodSegs as units
% thathave more than a certain number of events, and calculates their
% spatial tuning.
% Clay 2017

numbins = 40; % number of spatial bins over the treadmill track
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
       [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, numbins, 2);
       goodSegPosPks(n,:) = caPosVelStruc.binYcaSum;
   end
end



