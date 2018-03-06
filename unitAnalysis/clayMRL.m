function [meanLength, meanAngRad] = clayMRL(binCaAvg)


numBins = size(binCaAvg,1);

radBinSiz = 2*pi/numBins;

xSum = 0; ySum = 0;
for i = 1:numBins
    xSum = xSum + binCaAvg(i)*cos((i-1)*radBinSiz); % x = r*cos(theta);
    ySum = ySum + binCaAvg(i)*sin((i-1)*radBinSiz); % y = r*sin(theta);
end

xAv = xSum/numBins; % actually don't need avg over bins
yAv = ySum/numBins;

theta = atan2(ySum, xSum);

thetaPi = theta/pi;  % theta in pi radians

meanAngRad = theta;
%meanLength = sqrt(xAv^2 + yAv^2);
meanLength = sqrt(xSum^2 + ySum^2);

rho = meanLength;

%figure;
polarplot([theta 0], [rho 0], '-o'); %meanLength);

    
    
