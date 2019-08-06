
%generalize averaging of session halves, across all sessions in licksByPosLap:
normLickingFirstHalfAvg = [];
normLickingSecHalfAvg = [];
for i = 1:length(licksByPosLap)
C = licksByPosLap{i}.counts;
a = sum(C, 2);
D = C./repmat(a, [1, size(C, 2)]); % normalize each bin by total licks in the lap
D(isnan(D)) = 0;

bins = licksByPosLap{i}.bins;  % determine the range of bins to consider
bins = bins + mean(diff(bins))/2; %take the difference of each bin and measure half of it- defines edges of binning 
rZLocationsAll = [50, 1000; 50, 1000; 50, 1000; 50, 1000; 1050, 2000; 50, 1000;]; % write down the range of preRewZone from all sessions
rZLocation = rZLocationsAll(i, :);
binsInRZBool = bins >= rZLocation(1) & bins <= rZLocation(2);
binsInRZIndexes = find(binsInRZBool);
%binsInRZIndexes = find(bins >= rZLocation(1) & bins <= rZLocation(2));
DinRZ = D(:, binsInRZBool);

% 1:floor(sizeD,1)/2 is the first half of all laps
% sum all the bins within range
% deteremine the mean of sum

firstHalfOfLaps = sum(D(1:floor(size(D, 1)/2), binsInRZBool), 2);
firstHalfOfLaps = mean(firstHalfOfLaps);
secHalfOfLaps = sum(D((floor(size(D, 1)/2) + 1):end, binsInRZBool), 2);
secHalfOfLaps = mean(secHalfOfLaps);
normLickingFirstHalfAvg = [normLickingFirstHalfAvg; firstHalfOfLaps];
normLickingSecHalfAvg = [normLickingSecHalfAvg; secHalfOfLaps];
end
T1_sham_C2 = normLickingFirstHalfAvg
T2_sham_C2 = normLickingSecHalfAvg
% figure; plot(licksByPosLap{1}.bins, mean(normLickingFirstHalfAvg, 1), 'b');
% hold on; plot(licksByPosLap{1}.bins, mean(normLickingSecHalfAvg, 1), 'r');
 


% %using logic to find bins within a certain range
% bins = licksByPosLap{i}.bins;
% bins = bins + mean(diff(bins))/2;
% rZLocation = [50, 450];
% binsInRZBool = bins >= rZLocation(1) & bins <= rZLocation(2);
% binsInRZIndexes = find(binsInRZBool);
% binsInRZIndexes = find(bins >= rZLocation(1) & bins <= rZLocation(2));
% DinRZ = D(:, binsInRZBool);
% %these will result in the same DinRZ, one uses logical indexing, the other uses linear indexing
% DinRZ = D(:, binsInRZIndexes);
