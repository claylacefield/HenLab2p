function [rho, theta] = allSegMRL(sAll)

% Clay 2018
% Calculate mean resultant vector length and angle
% for deconvolved spikes from all cells


%figure; 
for i = 1:size(sAll,1) %goodSegPosPks,2)
    binCaAvg = sAll(i,:); %goodSegPosPks(:,i);
    [meanLength, meanAngRad] = clayMRL(binCaAvg);
    rho(i) = meanLength;
    theta(i) = meanAngRad;
end




