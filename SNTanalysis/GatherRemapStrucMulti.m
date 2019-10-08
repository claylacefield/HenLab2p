Path=uigetdir();
cd(Path);
sessDir=dir;
PCMatchedAll={}; PCMatchedAny={};

PCMatchedAll1=[];PCMatchedAll2=[];PCMatchedAll3=[];
PCMatchedAny1=[];PCMatchedAny2=[];PCMatchedAny3=[];
for i=3:length(sessDir)
    if ~isempty(strfind(sessDir(i).name,'MultSens'))
        cd(sessDir(i).name);
        load(findLatestFilename('remapSpatCellStruc'));
        if isfield (remapSpatCellStruc,'PCMatchedAll')
            PCMatchedAll1=[PCMatchedAll1;remapSpatCellStruc.PCMatchedAll{1,1}];
            PCMatchedAll2=[PCMatchedAll2;remapSpatCellStruc.PCMatchedAll{1,2}];
            PCMatchedAll3=[PCMatchedAll3;remapSpatCellStruc.PCMatchedAll{1,3}];
        end
    
    PCMatchedAny1=[PCMatchedAny1;remapSpatCellStruc.PCMatchedAny{1,1}];
    PCMatchedAny2=[PCMatchedAny2;remapSpatCellStruc.PCMatchedAny{1,2}];
    PCMatchedAny3=[PCMatchedAny3;remapSpatCellStruc.PCMatchedAny{1,3}];
    end
    cd(Path);
end
PCMatchedAll = {PCMatchedAll1,PCMatchedAll2,PCMatchedAll3};
PCMatchedAny = {PCMatchedAny1,PCMatchedAny2,PCMatchedAny3};

