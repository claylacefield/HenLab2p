function [treadBehStruc] = readTDML_cueShift(varargin);

%% USAGE: [treadBehStruc] = readTDML(varargin);
% Clay 2017
% Reads known events from .tdml output from Jack Bowler's BehaviorMate
% treadmill behavioral software.
% NOTE: only includes currently known events- may need to add more later.

% currDir = dir;
% currDirNames = {currDir.name};

% tone, open
% valve, "pin":3, open (olf stim)
% make list of RFID tags
% make list of laps of diff types (and maybe laps for particular events,
% for switch)

switch nargin
    case 1
        filename = findLatestFilename('.tdml');
        path = [pwd '/'];
    otherwise
        [filename, path] = uigetfile('*.tdml', 'Select TDML file to process:');
end

try
behCell = importdata([path filename], '\t');
catch
    disp('Trouble reading TDML so trying other method');
    behCell = importdata(filename);
end

disp(['Processing treadmill behavior data (cue shift task) from: ' filename]);

treadBehStruc.tdmlName = filename;

% initialize variables
time = [];
y = [];
currY = NaN;
lap = 0;
yTimes = []; yTimeNano = [];
lickTime = []; lickPos = []; lickLap = [];
lapTime = [];
rewTime = []; rewPos = []; rewLap = [];
rewZoneStartTime = [];
rewZoneStartPos = [];
rewZoneStopTime = [];
rewZoneStopPos = [];

olfTime = []; olfPos = []; olfLap = [];
ledTime = []; ledPos = []; ledLap = [];
toneTime = []; tonePos = []; toneLap = [];
tactTime = []; tactPos = []; tactLap = [];
rfidTime = []; rfidPos = []; rfidLap = []; rfidName = {};

tic;
for i=1:length(behCell)
    rowStr = behCell{i}; % load in the string for this eventd
    
    
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
            millisInd = strfind(rowStr, '"millis"');
            millis = str2num(rowStr(millisInd+9:yInd-3));
            yTimeNano = [yTimeNano millis];
        end
        
        % lap time
        if ~isempty(strfind(rowStr, '"lap"'))
            lapTime = [lapTime currTime];
            lap = lap+1;
        end
        
        % lick time/pos
        try
            if ~isempty(strfind(rowStr, '"lick"')) && ~isempty(strfind(rowStr, '"start"'))
                lickTime = [lickTime currTime];
                lickPos = [lickPos currY];
                lickLap = [lickLap lap];
            end
        catch
            disp('Dropping this lick because its before first pos reading');
        end
        
        % rew zone enter/exit time/pos
        if ~isempty(strfind(rowStr, 'context'))
            if ~isempty(strfind(rowStr, 'reward'))
                if ~isempty(strfind(rowStr, '"start"'))
                    rewZoneStartTime = [rewZoneStartTime currTime];
                    rewZoneStartPos = [rewZoneStartPos currY];
                elseif ~isempty(strfind(rowStr, '"stop"'))
                    rewZoneStopTime = [rewZoneStopTime currTime];
                    rewZoneStopPos = [rewZoneStopPos currY];
                end
            end
        end
        
        
        
        % rew time/pos
        if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, '"pin": 5'))
            rewTime = [rewTime currTime];
            rewPos = [rewPos currY];
            rewLap = [rewLap lap];
        end
        
        
        if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(syncPin)]))
            treadBehStruc.syncOnTime = currTime;
            %rewPos = [rewPos currY];
        elseif ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"close"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(syncPin)]))
            treadBehStruc.syncOffTime = currTime;
        end
        
        % olfactory stim time/pos
        if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, '"pin": 3,'))
            olfTime = [olfTime currTime];
            olfPos = [olfPos currY];
            olfLap = [olfLap lap];
        end
        
        % olfactory stim time/pos
        if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, '"pin": 34,'))
            ledTime = [ledTime currTime];
            ledPos = [ledPos currY];
            ledLap = [ledLap lap];
        end
        
        % tone stim time/pos
        if ~isempty(strfind(rowStr, '"tone"')) && ~isempty(strfind(rowStr, '"open"')) %&& ~isempty(strfind(rowStr, '"pin":3'))
            toneTime = [toneTime currTime];
            tonePos = [tonePos currY];
            toneLap = [toneLap lap];
        end
        
        % tone stim time/pos
        if ~isempty(strfind(rowStr, 'tact')) && ~isempty(strfind(rowStr, 'start')) %&& ~isempty(strfind(rowStr, '"pin":3'))
            tactTime = [tactTime currTime];
            tactPos = [tactPos currY];
            tactLap = [tactLap lap];
        end
        
        % RFID time/pos
        if ~isempty(strfind(rowStr, '"tag_reader"')) %&& ~isempty(strfind(rowStr, '"open"')) %&& ~isempty(strfind(rowStr, '"pin":3'))
            rfidTime = [rfidTime currTime];
            rfidPos = [rfidPos currY];
            rfidLap = [rfidLap lap];
            rfidName = [rfidName {rowStr(strfind(rowStr, '"tag"')+8:strfind(rowStr, '"tag"')+19)}];
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

treadBehStruc.yTimeNano = yTimeNano;

% adjust nano time based upon start computer time
% and adjust yTimes based upon diff between nano and beMate
yTimeNano = (yTimeNano-yTimeNano(1))/1000+yTimes(1);
dTimes = yTimes-yTimeNano;
dTimes = dTimes-runmean(dTimes, 200); 
yTimes2 = yTimes;
yTimes2(dTimes>0.02) = yTimes(dTimes>0.02)-dTimes(dTimes>0.02);
treadBehStruc.yTimesAdj = yTimes2;

treadBehStruc.lapTime = lapTime;
treadBehStruc.lickTime = lickTime; treadBehStruc.lickPos = lickPos; treadBehStruc.lickLap = lickLap;
treadBehStruc.rewTime = rewTime; treadBehStruc.rewPos = rewPos;treadBehStruc.rewLap = rewLap;
treadBehStruc.rewZoneStartTime = rewZoneStartTime;
treadBehStruc.rewZoneStartPos = rewZoneStartPos;
treadBehStruc.rewZoneStopTime = rewZoneStopTime;
treadBehStruc.rewZoneStopPos = rewZoneStopPos;

treadBehStruc.olfTime = olfTime; treadBehStruc.olfPos = olfPos; treadBehStruc.olfLap = olfLap;
treadBehStruc.ledTime = ledTime; treadBehStruc.ledPos = ledPos; treadBehStruc.ledLap = ledLap;
treadBehStruc.toneTime = toneTime; treadBehStruc.tonePos = tonePos; treadBehStruc.toneLap = toneLap;
treadBehStruc.tactTime = tactTime; treadBehStruc.tactPos = tactPos; treadBehStruc.tactLap = tactLap;
treadBehStruc.rfidTime = rfidTime; treadBehStruc.rfidPos = rfidPos; treadBehStruc.rfidLap = rfidLap; treadBehStruc.rfidName = rfidName;

% NOTE: these times (e.g. rewTime) will be in register with adjFrTimes