function [fps, numCh] = find2pScanParams()

% simple function to extract frameRate from 2p XML
% Clay 2020

[xmlCell] = import2pXml(1);

frameCellInds = find(contains(xmlCell, 'framePeriod'));

frameString = xmlCell{frameCellInds(end-1)};

period = str2double(frameString(strfind(frameString, 'value="')+8:strfind(frameString, 'value="')+13));

fps = round(1/period);

%% number of channels
numCh = 0;
if ~isempty(find(contains(xmlCell, 'channelName="Ch1"')))
    numCh = numCh+1;
end
if ~isempty(find(contains(xmlCell, 'channelName="Ch2"')))
    numCh = numCh+1;
end
