function [treadBehStruc] = readTDML()



% currDir = dir;
[[
% currDirNames = {currDir.name};



[filename, path] = uigetfile('*.tdml', 'Select TDML file to process:');

behCell = importdata([path filename], '\t');



disp(['Processing treadmill behavior data from: ' filename]);



time = [];

y = [];

yTime = [];

j=0;

tic;

for i=4:length(behCell)

   rowStr = behCell{i}; 

   timeInd = strfind(rowStr, '"time"');

   currTime = str2num(rowStr(timeInd+8:end-1));

   time = [time currTime];

   j = j+1;

   if ~isempty(strfind(rowStr, '"position"'))

       yInd = strfind(rowStr, '"y"');

       currY = str2num(rowStr(yInd+5:timeInd-2));

       y = [y currY];

       yTime = [yTime currTime];

       eventCell{j}= 'position';
       
   elseif ~isempty(strfind(rowStr, '"lick"'))
       
       
       eventCell{j}= 'lick';

   end

end



resampY = interp1(yTime, y, 0:0.033:900);



vel = abs(diff(resampY));



toc;



% save relevant variables to output structure

treadBehStruc.filename = filename;

treadBehStruc.y = y;

treadBehStruc.yTime = yTime;

treadBehStruc.resampY = resampY;

treadBehStruc.vel = vel;

















