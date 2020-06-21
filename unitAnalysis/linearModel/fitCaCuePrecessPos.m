function [goodParams, coefs, pvals, r2, paramNames] = fitCaCuePrecessPos(ca, treadBehStruc)

% Clay 2020
% For a single cell, do linear fit of calcium profile (fitlm) with cue and spatial terms
% NOTE: this should probably be used with randCue sessions
% e.g. '/Backup20TB/clay/DGdata/190626/190625_IR-519-B2_randCueOlf-001'
%
% ToDo:
% - add reward term (but remember maybe only look at rew consumed)
% - do for all cells and see pattern,
%   and how it matches up with other ways of finding cue cells

% extract behavior regressors
frTimes = treadBehStruc.adjFrTimes(1:2:end);
cueStart = treadBehStruc.olfTimeStart;
cueEnd = treadBehStruc.olfTimeEnd;
% rewStart = treadBehStruc.rewZoneStartTime;
% rewEnd = treadBehStruc.rewZoneStopTime;
pos = treadBehStruc.resampY(1:2:end); pos = pos/max(pos(:));

% make pseudo pos based upon second cue ref frame
pos2 = zeros(1, length(pos));
for i=1:length(cueStart)-1
    lapFr = find(frTimes>=cueStart(i) & frTimes<cueStart(i+1));
    lapLen(i) = length(lapFr);
    pos2(lapFr) = linspace(0,1,length(lapFr));
end

% fix beginning and end
avLap = round(mean(lapLen));
initEp = 1:find(frTimes>=cueStart(1),1)-1;
lapFrac = length(initEp)/avLap;
pos2(initEp) = linspace(1-lapFrac,1,length(initEp));
endEp = find(frTimes>=cueStart(end),1):length(pos2);
lapFrac = length(endEp)/avLap;
pos2(endEp) = linspace(0,lapFrac,length(endEp));


% process calcium signal
% ca = C(86,:);
ca = ca-runmean(ca, 1000); % filter out low freq/basline shifts
ca = ca-min(ca);
ca = ca/max(ca);


%% pos terms
% (divide belt into 10 segments and have step pulse at each epoch over
% session)

% exponential filter to pos signal
tau=40; 
x=1:6*tau; %60; %200; 
yexp=exp(-x/tau); % construct filter

posTerms1 = zeros(length(frTimes),10);

for i=1:10
    posTerm = zeros(length(frTimes),1);
    posTerm(find(pos>(i-1)/10 & pos<i/10)) = 1; 
    posTerm = conv(posTerm, yexp);
    posTerm = posTerm(1:length(frTimes));
    posTerm = posTerm/max(posTerm);
    posTerms1(:,i) = posTerm;
end

% for reference frame2
posTerms2 = zeros(length(frTimes),15);

for i=1:15
    posTerm = zeros(length(frTimes),1);
    posTerm(find(pos2>(i-1)/15 & pos2<i/15)) = 1; 
    posTerm = conv(posTerm, yexp);
    posTerm = posTerm(1:length(frTimes));
    posTerm = posTerm/max(posTerm);
    posTerms2(:,i) = posTerm;
end

%% linear fit
%ca = C(137,:);
ca = ca-runmean(ca, 1000); % filter out low freq/basline shifts
ca = ca-min(ca);
ca = ca/max(ca);
%lm = fitlm([cueSig rewSig posTerms], ca)
lm = fitlm([posTerms1 posTerms2], ca);
%lm = fitlm([cs2 posTerms], ca)
% [b, dev, stats] = glmfit([cs2 rs2 posTerms], ca, 'normal');




%% find significant coefficients

r2 = lm.Rsquared.Adjusted;  % R2 Rsquared for linear model

if r2>0.1 % only for cells with relatively good fit
pval = table2array(lm.Coefficients(:,4)); % pvals for each model coefficient
sigpv = find(pval<0.05);  % 0.1 % find significant ones
sigpv = sigpv(sigpv~=1); % exclude intercept (row 1)
coef = table2array(lm.Coefficients(:,1)); % pvals for each model coefficient
goodCoef = find(abs(coef)>0.01); % 0.04
goodCoef = goodCoef(goodCoef~=1);
goodParams = intersect(sigpv, goodCoef);
% find coeff value, pVal, overall model R2
pvals = pval(goodParams);
coefs = coef(goodParams);
else
    goodParams = []; pvals = []; coefs = [];
    %disp('R2<0.1 so bad fit');
end

paramNames = {'(int)', 'pos1Bin1', 'pos1Bin2', 'pos1Bin3', 'pos1Bin4', 'pos1Bin5', 'pos1Bin6', 'pos1Bin7', 'pos1Bin8', 'pos1Bin9', 'pos1Bin10', 'pos2Bin1', 'pos2Bin2', 'pos2Bin3', 'pos2Bin4', 'pos2Bin5', 'pos2Bin6', 'pos2Bin7', 'pos2Bin8', 'pos2Bin9', 'pos2Bin10', 'pos2Bin11', 'pos2Bin12', 'pos2Bin13', 'pos2Bin14', 'pos2Bin15'};

% try
% paramNames = {'(int)', 'cue', 'rew', 'posBin1', 'posBin2', 'posBin3', 'posBin4', 'posBin5', 'posBin6', 'posBin7', 'posBin8', 'posBin9', 'posBin10'};
% posParams = goodParams(find(coef(goodParams)>0));
% disp(['Good params: ' paramNames{posParams}]);
% %try
%     disp(['pvals=' num2str(pval(posParams)) ', coef=' num2str(coef(posParams))]);
% catch
% end