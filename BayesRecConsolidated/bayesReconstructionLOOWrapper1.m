
bayesRecAll = [];
bayesRecAll.treadPosCircOut = []; bayesRecAll.errorInCm = [];
bayesRecAll.lapVecOut = []; bayesRecAll.TOut = [];
bayesRecAll.predPos = []; bayesRecAll.BayesPost = [];
bayesRecAll.whichFold = []; bayesRecAll.meanBinFR = [];
bayesRecAll.isRefLap = []; bayesRecAll.isOmitLap = []; bayesRecAll.isShiftLap = [];
MedianErr={}; MedianErrRef ={};
MedianErrOmit = {};  MedianErrShift={};
perfromLOOAnalysis = 1;
LOOErrors = {};
 for I = 1:length(CombStrucAll) % [6 7 10 30 32 38 39 40]
  %  for I = [6]
    %goes through all of the sessions that has C, treadBehStruc, and cueshiftstruc in a field I called TotalCell
    % Preparing the data
    totalFrames = size(CombStrucAll{I}.TotalCell{3}.C2p, 2);
    resampY = CombStrucAll{I}.TotalCell{2}.resampY;
    downSamp = round(length(resampY)/totalFrames);  % find downsample rate
    treadPos = resampY(1:downSamp:end); % downsample position vector
    treadPos = treadPos/max(treadPos);  % normalize position vector
    T = CombStrucAll{I}.TotalCell{2}.adjFrTimes(1:downSamp:end);
    %just to make sure I'm using 4sd threshold for event detection
    pksCell={};
    for seg=1:size(CombStrucAll{I}.TotalCell{3}.C2p,1)
        pksCell{seg}=clayCaTransients(CombStrucAll{I}.TotalCell{3}.C2p(seg,:),15);
    end
    
    spikes = zeros(length(treadPos), length(pksCell));
    for i = 1:length(pksCell)
        spikes(pksCell{i}, i) = 1;
    end
    
    cueShiftStruc = CombStrucAll{I}.TotalCell{4};
    lapVec = zeros(1, totalFrames);
    lapInts = cueShiftStruc.lapCueStruc.lapEpochs;
    for i = 1:size(lapInts)
        lapVec(lapInts(i, 1):lapInts(i, 2)) = i;
    end
    lapVec = lapVec(1:downSamp:end);
    
    [MidCueCellInd, EdgeCueCellInd, nonCueCellInd, refLapType, shiftLapType] =  AllCueCells(cueShiftStruc);
    PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
    Allpc = find(PCLappedSessCue.Shuff.isPC==1);
    Nonpc = find(PCLappedSessCue.Shuff.isPC==0);
    ref = find(cueShiftStruc.lapCueStruc.lapTypeArr == refLapType);
    omit = find(cueShiftStruc.lapCueStruc.lapTypeArr == 0);
    shift = find(cueShiftStruc.lapCueStruc.lapTypeArr == shiftLapType);
    nonpksCell={};
    for n = 1:length(Nonpc)
        nonpksCell{n}= pksCell{Nonpc(n)};
    end
    
    ind=[];
    for j=1:length(nonpksCell)
        ind(j)= length(nonpksCell{j})>=5;
    end
    nonPCCells = (find(ind > 0))';

    useCells = [Allpc];
    %useCells is usually a list (or a logical vector of place cells):
    %useCells = isPC > 0;
    % if leaft it empty, it'll use all of them by default
    
    % Binning and cross-validation parameters
    kFolds = 5;%the number of cross-validation 'folds' (applies to lap numbers)
    binEveryNFrames = 15; %corresponds to 2 sec if =15 then 1 sec
    
    % Doing the decoding
    [bayesRec, transMatOut] = bayesReconstructionWithinSession(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells);
    % [bayesRec] = bayesReconstructionWithinSessionByBin(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells);
    kBins = bayesRec.meanBinFR > 0;
    bayesRec.treadPosCircOut = bayesRec.treadPosCircOut(kBins);
    bayesRec.TOut = bayesRec.TOut(kBins);
    bayesRec.lapVecOut = bayesRec.lapVecOut(kBins);
    bayesRec.predPos = bayesRec.predPos(kBins);
    bayesRec.whichFold = bayesRec.whichFold(kBins);
    bayesRec.meanBinFR = bayesRec.meanBinFR(kBins);
    bayesRec.BayesPost = bayesRec.BayesPost(kBins,:);
    bayesRec.errorInCm = bayesRec.errorInCm(kBins);
    transMatOut = transMatOut(kBins, :);
    
    %% LOO Analysis
    if perfromLOOAnalysis == 1
        disp('Performing LOO Analysis.');
        LOOIn = [];
        LOOIn.MeanErrorDiffAll = [];
        LOOIn.MedianErrorDiffActive = []; LOOIn.MedianErrorDiffRef = []; LOOIn.MedianErrorDiffOmit = []; LOOIn.MedianErrorDiffShift = [];
        LOOIn.MeanErrorDiffActive = []; LOOIn.MeanErrorDiffRef = []; LOOIn.MeanErrorDiffOmit = []; LOOIn.MeanErrorDiffShift = [];
        LOOIn.numActiveBins = []; LOOIn.numRefBins = []; LOOIn.numOmitBins = []; LOOIn.numShiftBins = [];
        if ~isempty(useCells)
           useCells = 1:size(transMatOut, 2);
        end
        nCells = 1:length(useCells);
        for n = 1:length(useCells)
             % excludes one cell at a time and recalculate error
            [bayesRecLoo] = bayesReconstructionWithinSession(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells(nCells ~= n));
            bayesRecLoo.treadPosCircOut = bayesRecLoo.treadPosCircOut(kBins);
            bayesRecLoo.TOut = bayesRecLoo.TOut(kBins);
            bayesRecLoo.lapVecOut = bayesRecLoo.lapVecOut(kBins);
            bayesRecLoo.predPos = bayesRecLoo.predPos(kBins);
            bayesRecLoo.whichFold = bayesRecLoo.whichFold(kBins);
            bayesRecLoo.meanBinFR = bayesRecLoo.meanBinFR(kBins);
            bayesRecLoo.BayesPost = bayesRecLoo.BayesPost(kBins,:);
            bayesRecLoo.errorInCm = bayesRecLoo.errorInCm(kBins);
            
            activeBins = transMatOut(:, useCells(n)) > 0;
            refBins =  transMatOut(:, useCells(n)) > 0 & ismember(round(bayesRec.lapVecOut), ref);
            omitBins = transMatOut(:, useCells(n)) > 0 & ismember(round(bayesRec.lapVecOut), omit);
            shiftBins = transMatOut(:, useCells(n)) > 0 & ismember(round(bayesRec.lapVecOut), shift);
            bayesRecLoo.errorInCm = abs(bayesRecLoo.errorInCm);
            bayesRec.errorInCm = abs(bayesRec.errorInCm);
            LOOIn.MeanErrorDiffAll = [LOOIn.MeanErrorDiffAll; nanmean(bayesRecLoo.errorInCm - bayesRec.errorInCm)];
            LOOIn.MedianErrorDiffActive = [LOOIn.MedianErrorDiffActive; nanmedian(bayesRecLoo.errorInCm(activeBins) - bayesRec.errorInCm(activeBins))];
            LOOIn.MeanErrorDiffActive = [LOOIn.MeanErrorDiffActive; nanmean(bayesRecLoo.errorInCm(activeBins) - bayesRec.errorInCm(activeBins))];
            LOOIn.numActiveBins = [LOOIn.numActiveBins; sum(activeBins)];
            LOOIn.MedianErrorDiffRef = [LOOIn.MedianErrorDiffRef; nanmedian(bayesRecLoo.errorInCm(refBins) - bayesRec.errorInCm(refBins))];
            LOOIn.MeanErrorDiffRef = [LOOIn.MeanErrorDiffRef; nanmean(bayesRecLoo.errorInCm(refBins) - bayesRec.errorInCm(refBins))];
            LOOIn.numRefBins = [LOOIn.numRefBins; sum(refBins)];
            LOOIn.MedianErrorDiffOmit = [LOOIn.MedianErrorDiffOmit; nanmedian(bayesRecLoo.errorInCm(omitBins) - bayesRec.errorInCm(omitBins))];
            LOOIn.MeanErrorDiffOmit = [LOOIn.MeanErrorDiffOmit; nanmean(bayesRecLoo.errorInCm(omitBins) - bayesRec.errorInCm(omitBins))];
            LOOIn.numOmitBins = [LOOIn.numOmitBins; sum(omitBins)];
            LOOIn.MedianErrorDiffShift = [LOOIn.MedianErrorDiffShift; nanmedian(bayesRecLoo.errorInCm(shiftBins) - bayesRec.errorInCm(shiftBins))];
            LOOIn.MeanErrorDiffShift = [LOOIn.MeanErrorDiffShift; nanmean(bayesRecLoo.errorInCm(shiftBins) - bayesRec.errorInCm(shiftBins))];
            LOOIn.numShiftBins = [LOOIn.numShiftBins; sum(shiftBins)];
        end
        LOOErrors{I} = LOOIn;    
    end
    
    save ('LOOErrorsPConly.mat', 'LOOErrors');
    %%
    
    
    bayesRecAll.treadPosCircOut = [bayesRecAll.treadPosCircOut, bayesRec.treadPosCircOut];
    bayesRecAll.TOut = [bayesRecAll.TOut, bayesRec.TOut];
    bayesRecAll.lapVecOut = [bayesRecAll.lapVecOut; bayesRec.lapVecOut];
    bayesRecAll.predPos = [bayesRecAll.predPos, bayesRec.predPos];
    bayesRecAll.whichFold = [bayesRecAll.whichFold, bayesRec.whichFold];
    bayesRecAll.meanBinFR = [bayesRecAll.meanBinFR; bayesRec.meanBinFR];
    bayesRecAll.BayesPost = [bayesRecAll.BayesPost; bayesRec.BayesPost];
    bayesRecAll.errorInCm = [bayesRecAll.errorInCm, bayesRec.errorInCm];
    
    %     if max(bayesRec.lapVecOut) ~= length(cueShiftStruc.lapCueStruc.lapTypeArr)
    %         error('Something smells.... fishy....');
    %     end
    % seperate into lap types

    bayesRecAll.isRefLap = [bayesRecAll.isRefLap; ismember(round(bayesRec.lapVecOut), ref)];
    bayesRecAll.isOmitLap = [bayesRecAll.isOmitLap; ismember(round(bayesRec.lapVecOut), omit)];
    bayesRecAll.isShiftLap = [bayesRecAll.isShiftLap; ismember(round(bayesRec.lapVecOut), shift)];

    
    %Within bayesRec (n = number of valid bins):
    %treadPosCircOut: actual position of the animal
    %TOut: time of the bin (center)
    %lapVecOut: id (number) of which lap of the bin
    %whichFold: cross-validation fold value (not usually useful)
    %predPos = predicted position of the animal
    %BayesPost: posterior probability of position for each bin (nBins X 100 spatial-bins)
    %errorInCm: the SIGNED reconstruction error for each bin (usually you want
    %to take the abs(errorInCm)
    
    %Remember:
    %%%%%%%%%%%%%%%   abs(errorInCM)    %%%%%%%%%%%%
    %% Simple reconstruction figure:
    %figure; plot(bayesRec.TOut, bayesRec.treadPosCircOut)
    %hold on; plot(bayesRec.TOut, bayesRec.treadPosCircOut, '.b')
    %hold on; plot(bayesRec.TOut, bayesRec.predPos, '.r');
    %   hold on; plot(bayesRec.TOut(ismember(bayesRec.lapVecOut, shift)==1), bayesRec.predPos(ismember(bayesRec.lapVecOut, shift)==1), 'r');
    %   hold on; plot(bayesRec.TOut(ismember(bayesRec.lapVecOut, omit)==1), bayesRec.predPos(ismember(bayesRec.lapVecOut, omit)==1), 'b');
    
    
    % %%heatmap
    % figure;
    % kBins = bayesRec.meanBinFR > 0;
    % Pr = bayesRec.BayesPost(kBins, :)';
    % Pr(Pr > prctile(Pr, 99)) = prctile(Pr(:), 99);
    % imagesc(1:size(Pr, 2), linspace(0, 2, 100), Pr);
    % predPos = bayesRec.predPos(kBins)*2;
    % realPos = bayesRec.treadPosCircOut(kBins)*2;
    % hold on; plot(predPos, 'm', 'LineWidth', 1);
    % hold on; plot(realPos, 'g', 'LineWidth', 1);
    % ylabel('Position (m)');
    % xlabel('Time (bins)');
    % axis square;
    % % xlim([25, 200])
    % % xlim([580       725.87]);
    % % xlim([308.63        454.5]);
    % h = colorbar;
    % h.Label.String = 'Posterior Prob.';
    % h.Label.Rotation = -90;
    % colormap('hot')
end
save ('bayesRecAllCells.mat', 'bayesRecAll');