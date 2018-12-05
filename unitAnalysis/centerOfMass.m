function [com] = centerOfMass(posRates)

% Clay Dec. 2018
% Not sure if this is correct


for i=1:size(posRates,1)
    com(i) = mean(posRates(i,:).*(1:size(posRates,2)))*size(posRates,2)/sum(posRates(i,:),2);
end