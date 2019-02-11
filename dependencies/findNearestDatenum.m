function [filename] = findNearestDatenum(datenum)

%% USAGE: [filename] = findNearestDatenum(datenum);
% Clay Oct. 2018
% ToDo:
%   - make varargin for file ending
%
% Mods:
% 01/01/19: made return [] if file not within last day

currDir = dir;
currDir = currDir(3:end); % elim first two dir entries

currDirDatenums = [currDir.datenum];

diffDatenum = currDirDatenums - datenum;

[val, ind] = min(abs(diffDatenum));

if val<0.02 % only return file if within, let's say, a half hour
filename = currDir(ind).name;
else
    filename = [];
end

