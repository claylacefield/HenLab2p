
%generalize averaging of session halves, across all sessions in licksByPosLap:
normLickingPZ = [];
normLickingFirstHalfAvg = [];
normLickingSecHalfAvg = [];
rRZLocationsAll = [451, 600; 451, 600; 1500, 1650; 451, 600; 451, 600; 1500, 1700; 451, 600; 400, 600]; % write down the range of rew zones from all sessions
for i = 1:length(licksByPosLap)
C = licksByPosLap{i}.counts;
a = sum(C, 2);

bins = licksByPosLap{i}.bins;  % determine the range of bins to consider
bins = bins + mean(diff(bins))/2;

rRZLocation = rRZLocationsAll(i, :);
binsInRZBool = bins >= rRZLocation(1) & bins <= rRZLocation(2);
binsInRZIndexes = find(binsInRZBool);
%binsInRZIndexes = find(bins >= rZLocation(1) & bins <= rZLocation(2));
DinRZ = sum(C(:, binsInRZBool),2);
a = a - DinRZ;

D = C./repmat(a, [1, size(C, 2)]); % normalize each bin by lap total
D(isnan(D)) = 0;

bins = licksByPosLap{i}.bins;  % determine the range of bins to consider
bins = bins + mean(diff(bins))/2;
rPLocationsAll = [1000, 2000; 1000, 2000; 0, 1000; 1000, 2000; 1000, 2000; 0, 1000; 1000, 2000; 1000, 2000]; % write down the range of preRewZone from all sessions
rPLocation = rPLocationsAll(i, :);
binsInCPBool = bins >= rPLocation(1) & bins <= rPLocation(2);
binsInRPIndexes = find(binsInCPBool);
%binsInRZIndexes = find(bins >= rZLocation(1) & bins <= rZLocation(2));
DinPZ = D(:, binsInCPBool);
                        
% 1:floor(sizeD,1)/2 is the first half of all laps
% sum all the bins within range
% deteremine the mean of sum

PZoneLicks = sum(D(:, binsInCPBool), 2);
PZoneLicks = mean(PZoneLicks);
firstHalfOfLapsC1 = sum(D(1:floor(size(D, 1)/2), binsInCPBool), 2);
firstHalfOfLapsC1 = mean(firstHalfOfLapsC1);
secHalfOfLapsC1 = sum(D((floor(size(D, 1)/2) + 1):end, binsInCPBool), 2);
secHalfOfLapsC1 = mean(secHalfOfLapsC1);
normLickingPZ = [normLickingPZ; PZoneLicks]
normLickingFirstHalfAvg = [normLickingFirstHalfAvg; firstHalfOfLapsC1];
normLickingSecHalfAvg = [normLickingSecHalfAvg; secHalfOfLapsC1];
end
IR_C1 = normLickingPZ
T1_IR_C1 = normLickingFirstHalfAvg
T2_IR_C1 = normLickingSecHalfAvg
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
