function [treadBehStruc] = readTDML_AG(pwd, filename)

% run this in the command window to run all of the tdml files in parent directory
%d = dir('*tdml');
%treadBehStruc = {};
%for i = 1:length(d)
%treadBehStruc{i} = readTDML_AG(pwd, d(i).name);
%end

behCell = importdata([pwd, '\', filename], '\t'); %create behCell, tab delimiter ('\t') creates rows for each line of the file

disp(['Processing treadmill behavior data from: ' filename]);

treadBehStruc.tdmlName = filename;

% initialize variables
filename = [];
time = [];
y = [];
yTime = [];
lickTime = [];
lickPos = [];
rewTime = [];
rewPos = [];
% toneTime = [];
% tonePos = [];
lapTime = [];
rewZoneStartTime = [];
rewZoneStopTime = [];
rewZoneStartPos = [];
rewZoneStopPos = [];

% toneZone1StartTime = [];
% toneZone1StopTime = [];
% toneZone1StartPos = [];
% toneZone1StopPos = [];

% rewZone2StartTime = [];
% rewZone2StartPos = [];
% rewZone2StopTime = [];
% rewZone2StopPos = [];
% 
% toneZone2StartTime = [];
% toneZone2StartPos = [];
% toneZone2StopTime = [];
% toneZone2StopPos = [];
currY =  NaN; %this is to make sure if a lick or valve detected before position it will appear as NaN as default
tic;
for i=4:length(behCell) %start row# from where it starts recording position first few are session info
    rowStr = behCell{i}; %putting it in {}s instead of () means its gonna take that cell of cell array and make it into string
    timeInd = strfind(rowStr, '"time"'); %where is the word "time" in this string? find index
    currTime = str2num(rowStr(timeInd+8:end-1));%to extract current time we want the number which starts 8 characters after that index being return by time index
    time = [time currTime]; % horizontally concatanate all of the times, this will be the time of all following events
    
    if ~isempty(strfind(rowStr, '"position"'))% ~isempty will return logical 1 in the presence of 'position'
        yInd = strfind(rowStr, '"y"');
        currY = str2num(rowStr(yInd+5:timeInd-2));
        y = [y currY];
        yTime = [yTime currTime];
        
    end
    
    % lick time/pos
    if ~isempty(strfind(rowStr, '"lick"')) && ~isempty(strfind(rowStr, '"start"'))
        lickTime = [lickTime currTime];
        lickPos = [lickPos currY]; %because its a for loop, we are using the currY from the last time it was detected
    end
    
    % reward time/pos
    if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"'))
        rewTime = [rewTime currTime];
        rewPos = [rewPos currY];
    end
    
    % tone time/pos
%     if ~isempty(strfind(rowStr, '"tone"')) && ~isempty(strfind(rowStr, '"open"'))
%         toneTime = [toneTime currTime];
%         tonePos = [tonePos currY];
%     end
    
    % rew zone enter/exit time/pos-->for only reward trials (*not currently in struct)
    if ~isempty(strfind(rowStr, '"context"'))
        if ~isempty(strfind(rowStr, '"start"')) && ~isempty(strfind(rowStr, '"reward"'))
            rewZoneStartTime = [rewZoneStartTime currTime];
            rewZoneStartPos = [rewZoneStartPos currY];
        %elseif ~isempty(strfind(rowStr, '"stop"')) && ~isempty(strfind(rowStr, '"reward"'))
            rewZoneStopTime = [(rewZoneStartTime+4) currTime];
            %rewZoneStopPos = [rewZoneStopPos currY];
        end
    end
   
    
      % tone zone 1 enter/exit time/pos-->for context trials (***need to write each context seperately)
%     if ~isempty(strfind(rowStr, '"context"'))
%         if ~isempty(strfind(rowStr, '"start"')) && ~isempty(strfind(rowStr, '"tone_context1"'))
%             toneZone1StartTime = [toneZone1StartTime currTime];
%             toneZone1StartPos = [toneZone1StartPos currY];
%         elseif ~isempty(strfind(rowStr, '"stop"')) && ~isempty(strfind(rowStr, '"tone_context1"'))
%             toneZone1StopTime = [toneZone1StopTime currTime];
%             toneZone1StopPos = [toneZone1StopPos currY];
%         end
%     end
     
        % reward zone 1 enter/exit time/pos-->for context trials (***need to write each context seperately)
%    if ~isempty(strfind(rowStr, '"context"'))
%         if ~isempty(strfind(rowStr, '"start"')) && ~isempty(strfind(rowStr, '"fist_reward"'))
%             rewZone1StartTime = [rewZone1StartTime currTime];
%             rewZone1StartPos = [rewZone1StartPos currY];
%         elseif ~isempty(strfind(rowStr, '"stop"')) && ~isempty(strfind(rowStr, '"fist_reward"'))
%             rewZone1StopTime = [rewZone1StopTime currTime];
%             rewZone1StopPos = [rewZone1StopPos currY];
%         end
%    end

   
%     % tone zone 2 enter/exit time/pos-->for context trials (***need to write each context seperately)
%     if ~isempty(strfind(rowStr, '"context"'))
%         if ~isempty(strfind(rowStr, '"start"')) && ~isempty(strfind(rowStr, '"tone_context2"'))
%             toneZone2StartTime = [toneZone2StartTime currTime];
%             toneZone2StartPos = [toneZone2StartPos currY];
%         elseif ~isempty(strfind(rowStr, '"stop"')) && ~isempty(strfind(rowStr, '"tone_context2"'))
%             toneZone2StopTime = [toneZone2StopTime currTime];
%             toneZone2StopPos = [toneZone2StopPos currY];
%         end
%     end
% 
%   
%         % reward zone 2 enter/exit time/pos-->for context trials (***need to write each context seperately)
%    if ~isempty(strfind(rowStr, '"context"'))
%         if ~isempty(strfind(rowStr, '"start"')) && ~isempty(strfind(rowStr, '"second_reward"'))
%             rewZone2StartTime = [rewZone2StartTime currTime];
%             rewZone2StartPos = [rewZone2StartPos currY];
%         elseif ~isempty(strfind(rowStr, '"stop"')) && ~isempty(strfind(rowStr, '"second_reward"'))
%             rewZone2StopTime = [rewZone2StopTime currTime];
%             rewZone2StopPos = [rewZone2StopPos currY];
%         end
%     end
       
        
    % lap time
    if ~isempty(strfind(rowStr, '"lap"'))
        lapTime = [lapTime currTime];
%     else ~isempty(strfind(rowStr, '"no tag"'))
%         currTimelapalt = str2num(rowStr(timeInd+8:end-20));
%         lapTime = [time currTimelapalt];
    end
    
    
end


%resample everything into 30hz time

E = yTime(length (yTime)); %last value of the vector
timeVec = 0:0.033:E;
resampY = interp1(yTime, y, timeVec);  %linearly interpolate y onto yTime which is converted to timeVec increments
                                       %CORRECT for circular interpolation
                   
vel = ((abs(diff(resampY))/0.33));% calculate velocity over each frame (at 30hz)
vel = [(vel(1:end)),NaN];
lickCount = histc(lickTime, timeVec);%count # number of licks that are within each timeVec bins
rewCount = histc (rewTime, timeVec); %count # rewards
BeCell = vertcat (timeVec, resampY, lickCount, rewCount, vel);
BeCell = BeCell';
lapCount = histc (lapTime, timeVec);%count # laps
% rewZoneStartTime = rewZoneStartTime(1:length(rewZoneStopTime)); %to make the lenght of start time same as end in case it starts but not ends
% RewZone = vertcat (rewZoneStartTime, rewZoneStopTime);



toc;

% save relevant variables to output structure
treadBehStruc.filename = filename;
treadBehStruc.y = y;
treadBehStruc.yTime = yTime;
treadBehStruc.resampY = resampY;
treadBehStruc.vel = vel;
treadBehStruc.lickPos = lickPos;
treadBehStruc.lickCount = lickCount;
treadBehStruc.lapTime = lapTime;
treadBehStruc.lapCount = lapCount;
%treadBehStruc.toneTime = toneTime;
%treadBehStruc.tonePos = tonePos;
treadBehStruc.rewTime = rewTime;
treadBehStruc.rewCount = rewCount;
treadBehStruc.rewPos = rewPos;
treadBehStruc.BeCell = BeCell;

treadBehStruc.rewZoneStartTime = rewZoneStartTime;
treadBehStruc.rewZoneStopTime = rewZoneStopTime;
treadBehStruc.rewZoneStartPos = rewZoneStartPos;
treadBehStruc.rewZoneStopPos = rewZoneStopPos;

% treadBehStruc.rewZone2StartPos = rewZone2StartPos;
% treadBehStruc.rewZone2StopPos = rewZone2StopPos;
% treadBehStruc.rewZone2StartTime= rewZone2StartTime;
% treadBehStruc.rewZone2StopTime = rewZone2StopTime;
% treadBehStruc.toneZone1StartTime = toneZone1StartTime;
% treadBehStruc.toneZone1StopTime = toneZone1StopTime;
% treadBehStruc.toneZone2StartTime = toneZone2StartTime;
% treadBehStruc.toneZone2StopTime = toneZone2StopTime;
% treadBehStruc.toneZone1StartPos = toneZone1StartPos;
% treadBehStruc.toneZone1StopPos = toneZone1StopPos;
% treadBehStruc.toneZone2StartPos = toneZone2StartPos;
% treadBehStruc.toneZone2StopPos = toneZone2StopPos;

