m = [];
for j = 1:length(behaviorCell)
med = median(behaviorCell{j}.data(:, 2));
m = [m; med];
end

 
m = [];
for j = 1:length(behaviorCell)
med = median(behaviorCell{j}.data(:, 2));
m = [m; med];
end
m

m =

       1234.9
       1342.5
       419.61
       1142.6
       1721.1
       1871.1
       907.84
       1210.8
       1175.7
       1061.8
       1038.8
       1069.5
       1087.6
       966.19
       921.43
       1007.1
       1125.7
       1256.2
         1160
       947.62
       1093.1
       1034.3

f = [1; 3; 5]

f =

     1
     3
     5

[f; 7]

ans =

     1
     3
     5
     7

f = [f; 7]

f =

     1
     3
     5
     7

f = [f; 7]

f =

     1
     3
     5
     7
     7

f = [f; 7]

f =

     1
     3
     5
     7
     7
     7

med = median(behaviorCell{1}.data(:, 2));
med

med =

       1234.9

behaviorCell{1}.med = med

behaviorCell = 

  Columns 1 through 7

    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]

  Columns 8 through 14

    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]

  Columns 15 through 21

    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]    [1x1 struct]

  Column 22

    [1x1 struct]

behaviorCell{1}

ans = 

        data: [2654x3 double]
    fileName: '0117420170110150156.csv'
         med: 1234.9

d = behaviorCell{1}.data;
whos d
  Name         Size            Bytes  Class     Attributes

  d         2654x3             63696  double              

d = [d, '0']
Error using horzcat
Dimensions of matrices being concatenated are not consistent.
 
d = [d, 0]
Error using horzcat
Dimensions of matrices being concatenated are not consistent.
 
Y = zeros(size(d, 1), 1);
size(d, 1)

ans =

        2654

size(d, 2)

ans =

     3

whos d
  Name         Size            Bytes  Class     Attributes

  d         2654x3             63696  double              

d = behaviorCell{1}.data;
Y = zeros(size(d, 1), 1);
d = [d, Y];
whos d
  Name         Size            Bytes  Class     Attributes

  d         2654x4             84928  double              

d = [d, Y];
whos d
  Name         Size             Bytes  Class     Attributes

  d         2654x5             106160  double    