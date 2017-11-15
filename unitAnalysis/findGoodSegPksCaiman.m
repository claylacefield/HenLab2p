function [goodSegPosPkStruc] = findGoodSegPksCaiman(C, treadBehStruc, numbins);

% This script detects transients for all units, selects goodSegs as units
% thathave more than a certain number of events, and calculates their
% spatial tuning.
% Clay 2017

%numbins = 40; % number of spatial bins over the treadmill track
fps = 15;

goodSegMinPks = 1;
greatSegMinPks = 4;

n=0; goodSeg = []; goodSegEvents={};
m=0; greatSeg = []; greatSegEvents={};
tic;
for i = 1:size(C,1) % go through all units
   ca = C(i,:);
   [pks] = clayCaTransients(ca, fps); % detect spiking events
   
   if length(pks) >= goodSegMinPks  % if this unit has at least one spike
       n = n+1;
       goodSeg(n) = i;  % add to goodSeg list
       goodSegEvents{n}=pks;    % and the spike frNum
       
       ca = zeros(length(ca),1); % create vector of spikes from spk times
       ca(pks) = 1;
       [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, numbins, 2);
       goodSegPosPks(n,:) = caPosVelStruc.binYcaSum; % position binned spikes
       
       if length(pks) >= greatSegMinPks
           m = m+1;
           greatSeg(m) = i;
           greatSegEvents{m}=pks;
           greatSegPosPks(m,:) = caPosVelStruc.binYcaSum;
       end
       
   end
end
toc;

% save variables to output struc
goodSegPosPkStruc.goodSeg = goodSeg;
goodSegPosPkStruc.goodSegEvents = goodSegEvents;
goodSegPosPkStruc.goodSegPosPks = goodSegPosPks;
goodSegPosPkStruc.greatSeg = greatSeg;
goodSegPosPkStruc.greatSegEvents = greatSegEvents;
goodSegPosPkStruc.greatSegPosPks = greatSegPosPks;

% and just save some params
goodSegPosPkStruc.params.numbins = numbins;
goodSegPosPkStruc.params.fps = fps;
goodSegPosPkStruc.params.goodSegMinPks = goodSegMinPks;
goodSegPosPkStruc.params.greatSegMinPks = greatSegMinPks;
