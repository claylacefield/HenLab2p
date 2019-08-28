
    %%
    PCMatchedAll = remapStruc.PCMatchedAll;

    %sort second column and match 1 and 3 accordingly:
    [~, s1] = nanmax(PCMatchedAll{2}, [], 2);
    [~, s2] = sort(s1);
    for i = 1:length(PCMatchedAll)
        PCMatchedAll{i} = PCMatchedAll{i}(s2, :);
    end
    figure;
    maxRate = Inf;
    CLims = [0, 0.44];
    
    for i = 1:3
        subplot(1, 3, i);
        c = PCMatchedAll{i}; 
        c(c > maxRate) = maxRate;
        imagesc(c);
        set(gca, 'CLim', CLims);
    end
    suptitle('nonNormRates');
   % colormap hot;
   %%
   figure;
bar([nanmean(AllCtxBootstrapStruc.PCAnyCorrCoef121323(:,1)) nanmean(AllIRCtxBootstrapStruc.PCAnyCorrCoef121323(:,1)) nanmean(AllCtxBootstrapStruc.PCAnyCorrCoef121323(:,3)) nanmean(AllIRCtxBootstrapStruc.PCAnyCorrCoef121323(:,3))]);

