CueStabilityOENon={};CueStabilityFLNon={}; CueCorrToLapNumNon={};
OmitStabilityOENon={};OmitStabilityFLNon={}; OmitCorrToLapNumNon={};
CuemeanStabilityOENon=[];CuemeanStabilityFLNon={}; CuemeanCorrToLapNumNon={};
OmitmeanStabilityOENon=[];OmitmeanStabilityFLNon={}; OmitmeanCorrToLapNumNon={};
CueStabilityOEEdge={};CueStabilityFLEdge={}; CueCorrToLapNumEdge={};
OmitStabilityOEEdge={};OmitStabilityFLEdge={}; OmitCorrToLapNumEdge={};
CuemeanStabilityOEEdge=[];CuemeanStabilityFLEdge={}; CuemeanCorrToLapNumEdge={};
OmitmeanStabilityOEEdge=[];OmitmeanStabilityFLEdge={}; OmitmeanCorrToLapNumEdge={};
CueStabilityOEMid={};CueStabilityFLMid={}; CueCorrToLapNumMid={};
OmitStabilityOEMid={};OmitStabilityFLMid={}; OmitCorrToLapNumMid={};
CuemeanStabilityOEMid=[];CuemeanStabilityFLMid={}; CuemeanCorrToLapNumMid={};
OmitmeanStabilityOEMid=[];OmitmeanStabilityFLMid={}; OmitmeanCorrToLapNumMid={};

[PCLapped1] = calcWithinSessStability(CueOmitLappedSess);
[PCLapped2] = calcWithinSessStabilityOmit(CueOmitLappedSess);

for i=1:length(CueOmitLappedSess)
    for j = 1:length(CueOmitLappedSess{i}.nonCueCellInd)
CueStabilityOENon{i}{j}= PCLapped1{i}.StabilityOE(CueOmitLappedSess{i}.nonCueCellInd(j));
CueStabilityFLNon{i}{j}= PCLapped1{i}.StabilityFL(CueOmitLappedSess{i}.nonCueCellInd(j));
CueCorrToLapNumNon{i}{j}= PCLapped1{i}.CorrToLapNum(CueOmitLappedSess{i}.nonCueCellInd(j));
OmitStabilityOENon{i}{j}= PCLapped2{i}.StabilityOE(CueOmitLappedSess{i}.nonCueCellInd(j));
OmitStabilityFLNon{i}{j}= PCLapped2{i}.StabilityFL(CueOmitLappedSess{i}.nonCueCellInd(j));
OmitCorrToLapNumNon{i}{j}= PCLapped2{i}.CorrToLapNum(CueOmitLappedSess{i}.nonCueCellInd(j));
CuemeanStabilityOENon=[CuemeanStabilityOENon; nanmean(cell2mat(CueStabilityOENon{i}))];
CuemeanStabilityFLNon=[CuemeanStabilityFLNon; nanmean(cell2mat(CueStabilityFLNon{i}))];
CuemeanCorrToLapNumNon=[CuemeanCorrToLapNumNon; nanmean(cell2mat(CueCorrToLapNumNon{i}))];
OmitmeanStabilityOENon=[OmitmeanStabilityOENon; nanmean(cell2mat(OmitStabilityOENon{i}))];
OmitmeanStabilityFLNon=[OmitmeanStabilityFLNon; nanmean(cell2mat(OmitStabilityFLNon{i}))];
OmitmeanCorrToLapNumNon=[OmitmeanCorrToLapNumNon; nanmean(cell2mat(OmitCorrToLapNumNon{i}))];
    end
end


for i=1:length(CueOmitLappedSess)
    for j = 1:length(CueOmitLappedSess{i}.EdgeCueCellInd)
CueStabilityOEEdge{i}{j}= PCLapped1{i}.StabilityOE(CueOmitLappedSess{i}.EdgeCueCellInd(j));
CueStabilityFLEdge{i}{j}= PCLapped1{i}.StabilityFL(CueOmitLappedSess{i}.EdgeCueCellInd(j));
CueCorrToLapNumEdge{i}{j}= PCLapped1{i}.CorrToLapNum(CueOmitLappedSess{i}.EdgeCueCellInd(j));
OmitStabilityOEEdge{i}{j}= PCLapped2{i}.StabilityOE(CueOmitLappedSess{i}.EdgeCueCellInd(j));
OmitStabilityFLEdge{i}{j}= PCLapped2{i}.StabilityFL(CueOmitLappedSess{i}.EdgeCueCellInd(j));
OmitCorrToLapNumEdge{i}{j}= PCLapped2{i}.CorrToLapNum(CueOmitLappedSess{i}.EdgeCueCellInd(j));
CuemeanStabilityOEEdge=[CuemeanStabilityOEEdge; nanmean(cell2mat(CueStabilityOEEdge{i}))];
CuemeanStabilityFLEdge=[CuemeanStabilityFLEdge; nanmean(cell2mat(CueStabilityFLEdge{i}))];
CuemeanCorrToLapNumEdge=[CuemeanCorrToLapNumEdge; nanmean(cell2mat(CueCorrToLapNumEdge{i}))];
OmitmeanStabilityOEEdge=[OmitmeanStabilityOEEdge; nanmean(cell2mat(OmitStabilityOEEdge{i}))];
OmitmeanStabilityFLEdge=[OmitmeanStabilityFLEdge; nanmean(cell2mat(OmitStabilityFLEdge{i}))];
OmitmeanCorrToLapNumEdge=[OmitmeanCorrToLapNumEdge; nanmean(cell2mat(OmitCorrToLapNumEdge{i}))];
    end
