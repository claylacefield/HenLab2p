function [linFitStruc, summStruc] = linearFitCaCuePrecessSess(toPlot)

% Clay 2020
% Function to run linear model on calcium signals from all neurons in a
% session, regressed against cue, rew, place.
% 
% INPUT: reads everything from session folder
% OUTPUT: 
% linFitStruc of parameters for each cell (R2<0.1 blank)
% summStruc of summary parameters for okCells

% ToDo:
% - NOTE that fit would probably be better if I didn't use calcium
% amplitude (since there is lots of unexplained variance in this)
% - NOTE: currently, position is modeled in a series of parameters with a
% step pulse at each 1/10 lap. Could do this better in R lang with circular
% predictors.
% - 


segDictName = findLatestFilename('_seg2P_');
if isempty(segDictName)
segDictName = findLatestFilename('_segDict_', 'goodSeg');
end
load(segDictName);
if contains(segDictName, 'seg2P')
    C = seg2P.C2p;
end

treadBehName = findLatestFilename('treadBehStruc');
load(treadBehName);


tic;
for i=1:size(C,1)
    
%     if mod(i,10)==0
%         disp(['Processing unit #' num2str(i) ' of ' num2str(size(C,1))]);
%     end
    
    % run linear model
    [goodParams, coefs, pvals, r2, paramNames] = fitCaCuePrecessPos(C(i,:), treadBehStruc);
    
    linFitStruc(i).r2 = r2;
    linFitStruc(i).goodParams = goodParams;
    linFitStruc(i).coefs = coefs;
    linFitStruc(i).pvals = pvals;
    linFitStruc(i).paramNames = paramNames;
    
end
toc;


%% extract some info and plot

% select cells with high coef (positive only)
coefs = {linFitStruc.coefs};
okCells = find(~cellfun('isempty',coefs)); % only cells with above constraints, r2>0.1 and coefs with signif pval (p<0.01, coef>+/-0.04)

r2 = [linFitStruc.r2];
quants = quantile(r2,4);
%topQuant = quants(end); % find limit for top quantile of r2's (all, not just good ones)
topQuant = 0.1; %5;
okR2 = find(r2>=topQuant); % only look at top quantile of R2's
okCells = intersect(okR2, okCells);
r2 = r2(okCells);   % r2 for all cells with r2>0.1 and coefs with signif pval (p<0.01, coef>+/-0.04)
coefs = coefs(okCells);

params = {linFitStruc.goodParams};
params = params(okCells);

% plot cue coef vs spatial coef (top pos one, or top significant ones: highest sig coef)
fr1coef = zeros(length(okCells),1);
fr2coef = zeros(length(okCells),1);
fr1param = zeros(length(okCells),1);
fr2param = zeros(length(okCells),1);

for k=1:length(okCells)
    % tighter constraint on cells, only pos coefs, and merge spatial params
    
    cellCoefs = coefs{k};
    cellParams = params{k};
    % and all pvals are significant from earlier filter
    
    
    placeInds = find(cellParams>1 & cellParams<=11);
    
    if ~isempty(placeInds)
        placeCoefs = cellCoefs(placeInds);
        [maxCoef,ind] = max(placeCoefs);
        if maxCoef>0
            fr1coef(k) = maxCoef;
        else
            [maxCoef,ind] = min(placeCoefs);
            fr1coef(k) = maxCoef;
        end
        fr1param(k) = cellParams(placeInds(ind))-2; % find spatial bin of best place param.
        
    end
    
    placeInds = find(cellParams>11);
    
    if ~isempty(placeInds)
        placeCoefs = cellCoefs(placeInds);
        [maxCoef,ind] = max(placeCoefs);
        if maxCoef>0
            fr2coef(k) = maxCoef;
        else
            [maxCoef,ind] = min(placeCoefs);
            fr2coef(k) = maxCoef;
        end
        fr2param(k) = cellParams(placeInds(ind))-2; % find spatial bin of best place param.
        
    end
    
end

% output summary params
summStruc.path = pwd;
summStruc.segDictName = segDictName;
summStruc.okCells = okCells; % cell indices of cells with ok R2 and some significant params (>0.04)
summStruc.cueCoef = fr1coef;
summStruc.placeCoef = fr1coef;
summStruc.placeParam = fr1param;

if toPlot
    figure; plot(fr1coef, fr1coef,'.');
    xlabel('cueCoef'); ylabel('placeCoef');
    
    load(findLatestFilename('_cueShiftStruc'));
    posRatesCat = [cueShiftStruc.PCLappedSessCell{1}.posRates cueShiftStruc.PCLappedSessCell{2}.posRates cueShiftStruc.PCLappedSessCell{3}.posRates];
    posRatesCat = posRatesCat(okCells,:);
    figure;
    sortInd = plotPosRates(posRatesCat(:,1:100),0,1);
    figure; imagesc(posRatesCat(sortInd,:));
    
    
end