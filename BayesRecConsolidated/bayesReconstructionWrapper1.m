
bayesRecAll = [];
bayesRecAll.treadPosCircOut = []; bayesRecAll.errorInCm = [];
bayesRecAll.lapVecOut = []; bayesRecAll.TOut = [];
bayesRecAll.predPos = []; bayesRecAll.BayesPost = [];
bayesRecAll.whichFold = []; bayesRecAll.meanBinFR = [];
bayesRecAll.isRefLap = []; bayesRecAll.isOmitLap = []; bayesRecAll.isShiftLap = [];
MedianErr={};

for I =  1:length(CombStrucAll) 
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
    
 ind=[];
for j=1:length(pksCell)
    ind(j)= length(pksCell{j})>=5;
end
 useCells = find(ind > 0);
    useCells= unique([MidCueCellInd; EdgeCueCellInd; nonCueCellInd]);
    %useCells=[];
    %useCells is usually a list (or a logical vector of place cells):
    %useCells = isPC > 0;
    % if leaft it empty, it'll use all of them by default
    
    % Binning and cross-validation parameters
    kFolds = 10;%the number of cross-validation 'folds' (applies to lap numbers)
    binEveryNFrames = 30; %corresponds to 2 sec if =15 then 1 sec
    
    % Doing the decoding
    [bayesRec] = bayesReconstructionWithinSession(spikes, T, treadPos, lapVec, binEveryNFrames, kFolds, useCells);
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
    bayesRecAll.isRefLap = [bayesRecAll.isRefLap; ismember(bayesRec.lapVecOut, ref)];
    bayesRecAll.isOmitLap = [bayesRecAll.isOmitLap; ismember(bayesRec.lapVecOut, omit)];
    bayesRecAll.isShiftLap = [bayesRecAll.isShiftLap; ismember(bayesRec.lapVecOut, shift)];
    MedianErr{I}=abs(bayesRec.errorInCm);

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
%  figure; plot(bayesRec.TOut, bayesRec.treadPosCircOut)
%  hold on; plot(bayesRec.TOut, bayesRec.treadPosCircOut, 'c')
%  hold on; plot(bayesRec.TOut(ismember(bayesRec.lapVecOut, ref)==1), bayesRec.predPos(ismember(bayesRec.lapVecOut, ref)==1), 'k');
%   hold on; plot(bayesRec.TOut(ismember(bayesRec.lapVecOut, shift)==1), bayesRec.predPos(ismember(bayesRec.lapVecOut, shift)==1), 'r');
%   hold on; plot(bayesRec.TOut(ismember(bayesRec.lapVecOut, omit)==1), bayesRec.predPos(ismember(bayesRec.lapVecOut, omit)==1), 'b');

end
figure;
for i=1:length(MedianErr)
    hold on;
     cdfplot(MedianErr{i});
end

set (gcf, 'Renderer', 'painters');
%%
disp(['Your reference median error is....']);
% pause(0.5); %dramatic pause
disp([num2str(nanmedian(abs(bayesRecAll.errorInCm(find(bayesRecAll.isRefLap==1)))), 3), ' cm']);
disp(['Your omit median error is....']);
% % pause(0.5); %dramatic pause
disp([num2str(nanmedian(abs(bayesRecAll.errorInCm(find(bayesRecAll.isOmitLap==1)))), 3), ' cm']);
disp(['Your shift median error is....']);
% pause(0.5); %dramatic pause
disp([num2str(nanmedian(abs(bayesRecAll.errorInCm(find(bayesRecAll.isShiftLap==1)))), 3), ' cm']);

%% Example figure
%median is always lower than mean so using this one for now. 
outRef= makeSlidingMedianForCircPos(round(bayesRecAll.treadPosCircOut(find(bayesRecAll.isRefLap==1))'*100), abs(bayesRecAll.errorInCm(find(bayesRecAll.isRefLap==1)))', 10, 1000);
outShift= makeSlidingMedianForCircPos(round(bayesRecAll.treadPosCircOut(find(bayesRecAll.isShiftLap==1))'*100), abs(bayesRecAll.errorInCm(find(bayesRecAll.isShiftLap==1)))', 10, 1000);
outOmit= makeSlidingMedianForCircPos(round(bayesRecAll.treadPosCircOut(find(bayesRecAll.isOmitLap==1))'*100), abs(bayesRecAll.errorInCm(find(bayesRecAll.isOmitLap==1)))', 10, 1000);

figure; shadedErrorBar(linspace(0, 2, 100), outRef.vals, outRef.errBars, 'k');
hold on; shadedErrorBar(linspace(0, 2, 100), outShift.vals, outShift.errBars, 'r');
%hold on; shadedErrorBar(linspace(0, 2, 100), outOmit.vals, outOmit.errBars, 'b');
xlabel('Position (m)');
ylabel('Median Error (cm)');
set (gcf, 'Renderer', 'painters');

diffRO = outShift.vals - outRef.vals ;
errRO= outShift.errBars(1,:) - outShift.errBars(2,:);
% ST: I don't know how to plot this better? 
X=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]; 
Y1= [mean(diffRO (1:5)) mean(diffRO (6:10)) mean(diffRO (11:15)) mean(diffRO (16:20)) ...
    mean(diffRO (21:25)) mean(diffRO (26:30)) mean(diffRO (31:35)) mean(diffRO (36:40)) ...
    mean(diffRO (41:45)) mean(diffRO (46:50)) mean(diffRO (51:55)) mean(diffRO (56:60)) ...
    mean(diffRO (61:65)) mean(diffRO (66:70)) mean(diffRO (71:75)) mean(diffRO(76:80)) ...
    mean(diffRO (81:85)) mean(diffRO (86:90)) mean(diffRO (91:95)) mean(diffRO(96:100))]; 
err1= [mean(abs(errRO (1:5))) mean(abs(errRO (6:10))) mean(abs(errRO (11:15))) mean(abs(errRO (16:20))) ...
    mean(abs(errRO (21:25))) mean(abs(errRO (26:30))) mean(abs(errRO (31:35))) mean(abs(errRO (36:40))) ...
    mean(abs(errRO (41:45))) mean(abs(errRO (46:50))) mean(abs(errRO (51:55))) mean(abs(errRO (56:60))) ...
    mean(abs(errRO (61:65))) mean(abs(errRO (66:70))) mean(abs(errRO (71:75))) mean(abs(errRO(76:80))) ...
    mean(abs(errRO (81:85))) mean(abs(errRO (86:90))) mean(abs(errRO (91:95))) mean(abs(errRO(96:100)))]; 


 figure; bar(X,Y1, 'r'); hold on; er1 = errorbar(X,Y1, err1); 
 er1.Color=[0 0 0]; title('Diff MedianErr');
 set (gcf, 'Renderer', 'painters');

 
 
%% 
RefErr=abs(bayesRecAll.errorInCm(find(bayesRecAll.isRefLap==1)));
ShiftErr=abs(bayesRecAll.errorInCm(find(bayesRecAll.isShiftLap==1)));
OmitErr=abs(bayesRecAll.errorInCm(find(bayesRecAll.isOmitLap==1)));

 PAll = [RefErr'; ShiftErr'; OmitErr'];
PGroup = [zeros(length(RefErr), 1) + 1; zeros(length(ShiftErr), 1) + 2; zeros(length(OmitErr), 1) + 3];
[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);