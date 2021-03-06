
close all;
PFNum=[];
% IRPCAll =[]; IRTuningAll=[]; outPCAll=[];
% IRCvsZStruc = {};
%pathCell = {}; 
%[cueShiftStruc] = quickTuningS2P() ;
%load(findLatestFilename('2PcueShiftStruc'));
for i=1:length(SpatPropCueCellsmice.TotalIRcueShiftStruc)
    cueShiftStruc = SpatPropCueCellsmice.TotalIRcueShiftStruc{i};
  
   %% select the  PCLappedSess of the refLap type
    lapTypeArr = cueShiftStruc.lapCueStruc.lapTypeArr;
    lapTypeArr(lapTypeArr==0) = max(lapTypeArr)+1;
    for i=1:length(cueShiftStruc.pksCellCell)
        numLapType(i) = length(find(lapTypeArr==i));
    end
    [val, refLapType] = max(numLapType);
    [val, shiftLapType] = min(numLapType);
    
    plotCueShiftStruc(cueShiftStruc, refLapType,1);
    
    [MidCueCellInd, EdgeCueCellInd, nonCueCellInd] =  AllCueCells(cueShiftStruc);
    
    %%
    PCLappedSessCue = cueShiftStruc.PCLappedSessCell{1,refLapType};
    posRatesRef = cueShiftStruc.PCLappedSessCell{refLapType}.posRates;
    
    [N, edges, bin] = histcounts(cueShiftStruc.lapCueStruc.cuePos, cueShiftStruc.lapCueStruc.numLapTypes);
    cuePosStart = round(mean((cueShiftStruc.lapCueStruc.cuePos((bin(1:end-1)==refLapType))- [50])/20));
    cuePosEnd = round(mean(cueShiftStruc.lapCueStruc.cuePosEnd((bin(1:end-1)==refLapType))/20));
    MidCueRegion = [cuePosStart, cuePosEnd]; EdgeCueRegion = [90, 10];
    
    % get the center of mass for all pcs
    MidCueCOMbin = []; EdgeCueCOMbin = []; nonCueCOMbin = [];
    circbin = 1:100;
    circbin = ((circbin - 1)/99)*2*pi() - pi();
    
    for i = 1:size (MidCueCellInd, 1)
        posRatesIn1 = posRatesRef(MidCueCellInd(i),:);
        c1 = circ_mean(circbin, posRatesIn1, 2);
        MidCueCOMbin(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
    end
    for i = 1:size (EdgeCueCellInd, 1)
        posRatesIn1 = posRatesRef(EdgeCueCellInd(i),:);
        c1 = circ_mean(circbin, posRatesIn1, 2);
        EdgeCueCOMbin(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
    end
    for i = 1:size (nonCueCellInd, 1)
        posRatesIn1 = posRatesRef(nonCueCellInd(i),:);
        c1 = circ_mean(circbin, posRatesIn1, 2);
        nonCueCOMbin(i) = round(((c1 + pi())/(2*pi()))*99 + 1);
    end
    MidCueCOMbin = MidCueCOMbin';
    EdgeCueCOMbin = EdgeCueCOMbin';
    nonCueCOMbin = nonCueCOMbin';
    
% IRCvsZStruc {i,1} = [MidCueCOMbin, MidSpkZ];
% IRCvsZStruc {i,2} = MidCueRegion;
% IRCvsZStruc {i,3} = [EdgeCueCOMbin, EdgeSpkZ];
% IRCvsZStruc {i,4} = EdgeCueRegion;
% IRCvsZStruc {i,5} = [nonCueCOMbin, nonSpkZ];
    
    %%
    MidCuePcposRates = PCLappedSessCue.posRates(MidCueCellInd,:);
    EdgeCuePcposRates = PCLappedSessCue.posRates(EdgeCueCellInd,:);
    nonCuePcposRates = PCLappedSessCue.posRates(nonCueCellInd,:);
    
    MidSpkZ = PCLappedSessCue.Shuff.InfoPerSpkZ(MidCueCellInd,:);
    EdgeSpkZ = PCLappedSessCue.Shuff.InfoPerSpkZ(EdgeCueCellInd,:);
    nonSpkZ = PCLappedSessCue.Shuff.InfoPerSpkZ(nonCueCellInd,:);
    
    MidSpkP = PCLappedSessCue.Shuff.InfoPerSpkP(MidCueCellInd,:);
    EdgeSpkP = PCLappedSessCue.Shuff.InfoPerSpkP(EdgeCueCellInd,:);
    nonSpkP = PCLappedSessCue.Shuff.InfoPerSpkP(nonCueCellInd,:);
    
    % consistency of place fields first and last 10 laps (only normal cue laps)
    rMid = []; pMid = []; rEdge = []; pEdge = [];
    rNon = []; pNon = [];
    
    for i= 1:length(MidCueCellInd)
        ByLapRate = squeeze(PCLappedSessCue.ByLap.posRateByLap(MidCueCellInd(i),:,:))';
        EndRate = nanmean(ByLapRate (end-9:end,:),1);
        BeginRate = nanmean(ByLapRate (1:10,:),1);
        [r, p] = corrcoef(BeginRate', EndRate');
        if isnan(r(1, 2))
            r(1, 2) = 0;
        end
        rMid = [rMid; r(1, 2)];
        pMid = [pMid; p(1, 2)];
    end
    for i= 1:length(EdgeCueCellInd)
        ByLapRate = squeeze(PCLappedSessCue.ByLap.posRateByLap(EdgeCueCellInd(i),:,:))';
        EndRate = nanmean(ByLapRate (end-9:end,:),1);
        BeginRate = nanmean(ByLapRate (1:10,:),1);
        [r, p] = corrcoef(BeginRate', EndRate');
        if isnan(r(1, 2))
            r(1, 2) = 0;
        end
        rEdge = [rEdge; r(1, 2)];
        pEdge = [pEdge; p(1, 2)];
    end
    for i= 1:length(nonCueCellInd)
        ByLapRate = squeeze(PCLappedSessCue.ByLap.posRateByLap(nonCueCellInd(i),:,:))';
        EndRate = nanmean(ByLapRate (end-9:end,:),1);
        BeginRate = nanmean(ByLapRate (1:10,:),1);
        [r, p] = corrcoef(BeginRate', EndRate');
        if isnan(r(1, 2))
            r(1, 2) = 0;
        end
        rNon = [rNon; r(1, 2)];
        pNon = [pNon; p(1, 2)];
    end
    
    %%
    % calculate inhibition (peaks are detected by sorting posRates so currently this is done w/o cellInd)
    [posBinNumCells, pcRatesBlanked, pcOmitRatesBlanked] = cuePosInhib2P(cueShiftStruc);
    outPCRateNon= mean([nanmean(mean(pcRatesBlanked(:,11:44),2),1) nanmean(mean(pcRatesBlanked(:,56:89),2),1)]);
    outPCRateEdge= mean([nanmean(mean(pcRatesBlanked(:,1:10),2),1) nanmean(mean(pcRatesBlanked(:,90:100),2),1)]);
    outPCRateMid = nanmean(mean(pcRatesBlanked(:,45:55),2),1);
    outPCRateMidOmit = nanmean(mean(pcOmitRatesBlanked(:,45:55),2),1);
    
    %% single vs multiple place fields
    field =[]; MC=[]; EC=[]; NC=[];
    for i=1:length(MidCueCellInd)
        MC=[MC; length(PCLappedSessCue.Shuff.PFInAllPos{MidCueCellInd(i)})];
    end
    for i=1:length(EdgeCueCellInd)
        EC=[EC; length(PCLappedSessCue.Shuff.PFInAllPos{EdgeCueCellInd(i)})];
    end
    
    for i=1:length(nonCueCellInd)
        NC=[NC; length(PCLappedSessCue.Shuff.PFInAllPos{nonCueCellInd(i)})];
    end
    FracMCSingField= length(find(MC==1))/length(MidCueCellInd);
    FracECSingField= length(find(EC==1))/length(EdgeCueCellInd);
    FracNCSingField= length(find(NC==1))/length(nonCueCellInd);
    field= [FracMCSingField FracECSingField FracNCSingField];
    PFNum=[PFNum; field];
    
    %%
    % collect all variables in a table/struc
    midCue=MidCueRegion;
    edgeCue= EdgeCueRegion;
    numSeg = length(PCLappedSessCue.InfoPerSpk);
    NumNon = length(nonCueCOMbin); NumMid = length(MidCueCOMbin); NumEdge = length(EdgeCueCOMbin);
    RateNon = mean(mean(nonCuePcposRates,2)); RateMid = mean(mean(MidCuePcposRates,2)); RateEdge = mean(mean(EdgeCuePcposRates,2));
    stdNon = std(mean(nonCuePcposRates,2)); stdMid = std(mean(MidCuePcposRates,2)); stdEdge = std(mean(EdgeCuePcposRates,2));
    
    SpkZabfisNon = nanmean(nonSpkZ); SpkZMid = nanmean(MidSpkZ); SpkZEdge = mean(EdgeSpkZ);
    stdZNon = nanstd(nonSpkZ); stdZMid = nanstd(MidSpkZ); stdZEdge = nanstd(EdgeSpkZ);
    CorrRNon = nanmean(rNon); CorrRMid = nanmean(rMid); CorrREdge = nanmean(rEdge);
    stdRNon = nanstd(rNon); stdRMid = nanstd(rMid); stdREdge = nanstd(rEdge);
    
    %pathCell = [pathCell pwd];
% PCMice =[]; TuningMice =[]; outPCMice=[];
% PCMice = [midCue, edgeCue, numSeg, NumNon, NumMid, NumEdge, RateNon, stdNon, RateMid, stdMid, RateEdge, stdEdge ];
% outPCMice = [outPCRateNon , outPCRateEdge, outPCRateMid, outPCRateMidOmit ]
% IRPCAll = [IRPCAll; PCMice];
% outPCAll=[outPCAll; outPCMice];
% TuningMice = [SpkZNon, stdZNon, SpkZMid, stdZMid, SpkZEdge, stdZEdge, CorrRNon, stdRNon, CorrRMid, stdRMid, CorrREdge, stdREdge];
% IRTuningAll= [IRTuningAll;TuningMice];

    % sz=60;
    % figure; scatter(MidCueCOMbin, MidSpkZ, sz, 'filled', 'r');
    % hold on; scatter(EdgeCueCOMbin, EdgeSpkZ, sz, 'filled', 'g');
    % hold on; scatter(nonCueCOMbin, nonSpkZ, sz, 'filled', 'k');
end

%SpatPropCueCellsmice={};
%SpatPropCueCellsmice.PCtitles = {'midCuePosStart', 'midCuePosEnd', 'edgeCuePosStart', 'edgeCuePosEnd', 'numSeg', 'NumNon', 'NumMid', 'NumEdge', 'RateNon', 'stdNon', 'RateMid', 'stdMid', 'RateEdge', 'stdEdge'};
%SpatPropCueCellsmice.PCAll = PCAll;
%SpatPropCueCellsmice.CvsZStruc = CvsZStruc;
%SpatPropCueCellsmice.IRPCAll = IRPCAll;
%SpatPropCueCellsmice. Tuningtitles = {'SpkZNon', 'stdZNon', 'SpkZMid', 'stdZMid', 'SpkZEdge', 'stdZEdge', 'CorrRNon', 'stdRNon', 'CorrRMid', 'stdRMid', 'CorrREdge', 'stdREdge'};
%SpatPropCueCellsmice.TuningAll = IRTuningAll;
%SpatPropCueCellsmice.IRTuningAll = IRTuningAll;
%SpatPropCueCellsmice.IRCvsZStruc = IRCvsZStruc;
% SpatPropCueCellsmice.outPCtitles = {'outPCRateNon', 'outPCRateEdge', 'outPCRateMid', 'outPCRateMidOmit'};
% SpatPropCueCellsmice.outPCIRAll = outPCIRAll;
% SpatPropCueCellsmice.outPCAll = outPCAll;
% SpatPropCueCellsmice.pathCell  = pathCell;
%SpatPropCueCellsmice.pathIRCell  = pathIRCell;

% save('SpatPropCueCellsmice.mat', 'SpatPropCueCellsmice');