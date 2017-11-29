function [treadBehStruc] = readTDML(varargin);

%% USAGE: [treadBehStruc] = readTDML(varargin);
% Clay 2017
% Reads known events from .tdml output from Jack Bowler's BehaviorMate
% treadmill behavioral software.
% NOTE: only includes currently known events- may need to add more later.

% currDir = dir;
% currDirNames = {currDir.name};

switch nargin
    case 1
        filename = findLatestFilename('.tdml');
        path = [pwd '/'];
    otherwise
        [filename, path] = uigetfile('*.tdml', 'Select TDML file to process:');
end

behCell = importdata([path filename], '\t');

disp(['Processing treadmill behavior data from: ' filename]);

treadBehStruc.tdmlName = filename;

% initialize variables
time = [];
y = [];
yTimes = [];
lickTime = [];
lickPos = [];
lapTime = [];
rewTime = [];
rewPos = [];
rewZoneStartTime = [];
rewZoneStartPos = [];
rewZoneStopTime = [];
rewZoneStopPos = [];

tic;
for i=1:length(behCell)
    rowStr = behCell{i}; % load in the string for this event
    
    
    % sync pin (2p trigger ON)
    if ~isempty(strfind(rowStr, '"settings"'))
        treadBehStruc.settingsString = rowStr;
        syncPin = str2num(rowStr(strfind(rowStr, 'sync_pin')+11:strfind(rowStr, 'sync_pin')+12));
    end
    
    % sync pin (2p trigger ON)
    if ~isempty(strfind(rowStr, '"mouse"'))
        treadBehStruc.sessInfo = rowStr;
    end
    
    if ~isempty(strfind(rowStr, '"time"'))
        timeInd = strfind(rowStr, '"time"');
        currTime = str2num(rowStr(timeInd+8:end-1));
        time = [time currTime];
        
        if ~isempty(strfind(rowStr, '"position"'))
            yInd = strfind(rowStr, '"y"');
            currY = str2num(rowStr(yInd+5:timeInd-2));
            y = [y currY];
            yTimes = [yTimes currTime];
            
        end
        
        % lick time/pos
        if ~isempty(strfind(rowStr, '"lick"')) && ~isempty(strfind(rowStr, '"start"'))
            lickTime = [lickTime currTime];
            lickPos = [lickPos currY];
        end
        
        % rew zone enter/exit time/pos
        if ~isempty(strfind(rowStr, '"reward"'))
            if ~isempty(strfind(rowStr, '"start"'))
                rewZoneStartTime = [rewZoneStartTime currTime];
                rewZoneStartPos = [rewZoneStartPos currY];
            elseif ~isempty(strfind(rowStr, '"stop"'))
                rewZoneStopTime = [rewZoneStopTime currTime];
                rewZoneStopPos = [rewZoneStopPos currY];
            end
        end
        
        % lap time
        if ~isempty(strfind(rowStr, '"lap"'))
            lapTime = [lapTime currTime];
        end
        
        % rew time/pos
        if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, '"pin": 5'))
            rewTime = [rewTime currTime];
            rewPos = [rewPos currY];
        end
        
        
        if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(syncPin)]))
            treadBehStruc.syncOnTime = currTime;
            %rewPos = [rewPos currY];
        elseif ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"close"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(syncPin)]))
            treadBehStruc.syncOffTime = currTime;
        end
        
        
        
        % other events: debug timeout,
        
    end
    
end

% calculate velocity over each frame (at 30hz)
% resampY = interp1(yTime, y, 0:0.033:900);
% vel = abs(diff(resampY));

toc;

% save relevant variables to output structure
%treadBehStruc.filename = filename;
treadBehStruc.y = y;
treadBehStruc.yTimes = yTimes;
% treadBehStruc.resampY = resampY;
% treadBehStruc.vel = vel;

treadBehStruc.lickTime = lickTime;
treadBehStruc.lickPos = lickPos;
treadBehStruc.lapTime = lapTime;
treadBehStruc.rewTime = rewTime;
treadBehStruc.rewPos = rewPos;
treadBehStruc.rewZoneStartTime = rewZoneStartTime;
treadBehStruc.rewZoneStartPos = rewZoneStartPos;
treadBehStruc.rewZoneStopTime = rewZoneStopTime;
treadBehStruc.rewZoneStopPos = rewZoneStopPos;