end

for i=1:length(CueOmitLappedSess)
    for j = 1:length(CueOmitLappedSess{i}.MidCueCellInd)
CueStabilityOEMid{i}{j}= PCLapped1{i}.StabilityOE(CueOmitLappedSess{i}.MidCueCellInd(j));
CueStabilityFLMid{i}{j}= PCLapped1{i}.StabilityFL(CueOmitLappedSess{i}.MidCueCellInd(j));
CueCorrToLapNumMid{i}{j}= PCLapped1{i}.CorrToLapNum(CueOmitLappedSess{i}.MidCueCellInd(j));
OmitStabilityOEMid{i}{j}= PCLapped2{i}.StabilityOE(CueOmitLappedSess{i}.MidCueCellInd(j));
OmitStabilityFLMid{i}{j}= PCLapped2{i}.StabilityFL(CueOmitLappedSess{i}.MidCueCellInd(j));
OmitCorrToLapNumMid{i}{j}= PCLapped2{i}.CorrToLapNum(CueOmitLappedSess{i}.MidCueCellInd(j));
CuemeanStabilityOEMid=[CuemeanStabilityOEMid; nanmean(cell2mat(CueStabilityOEMid{i}))];
CuemeanStabilityFLMid=[CuemeanStabilityFLMid; nanmean(cell2mat(CueStabilityFLMid{i}))];
CuemeanCorrToLapNumMid=[CuemeanCorrToLapNumMid; nanmean(cell2mat(CueCorrToLapNumMid{i}))];
OmitmeanStabilityOEMid=[OmitmeanStabilityOEMid; nanmean(cell2mat(OmitStabilityOEMid{i}))];
OmitmeanStabilityFLMid=[OmitmeanStabilityFLMid; nanmean(cell2mat(OmitStabilityFLMid{i}))];
OmitmeanCorrToLapNumMid=[OmitmeanCorrToLapNumMid; nanmean(cell2mat(OmitCorrToLapNumMid{i}))];
    end
end
%%
OmitmeanStabilityFLNon(cellfun(@(OmitmeanStabilityFLNon) any(isnan(OmitmeanStabilityFLNon)),OmitmeanStabilityFLNon)) = [];
OmitmeanStabilityFLEdge(cellfun(@(OmitmeanStabilityFLEdge) any(isnan(OmitmeanStabilityFLEdge)),OmitmeanStabilityFLEdge)) = [];
CuemeanStabilityFLNon(cellfun(@(CuemeanStabilityFLNon) any(isnan(CuemeanStabilityFLNon)),CuemeanStabilityFLNon)) = [];
CuemeanStabilityFLEdge(cellfun(@(CuemeanStabilityFLEdge) any(isnan(CuemeanStabilityFLEdge)),CuemeanStabilityFLEdge)) = [];
CuemeanStabilityFLMid(cellfun(@(CuemeanStabilityFLMid) any(isnan(CuemeanStabilityFLMid)),CuemeanStabilityFLMid)) = [];

PAll = [CuemeanStabilityFLNon; CuemeanStabilityFLEdge; CuemeanStabilityFLMid];
PGroup = [zeros(length(CuemeanStabilityFLNon), 1) + 1; zeros(length(CuemeanStabilityFLEdge), 1) + 2; zeros(length(CuemeanStabilityFLMid), 1) + 3];
[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);
StabilityStats.CueNEM=c;

%%
PAll = [CuemeanStabilityFLNon; OmitmeanStabilityFLNon; CuemeanStabilityFLEdge; OmitmeanStabilityFLEdge];
PGroup = [zeros(length(CuemeanStabilityFLNon), 1) + 1; zeros(length(OmitmeanStabilityFLNon), 1) + 2; zeros(length(CuemeanStabilityFLEdge), 1) + 3; zeros(length(OmitmeanStabilityFLEdge), 1) + 4];
[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);
StabilityStats.CuevsOmitNoEo=c;




