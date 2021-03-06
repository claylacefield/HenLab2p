function [mdl] = treadLinReg(ca, treadBehStruc);

%% USAGE: [mdl] = treadLinReg(ca, treadBehStruc);

%linRegStruc = procTreadSigsForRegr(treadBehStruc);

ca = ca/max(ca);
if size(ca,1)>size(ca,2)
    ca = ca';
end

T = 1:length(ca);

vel = fixVel(treadBehStruc.vel(1:2:end));
vel = vel/max(vel);
pos = treadBehStruc.resampY(1:2:end);
pos = pos/max(pos);

%% construct signals for events
frTimes = treadBehStruc.adjFrTimes(1:2:end);

% reward
rewTime = treadBehStruc.rewTime;
%rewStartTimes = rewTime([1 find(diff(rewTime)>10)+1]);
frInds = knnsearch(frTimes', rewTime');
rew = zeros(1,length(T));
rew(frInds) = 1;

% licks
lickTime = treadBehStruc.lickTime;
frInds = knnsearch(frTimes', lickTime');
lick = zeros(1,length(T));
lick(frInds) = 1;


% construct table
tbl = table(T',pos',vel',rew',lick',ca', 'VariableNames', {'T', 'pos', 'vel', 'rew', 'lick', 'ca'});


% linear regression
mdl = fitlm(tbl, 'linear');

