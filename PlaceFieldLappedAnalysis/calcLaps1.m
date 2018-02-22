function [lapVec, lapInts] = calcLaps1(treadPos, T);
%function [lapVec, lapInts] = calcLaps1(treadPos, T);




d1 = diff(treadPos);
d1 = [0, d1, 0];
ints1 = suprathresh(diff(treadPos), -0.5);
ints1(ints1 > length(treadPos)) = length(treadPos);

lapInts = [];
lapVec = NaN(size(treadPos));

tInt1 = [T(ints1(:, 1))', T(ints1(:, 2))'];
ints1 = ints1(diff(tInt1, [], 2) > 0, :);
tInt1 = tInt1(diff(tInt1, [], 2) > 0, :);
ints1(:, 2) = ints1(:, 2) + 1;

c = 1;
for i = 1:size(ints1, 1)
    h = histc(treadPos(ints1(i, 1):ints1(i, 2)), 0:0.01:1);
    if mean(h > 0) >= 0.5
        lapInts = [lapInts; tInt1(i, :)];
        lapVec(ints1(i, 1):ints1(i, 2)) = c;
        c = c + 1;
    end
end
    