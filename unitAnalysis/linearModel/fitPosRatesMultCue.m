function [goodParams, coefs, pvals, r2, paramNames] = fitPosRatesMultCue(posRatesCat)

% Clay 2020
% from fitCaCuePos
% Just a prelim analysis based upon posRates for all PCs from cuePrecess
% expt. PCs based upon lapType1
%
% posRatesCat is for all cells from all animals 190514, with the 3 lapTypes
% concatenated by pos, i.e. 1:100 x3 = 1:300
% I think I got the posRates from the plotGroupCueStruc script, which
% concatenates all cells/lapTypes from groupCueStruc from a day.
%
% ToDo:
% - 

pos1 = [1:100 1:100 1:100];
pos2 = [1:150 1:150];


%% pos terms
% (divide belt into 10 segments and have step pulse at each epoch over
% session) NOTE: for this version (w. posRates) not filtering like I did
% with Ca fit
pos1Terms = zeros(length(pos1),10);

for i=1:10
    pos1Term = zeros(length(pos1),1);
    pos1Term(find(pos1>(i-1)*10 & pos1<=i*10)) = 1; 
    %pos1Term = conv(pos1Term, yexp);
    %pos1Term = pos1Term(1:length(ca));
    %pos1Term = pos1Term/max(pos1Term);
    pos1Terms(:,i) = pos1Term;
end

pos2Terms = zeros(length(pos2),10);

for i=1:15
    pos2Term = zeros(length(pos2),1);
    pos2Term(find(pos2>(i-1)*10 & pos2<=i*10)) = 1; 
    %pos1Term = conv(pos1Term, yexp);
    %pos1Term = pos1Term(1:length(ca));
    %pos1Term = pos1Term/max(pos1Term);
    pos2Terms(:,i) = pos2Term;
end

%aFilt = fspecial('gaussian', [20,1], 10);

%% linear fit
% NOTE: sortInd from where?
[maxVal, maxInd] = max(posRatesCat(:,1:100)');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;

posRatesCat2 = posRatesCat(sortInd,:);

for i=1:size(posRatesCat,1)
    ca = posRatesCat(sortInd(i),:); ca=ca/max(ca);
    lm = fitlm([pos1Terms pos2Terms], ca);
    pval = table2array(lm.Coefficients(:,4)); pval = pval(2:end); % pvals for all posTerms (elim intercept row)
    [val, ind] = min(pval);
    coef = table2array(lm.Coefficients(:,1)); coef = coef(2:end);
    if coef(ind)>0 && val<0.05
        vals(i)=val; inds(i)=ind; coefs(i)=coef(ind);
    else
        vals(i)=NaN; inds(i)=NaN; coefs(i)=NaN;
    end
end



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