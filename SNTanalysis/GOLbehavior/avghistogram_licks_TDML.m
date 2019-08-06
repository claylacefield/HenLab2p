%modify histogram_licks_TDML histograms, averages each column in histogram then plot histogram
licksByPosLap = {};
for i = 1 : length(treadBehStruc); %iterate over sessions
    d = treadBehStruc{i}.BeCell; %pick the BeCell structure for each session
    timevec = d(:,1);
    posvec = d(:,2);
    lickvec = d(:,3);
    %to call the lap function saved in directory
    [lapVec1, lapInts1] = calcLapsSeb1(posvec', timevec');
    lapVec1 = lapVec1'; % to transpose lapVect into colummn vector from row vector
    
    %trialNum = 1; (for only first, lap for example)
    %or trialNum = 1:max(lapVec1)/2
    licksByLap = []; %initialize the variable
    for trialNum = 1:max(lapVec1)  %count for all the laps sequentially
        logicalVec = lickvec == 1 & lapVec1 == trialNum;  % & operator is used so time has to be licktime AND lap vector has to be equal to trial number
        % this operator is the thing that makes this work
        lick = d(logicalVec, 2);  % this gives you all the positions in column 2 rows that has licks: go fectch me every item of d(:,2)--> Y==1 replaces :
        nolick = d((d(:,3)) == 0,2);  % this gives you all the positions in column 2 row locations that has no licks
        
        %figure; histogram(lick)  % gives you the histogram of licks by automatically detecting the x linspace
        bins = linspace(min(posvec), max(posvec), (round(max(posvec)/20)));  % gives you a linearsapce btwn max and min and number of bins inside
        h = histc(lick, bins, 1);   % the output of histc vector is a column vector, that tells it to perform hisc operation (binning) as a row
        h = h(1:(end - 1))';   % and then transpose h to laps will be on the y axis so h is transposed,
        %and exclude the last hist count because it
        %falls to the edge (an issue of histc function)
        %         if size(h, 1) > size(h, 2)   % if the number of rows , size (h,1)means size along the first dimention - if greater than
        %             %size (h,2)means columns --> transpose h
        %             h = h';
        %         end
        %
        licksByLap = [licksByLap; h];   %add the h as a row vector to the matrix of lickByLap
    end
    %to calculate rates
    licksByPos = [];
    [bincounts, ind]= histc(posvec, bins, 1);
    ocvec = bincounts/30;
    for j = 1:max(ind)
        L = sum(lickvec(ind == j)); %find the index of j in the indx vector and sum those inds in licvec
        licksByPos = [licksByPos; L];
  
    end
    lickRate = licksByPos./ocvec;
    
    
    licksByPosLap{i}.counts = licksByLap;
    licksByPosLap{i}.bins = bins(1:(end - 1));
    licksByPosLap{i}.licksByPos = licksByPos;
    licksByPosLap{i}.lickRate = lickRate;
    
    
    fig = figure;
    ax1 = subplot (3,1,1);
    imagesc(licksByPosLap{i}.bins, 1:size(licksByPosLap{i}.counts, 1), licksByPosLap{i}.counts);
    ax2 = subplot(3,1,2);
    bar(licksByPosLap{i}.bins, mean(licksByPosLap{i}.counts), 'histc');
    xlim([0, (round(max(posvec)/20))]);
        set(ax2, 'XLim', [0, (round(max(posvec)/20))]);
        ax3 = subplot (3,1,3);
        bar(licksByPosLap{i}.bins, licksByPosLap{i}.lickRate, 'histc');
        %set(ax3, 'XLim', [0, (round(max(posvec)/20))
        suptitle(treadBehStruc{i}.tdmlName);
        
        end
        
        
        
        
        
