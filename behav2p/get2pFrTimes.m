function [relFrTimes, absFrTimes, frInds] = get2pFrTimes(varargin);

%% USAGE: [relFrTimes, absFrTimes, frInds] = get2pFrTimes(varargin);
% Clay 2017

% import the Bruker 2p XML data as cell array
switch nargin
    case 1
        [xmCell] = import2pXml('auto');
    otherwise
        [xmCell] = import2pXml();
end


relFrTimes = [];
absFrTimes = [];
frInds = [];

% look through XML cell array for info from each frame
tic;
for i=1:length(xmCell)
    rowStr = xmCell{i};
    
    if ~isempty(strfind(rowStr, 'relativeTime'))
        relTimeInd = strfind(rowStr, 'relativeTime');
        absTimeInd = strfind(rowStr, 'absoluteTime');
        indexInd = strfind(rowStr, 'index');
        parInd = strfind(rowStr, 'parameterSet');
        
        % NOTE: times extracted based upon current character indices within
        % Bruker XML frame info strings 
        relTime = str2num(rowStr(relTimeInd+14:absTimeInd-3));
        absTime = str2num(rowStr(absTimeInd+14:indexInd-3));
        index = str2num(rowStr(indexInd+7:parInd-3));
        
        relFrTimes = [relFrTimes relTime];
        absFrTimes = [absFrTimes absTime];
        frInds = [frInds index];
    end
    
end
toc;