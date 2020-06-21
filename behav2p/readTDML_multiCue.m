function [treadBehStruc] = readTDML_multiCue(varargin);

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
%
% 051820
% Modifying to read contexts from settings JSON
% 052120
% New approach:
% Make list of all contexts from settings
% cycle through all contexts each rowStr and look for which context it
% belongs to
% AND make lapList for all events
% Notes:
% - while the "context" and "valve open" tags come in at different times in
% the TDML, the original arduino millis of these two events is at about the same time
% Thus I can just use the "context" time
% - go ahead and find lapTypeArr?
% - jsondecode doesn't seem to work that well on other events
% - for tone, test
% '/Backup20TB/clay/DGdata/190509/190509_B6-0419-02_toneStepOmit-001'
% - still unsure of how to structure events vs. contexts
%
% Current ToDo:
% - still haven't decided how to structure context event output.
% - instead of separately listing individual events, should have everything
% in a structure (like eventSTruc).
% - BUT have to make all dependent scripts be able to read this instead of
% previous formatting
% - should I put all events (e.g. licks, rew) in this struct? Probably not
% if it's not in a context (i.e. cue or static rew), because contexts can
% be used for determining lap type while other events cannot.
% - ANYWAY, I have to fix these issues before this works.

%% READ TDML
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

%% initialize variables
time = 0; %[];
y = [];
currY = NaN;
yTimes = []; yTimeNano = [];
lickTime = []; lickPos = []; lickLap = [];
lapTime = []; lapNum = []; lap = 0; 
rewTime = []; rewPos = []; rewLap = [];
rewZoneStartTime = [];
rewZoneStartPos = [];
rewZoneStopTime = [];
rewZoneStopPos = [];

olfTimeStart = []; olfPosStart = []; olfLap = []; olfTimeEnd = []; olfPosEnd = [];
ledTimeStart  = []; ledPosStart = []; ledLap = []; ledTimeEnd = []; ledPosEnd = []; 
toneTimeStart = []; tonePosStart = []; toneLap = [];toneTimeEnd = []; tonePosEnd = [];
tactTimeStart = []; tactPosStart = []; tactLap = []; tactTimeEnd = []; tactPosEnd = []; 
optoTimeStart = []; optoPosStart = []; optoLap = []; optoTimeEnd = []; optoPosEnd = [];
rfidTime = []; rfidPos = []; rfidLap = []; rfidName = {};
ctxtTime = []; ctxtPos = []; ctxtLap = []; ctxtName = {};
frCountTime = []; frCountPos = []; frCount = [];

%% read each event and concat
tic;
for i=1:length(behCell)
    rowStr = behCell{i}; % load in the string for this eventd
    
    
    %% READ SETTINGS: get info from settings string, e.g. sync pin 
    if contains(rowStr, '"settings"')
        treadBehStruc.settingsString = rowStr;
        info = jsondecode(rowStr); % NEW read JSON settings string
        syncPin = info.settings.sync_pin; % read sync pin
        
        % read info about contexts
        contexts = info.settings.contexts;
        for ctx = 1:length(contexts)
            id = contexts{ctx}.id;
            idCell{ctx,1} = id;
        end
        
        % drop "dummy" context?
        % (sometimes blank context necessary for BeMate to work correctly)
        
        
        % contextStruc (but errors if some fields missing)
        for ctx = 1:length(contexts)
            contextStruc(ctx).name = contexts{ctx}.id;
            try; contextStruc(ctx).pin = info.settings.contexts{ctx}.valves; catch; contextStruc(ctx).pin = []; end
            try; contextStruc(ctx).lapList = info.settings.contexts{ctx}.decorators.lap_list; catch; contextStruc(ctx).lapList = []; end
            try; contextStruc(ctx).repeat = info.settings.contexts{ctx}.decorators.repeat; catch; contextStruc(ctx).repeat = []; end
            try; contextStruc(ctx).locations = info.settings.contexts{ctx}.locations; catch; contextStruc(ctx).locations = []; end
            try; contextStruc(ctx).duration = info.settings.contexts{ctx}.durations; catch; contextStruc(ctx).duration = []; end
            try; contextStruc(ctx).radius = info.settings.contexts{ctx}.radius; catch; contextStruc(ctx).radius = []; end
            try; contextStruc(ctx).freq = info.settings.contexts{ctx}.frequency; catch; contextStruc(ctx).freq = []; end
            contextStruc(ctx).startTimes = []; contextStruc(ctx).startPos = []; 
            contextStruc(ctx).endTimes = []; contextStruc(ctx).endPos = []; 
        end
        treadBehStruc.contextStruc = contextStruc;
        
        % construct lap pattern from settings
        repeatArr = [contextStruc.repeat];
        lapListCell = {contextStruc.lapList};
        cuePosLap = zeros(ctx,contextStruc(2).repeat);
        for ctx=1:length(lapListCell)
            if ~isempty(lapListCell{ctx})
                lapList = lapListCell{ctx};
                
            end
        end

        
        % get "valves" or pins for diff cues
        
        if ~isempty(find(contains(idCell, 'reward'))) % since led pin can be diff, find from settings
            rewCtxInd = find(contains(idCell, 'reward'));
            rewPin = info.settings.contexts{rewCtxInd}.valves;
            %rewLapList = info.settings.contexts{rewCtxInd}.decorators.lap_list;
        end
        
