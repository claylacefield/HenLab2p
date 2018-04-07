function [lapXc] = xcorrLapActiv(PCLappedSess);

%% USAGE: [lapXc] = xcorrLapActiv(PCLappedSess);
% Clay 2018
% takes output from Andres's computePlaceCellsLappedWithEdges2
% or wrapper wrapAndresPlaceFieldsClay.m 
% and xcorrs mean activity per lap

numSegs = size(PCLappedSess.ByLap.posRateByLap,1);

for i = 1:numSegs
    lapActiv1 = squeeze(nanmean(PCLappedSess.ByLap.posRateByLap(i,:,:),2));
    for j = 1:numSegs
        lapActiv2 = squeeze(nanmean(PCLappedSess.ByLap.posRateByLap(j,:,:),2));
        xc = xcorr(lapActiv1, lapActiv2, 'coeff'); % 'coeff' to normalize
        %[maxVal, maxInd] = max(abs(xc));
        maxVal = xc(round(length(xc)/2));%xc(maxInd); % just want corr coeff at 0 lag
        lapXc(i,j) = maxVal;
    end
end

figure;
%colormap(jet);
imagesc(lapXc);