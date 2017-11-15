function [goodSegPosPkStruc] = findGoodSegPksCaiman(C, treadBehStruc, numbins);

% This script detects transients for all units, selects goodSegs as units
% thathave more than a certain number of events, and calculates their
% spatial tuning.
% Clay 2017

%numbins = 40; % number of spatial bins over the treadmill track
fps = 15;
n=0; goodSeg = []; goodSegEvents={};
m=0; greatSeg = []; greatSegEvents={};

for i = 1:size(C,1)
   ca = C(i,:);
   [pks] = clayCaTransients(ca, fps);
   
   if length(pks) >= 1  % if this unit has at least one spike
       n = n+1;
       goodSeg(n) = i;  % add to goodSeg list
       goodSegEvents{n}=pks;    % and the spike frNum
       
       ca = zeros(length(ca),1);
       ca(pks) = 1;
       [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, numbins, 2);
       goodSegPosPks(n,:) = caPosVelStruc.binYcaSum; % position binned spikes
       
       if length(pks) >= 4
           m = m+1;
           greatSeg(m) = i;
           greatSegEvents{m}=pks;
           greatSegPosPks(m,:) = caPosVelStruc.binYcaSum;
       end
       
   end
end

goodSegPosPkStruc.goodSeg = goodSeg;
goodSegPosPkStruc.goodSegEvents = goodSegEvents;
goodSegPosPkStruc.goodSegPosPks = goodSegPosPks;
goodSegPosPkStruc.greatSeg = greatSeg;
goodSegPosPkStruc.greatSegEvents = greatSegEvents;
goodSegPosPkStruc.greatSegPosPks = greatSegPosPks;