%         if ~isempty(find(contains(idCell, 'led'))) % since led pin can be diff, find from settings
%             ledCtxInd = find(contains(idCell, 'led'));
%             ledPin = info.settings.contexts{ledCtxInd}.valves;
%             ledLapList = info.settings.contexts{ledCtxInd}.decorators.lap_list;
%         end
%         
%         if ~isempty(find(contains(idCell, 'tone'))) % since led pin can be diff, find from settings
%             toneCtxInd = find(contains(idCell, 'tone'));
%             tonePin = info.settings.contexts{toneCtxInd}.valves;
%             toneLapList = info.settings.contexts{toneCtxInd}.decorators.lap_list;
%         end
        
        
        
    end  % END processing settings string
    
    %% sessInfo (mouse name, project, etc.)
    if ~isempty(strfind(rowStr, '"mouse"'))
        treadBehStruc.sessInfo = rowStr;
    end
    
    %% for other events
    
    
    % find computer time from this event/row
    if ~isempty(strfind(rowStr, '"time"'))
        skip=0;
        timeInd = strfind(rowStr, '"time"');
        currTime = str2num(rowStr(timeInd+8:end-1));
        lastTime = time(end);
        if currTime>=lastTime
            time = [time currTime];
        else
            skip=1; % sometimes a message gets re-sent later, so skip this if so (i.e. out of order messages)
        end
        
        if skip~=1 % if message not out-of-order, parse message
            
            %% NON-CONTEXT EVENTS (e.g. pos, lap, lick, rew, sync)
            %% POS position reading (log PC time and arduino Nano millis, because PC time may be delayed due to packet drop, etc.)
            if ~isempty(strfind(rowStr, '"position"'))
                yInd = strfind(rowStr, '"y"');
                if length(yInd)==1 && currTime>lastTime %&& abs(str2num(rowStr(yInd+5:timeInd-2)))<% built this in because sometimes pos messages garbled, so throw out
                    currY = str2num(rowStr(yInd+5:timeInd-2));
                    y = [y currY];
                    yTimes = [yTimes currTime];
                    millisInd = strfind(rowStr, '"millis"');
                    millis = str2num(rowStr(millisInd+9:yInd-3));
                    yTimeNano = [yTimeNano millis];
                end
            end
            
            %% LAP time (NOTE may miss laps so don't trust this too much)
            if ~isempty(strfind(rowStr, '"lap"'))
                lapTime = [lapTime currTime];
                lap = str2num(rowStr(strfind(rowStr, '"lap"')+7:strfind(rowStr, '"time"')-2)); % lap+1;
                lapNum = [lapNum lap];
            end
            
            %% LICK time/pos
            try
                if ~isempty(strfind(rowStr, '"lick"')) && ~isempty(strfind(rowStr, '"start"'))
                    lickTime = [lickTime currTime];
                    lickPos = [lickPos currY];
                    lickLap = [lickLap lap];
                end
            catch
                disp('Dropping this lick because its before first pos reading');
            end
            
            %% REW ZONE enter/exit time/pos
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
            
            
            % REW time/pos
            if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(rewPin)]))
                rewTime = [rewTime currTime];
                rewPos = [rewPos currY];
                rewLap = [rewLap lap];
            end
            
            % SYNC pin activation for 2p trig (start of 2p imaging)
            if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(syncPin)]))
                treadBehStruc.syncOnTime = currTime;
                %rewPos = [rewPos currY];
            elseif ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"close"')) && ~isempty(strfind(rowStr, ['"pin": ' num2str(syncPin)]))
                treadBehStruc.syncOffTime = currTime;
            end
            
            %% contexts
            
            for j=1:length(idCell)
                if contains(rowStr, idCell{j})
                    contextType = j;
                    if contains(rowStr, 'start')
                        contextStruc(j).startTimes = [contextStruc(j).startTimes currTime];
                        contextStruc(j).startPos = [contextStruc(j).startPos currY];
                        %contextStruc(j).startPos = [contextStruc(j).startPos lap];
                    elseif contains(rowStr, 'stop')
                        contextStruc(j).endTimes = [contextStruc(j).endTimes currTime];
                        contextStruc(j).endPos = [contextStruc(j).endPos currY];
                    end
                end
            end
