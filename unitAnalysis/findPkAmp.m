function [pkAmpCell] = findPkAmp(pksCell, Cgood)

% find the amplitude of peaks identified in pksCell

% pseudocode
% pksCell might be from subset of laps
% and from subset of cells
% so have to find the correct cells and laps in C

a