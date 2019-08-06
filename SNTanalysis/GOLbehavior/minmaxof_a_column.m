d = behaviorCell{1}.data;
min(d(:, 2))

ans =

        0.288

max(d(:, 2))

ans =

       2116.3

bins = linspace(min(d(:, 2)), max(d(:, 2)), 51);
h = histc(d(:, 2), bins);
whos h
  Name       Size            Bytes  Class     Attributes

  h         51x1               408  double              

figure; plot(h)
figure; plot(bins, h)
figure; plot(d(:, 2))