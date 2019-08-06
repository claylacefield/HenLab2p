

%1) threshold based on velocity (>5cm/sec)
%2) bin position vector into ~100 bins (each 2 cm) using histc function
%3) for loop each bin calculate 
%             a) sum all samples are within each bin and divide by 30Hz, this is occupancy vector
%             b) sum all events (Ca or licks) are within each bin
%             c) smooth each vector  using fspecial ? check this
%             d) divide b by a

lickRatebyBin = {};

for i = 1 : length(treadBehStruc)
    d= treadBehStruc{i}.BeCell;
    timevec = d(:,1);
    posvec = d(:,2);
    lickvec = d(:,3);
    
    binranges = linspace (min(posvec),max(posvec),(round(max(posvec)/20))); %linespace is similar to : operator but can control the number of points and endpoints
    [bincounts, ind]= histc(posvec, binranges, 1);
    %bincount countains # of elements in each bin
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
  
    
end
lickRatebyBin{i}.Lickrate = Lickrate;
lickRatebyBin{i}.licksbyBin = licksbyBin;



bar(binranges, lickrate, 'histc');
title(treadBehStruc{1}.tdmlName)

