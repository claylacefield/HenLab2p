%create laps in pso and T then place lick counts into histograms then plot imagesc 
% d = dir('*tdml');
% treadBehStruc = {};
% for ii = 1:length(d)
%     treadBehStruc{ii} = readTDML_AG(pwd, d(ii).name);
% end -- figure out how to make this and read TDML a function
    
    behaviorCell = {};
    licksByPosLap = {};
    for i = 1 : length(treadBehStruc) %iterate over sessions
        behaviorCell{i}.data = treadBehStruc{i}.BeCell; %pick the BeCell structure for each session
        behaviorCell{i}.fileName = treadBehStruc{i}.filename;
        d= behaviorCell{i}.data;
        
        %     % corresponding position with lick times
        %     d= behaviorCell{i}.data;
        %     ind = dsearchn ((d(:,1)), d(:,3));  %create a list of indexes after finding the closests point in column 1 for each point in column 3
        %     % ie row 3, 6,7,8, has closest points in column 1 and 3
        %     Y = zeros (size(d,1),1);  %create new column with all zeros with the row size of cell d
        %     Y(ind)=1; % puts one for all the rows in column Y as indexed from 'ind' from dsearchn
        
        %to call the lap function saved in directory
        T = behaviorCell{i}.data(:, 1)';
        pos = behaviorCell{i}.data(:, 2)';
        [lapVec1, lapInts1] = calcLapsSeb1(pos, T);
        lapVec1 = lapVec1'; % to transpose lapVect into colummn vector from row vector
        
        
        
        %trialNum = 1; (for only first, lap for example)
        %or trialNum = 1:max(lapVec1)/2
        licksByLap = []; %initialize the variable
        for trialNum = 1:max(lapVec1)  %count for all the laps sequentially
            logicalVec = d(:,3) == 1 & lapVec1 == trialNum;  % & operator is used so time has to be licktime AND lap vector has to be equal to trial number
            % this operator is the thing that makes this work
            lick = d(logicalVec, 2);  % this gives you all the positions in column 2 rows that has licks: go fectch me every item of d(:,2)--> Y==1 replaces :
            nolick = d((d(:,3)) == 0,2);  % this gives you all the positions in column 2 row locations that has no licks
            
            %figure; histogram(lick)  % gives you the histogram of licks by automatically detecting the x linspace
            bins = linspace(min(d(:, 2)), max(d(:, 2)), 81);  % gives you a linearsapce btwn max and min and number of bins inside
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
        licksByPosLap{i}.counts = licksByLap;
        licksByPosLap{i}.bins = bins(1:(end - 1));
        fig = figure; imagesc(licksByPosLap{i}.bins, 1:size(licksByPosLap{i}.counts, 1), licksByPosLap{i}.counts);
         title(behaviorCell{i}.fileName);
        
    end
    
%end