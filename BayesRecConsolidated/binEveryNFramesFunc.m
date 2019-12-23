function varargout = binEveryN(binEveryN, varargin)
%take average across every N'th bin (non-overlapping), all variables
%must have the same size(1)

us = [];
for i = 1:length(varargin)
    us = [us, size(varargin{i}, 1)];
end
us = unique(us);
if length(us) ~= 1
    error('Luuuccccyyy!');
end
n1 = (binEveryN - 1);
k = 1:binEveryN:(us - n1);
for v = 1:length(varargin)
    varargout{v} = NaN(length(k), size(varargin{v}, 2));
end


varargout{1} = zeros(size(varargin{1}, 1), 1);
count = 1;
for i = k
    varargout{1}(i:(i + n1)) = count;
    for v = 1:length(varargin)
        varargout{v + 1}(count, :) = nanmean(varargin{v}(i:(i + n1), :), 1);
    end
    count = count + 1;
end

    


