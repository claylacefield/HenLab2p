function [pks] = clayCaTransients(ca, fps, varargin);

% Clay Oct 2017
% 
% New method to detect transient onsets from NMF data
% (not as sensitive to absolute ca levels)
%
% requirements:
% LocalMinima (old script from Buzsaki lab)

if length(varargin)~=0
   toPlot = 1;
else
    toPlot = 0;
end


sdThresh = 2;

rm = runmean(ca, fps); % smooth a little

dCa = diff(rm);  % note that in absolute terms, this will be one fr short

thresh = sdThresh*std(dCa);  % threshold, in SD

pks = LocalMinima(-dCa, 10*fps, -thresh);

if toPlot
    figure; t = 1:length(ca);
    plot(ca);
    hold on;
    plot(t(pks), ca(pks), 'r.');
    
    figure; hold on;
    for i = 1:length(pks)
        try
            plot(ca(pks(i)-100:pks(i)+450)-ca(pks(i)-15));
        catch
        end
    end
end