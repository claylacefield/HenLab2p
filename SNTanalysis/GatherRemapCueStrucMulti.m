Path=uigetdir();
cd(Path);
sessDir=dir;
MatchedAll={}; MatchedAny={}; MatchedFirstTwo={}; MatchedLastTwo={}; MatchedFirstThird={};

MatchedAll1=[];MatchedAll2=[];MatchedAll3=[];
MatchedAny1=[];MatchedAny2=[];MatchedAny3=[];
MatchedFirstTwo1=[];MatchedFirstTwo2=[];
MatchedFirstThird1=[]; MatchedFirstThird2=[];
MatchedLastTwo1=[];MatchedLastTwo2=[];

%%
for i=3:length(sessDir)
    if ~isempty(strfind(sessDir(i).name,'MultDay'))
        cd(sessDir(i).name);
load(findLatestFilename('remapNonCueStruc'));
 MatchedAny1=[MatchedAny1;SameCellTypeRemapStruc.posRatesInAny{1,1}];
    MatchedAny2=[MatchedAny2;SameCellTypeRemapStruc.posRatesInAny{1,2}];
    MatchedAny3=[MatchedAny3;SameCellTypeRemapStruc.posRatesInAny{1,3}];
        if isfield (SameCellTypeRemapStruc,'posRatesInAll')
            MatchedAll1=[MatchedAll1;SameCellTypeRemapStruc.posRatesInAll{1,1}];
            MatchedAll2=[MatchedAll2;SameCellTypeRemapStruc.posRatesInAll{1,2}];
            MatchedAll3=[MatchedAll3;SameCellTypeRemapStruc.posRatesInAll{1,3}];
        end
        if isfield (SameCellTypeRemapStruc,'posRatesInFirstTwo')
            MatchedFirstTwo1=[MatchedFirstTwo1;SameCellTypeRemapStruc.posRatesInFirstTwo{1,1}];
            MatchedFirstTwo2=[MatchedFirstTwo2;SameCellTypeRemapStruc.posRatesInFirstTwo{1,2}];
        end
        if isfield (SameCellTypeRemapStruc,'posRatesInFirstThird')
            MatchedFirstThird1=[MatchedFirstThird1;SameCellTypeRemapStruc.posRatesInFirstThird{1,1}];
            MatchedFirstThird2=[MatchedFirstThird2;SameCellTypeRemapStruc.posRatesInFirstThird{1,2}];
        end
        if isfield (SameCellTypeRemapStruc,'posRatesInLastTwo')
            MatchedLastTwo1=[MatchedLastTwo1;SameCellTypeRemapStruc.posRatesInLastTwo{1,1}];
            MatchedLastTwo2=[MatchedLastTwo2;SameCellTypeRemapStruc.posRatesInLastTwo{1,2}];
        end
    end
        cd(Path);
end
MatchedAll = {MatchedAll1,MatchedAll2,MatchedAll3};
MatchedAny = {MatchedAny1,MatchedAny2,MatchedAny3};
MatchedFirstTwo ={MatchedFirstTwo1, MatchedFirstTwo2};
MatchedFirstThird ={MatchedFirstThird1,MatchedFirstThird2};
MatchedLastTwo ={MatchedLastTwo1, MatchedLastTwo2};

NonStruc.MatchedAll = MatchedAll;
NonStruc.MatchedAny =MatchedAny ;
NonStruc.MatchedFirstTwo =MatchedFirstTwo;
NonStruc.MatchedFirstThird =MatchedFirstThird;
NonStruc.MatchedLastTwo =MatchedLastTwo;


%%
g=[];
Matched = posRatesStruc.MatchedSecond; 
g = fspecial ('gaussian', [10, 1], 2.5);
p = Matched{1, 1}; s = Matched{1, 2}; o = Matched{1, 3};
goodBins = [zeros(100, 1); zeros(100, 1) + 1; zeros(100, 1)];
pSmooth = convWith(repmat(p', [3, 1]), g);
pSmooth = pSmooth(goodBins == 1, :)';
sSmooth = convWith(repmat(s', [3, 1]), g);
sSmooth = sSmooth(goodBins == 1, :)';
oSmooth = convWith(repmat(o', [3, 1]), g);
oSmooth = oSmooth(goodBins == 1, :)';
Matched={};
Matched{1}=pSmooth;
Matched{2}=sSmooth;
Matched{3}=oSmooth;


[~, s1] = nanmax(Matched{2}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(Matched)
    Matched{i} = Matched{i}(s2, :);
end
figure;
maxRate = Inf;
CLims = [0, 0.5];
for i = 1:3
    subplot(1, 3, i);
    c = Matched{i};
    c(c > maxRate) = maxRate;
    imagesc(c);
    set(gca, 'CLim', CLims);
end
suptitle('MultDay  matched for Second');
colormap hot;

