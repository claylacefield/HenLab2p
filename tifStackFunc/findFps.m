function [fps] = findFps()

% simple function to extract frameRate from 2p XML
% Clay 2020

[xmlCell] = import2pXml(1);

frameCellInds = find(contains(xmlCell, 'framePeriod'));

frameString = xmlCell{frameCellInds(end-1)};

period = str2double(frameString(strfind(frameString, 'value="')+8:strfind(frameString, 'value="')+13));

fps = round(1/period);

numFrCh1 = 