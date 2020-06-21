function [goodParams, coefs, pvals, r2, paramNames] = fitCaCuePos(ca, treadBehStruc)

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
try
cueStart = treadBehStruc.olfTimeStart;
cueEnd = treadBehStruc.olfTimeEnd;
catch
    cueStart = treadBehStruc.ledTimeStart;
cueEnd = treadBehStruc.ledTimeEnd;
end
rewStart = treadBehStruc.rewZoneStartTime;
rewEnd = treadBehStruc.rewZoneStopTime;
pos = treadBehStruc.resampY(1:2:end); pos = pos/max(pos(:));

% process calcium signal
% ca = C(86,:);
ca = ca-runmean(ca, 1000); % filter out low freq/basline shifts
ca = ca-min(ca);
ca = ca/max(ca);

%% cue term
cueSig = zeros(length(frTimes),1);
for i=1:length(cueStart) 
    try
    cueSig(find(frTimes>cueStart(i)+2 & frTimes<(cueEnd(i)+3)))=1; %end+10
    %cueSig(find(frTimes>=cueStart(i)+1,1))=1;
    catch
    end
end

% exponential filter to cue signal
tau=40; 
x=1:6*tau; %60; %200; 
yexp=exp(-x/tau); % construct filter
%figure; plot(yexp);
cs2 = conv(cueSig,yexp);
cs2 = cs2/max(cs2);
cs2 = cs2(1:length(ca));

% figure; plot(cueSig); hold on; plot(cs2,'r');
% plot(ca,'g');
% plot(pos,'k');

%% rew term
rewSig = zeros(length(frTimes),1);
for i=1:length(rewStart) 
    try
    rewSig(find(frTimes>rewStart(i)+2 & frTimes<(rewEnd(i)+3)))=1; 
    catch
    end
end

% exponential filter to rew signal
rs2 = conv(rewSig,yexp);
rs2 = rs2/max(rs2);
rs2 = rs2(1:length(ca));

%% pos terms
% (divide belt into 10 segments and have step pulse at each epoch over
% session)
posTerms = zeros(length(frTimes),10);

for i=1:10
    posTerm = zeros(length(frTimes),1);
    posTerm(find(pos>(i-1)/10 & pos<i/10)) = 1; 
    posTerm = conv(posTerm, yexp);
    posTerm = posTerm(1:length(ca));
    posTerm = posTerm/max(posTerm);
    posTerms(:,i) = posTerm;
end


%% linear fit
%ca = C(137,:);
% ca = ca-runmean(ca, 1000); % filter out low freq/basline shifts
% ca = ca-min(ca);
% ca = ca/max(ca);
%lm = fitlm([cueSig rewSig posTerms], ca)
lm = fitlm([cs2 rs2 posTerms], ca);
%lm = fitlm([cs2 posTerms], ca)
% [b, dev, stats] = glmfit([cs2 rs2 posTerms], ca, 'normal');

% figure;  hold on; 
% %plot(cueSig);
% plot(cs2,'r'); 
% plot(pos, 'k');
% %plot(posTerms(:,3), 'm');%plot(rs2, 'm');
% plot(ca,'g');

% %% (from RegressClayCalcium.m in brunoLab)

% for i=1:10
%     eval(['posTerms' num2str(i) '=posTerms(:,' num2str(i) ');']);
% end
% 
% ds = dataset(cs2, rs2, posTerms1, posTerms2, posTerms3, posTerms4, posTerms5, posTerms6, posTerms7, posTerms8, posTerms9, posTerms10, ca');
% 
% 
% mdl = LinearModel.stepwise(ds, 'Verbose', 2)


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

paramNames = {'(int)', 'cue', 'rew', 'posBin1', 'posBin2', 'posBin3', 'posBin4', 'posBin5', 'posBin6', 'posBin7', 'posBin8', 'posBin9', 'posBin10'};

% try
% paramNames = {'(int)', 'cue', 'rew', 'posBin1', 'posBin2', 'posBin3', 'posBin4', 'posBin5', 'posBin6', 'posBin7', 'posBin8', 'posBin9', 'posBin10'};
% posParams = goodParams(find(coef(goodParams)>0));
% disp(['Good params: ' paramNames{posParams}]);
% %try
%     disp(['pvals=' num2str(pval(posParams)) ', coef=' num2str(coef(posParams))]);
% catch
% end