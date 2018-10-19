function playTreadMov(pos, varargin)

%
% Function to play a movie of mouse positions


if nargin==2
    pos2=varargin{1};
end



figure('pos', [50,50,2400,400]);
subplot(2,1,1);
plot(pos);
hold on;
if nargin==2
plot(pos2, 'r');
end

subplot(2,1,2);
xlim([0 2200]);
rectangle('Position', [0,0,2200,100]);
hold on;

for i = 1:length(pos)
    try
        cla;
    rectangle('Position', [0,0,2200,100]);
    rectangle('Position', [pos(i)-25-min(pos),0,50,100], 'FaceColor', 'b');
    if nargin==2
        rectangle('Position', [pos2(i)-10-min(pos),0,20,100], 'FaceColor', 'r');
    end
    pause(1/15);
    catch
    end
end