%             
%             % OLFACTORY/scent stim time/pos
%             if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && ~isempty(strfind(rowStr, '"pin": 3,'))
%                 olfTimeStart = [olfTimeStart currTime];
%                 olfPosStart = [olfPosStart currY];
%                 olfLap = [olfLap lap];
%             elseif ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"close"')) && ~isempty(strfind(rowStr, '"pin": 3,'))
%                 olfTimeEnd = [olfTimeEnd currTime];
%                 olfPosEnd = [olfPosEnd currY];
%             end
%             
%             % LED stim time/pos
%             if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"')) && contains(rowStr, ['"pin": ' num2str(ledPin) ',']) % && (~isempty(strfind(rowStr, '"pin": 34,'))|| ~isempty(strfind(rowStr, 'led')))
%                 ledTimeStart = [ledTimeStart currTime];
%                 ledPosStart = [ledPosStart currY];
%                 ledLap = [ledLap lap];
%             elseif ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"close"')) && contains(rowStr, ['"pin": ' num2str(ledPin) ',']) % ~isempty(strfind(rowStr, '"pin": 34,'))
%                 ledTimeEnd = [ledTimeEnd currTime];
%                 ledPosEnd = [ledPosEnd currY];
%                 
%             end
%             
%             % TONE stim time/pos
%             if ~isempty(strfind(rowStr, '"tone"')) && ~isempty(strfind(rowStr, '"open"')) %&& ~isempty(strfind(rowStr, '"pin":3'))
%                 toneTimeStart = [toneTimeStart currTime];
%                 tonePosStart = [tonePosStart currY];
%                 toneLap = [toneLap lap];
%             elseif ~isempty(strfind(rowStr, '"tone"')) && ~isempty(strfind(rowStr, '"close"'))
%                 toneTimeEnd = [toneTimeEnd currTime];
%                 tonePosEnd = [tonePosEnd currY];
%                 
%             end
%             
%             % TACTILE stim time/pos (based upon zone so might be off by a few
%             % ms from actual pulse)
%             if ~isempty(strfind(rowStr, 'tact')) && ~isempty(strfind(rowStr, 'start'))
%                 tactTimeStart = [tactTimeStart currTime];
%                 tactPosStart = [tactPosStart currY];
%                 tactLap = [tactLap lap];
%             elseif ~isempty(strfind(rowStr, 'tact')) && ~isempty(strfind(rowStr, 'stop'))
%                 tactTimeEnd = [tactTimeEnd currTime];
%                 tactPosEnd = [tactPosEnd currY];
%             end
%             
%             % OPTO stim time/pos (based upon zone so might be off by a few
%             % ms from actual pulse)
%             if ~isempty(strfind(rowStr, 'opto')) && ~isempty(strfind(rowStr, 'start'))
%                 optoTimeStart = [optoTimeStart currTime];
%                 optoPosStart = [optoPosStart currY];
%                 optoLap = [optoLap lap];
%             elseif ~isempty(strfind(rowStr, 'opto')) && ~isempty(strfind(rowStr, 'stop'))
%                 optoTimeEnd = [optoTimeEnd currTime];
%                 optoPosEnd = [optoPosEnd currY];
%             end
            
            % RFID time/pos
            if ~isempty(strfind(rowStr, '"tag_reader"')) %&& ~isempty(strfind(rowStr, '"open"')) %&& ~isempty(strfind(rowStr, '"pin":3'))
                rfidTime = [rfidTime currTime];
                rfidPos = [rfidPos currY];
                rfidLap = [rfidLap lap];
                rfidName = [rfidName {rowStr(strfind(rowStr, '"tag"')+8:strfind(rowStr, '"tag"')+19)}];
            end
            
            
            % make list of contexts as you go
            if ~isempty(strfind(rowStr, 'context')) && ~isempty(strfind(rowStr, 'start'))
                ctxtTime = [ctxtTime currTime];
                ctxtPos = [ctxtPos currY];
                ctxtLap = [ctxtLap lap];
                ctxtName = [ctxtName {rowStr(strfind(rowStr, '"id"')+7:strfind(rowStr, '"},')-1)}];
            end
            
            % make list of frame counts
            if ~isempty(strfind(rowStr, 'count'))
                frCountTime = [frCountTime currTime];
                frCountPos = [frCountPos currY];
                count = str2num(rowStr(strfind(rowStr, '"count"')+9:strfind(rowStr, ',"millis"')-1));
                frCount = [frCount count];
            end
            
            % other events: debug timeout,
            
        end % end IF skip~=1
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

