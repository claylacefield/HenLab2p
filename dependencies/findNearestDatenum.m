function [filename] = findNearestDatenum(datenum)

%% USAGE: [filename] = findNearestDatenum(datenum);
% Clay Oct. 2018
% ToDo:
%   - make varargin for file ending

currDir = dir;

currDirDatenums = [currDir.datenum];

diffDatenum = currDirDatenums - datenum;

[val, ind] = min(abs(diffDatenum));

filename = currDir(ind).name;

