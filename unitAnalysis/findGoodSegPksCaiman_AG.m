function [goodSegAll, goodSegEvents, goodSegPosPks, pksAll] = findGoodSegPksCaiman_AG(C, treadBehStruc);

% This script detects transients for all units, selects goodSegs as units
% thathave more than a certain number of events, and calculates their
% spatial tuning. Does not consider gui selected goodSegs (ST)
% Clay 2017

fps = 15;
n=0; goodSegAll = []; goodSegEvents={}; 
pksAll = {};
for i = 1:size(C,1)
   ca = C(i,:);
   [pks] = clayCaTransients(ca, fps);
   pksAll{i} = pks;
   if length(pks) <4
       n = n+1;
       goodSegAll(n) = i;
       goodSegEvents{n}=pks;
       
       ca = zeros(length(ca),1);
       ca(pks) = 1;
       [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, 100, 2);
       goodSegPosPks(n,:) = caPosVelStruc.binYcaSum;
   end
   
end



