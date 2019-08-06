C = licksByPosLap{i}.counts;

%figure; bar(licksByPosLap{i}.bins, a) %%x axis is dimention of bins
%figure; bar(a)

%Method 1 : fraction of licks in the lap per bin
a = sum(C, 2); %%sum across columns (summing btween columns in one row) is done as funct(matrix, 2)
D = C;  %%D will be the normalized matrix --> by dividing all the columns (bins) within a row with the sum of that row
for i = 1:size(D, 1)% 1:size(D,1) function will go thru all the rows in D, lap1,2.. to end  
D(i, :) = D(i, :)/a(i); %% new columns in all rows of D (D(i,:)) is calc.
%%by dividing all of the column vectors within D rows (D(i,:)) with the a(i) column vector
%%*can divide columns with columns 
%%**this could be problematic cus 0/0=NaN, n/0=infin, -n/0=-infin
end

% Method 2
C = licksByPosLap{i}.counts;
a = sum(C, 2); %one column
A = repmat(a, [1, size(C, 2)]);  %repeatmatrix making copies of a such that it ends up being the same size as C
% repeat the 'a' vector, [1 row, size of (C,2's) columns] times
% , in brackets will be how many columns a row vectors will be copied
D = C./A; %%'./' means element-wise division
