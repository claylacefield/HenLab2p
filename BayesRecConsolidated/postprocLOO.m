meanAllpc=[]; medianAllpc=[]; rateAllpc =[]; spkZAllpc =[];
meanNonpc=[]; medianNonpc=[]; rateNonpc =[]; spkZNonpc =[];
meanMidcue=[]; medianMidcue=[]; rateMidcue =[]; spkZMidcue =[];
meanEdgecue=[]; medianEdgecue=[]; rateEdgecue =[]; spkZEdgecue =[];
meanNoncue=[]; medianNoncue=[]; rateNoncue =[]; spkZNoncue =[];
for I = 1:length(CombStrucAll)
    cueShiftStruc = CombStrucAll{I}.TotalCell{4};
    pksCell={};
    for seg=1:size(CombStrucAll{I}.TotalCell{3}.C2p,1)
        pksCell{seg}=clayCaTransients(CombStrucAll{I}.TotalCell{3}.C2p(seg,:),15);
    end
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
    
    meanAllpc = [meanAllpc; LOOErrors{I}.MeanErrorDiffActive(Allpc)];
    medianAllpc = [medianAllpc; LOOErrors{I}.MedianErrorDiffActive(Allpc)];
    rateAllpc =[rateAllpc; nanmean(PCLappedSessCue.posRates(Allpc,:),2)];
    spkZAllpc = [spkZAllpc; PCLappedSessCue.Shuff.InfoPerSecZ(Allpc)];
    meanNonpc=[meanNonpc; LOOErrors{I}.MeanErrorDiffActive(nonPCCells)];
    medianNonpc=[medianNonpc ; LOOErrors{I}.MedianErrorDiffActive(nonPCCells)];
    rateNonpc =[rateNonpc; nanmean(PCLappedSessCue.posRates(nonPCCells,:),2)];
    spkZNonpc = [spkZNonpc; PCLappedSessCue.Shuff.InfoPerSecZ(nonPCCells)];
    meanMidcue=[meanMidcue;LOOErrors{I}.MeanErrorDiffActive(MidCueCellInd)]; %ismember(Allpc, MidCueCellInd)==1)
    medianMidcue=[medianMidcue; LOOErrors{I}.MedianErrorDiffActive(MidCueCellInd)];
    rateMidcue =[rateMidcue; nanmean(PCLappedSessCue.posRates(MidCueCellInd,:),2)];
    spkZMidcue = [spkZMidcue; PCLappedSessCue.Shuff.InfoPerSecZ(MidCueCellInd)];
    meanEdgecue=[meanEdgecue; LOOErrors{I}.MeanErrorDiffActive(EdgeCueCellInd)]; %ismember(Allpc, EdgeCueCellInd)==1)
    medianEdgecue=[medianEdgecue;LOOErrors{I}.MedianErrorDiffActive(EdgeCueCellInd)];
    rateEdgecue =[rateEdgecue; nanmean(PCLappedSessCue.posRates(EdgeCueCellInd,:),2)];
    spkZEdgecue = [spkZEdgecue; PCLappedSessCue.Shuff.InfoPerSecZ(EdgeCueCellInd)];
    meanNoncue=[meanNoncue;LOOErrors{I}.MeanErrorDiffActive(nonCueCellInd)]; %(ismember(Allpc, nonCueCellInd)==1)
    medianNoncue=[medianNoncue;LOOErrors{I}.MedianErrorDiffActive(nonCueCellInd)];
    rateNoncue =[rateNoncue; nanmean(PCLappedSessCue.posRates(nonCueCellInd,:),2)];
    spkZNoncue = [spkZNoncue; PCLappedSessCue.Shuff.InfoPerSecZ(nonCueCellInd)];
end

%%
numberOfDivisions = 10;
percs = prctile(rateMidcue, linspace(0, 100, numberOfDivisions + 1)); 
percs2 = prctile(rateEdgecue, linspace(0, 100, numberOfDivisions + 1)); 
percs3 = prctile(rateNoncue, linspace(0, 100, numberOfDivisions + 1)); 
percs(end) = percs(end) + 1;
percs2(end) = percs2(end) + 1;
percs3(end) = percs3(end) + 1;


