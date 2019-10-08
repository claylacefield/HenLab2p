Path=uigetdir();
cd(Path);
sessDir=dir;

Cell12Shuff=[]; Cell13Shuff=[]; Cell23Shuff=[];
Total123=[];Both122313=[];
Only1per12Rates1=[];Only1per12Rates2=[];
Only2per23Rates1=[];Only2per23Rates2=[];
Only1per13Rates1=[];Only1per13Rates2=[];

for i=3:length(sessDir)
    if ~isempty(strfind(sessDir(i).name,'MultSens'))
        cd(sessDir(i).name);
        load(findLatestFilename('EdgeBootstrapStruc'));
        Cell12Shuff =[Cell12Shuff;BootstrapStruc.Cell12Shuff];
        Cell23Shuff =[Cell23Shuff;BootstrapStruc.Cell23Shuff];
        Cell13Shuff=[Cell13Shuff;BootstrapStruc.Cell13Shuff];
        
        Total123=[Total123;length(BootstrapStruc.Sess1Total), length(BootstrapStruc.Sess2Total),length(BootstrapStruc.Sess3Total)];
        Both122313=[Both122313;length(BootstrapStruc.Both12Ind),length(BootstrapStruc.Both23Ind), length(BootstrapStruc.Both13Ind)];
        if isfield (BootstrapStruc,'posRatesOnly1per12')
            Only1per12Rates1=[Only1per12Rates1;BootstrapStruc.posRatesOnly1per12{1,1}];
            Only1per12Rates2=[Only1per12Rates2;BootstrapStruc.posRatesOnly1per12{1,2}];
        end
        if isfield (BootstrapStruc,'posRatesOnly2per23')
            Only2per23Rates1=[Only2per23Rates1;BootstrapStruc.posRatesOnly2per23{1,1}];
            Only2per23Rates2=[Only2per23Rates2;BootstrapStruc.posRatesOnly2per23{1,2}];
        end
        if isfield (BootstrapStruc,'posRatesOnly1per13')
            Only1per13Rates1=[Only1per13Rates1;BootstrapStruc.posRatesOnly1per13{1,1}];
            Only1per13Rates2=[Only1per13Rates2;BootstrapStruc.posRatesOnly1per13{1,2}];
        end
        
    end
    cd(Path);
end
PosRatesOnly1per12 = {Only1per12Rates1,Only1per12Rates2};
PosRatesOnly2per23 = {Only2per23Rates1,Only2per23Rates2};
PosRatesOnly1per13 ={Only1per13Rates1, Only1per13Rates2};

CumBootStruc.EdgePosRatesOnly1per12 = PosRatesOnly1per12;
CumBootStruc.EdgePosRatesOnly2per23 =PosRatesOnly2per23 ;
CumBootStruc.EdgePosRatesOnly1per13 =PosRatesOnly1per13;
CumBootStruc.EdgeShuff12= Cell12Shuff;
CumBootStruc.EdgeShuff13= Cell13Shuff;
CumBootStruc.EdgeShuff23= Cell23Shuff;
CumBootStruc.EdgeTotal123= Total123;
CumBootStruc.EdgeBoth122313= Both122313;

%%
g=[];
Matched = [];
g = fspecial ('gaussian', [10, 1], 2.5);
p = [CumBootStruc.NonPosRatesOnly1per12{1, 1};CumBootStruc.NonPosRatesOnly1per13{1, 1};CumBootStruc.NonPosRatesOnly2per23{1, 1}]; 
s = [CumBootStruc.NonPosRatesOnly1per12{1, 2};CumBootStruc.NonPosRatesOnly1per13{1, 2};CumBootStruc.NonPosRatesOnly2per23{1, 2}];  
%o = Matched{1, 3};
goodBins = [zeros(100, 1); zeros(100, 1) + 1]; %; zeros(100, 1)];
pSmooth = convWith(repmat(p', [3, 1]), g);
pSmooth = pSmooth(goodBins == 1, :)';
sSmooth = convWith(repmat(s', [3, 1]), g);
sSmooth = sSmooth(goodBins == 1, :)';
% oSmooth = convWith(repmat(o', [3, 1]), g);
% oSmooth = oSmooth(goodBins == 1, :)';
Matched={};
Matched{1}=pSmooth;
Matched{2}=sSmooth;
% Matched{3}=oSmooth;


[~, s1] = nanmax(Matched{1}, [], 2);
[~, s2] = sort(s1);
for i = 1:length(Matched)
    Matched{i} = Matched{i}(s2, :);
end
figure;
maxRate = Inf;
CLims = [0, 0.5];
for i = 1:2
    subplot(1, 2, i);
    c = Matched{i};
    c(c > maxRate) = maxRate;
    imagesc(c);
    set(gca, 'CLim', CLims);
end
suptitle('MultDay Non Cue in 1st not 2nd nonNormRates');
colormap hot;

