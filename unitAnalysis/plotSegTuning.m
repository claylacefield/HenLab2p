function [caPos, caPosNorm, evPos] = plotSegTuning(ca, fps, treadBehStruc, dsFactor);

% Clay 101817 from plotGoodSegTuning.m
% for single trace

numbins = 40;

tic;

% raw calcium
[binYca, binYvel, binVelCa] = caVsPosVel(treadBehStruc, ca, numbins, dsFactor);
binYca = interp1(0:1/numbins:1-1/numbins, binYca, 0:0.01:1-1/numbins);
caPos = binYca;
caPosNorm = binYca/max(binYca);


% events
[pks] = clayCaTransients(ca, fps);
ev = zeros(length(ca),1);
ev(pks) = 1;
[binYca, binYvel, binVelCa] = caVsPosVel(treadBehStruc, ev, numbins, dsFactor);
binYca = interp1(0:1/numbins:1-1/numbins, binYca, 0:0.01:1-1/numbins);
evPos = binYca;


% Find rewZone
% NOTE: this currently only works with single rewZone (092617)
rewZone = treadBehStruc.rewZoneStartPos;
%[cts, cntrs] = hist(rewZone);
relRewPos = round(100*mean(rewZone)/max(treadBehStruc.y));



%% Plot
figure('pos', [50 50 400 800]); 

subplot(3,1,1);
plot(caPos);
%xlim([1 size(caPos,1)]);
ylim([min(caPos-0.001) max(caPos+0.001)]);
hold on;
line([relRewPos relRewPos], [min(caPos-0.01) max(caPos+0.01)], 'Color','r');
title('mean goodSeg ca vs. position (not norm)');

subplot(3,1,2);
plot(evPos);
%xlim([1 size(evPos,1)]);
ylim([min(evPos-0.001) max(evPos+0.001)]);
hold on;
line([relRewPos relRewPos], [min(evPos-0.01) max(evPos+0.01)], 'Color','r');
title('ca events vs. position');

subplot(3,1,3);
plot(binYvel);
xlim([1 length(binYvel)]);
hold on;
line([relRewPos/2.5 relRewPos/2.5], [0 1], 'Color','r');
title('vel');

toc;