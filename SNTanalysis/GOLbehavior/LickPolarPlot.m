
d = dir('*tdml');
treadBehStruc = {};
for ii = 1:length(d)
    treadBehStruc{ii} = readTDML_AG(pwd, d(ii).name);
end
lickRatebyBin = {};

for i = 1: length(treadBehStruc)
    d= treadBehStruc{i}.BeCell;
    timevec = d(:,1);
    posvec = d(:,2);
    lickvec = d(:,3);
    BinRanges =[];
    binranges = linspace (min(posvec),max(posvec), 40); %linespace is similar to : operator but can control the number of points and endpoints
   [bincounts, ind]= histc(posvec, binranges, 1);
     BinRanges = [BinRanges; binranges];
    ocvec = bincounts/30;
    %convert to circular
    binranges2 = (binranges/max(binranges))*2*pi();
    binrangesCirc = binranges2(1:(end - 1)) + mean(diff(binranges2))/2;
    binrangesCirc = [binrangesCirc, binrangesCirc(1)];
    
    licksbyBin = [];
    Lickrate =[];
    for j = 1:max(ind)
        L = sum(lickvec(ind == j)); %find the index of j in the indx vector and sum those inds in licvec
        licksbyBin = [licksbyBin; L];
    end
    lickrate = licksbyBin./ocvec;
    Lickrate = [Lickrate; lickrate];
    %lick circular tuning
    mrl = []; mra=[];
    mrl = circ_r(binrangesCirc', Lickrate, binrangesCirc);
    mra = circ_mean(binrangesCirc', Lickrate);
    %alternative: lickbybin = accumarray (binind, lickvec) but binind needs to
    %be positive integers
    Lickrate = Lickrate(1:(end - 1));
    Lickrate = [Lickrate; Lickrate(1)];
    
    lickRatebyBin{i}.BinRanges = BinRanges;
    lickRatebyBin{i}.Lickrate = Lickrate;
    lickRatebyBin{i}.licksbyBin = licksbyBin;
    lickRatebyBin{i}.mrl = mrl;
    lickRatebyBin{i}.mra = mra;
    
    fig = figure;
    subplot(1,2,1);
    polarplot(binrangesCirc, Lickrate)
    subplot(1,2,2);
    compass(mrl*cos(mra), mrl*sin(mra));
    title(treadBehStruc{i}.tdmlName);
end

%% collect all in a table

MRL=[];
MRA=[];
all = [];
for i=1:length (lickRatebyBin);
mrl=lickRatebyBin{i}.mrl;
MRL=[MRL mrl];
mra=lickRatebyBin{i}.mra;
MRA=[MRA mra];
end

MRL=MRL';
MRA=MRA';

all = [MRL MRA ];

save ('MRL_MRA.mat', 'all');




