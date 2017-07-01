function [relFrTimes, absFrTimes, frInds] = get2pFrTimes()

[xmCell] = import2pXml();


relFrTimes = [];
absFrTimes = [];
frInds = [];

tic;
for i=1:length(xmCell)
    rowStr = xmCell{i};
    
    if ~isempty(strfind(rowStr, 'relativeTime'))
        relTimeInd = strfind(rowStr, 'relativeTime');
        absTimeInd = strfind(rowStr, 'absoluteTime');
        indexInd = strfind(rowStr, 'index');
        parInd = strfind(rowStr, 'parameterSet');
        
        relTime = str2num(rowStr(relTimeInd+14:absTimeInd-3));
        absTime = str2num(rowStr(absTimeInd+14:indexInd-3));
        index = str2num(rowStr(indexInd+7:parInd-3));
        
        relFrTimes = [relFrTimes relTime];
        absFrTimes = [absFrTimes absTime];
        frInds = [frInds index];
    end
    
end
toc;