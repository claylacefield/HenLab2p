function plotTunedUnitVect(circStatStruc);

%% USAGE: plotTunedUnitVect(circStatStruc);

allR = circStatStruc.allR;
allPhi = circStatStruc.allPhi;
mw = max(allR);

figure; 
subplot(1,3,1);
hold on;
for j = 1:length(allR)

    % plot mean resultant vector length and direction
    r = allR(j);
    phi = allPhi(j);
    zm = r*exp(1i*phi');
    plot([0 real(zm)], [0, imag(zm)],'b','linewidth',1.5)
    
    % plot the tuning function of the three neurons
    %polar([ori ori(1)], [w(j,:) w(j,1)],'k')

end

% draw a unit circle
zz = exp(1i*linspace(0, 2*pi, 101)) * mw;
plot(real(zz),imag(zz),'k:')
plot([-mw mw], [0 0], 'k:', [0 0], [-mw mw], 'k:')

formatSubplot(gca,'ax','square','box','off','lim',[-mw mw -mw mw])
set(gca,'xtick',[]);
set(gca,'ytick',[]);
title('goodSeg (spks>3)');

%%

% cells with low Rayleigh score
wellTunedInd = find(circStatStruc.uniform(:,1)<0.01);
allR2 = allR(wellTunedInd);
allPhi2 = allPhi(wellTunedInd);
mw2 = max(allR2);

subplot(1,3,2);
hold on;
for j = 1:length(allR2)

    % plot mean resultant vector length and direction
    r = allR2(j);
    phi = allPhi2(j);
    zm = r*exp(1i*phi');
    plot([0 real(zm)], [0, imag(zm)],'r','linewidth',1.5)
    
    % plot the tuning function of the three neurons
    %polar([ori ori(1)], [w(j,:) w(j,1)],'k')

end

% draw a unit circle
zz = exp(1i*linspace(0, 2*pi, 101)) * mw2;
plot(real(zz),imag(zz),'k:')
plot([-mw2 mw2], [0 0], 'k:', [0 0], [-mw2 mw2], 'k:')

formatSubplot(gca,'ax','square','box','off','lim',[-mw2 mw2 -mw2 mw2])
set(gca,'xtick',[]);
set(gca,'ytick',[]);
title('goodSeg, Rayleigh<0.01');

%%

% cells with low Rayleigh score
wellTunedInd = find(circStatStruc.uniform(:,1)<0.001);
allR3 = allR(wellTunedInd);
allPhi3 = allPhi(wellTunedInd);
mw3 = max(allR);

subplot(1,3,3);
hold on;
for j = 1:length(allR3)

    % plot mean resultant vector length and direction
    r = allR3(j);
    phi = allPhi3(j);
    zm = r*exp(1i*phi');
    plot([0 real(zm)], [0, imag(zm)],'g','linewidth',1.5)
    
    % plot the tuning function of the three neurons
    %polar([ori ori(1)], [w(j,:) w(j,1)],'k')

end

% draw a unit circle
zz = exp(1i*linspace(0, 2*pi, 101)) * mw3;
plot(real(zz),imag(zz),'k:')
plot([-mw3 mw3], [0 0], 'k:', [0 0], [-mw3 mw3], 'k:')

formatSubplot(gca,'ax','square','box','off','lim',[-mw3 mw3 -mw3 mw3])
set(gca,'xtick',[]);
set(gca,'ytick',[]);
title('goodSeg, Rayleigh<0.001');