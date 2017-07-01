function [treadBehStruc] = readTDML()

% currDir = dir;
% currDirNames = {currDir.name};

[filename, path] = uigetfile('*.tdml', 'Select TDML file to process:');
behCell = importdata([path filename], '\t');

disp(['Processing treadmill behavior data from: ' filename]);

treadBehStruc.tdmlName = filename;

% initialize variables
time = [];
y = [];
yTime = [];
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
for i=6:length(behCell)
   rowStr = behCell{i}; 
   timeInd = strfind(rowStr, '"time"');
   currTime = str2num(rowStr(timeInd+8:end-1));
   time = [time currTime];
   
   if ~isempty(strfind(rowStr, '"position"'))
       yInd = strfind(rowStr, '"y"');
       currY = str2num(rowStr(yInd+5:timeInd-2));
       y = [y currY];
       yTime = [yTime currTime];
    
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
   if ~isempty(strfind(rowStr, '"valve"')) && ~isempty(strfind(rowStr, '"open"'))
       rewTime = [rewTime currTime];
       rewPos = [rewPos currY];
   end
   
   % other events: debug timeout, 
   
end

% calculate velocity over each frame (at 30hz)
resampY = interp1(yTime, y, 0:0.033:900);
vel = abs(diff(resampY));

toc;

% save relevant variables to output structure
%treadBehStruc.filename = filename;
treadBehStruc.y = y;
treadBehStruc.yTime = yTime;
treadBehStruc.resampY = resampY;
treadBehStruc.vel = vel;

treadBehStruc.lickTime = lickTime;
treadBehStruc.lickPos = lickPos;
treadBehStruc.lapTime = lapTime;
treadBehStruc.rewTime = rewTime;
treadBehStruc.rewPos = rewPos;
treadBehStruc.rewZoneStartTime = rewZoneStartTime;
treadBehStruc.rewZoneStartPos = rewZoneStartPos;
treadBehStruc.rewZoneStopTime = rewZoneStopTime;
treadBehStruc.rewZoneStopPos = rewZoneStopPos;



