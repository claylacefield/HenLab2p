function [filename] = findLatestFilename(fileTag, varargin)

% This function returns the filename for the most recent file whose name
% contains fileTag

% INPUT: fileTag = string in filenames to check

if nargin == 2
    notInclude = varargin{1};
else
    notInclude = [];
end

currDir = dir;

dirFilenames = {currDir.name};

fileTypeInd = find(cellfun(@length, strfind(dirFilenames, fileTag)));

% now eliminate files with notInclude string
if ~isempty(notInclude)
    fileNotTypeInd = find(cellfun(@length, strfind(dirFilenames(fileTypeInd), notInclude)));
    fileTypeInd(fileNotTypeInd) = [];
end


%             if filterDate ~= 0
%                 filterInd = find(cellfun(@length, strfind({tifDir.name}, filterDate)));
%                 segInd = intersect(segInd, filterInd);
%             end

if ~isempty(fileTypeInd)

% find the latest file index
fileDatenums = [currDir(fileTypeInd).datenum];
[maxDatenum, latestInd] = max(fileDatenums);
latestDirInd = fileTypeInd(latestInd);

filename = currDir(latestDirInd).name;
else
    filename = [];
end