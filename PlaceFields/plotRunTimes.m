function plotRunTimes(runTimes,T,pos)

% Clay 2018
% Plot treadmill position vector with Andres's runTimes (from
% calcMovEpochs1, or in computePlaceTransVectorSimple1.m)


[bool, runStartInd] = ismember(runTimes(:,1), T);
[bool, runStopInd] = ismember(runTimes(:,2), T);


figure; 
plot(T,pos); 
hold on; 
plot(T(runStartInd), pos(runStartInd), 'c*');
plot(T(runStopInd), pos(runStopInd), 'm*');




