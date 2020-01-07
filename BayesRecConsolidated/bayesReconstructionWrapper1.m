
bayesRecAll = [];
bayesRecAll.treadPosCircOut = []; bayesRecAll.errorInCm = [];
bayesRecAll.lapVecOut = []; bayesRecAll.TOut = [];
bayesRecAll.predPos = []; bayesRecAll.BayesPost = [];
bayesRecAll.whichFold = []; bayesRecAll.meanBinFR = [];
bayesRecAll.isRefLap = []; bayesRecAll.isOmitLap = []; bayesRecAll.isShiftLap = [];
MedianErr={}; MedianErrRef ={}; 
 MedianErrOmit = {};  MedianErrShift={};
   

 for I = 1:length(CombStrucAll) % [6 7 10 30 32 38 39 40] 
%for I = [6]
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

    nonpksCell={}; 
for n = 1:length(Nonpc)
    nonpksCell{n}= pksCell{Nonpc(n)};
end

 ind=[];
for j=1:length(nonpksCell)
    ind(j)= length(nonpksCell{j})>=5;
end
 nonPCCells = (find(ind > 0))';
    %useCells= unique([nonCueCellInd]);
    useCells=[nonPCCells ; Allpc];
    %useCells is usually a list (or a logical vector of place cells):
    %useCells = isPC > 0;
    % if leaft it empty, it'll use all of them by default
    
    % Binning and cross-validation parameters
    kFolds = 5;%the number of cross-validation 'folds' (applies to lap numbers)
    binEveryNFrames = 15; %corresponds to 2 sec if =15 then 1 sec
    
    % Doing the decoding
    [bayesRec] = bayesReconstructionWithinSession(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells);
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
    ref = find(cueShiftStruc.lapCueStruc.lapTypeArr == refLapType);
    omit = find(cueShiftStruc.lapCueStruc.lapTypeArr == 0);
    shift = find(cueShiftStruc.lapCueStruc.lapTypeArr == shiftLapType);
    bayesRecAll.isRefLap = [bayesRecAll.isRefLap; ismember(round(bayesRec.lapVecOut), ref)];
    bayesRecAll.isOmitLap = [bayesRecAll.isOmitLap; ismember(round(bayesRec.lapVecOut), omit)];
    bayesRecAll.isShiftLap = [bayesRecAll.isShiftLap; ismember(round(bayesRec.lapVecOut), shift)];
    MedianErr{I}=abs(bayesRec.errorInCm);
    MedianErrRef {I} = abs(bayesRec.errorInCm(ismember(bayesRec.lapVecOut, ref)==1));
    MedianErrOmit {I} = abs(bayesRec.errorInCm(ismember(bayesRec.lapVecOut, omit)==1));
    MedianErrShift {I} = abs(bayesRec.errorInCm(ismember(bayesRec.lapVecOut, shift)==1));

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
disp(['Your reference median error is....']);
% pause(0.5); %dramatic pause
disp([num2str(nanmedian(abs(bayesRecAll.errorInCm(find(bayesRecAll.isRefLap==1)))), 3), 'cm']);
disp(['Your omit median error is....']);
% pause(0.5); %dramatic pause
 disp([num2str(nanmedian(abs(bayesRecAll.errorInCm(find(bayesRecAll.isOmitLap==1)))), 3), ' cm']);
disp(['Your shift median error is....']);
% pause(0.5); %dramatic pause
disp([num2str(nanmedian(abs(bayesRecAll.errorInCm(find(bayesRecAll.isShiftLap==1)))), 3), ' cm']);
%% Example figure
%median is always lower than mean so using this one for now. 
% outRef= makeSlidingMedianForCircPos(round(bayesRecAll.treadPosCircOut(find(bayesRecAll.isRefLap==1))'*100), abs(bayesRecAll.errorInCm(find(bayesRecAll.isRefLap==1)))', 10, 1000);
% outShift= makeSlidingMedianForCircPos(round(bayesRecAll.treadPosCircOut(find(bayesRecAll.isShiftLap==1))'*100), abs(bayesRecAll.errorInCm(find(bayesRecAll.isShiftLap==1)))', 10, 1000);
% outOmit= makeSlidingMedianForCircPos(round(bayesRecAll.treadPosCircOut(find(bayesRecAll.isOmitLap==1))'*100), abs(bayesRecAll.errorInCm(find(bayesRecAll.isOmitLap==1)))', 10, 1000);

% figure; shadedErrorBar(linspace(0, 2, 100), outRef.vals, outRef.errBars, 'k');
% hold on; shadedErrorBar(linspace(0, 2, 100), outShift.vals, outShift.errBars, 'r');
% hold on; shadedErrorBar(linspace(0, 2, 100), outOmit.vals, outOmit.errBars, 'b');
% xlabel('Position (m)');
% ylabel('Median Error (cm)');
% set (gcf, 'Renderer', 'painters');


% figure;
% for i=1:length(MedianErr)
%     hold on;
%      cdfplot(MedianErr{i});
% end
% 
% set (gcf, 'Renderer', 'painters');
%%
% numberOfDivisions = 15;
% percs = prctile(bayesRecAll.meanBinFR, linspace(0, 100, numberOfDivisions + 1)); 
% percs(end) = percs(end) + 1;
% [h, whichBin] = histc(bayesRecAll.meanBinFR, percs);
% A = [];
% for i = 1:20
% A = [A; i, nanmean(bayesRecAll.meanBinFR(whichBin == i)), nanmedian(abs(bayesRecAll.errorInCm(whichBin == i))), makeStdErrorOfMean(abs(bayesRecAll.errorInCm(whichBin == i)))];
% end
% figure;
% errorbar(A(:, 2), A(:, 3), A(:, 4))

%%
% RefErr=abs(bayesRecAll.errorInCm(find(bayesRecAll.isRefLap==1)));
% ShiftErr=abs(bayesRecAll.errorInCm(find(bayesRecAll.isShiftLap==1)));
% OmitErr=abs(bayesRecAll.errorInCm(find(bayesRecAll.isOmitLap==1)));
% 
%  PAll = [RefErr'; ShiftErr'; OmitErr'];
% PGroup = [zeros(length(RefErr), 1) + 1; zeros(length(ShiftErr), 1) + 2; zeros(length(OmitErr), 1) + 3];
% [p,tbl,stats] = kruskalwallis(PAll, PGroup);
% c = multcompare(stats);