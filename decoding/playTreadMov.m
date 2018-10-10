function playTreadMov(pos)

%
% Function to play a movie of mouse positions






figure('pos', [50,50,2400,200]);
xlim([0 2200]);
rectangle('Position', [0,0,2200,100]);
hold on;

for i = 1:length(pos)
    try
        cla;
    rectangle('Position', [0,0,2200,100]);
    rectangle('Position', [pos(i)-25,0,50,100], 'FaceColor', 'r');
    pause(1/15);
    catch
    end
end




