function [spike_times, pos, pos_times] = preFormatForDecoding(pksCell, treadBehStruc, varargin);


% Pre-format data for Kording decoding examples
% Clay Oct. 2018

if nargin==3
    pos = varargin{1}; % e.g. for pos with nonmov. NaNs
elseif nargin == 4
    pos = varargin{1}; % e.g. for pos from only certain laps
    pos_times = varargin{2};
else
    pos = treadBehStruc.resampY(1:2:end)';
    pos_times = treadBehStruc.adjFrTimes(1:2:end); % should be 1 x #fr
end

spike_times = pksCell'; % should be #cells x 1

% pos = treadBehStruc.resampY(1:2:end)'; % should be #fr x 2 (code is set up for X,Y so just double belt pos)
pos = [pos pos];


%save(uigetfile(),'spike_times', 'pos', 'pos_times');