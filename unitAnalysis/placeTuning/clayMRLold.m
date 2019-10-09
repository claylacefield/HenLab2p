function [meanLength, meanAngRad] = clayMRLold(binCaAvg, numBins, toPlot);

%% USAGE: [meanLength, meanAngRad] = clayMRL(binCaAvg(bins x #seg), toPlot);

if size(binCaAvg,2)==numBins
    binCaAvg = binCaAvg';
end

%numBins = size(binCaAvg,1);

radBinSiz = 2*pi/numBins; % bin size in radians

for j = 1:size(binCaAvg,2) % for all units
    binCa = binCaAvg(:,j);
    xSum = 0; ySum = 0;
    totalSpikes = sum(binCa);
    for i = 1:numBins
        xSum = xSum + binCa(i)*cos((i-1)*radBinSiz)/totalSpikes; % x = r*cos(theta);
        ySum = ySum + binCa(i)*sin((i-1)*radBinSiz)/totalSpikes; % y = r*sin(theta);
    end
    
    xSumAll(j) = xSum;
    ySumAll(j) = ySum;
    
    xAv = xSum/numBins; % actually don't need avg over bins
    yAv = ySum/numBins;
    
    theta = atan2(ySum, xSum);
    
    thetaPi = theta/pi;  % theta in pi radians
    
    meanAngRad(j) = theta;
    %meanLength = sqrt(xAv^2 + yAv^2);
    meanLength(j) = sqrt(xSum^2 + ySum^2);
    
    rho = meanLength;
end

if toPlot
% figure;
% polarplot([theta 0], [rho 0], '-o'); %meanLength);
figure; compass(xSumAll', ySumAll');
title('Normalized MRL');
end
    
    
