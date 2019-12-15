function plotEvTrigSigCell(evTrigSigCell, colors)


figure('Position', [100 100 1200 400]); 

t = linspace(-2,12,211);

subplot(1,2,1); hold on;
for i = 1:length(evTrigSigCell)
    evSig = evTrigSigCell{i};
    av = min(evSig(:)); % actually using min not mean
    evCell{i} = (evSig-av)/av;
    plot(t,evCell{i},colors{i});
end
yl = ylim;
line([0 0], yl, 'Color', [0.5 0.5 0.5]);
xlim([-2 12]);
xlabel('sec');
ylabel('dF/F');

subplot(1,2,2); hold on;
for i=1:length(evTrigSigCell)
    plotMeanSEMshaderr(evCell{i},colors{i}, 30, t);
end
yl = ylim;
line([0 0], yl, 'Color', [0.5 0.5 0.5]);
xlim([-2 12]);
xlabel('sec');
ylabel('dF/F');






