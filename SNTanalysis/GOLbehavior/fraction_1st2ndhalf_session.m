C = licksByPosLap{i}.counts;
%normalizing licks per bin by sum of entire bins in a row
a = sum(C, 2); %one column
A = repmat(a, [1, size(C, 2)]);  %repeatmatrix making copies of a such that it ends up being the same size as C
% repeat the 'a' vector, [1 row, size of (C,2's) columns] times
% , in brackets will be how many columns a row vectors will be copied
D = C./A; %%'./' means element-wise division
D(isnan(D)) = 0;


%make new rows with only first half and second half of the session
nLaps = size(D, 1);
firstHalfOfLaps = D(1:floor(nLaps/2), :); %half of the rows and all columns
secondHalfOfLaps = D((floor(nLaps/2) + 1):end, :); %this accounts for odd-numbered lap cases without double counting laps
%floor rounds something down


%averaging across rows for all columns 
E = mean(firstHalfOfLaps, 1);
F = mean(secondHalfOfLaps, 1);
figure; plot(licksByPosLap{1}.bins, E, 'b')
hold on; plot(licksByPosLap{1}.bins, F, 'r')