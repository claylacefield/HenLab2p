cd 0117_4\
dir *csv

0117420170110150156.csv    0117_4_20170113192027.csv  0117_4_20170117170529.csv  0117_4_20170120140229.csv  
0117_4_20170111182106.csv  0117_4_20170114180108.csv  0117_4_20170118144102.csv  0117_4_20170120181034.csv  
0117_4_20170112162317.csv  0117_4_20170114193935.csv  0117_4_20170118144905.csv  0117_4_20170120194653.csv  
0117_4_20170112173809.csv  0117_4_20170114194721.csv  0117_4_20170118161415.csv  0117_4_20170120205350.csv  
0117_4_20170113172919.csv  0117_4_20170117105052.csv  0117_4_20170118174106.csv  
0117_4_20170113174102.csv  0117_4_20170117142514.csv  0117_4_20170118183148.csv  

d = dir('*csv)
edit LoadCSV1
csvNames = dir('*csv')

csvNames = 

22x1 struct array with fields:

    name
    date
    bytes
    isdir
    datenum

csvNames(1)

ans = 

       name: '0117420170110150156.csv'
       date: '22-Jan-2017 20:25:44'
      bytes: 56630
      isdir: 0
    datenum: 7.3672e+05

csvNames(2)

ans = 

       name: '0117_4_20170111182106.csv'
       date: '22-Jan-2017 20:25:49'
      bytes: 39288
      isdir: 0
    datenum: 7.3672e+05

csvNames(3)

ans = 

       name: '0117_4_20170112162317.csv'
       date: '22-Jan-2017 20:25:48'
      bytes: 48582
      isdir: 0
    datenum: 7.3672e+05

csvNames(2).date

ans =

22-Jan-2017 20:25:49

csvNames(2).name

ans =

0117_4_20170111182106.csv

1:length(csvNames)

ans =

  Columns 1 through 18

     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18

  Columns 19 through 22

    19    20    21    22

length(csvNames)

ans =

    22

LoadCSV1

behaviorCell = 

     {}

behaviorCell

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

d = behaviorCell{1}.data;
whos d
  Name         Size            Bytes  Class     Attributes

  d         2654x3             63696  double              

behaviorCell{1}.fileName

ans =

0117420170110150156.csv

behaviorCell{10}.fileName

ans =

0117_4_20170114194721.csv