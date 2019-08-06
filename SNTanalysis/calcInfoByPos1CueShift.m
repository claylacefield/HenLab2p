
% Firing rates around cues 
centers = [str2num(D1OmitCueShiftTuningStruc.cueMid1)];
posRates1 = D1OmitCueShiftTuningStruc.posRate1;
posRates2 = D1OmitCueShiftTuningStruc.posRate2;
% for i = 1:2
%     irPosRates1 = [irPosRates1; SortCueShiftTuningvsCOMStruc.(['IRposRate', int2str(i)])];
%     nirPosRates = [nirPosRates;SortCueShiftTuningvsCOMStruc.(['posRate', int2str(i)])];
% end
posRates1 = repmat(posRates1, [1, 3]);
posRates2 = repmat(posRates2, [1, 3]);

PosRates1 = [];
PosRates2 = [];
for i = 1:length(centers)
    PosRates1 = [PosRates1; circshift(posRates1, 50 - centers(i), 2)];
    PosRates2 = [PosRates2; circshift(posRates2, 50 - centers(i), 2)];
end

gaussHalfWidth = 5;
g1 = fspecial('Gaussian',[gaussHalfWidth*2 + 1, 1], 5)';
g2 = fspecial('Gaussian',[gaussHalfWidth*2 + 1, 1], 5)';
x = linspace(-1, 1, 101);
k = [zeros(100, 1); zeros(101, 1) + 1; zeros(99, 1)];
pr1ErrorBars = std(posRates1)/sqrt(length(posRates1));
%makeBootStrapEZ1(IrPosRates1, [97.5, 2.5], 1000);
% ir1ErrorBars = abs(ir1ErrorBars - repmat(nanmean(IrPosRates1), [2, 1]));
pr1ErrorBarsG = nanConvWith(pr1ErrorBars', g2)';
pr1InG = nanConvWith(nanmean(PosRates1)', g2)';

figure; shadedErrorBarAG(x , pr1InG(k == 1), pr1ErrorBarsG(:, k == 1), 'r', 1)

pr2ErrorBars = std(posRates2)/sqrt(length(posRates2));
%makeBootStrapEZ1(IrPosRates2, [97.5, 2.5], 1000);
% ir2ErrorBars = abs(ir2ErrorBars - repmat(nanmean(IrPosRates2), [2, 1]));
pr2ErrorBarsG = nanConvWith(pr2ErrorBars', g2)';
pr2InG = nanConvWith(nanmean(PosRates2)', g2)';
hold on; shadedErrorBarAG(x , pr2InG(k == 1), pr2ErrorBarsG(:, k == 1), 'k', 1)

xlim([-0.5, 0.5]);
ylabel('Firing Rate (Hz.)')
xlabel('Distance From Cue (m)');
yL = get(gca, 'YLim');
hold on; plot([0, 0], yL, ':k');
ylim(yL);


%% for normalized spatial info
ComZ2 = []; ComZ1 = [];
ComZ1 = [D3ShiftCueRewTuningStruc.COM1, D3ShiftCueRewTuningStruc.Z1];
ComZ2 = [D3ShiftCueRewTuningStruc.COM2, D3ShiftCueRewTuningStruc.Z2];

ComZ1 = ComZ1(ComZ1(:, 2) < 30, :);
ComZ2 = ComZ2(ComZ2(:, 2) < 30, :);
z1 = nan(length(ComZ1), 100);
for i = 1:length(ComZ1)
    z1(i, ComZ1(i, 1)) = ComZ1(i, 2);
end
z2 = nan(length(ComZ2), 100);
for i = 1:length(ComZ2)
    z2(i, ComZ2(i, 1)) = ComZ2(i, 2);
end


gaussHalfWidth = 5;
g1 = fspecial('Gaussian',[gaussHalfWidth*2 + 1, 1], 5)';
g2 = fspecial('Gaussian',[gaussHalfWidth*2 + 1, 1], 5)';
z1 = nan(length(ComZ1), 300);
for i = 1:length(ComZ1)
    for ii = 1:3
        ind = ComZ1(i, 1) + (ii - 1)*100;
        ind = [ind - gaussHalfWidth, ind + gaussHalfWidth];
        if ind(1) >= 1 & ind(2) <= 300
            z1(i, ind(1):ind(2)) = ComZ1(i, 2).*g1;
        end
    end
end
z2 = nan(length(ComZ2), 300);
for i = 1:length(ComZ2)
    for ii = 1:3
        ind = ComZ2(i, 1) + (ii - 1)*100;
        ind = [ind - gaussHalfWidth, ind + gaussHalfWidth];
        if ind(1) >= 1 & ind(2) <= 300
            z2(i, ind(1):ind(2)) = ComZ2(i, 2).*g1;
        end
    end
end

%% Calc confidence interval and recenter on cues
centers = [str2num(D3ShiftCueRewTuningStruc.cueMid1)];
Z1 = []; Z2 = [];
for i = 1:length(centers)
    Z1 = [Z1; circshift(z2, 50 - centers(i), 2)];
    Z2 = [Z2; circshift(z1, 50 - centers(i), 2)];
end

x = linspace(-1, 1, 101);
k = [zeros(100, 1); zeros(101, 1) + 1; zeros(99, 1)];
irErrorBars = makeBootStrapEZ1(Z1, [95, 5], 1000);
irErrorBars = abs(irErrorBars - repmat(nanmean(Z1), [2, 1]));
irErrorBarsG = nanConvWith(irErrorBars', g2)';
irInG = nanConvWith(nanmean(Z1)', g2)';


figure; shadedErrorBarAG(x , irInG(k == 1), irErrorBarsG(:, k == 1), 'r', 1)

nirErrorBars = makeBootStrapEZ1(Z2, [97.5, 2.5], 1000);
nirErrorBars = abs(nirErrorBars - repmat(nanmean(Z2), [2, 1]));
nirErrorBarsG = nanConvWith(nirErrorBars', g2)';
nirInG = nanConvWith(nanmean(Z2)', g2)';
hold on; shadedErrorBarAG(x , nirInG(k == 1), nirErrorBarsG(:, k == 1), 'k', 1)

xlim([-0.5, 0.5]);
ylabel('Spatial Information (norm. bit/sec.)')
xlabel('Distance From Cue (m)');
yL = get(gca, 'YLim');
hold on; plot([0, 0], yL, ':k');
ylim(yL);


%% Get normalized info for cue adjacent cells
k1 = ComZ1(:, 1) >= 95 | ComZ1(:, 1) <= 5;
k2 = ComZ1(:, 1) >= 45 & ComZ1(:, 1) <= 55;
nirComZCue = ComZ1(k1 | k2, :);
k1 = ComZ2(:, 1) >= 95 | ComZ2(:, 1) <= 5;
k2 = ComZ2(:, 1) >= 45 & ComZ2(:, 1) <= 55;
irComZCue = ComZ2(k1 | k2, :);

set(gcf, 'Renderer', 'painters')