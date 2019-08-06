figure; imagesc(licksByPosLap{22}.bins, size(licksByPosLap{22}.bins, 1), licksByPosLap{22}.counts)
rewardZone = [1480, 1700];
bins = licksByPosLap{22}.bins;
kBins = bins >= rewardZone(1) & bins <= rewardZone(2);
kBins

kBins =

  Columns 1 through 22

     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0

  Columns 23 through 44

     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     0     0     0

  Columns 45 through 50

     0     0     0     0     0     0