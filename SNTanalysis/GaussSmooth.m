%gaussian smoothing
g = fspecial ('gaussian', [10, 1], 5); %figure;plot(g) will give you width of the kernel
bin=1:100;
COMIR123= [cumIRposRateCOMs1; cumIRposRateCOMs2; cumIRposRateCOMs3];
comIR123 = histc(COMIR123,bin);
SmcomIR123 = convWith([comIR123; comIR123; comIR123],g);
k = [zeros(length(comIR123), 1); zeros(length(comIR123), 1) + 1; zeros(length(comIR123), 1)];
SmcomIR123 = SmcomIR123(k == 1);

COM123= [cumposRateCOMs1; cumposRateCOMs2; cumposRateCOMs3];
com123 = histc(COM123,bin);
k = [zeros(length(com123), 1); zeros(length(com123), 1) + 1; zeros(length(com123), 1)];
Smcom123 = convWith([com123; com123; com123],g);
Smcom123 = Smcom123(k == 1);

figure; plot(Smcom123/sum(Smcom123),'k-', 'LineWidth', 2); hold on; plot (SmcomIR123/sum(SmcomIR123),'-r', 'LineWidth', 2);

