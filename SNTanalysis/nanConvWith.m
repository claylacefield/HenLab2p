function out = nanConvWith(sp, win1)
%function out = nanConvWith(sp, win1) - win1 convtrimmed with collumns of sp

out = zeros(size(sp));
for I = 1:size(sp, 2)

    out(:, I) = nanconv(sp(:, I), win1, 'nanout', '1d');
end
out = out/sum(win1);