function [treadBehavStruc] = procArdTreadBehav()

% [treadBehavStruc] = procTreadBehav();
% gui select .txt file of treadmill behavior to read
% and output structure of position and event times

% Clay 2017
% 
% 111317
% - adding in sync pulse 
% - reconciling with nVistaAlign

% Select .txt file to read
[filename, pathname] = uigetfile('*.txt', 'Select a text file of behavior to read');
filepath = [pathname filename];
cd(pathname);

disp(['Processing treadmill behavior for: ' filename]);
tic;

fullCell= textread(filepath,'%s', 'delimiter', '\n'); % read whole file as cell array

beginInd = find(cellfun(@length, strfind(fullCell, 'START SESSION')))+1;
fullCell = fullCell(beginInd:end); % cut off header then pad end
% fullCell = [fullCell; 'pad'; '0'; 'pad'; '0'; 'pad'; '0'; 'pad'; '0'; 'pad'; '0'];

numPosMeas = 0;
numLicks = 0;
numRew = 0;
numSync = 0;

% scan fullCell of text data to look for particular events
for txtInd = 1:length(fullCell)
    
    event1 = fullCell{txtInd};
    
    if ~isempty(strfind(event1, 'vel'))
        numPosMeas = numPosMeas + 1;
        millisInd = strfind(event1, 'millis');
        currPosInd = strfind(event1, 'currPos');
        currPosMs(numPosMeas) = str2num(event1(millisInd+7:end));
        currPos(numPosMeas) = str2num(event1(currPosInd+8:millisInd-3));
    elseif ~isempty(strfind(event1, 'lick'))
        numLicks = numLicks + 1;
        millisInd = strfind(event1, 'millis');
        lickMs(numLicks) = str2num(event1(millisInd+7:end));
        lickPos(numLicks) = currPos(end);
    elseif ~isempty(strfind(event1, 'REWARD'))
        numRew = numRew + 1;
        millisInd = strfind(event1, 'millis');
        rewMs(numRew) = str2num(event1(millisInd+7:end));
        rewPos(numRew) = currPos(end);
    elseif ~isempty(strfind(event1, 'sync'))
        numSync = numSync + 1;
        millisInd = strfind(event1, 'millis');
        syncMs(numSync) = str2num(event1(millisInd+9:end));
        %syncPos(numSync) = currPos(end);
    end
    
end
toc;

% Put variables into output structure
treadBehavStruc.filename = filename;
treadBehavStruc.currPos = currPos;
treadBehavStruc.currPosMs = currPosMs;
treadBehavStruc.lickPos = lickPos;
treadBehavStruc.lickMs = lickMs;
treadBehavStruc.rewPos = rewPos;
treadBehavStruc.rewMs = rewMs;
%treadBehavStruc.syncPos = syncPos;
treadBehavStruc.syncMs = syncMs;

% Save output to .txt directory
basename = filename(1:strfind(filename, '.txt')-1);
save([basename '_treadBehavStruc_' date], 'treadBehavStruc');

% plot output

figure;
plot(currPosMs, currPos);
hold on;
plot(lickMs, lickPos, 'r*');
plot(rewMs, rewPos, 'g*');
title(filename); %  ', b=pos, g=rew, r=licks']);
ylabel('Position');
xlabel('time(ms)');
legend('pos', 'licks', 'rews');