%%
g=[];
g = fspecial ('gaussian', [10, 1], 2.5); 
p = PCMatchedAll{1, 1}; s = PCMatchedAll{1, 2}; o = PCMatchedAll{1, 3};
goodBins = [zeros(100, 1); zeros(100, 1) + 1; zeros(100, 1)];
pSmooth = convWith(repmat(p', [3, 1]), g);
pSmooth = pSmooth(goodBins == 1, :)';
sSmooth = convWith(repmat(s', [3, 1]), g);
sSmooth = sSmooth(goodBins == 1, :)';
oSmooth = convWith(repmat(o', [3, 1]), g);
oSmooth = oSmooth(goodBins == 1, :)';
PCMatchedAll={};
PCMatchedAll{1}=pSmooth;
PCMatchedAll{2}=sSmooth;
PCMatchedAll{3}=oSmooth;
[~, s1] = nanmax(PCMatchedAll{1}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(PCMatchedAll)
    PCMatchedAll{i} = PCMatchedAll{i}(s2, :);
end
%% Rate correlation
popVecCorr12 = 1 - pdist2(PCMatchedAll{1}', PCMatchedAll{2}', 'correlation');
popVecCorr13 = 1 - pdist2(PCMatchedAll{1}', PCMatchedAll{3}', 'correlation');
cellCorr12 = 1 - pdist2(PCMatchedAll{1}, PCMatchedAll{2}, 'correlation'); 
cellCorr13 =1 - pdist2(PCMatchedAll{1}, PCMatchedAll{3}, 'correlation');

ShuffpopVecCorr12=[];ShuffpopVecCorr13=[];
ShuffcellCorr12=[];ShuffcellCorr13=[];
   rng('shuffle')
   for sh = 1:200
       posRatesCellRand = PCMatchedAll;
       posRatesCellRand{1} = PCMatchedAll{1}(randperm(size(PCMatchedAll{1}, 1)), :);
       posRatesCellRand{2} = PCMatchedAll{2}(randperm(size(PCMatchedAll{2}, 1)), :);
       posRatesCellRand{3} = PCMatchedAll{3}(randperm(size(PCMatchedAll{3}, 1)), :);
ShuffpopVecCorr12{sh} = 1 - pdist2(posRatesCellRand{1}', PCMatchedAll{2}', 'correlation');
ShuffpopVecCorr13{sh} = 1 - pdist2(posRatesCellRand{1}', PCMatchedAll{3}', 'correlation');
ShuffcellCorr12{sh}= 1 - pdist2(posRatesCellRand{1}, PCMatchedAll{2}, 'correlation');
ShuffcellCorr13{sh}= 1 - pdist2(posRatesCellRand{1}, PCMatchedAll{3}, 'correlation'); 
   end
    ShpopVecCorr12=[]; ShpopVecCorr13=[];
   ShcellCorr12=[];ShcellCorr13=[];
   for i=1:length(ShuffpopVecCorr12)
        a=ShuffpopVecCorr12{i};
        b=ShuffpopVecCorr13{i};
       c=ShuffcellCorr12{i};
       d=ShuffcellCorr13{i};
       a=diag(a); b=diag(b); 
       c=diag(c); d=diag(d);
        ShpopVecCorr12=[ShpopVecCorr12 a];
        ShpopVecCorr13=[ShpopVecCorr13 b];
       ShcellCorr12=[ShcellCorr12 c];
       ShcellCorr13=[ShcellCorr13 d];
   end
   
    meanShpopVecCorr12 = nanmean(ShpopVecCorr12,2); meanShpopVecCorr13 = nanmean(ShpopVecCorr13,2);
    meancellCorr12 = nanmean(diag(cellCorr12),1);   meancellCorr13 = nanmean(diag(cellCorr13),1); 
     semcellCorr12 = std(diag(cellCorr12),1)/sqrt(length(diag(cellCorr12)));     semcellCorr13 = std(diag(cellCorr13),1)/sqrt(length(diag(cellCorr13))); 
meanShcellCorr12=mean(nanmean(ShcellCorr12,2),1); meanShcellCorr13=mean(nanmean(ShcellCorr13,2),1); 
semShcellCorr12=std(nanmean(ShcellCorr12,2),1)/sqrt(length(nanmean(ShcellCorr12,2)));  semShcellCorr13=std(nanmean(ShcellCorr13,2),1)/sqrt(length(nanmean(ShcellCorr13,2))); 
       %%
figure; plot(diag(popVecCorr12)); hold on;  plot(diag(popVecCorr13)); hold on; plot(meanShpopVecCorr12, '--');hold on; plot(meanShpopVecCorr13, ':') ;
 X=[1,2,3,4]; Y= [meancellCorr12 meancellCorr13 meanShcellCorr12 meanShcellCorr13]; err=[semcellCorr12 semcellCorr13 semShcellCorr12 semShcellCorr13];
 figure; bar(X,Y); hold on; er = errorbar(X,Y, err); 
 er.Color=[0 0 0];
 
 PAll = [diag(cellCorr12); diag(cellCorr13); nanmean(ShcellCorr12,2); nanmean(ShcellCorr13,2)];
PGroup = [zeros(length(diag(cellCorr12)), 1) + 1; zeros(length(diag(cellCorr13)), 1) + 2; zeros(length(nanmean(ShcellCorr12,2)), 1) + 3; zeros(length(nanmean(ShcellCorr13,2)), 1) + 4];

[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);

x=[diag(cellCorr12),diag(cellCorr13),nanmean(ShcellCorr12,2), nanmean(ShcellCorr13,2)];
figure; boxplot(x, 'Notch', 'on', 'Labels', {'Within Day','Across Days','Shuffle'}, 'Whisker', 1)
figure; violin (x);

%%
figure;
maxRate = Inf;
CLims = [0, 0.5];
for i = 1:3
    subplot(1, 3, i);
    c = PCMatchedAll{i};
    c(c > maxRate) = maxRate;
    imagesc(c);
    set(gca, 'CLim', CLims);
end
suptitle('MultSess PC Matched All nonNormRates');
colormap hot;

