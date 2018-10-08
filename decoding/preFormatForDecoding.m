function [spike_times, pos, pos_times] = preFormatForDecoding(pksCell, treadBehStruc, varargin);


% Pre-format data for Kording decoding examples
% Clay Oct. 2018

if nargin==1
    pos = varargin{1};
else
    pos = treadBehStruc.resampY(1:2:end)';
end

spike_times = pksCell'; % should be #cells x 1

% pos = treadBehStruc.resampY(1:2:end)'; % should be #fr x 2 (code is set up for X,Y so just double belt pos)
pos = [pos pos];

pos_times = treadBehStruc.adjFrTimes(1:2:end); % should be 1 x #fr

save(uigetfile(),'spike_times', 'pos', 'pos_times');