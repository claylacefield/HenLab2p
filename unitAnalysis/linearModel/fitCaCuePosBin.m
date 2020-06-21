function [goodParams, coefs, pvals, r2, paramNames] = fitCaCuePosBin(ca, treadBehStruc)

% Clay 2020
% (from fitCaCuePos.m, but binning all signals)
% For a single cell, do linear fit of calcium profile (fitlm) with cue and spatial terms
% NOTE: this should probably be used with randCue sessions
% e.g. '/Backup20TB/clay/DGdata/190626/190625_IR-519-B2_randCueOlf-001'
%
% NOTE: testing on cue cells it seems to work okay, but doesn't work well
% with posTerms, even for strong "place" cells like lap cue cells

% extract behavior regressors
frTimes = treadBehStruc.adjFrTimes(1:2:end);
cueStart = treadBehStruc.olfTimeStart;
cueEnd = treadBehStruc.olfTimeEnd;
rewStart = treadBehStruc.rewZoneStartTime;
rewEnd = treadBehStruc.rewZoneStopTime;
pos = treadBehStruc.resampY(1:2:end);

% detect ca events
[pks, amps, wavef] = clayCaTransients(ca, 15, 1, 3);

%% bin cue, rew, ca term
frLen = length(pos);
binSize = 20;
numBins = round(frLen/binSize);
cueSig = zeros(numBins,1);
rewSig = zeros(numBins,1);
caEv = zeros(numBins,1);
for i=1:numBins
    epTimes = [frTimes((i-1)*binSize+1), frTimes(i*binSize)];
    
    cueSig(i) = length(find(cueStart+1>epTimes(1) & cueStart+1<=epTimes(2)));
    rewSig(i) = length(find(rewStart>epTimes(1) & rewStart<=epTimes(2)));
    
    caEv(i) =  length(find(pks>(i-1)*binSize+1 & pks<=i*binSize));

end
%lm = fitlm([cueSig rewSig], caEv)

%% pos terms
% (divide belt into X segments and have step pulse at each epoch over
% session)
posBins = 10;
posTerms = zeros(13600,posBins);
pos = pos/max(pos(:));
for i=1:posBins
    posTerm = zeros(13600,1);
    posTerm(find(pos>(i-1)/posBins & pos<i/posBins)) = 1; 
    posTerms(:,i) = posTerm;
end

% find avg length of pos bin
num = length(find(diff(posTerms(:,1))>0));
posBinLen = ceil(sum(posTerms(:,1)/num)); % avg length of pos bin (fr)

for j=1:posBins % for each pos parameter
    for i=1:numBins     % for each temp bin
        epFr = [(i-1)*binSize+1, i*binSize];
        posTerms2(i,j) = sum(posTerms(epFr(1):epFr(2),j))/posBinLen;
    end
end


lm = fitlm([cueSig rewSig posTerms2], caEv)

% %% linear fit
% %ca = C(137,:);
% ca = ca-runmean(ca, 1000); % filter out low freq/basline shifts
% ca = ca-min(ca);
% ca = ca/max(ca);
% %lm = fitlm([cueSig rewSig posTerms], ca)
% lm = fitlm([cs2 rs2 posTerms], ca);
% %lm = fitlm([cs2 posTerms], ca)
% % [b, dev, stats] = glmfit([cs2 rs2 posTerms], ca, 'normal');
% 
% % figure;  hold on; 
% % %plot(cueSig);
% % %plot(cs2,'r'); 
% % plot(posTerms(:,3), 'm');%plot(rs2, 'm');
% % plot(ca,'g');
% 
% % %% (from RegressClayCalcium.m in brunoLab)
% 
% % for i=1:10
% %     eval(['posTerms' num2str(i) '=posTerms(:,' num2str(i) ');']);
% % end
% % 
% % ds = dataset(cs2, rs2, posTerms1, posTerms2, posTerms3, posTerms4, posTerms5, posTerms6, posTerms7, posTerms8, posTerms9, posTerms10, ca');
% % 
% % 
% % mdl = LinearModel.stepwise(ds, 'Verbose', 2)
% 
% 
% %% find significant coefficients
% 
% r2 = lm.Rsquared.Adjusted;  % R2 Rsquared for linear model
% 
% if r2>0.1 % only for cells with relatively good fit
% pval = table2array(lm.Coefficients(:,4)); % pvals for each model coefficient
% sigpv = find(pval<0.01);   % find significant ones
% sigpv = sigpv(sigpv~=1); % exclude intercept (row 1)
% coef = table2array(lm.Coefficients(:,1)); % pvals for each model coefficient
% goodCoef = find(abs(coef)>0.04);
% goodCoef = goodCoef(goodCoef~=1);
% goodParams = intersect(sigpv, goodCoef);
% % find coeff value, pVal, overall model R2
% pvals = pval(goodParams);
% coefs = coef(goodParams);
% else
%     goodParams = []; pvals = []; coefs = [];
%     disp('R2<0.1 so bad fit');
% end
% 
% try
% paramNames = {'(int)', 'cue', 'rew', 'posBin1', 'posBin2', 'posBin3', 'posBin4', 'posBin5', 'posBin6', 'posBin7', 'posBin8', 'posBin9', 'posBin10'};
% posParams = goodParams(find(coef(goodParams)>0));
% disp(['Good params: ' paramNames{posParams}]);
% %try
%     disp(['pvals=' num2str(pval(posParams)) ', coef=' num2str(coef(posParams))]);
% catch
% end