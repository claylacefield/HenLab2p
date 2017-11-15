function out = convWith(sp, win1)
%function out = convWith(sp, win1) - win1 convtrimmed with collumns of sp

out = zeros(size(sp));
for I = 1:size(sp, 2)

    out(:, I) = convtrim(sp(:, I), win1);
end
out = out/sum(win1);