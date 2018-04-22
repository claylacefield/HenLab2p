function treadLinReg(ca, treadBehStruc)


%linRegStruc = procTreadSigsForRegr(treadBehStruc);

vel = fixVel(treadBehStruc.vel(1:2:end));
pos = treadBehStruc.resampY(1:2:end);
T = 1:length(vel);

frTimes = treadBehStruc.adjFrTimes(1:2:end);
rewTime = treadBehStruc.rewTime;
lickTime = treadBehStruc.lickTime;

rewStartTimes = rewTime([1 find(diff(rewTime)>10)+1]);

frInds = knnsearch(frTimes', rewStartTimes');

