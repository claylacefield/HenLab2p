function [transMatOut, TOut, treadPosCircOut] = binEveryNCircPos(binEveryN, transMat, T, treadPosCirc)
%function varargout = binEveryNCircPos(binEveryN, transMat, T, treadPosCirc)

if size(transMat, 1) ~= length(treadPosCirc);
    error('Luuuccccyyy!');
end
us = size(transMat, 1);
n1 = (binEveryN - 1);
k = 1:binEveryN:(us - n1);

transMatOut = NaN(length(k), size(transMat, 2));
treadPosCircOut = NaN(1, length(k));
TOut = NaN(1, length(k));

count = 1;
for i = k
    transMatOut(count, :) = nansum(transMat(i:(i + n1), :), 1);
    TOut(count) = nanmean(T(i:(i + n1)));
    treadPosCircOut(count) = circ_mean(treadPosCirc(i:(i + n1)));
    count = count + 1;
end




