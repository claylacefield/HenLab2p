

%1) threshold based on velocity (>5cm/sec)
%2) bin position vector into ~100 bins (each 2 cm) using histc function
%3) for loop each bin calculate 
%             a) sum all samples are within each bin and divide by 30Hz, this is occupancy vector
%             b) sum all events (Ca or licks) are within each bin
%             c) smooth each vector  using fspecial ? check this
%             d) divide b by a
 d = dir('*tdml');
 treadBehStruc = {};
 for ii = 1% 1:length(d)
   treadBehStruc{ii} = readTDML_AG(pwd, d(ii).name);
 end
lickRatebyBin = {};

for i = 1: length(treadBehStruc)
    d= treadBehStruc{i}.BeCell;
    timevec = d(:,1);
    posvec = d(:,2);
    lickvec = d(:,3);
    BinRanges =[];
    binranges = linspace (min(posvec),max(posvec),100); %linespace is similar to : operator but can control the number of points and endpoints
    [bincounts, ind]= histc(posvec, binranges, 1);
    %bincount countains # of elements in each bin
    BinRanges = [BinRanges; binranges];
    ocvec = bincounts/30;
    % ind (same size as posvec) is the the bin number each element in posvec goes after histc
    %if you plot bar(binranges, bincounts, 'histc') will see the positions animal hangs out during the trial
    licksbyBin = [];
    Lickrate =[];
    for j = 1:max(ind)
        L = sum(lickvec(ind == j)); %find the index of j in the indx vector and sum those inds in licvec
        licksbyBin = [licksbyBin; L];
    end
     lickrate = licksbyBin./ocvec;
     Lickrate = [Lickrate; lickrate];
    %alternative: lickbybin = accumarray (binind, lickvec) but binind needs to
    %be positive integers
    lickRatebyBin{i}.BinRanges = BinRanges;
    lickRatebyBin{i}.Lickrate = Lickrate;
    lickRatebyBin{i}.licksbyBin = licksbyBin;
    fig = figure; 
    %bar(lickRatebyBin{i}.BinRanges, lickRatebyBin{i}.Lickrate ,'histc', 'FaceColor', [1, 0, 0]);
    barObject = bar(lickRatebyBin{i}.BinRanges, lickRatebyBin{i}.Lickrate, 'histc');
    set(barObject, 'FaceColor', 'r');
    ylim ([0,6]);
    title(treadBehStruc{i}.tdmlName);
end
L=[];
for i=1:length(lickRatebyBin);
lick=lickRatebyBin{i}.Lickrate;
L=[L lick];

end
L=L';
save ('L.mat', 'L');

% L = struct2csv(L, 'LickRate.xls' );
% FileName='LickRate.xls';
% writetable(L, FileName);
 


% First order sessions into 500, 1500 groups
% L=[];
% for i=1:length(lickRatebyBin);
% lick=lickRatebyBin{i}.Lickrate;
% L=[L lick];
% end
% 
% M=mean (L,2); 
% STD= std()
% S=sum(M(20:30)); C=sum(M(70:80));