[h, whichBin1] = histc(rateMidcue, percs2);
A = [];
for i = 1:10
A = [A; i, nanmean(rateMidcue(whichBin1 == i)), nanmean(medianMidcue(whichBin1 == i)), makeStdErrorOfMean(medianMidcue(whichBin1 == i))];
end
[h, whichBin2] = histc(rateEdgecue, percs2);
B = [];
for i = 1:10
B = [B; i, nanmean(rateEdgecue(whichBin2 == i)), nanmean(medianEdgecue(whichBin2 == i)), makeStdErrorOfMean(medianEdgecue(whichBin2 == i))];
end

[h, whichBin3] = histc(rateNoncue, percs2);
C = [];
for i = 1:10
C = [C; i, nanmean(rateNoncue(whichBin3 == i)), nanmean(medianNoncue(whichBin3 == i)), makeStdErrorOfMean(medianNoncue(whichBin3 == i))];
end
figure;
errorbar(A(:, 2), A(:, 3), A(:, 4));
hold on;  errorbar(B(:, 2), B(:, 3), B(:, 4), 'r');
hold on; errorbar(C(:, 2), C(:, 3), C(:, 4), 'b');
title(' LOO Difference in Median Err vs Rate Mid Edge Non ');
%%
X=[1,2,3,4,5]; 
Y1= [nanmean(meanAllpc) nanmean(meanNonpc) nanmean(meanEdgecue) nanmean(meanMidcue) nanmean(meanNoncue)]; 
err1= [makeStdErrorOfMean(meanAllpc) makeStdErrorOfMean(meanNonpc) makeStdErrorOfMean(meanEdgecue) makeStdErrorOfMean(meanMidcue) makeStdErrorOfMean(meanNoncue)]; 


 figure; bar(X,Y1); hold on; er1 = errorbar(X,Y1, err1); 
 er1.Color=[0 0 0]; title(' Mean Error LOO Aggregate Difference Active bins');
 set (gcf, 'Renderer', 'painters');

 X=[1,2,3,4,5]; 
Y1= [nanmean(medianAllpc) nanmean(medianNonpc) nanmean(medianEdgecue) nanmean(medianMidcue) nanmean(medianNoncue)]; 
err1= [makeStdErrorOfMean(medianAllpc) makeStdErrorOfMean(medianNonpc) makeStdErrorOfMean(medianEdgecue) makeStdErrorOfMean(medianMidcue) makeStdErrorOfMean(medianNoncue)]; 


 figure; bar(X,Y1); hold on; er1 = errorbar(X,Y1, err1); 
 er1.Color=[0 0 0]; title(' median Error LOO Aggregate Difference Active bins');
 set (gcf, 'Renderer', 'painters');
 
 
  PAll = [medianAllpc; medianNonpc; medianEdgecue; medianMidcue; medianNoncue]; 
PGroup = [zeros(length(medianAllpc), 1) + 1;zeros(length(medianNonpc), 1) + 2;zeros(length(meanEdgecue), 1) + 3; ...
    zeros(length(meanMidcue), 1) + 4; zeros(length(meanNoncue), 1) + 5];

[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);
%%
medianMidcue(isnan(medianMidcue))=0;
rateMidcue(isnan(rateMidcue))=0;
[r,p]= corrcoef(A(:, 2), A(:, 3));
MidR = r(2)
MidP = p(2);
rateEdgecue(isnan(rateEdgecue))=0;
medianEdgecue(isnan(medianEdgecue))=0;
[r,p]= corrcoef(B(:, 2), B(:, 3));
EdgeR = r(2) 
EdgeP = p(2);
rateNoncue(isnan(rateNoncue))=0;
medianNoncue(isnan(medianNoncue))=0;
[r,p]= corrcoef(C(:, 2), C(:, 3));
NonR = r(2) 
NonP = p(2);



p= FisherZ1([NonR, EdgeR], [length(rateNoncue), length(rateEdgecue)]);
[corrected_p, h]=bonf_holm([MidP EdgeP NonP],0.05)