treadBehStruc.lapTime = lapTime; treadBehStruc.lapNum = lapNum;
treadBehStruc.lickTime = lickTime; treadBehStruc.lickPos = lickPos; treadBehStruc.lickLap = lickLap;
treadBehStruc.rewTime = rewTime; treadBehStruc.rewPos = rewPos;treadBehStruc.rewLap = rewLap;
treadBehStruc.rewZoneStartTime = rewZoneStartTime;
treadBehStruc.rewZoneStartPos = rewZoneStartPos;
treadBehStruc.rewZoneStopTime = rewZoneStopTime;
treadBehStruc.rewZoneStopPos = rewZoneStopPos;

treadBehStruc.olfTimeStart = olfTimeStart; treadBehStruc.olfPosStart = olfPosStart; treadBehStruc.olfLap = olfLap;
treadBehStruc.olfTimeEnd = olfTimeEnd; treadBehStruc.olfPosEnd = olfPosEnd; 
treadBehStruc.ledTimeStart = ledTimeStart; treadBehStruc.ledPosStart = ledPosStart; treadBehStruc.ledLap = ledLap;
treadBehStruc.ledTimeEnd = ledTimeEnd; treadBehStruc.ledPosEnd = ledPosEnd;
treadBehStruc.toneTimeStart = toneTimeStart; treadBehStruc.tonePosStart = tonePosStart; treadBehStruc.toneLap = toneLap;
treadBehStruc.toneTimeEnd = toneTimeEnd; treadBehStruc.tonePosEnd = tonePosEnd; 
treadBehStruc.tactTimeStart = tactTimeStart; treadBehStruc.tactPosStart = tactPosStart; treadBehStruc.tactLap = tactLap;
treadBehStruc.tactTimeEnd = tactTimeEnd; treadBehStruc.tactPosEnd = tactPosEnd;
treadBehStruc.optoTimeStart = optoTimeStart; treadBehStruc.optoPosStart = optoPosStart; treadBehStruc.optoLap = optoLap;
treadBehStruc.optoTimeEnd = optoTimeEnd; treadBehStruc.optoPosEnd = optoPosEnd;
treadBehStruc.rfidTime = rfidTime; treadBehStruc.rfidPos = rfidPos; treadBehStruc.rfidLap = rfidLap; treadBehStruc.rfidName = rfidName;
treadBehStruc.ctxtTime = ctxtTime; treadBehStruc.ctxtPos = ctxtPos; treadBehStruc.ctxtLap = ctxtLap; treadBehStruc.ctxtName = ctxtName;
treadBehStruc.frCountTime = frCountTime; treadBehStruc.frCountPos = frCountPos; treadBehStruc.frCount = frCount;


% NOTE: these times (e.g. rewTime) will be in register with adjFrTimes