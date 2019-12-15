function plotDiffOmitPosRatesStruc(diffOmitPosRatesStruc)



numSess = length(diffOmitPosRatesStruc.dPFrateCell);
%range = [30 70];

pkPosPC = diffOmitPosRatesStruc.pkPosPC;
dPFratePC = diffOmitPosRatesStruc.dPFratePC;

%% for diff omit rate
figure; plot(pkPosPC, dPFratePC,'.');

    xlabel('pkPos'); ylabel('dPFrate');
    
    
    nBins = 20;
    [N, edges, bins] = histcounts(pkPosPC,nBins);
    for j=1:nBins
        binDiff = dPFratePC(bins==j);
        binDiffCell{j} = binDiff;
        avDiff(j) = nanmean(binDiff);
        semDiff(j) = nanstd(binDiff)/sqrt(length(binDiff));
        [h,pval(j)] = ttest(binDiff);
    end
    figure; bar(avDiff); hold on
    errorbar(avDiff, semDiff, '.');
    xlabel('posBin'); ylabel('mean diffOmit Rates/bin');
    %try title(filename); catch; end
    
    % 2D histogram
    x(:,1) = pkPosPC;
    x(:,2) = dPFratePC;
    N = hist3(x,[100 100]);
    N=N';
    N2 = N(end:-1:1,:);
    N3 = imgaussfilt(N2,2);
    figure; imagesc(N2);
    colormap(jet);
    caxis([0,25]);
    figure; imagesc(N3); colormap(jet); caxis([0.25,6]);
    title('dPFratePC');
%     for i=1:10; ylab{i}=10*i-50; end
%     set(gca, 'YTickLabel', ylab);
    %ylim([10 65]);
    
%% for relative omit rate (omit/norm)
    relPFratePC = diffOmitPosRatesStruc.relPFratePC;
    
figure; plot(pkPosPC, relPFratePC,'.');

    xlabel('pkPos'); ylabel('relPFratePC');
    
    
%     nBins = 20;
%     [N, edges, bins] = histcounts(pkPosPC,nBins);
    for j=1:nBins
        binRel = relPFratePC(bins==j);
        binRelCell{j} = binRel;
        avRel(j) = nanmean(binRel);
        semRel(j) = nanstd(binRel)/sqrt(length(binRel));
        [h,pval(j)] = ttest(binRel);
    end
    figure; bar(avRel); hold on
    errorbar(avRel, semRel, '.');
    xlabel('posBin'); ylabel('relative Omit Rates/bin');
    %try title(filename); catch; end
    
    % 2D histogram
    x(:,1) = pkPosPC;
    x(:,2) = relPFratePC;
    N = hist3(x,[100 100]);
    N=N';
    N2 = N(end:-1:1,:);
    N3 = imgaussfilt(N2,2);
    figure; imagesc(N2);
    colormap(jet);
    caxis([0,25]);
    figure; imagesc(N3); colormap(jet); caxis([0.25,6]);
    title('relPFratePC');
    
    
%     %% pvals based upon pos (not using right now)
%     
%     for i = 5:9
%         dRate = [dRate binDiffCell{i}];
%     end
%     n=0;
%     for i=7:17
%         n=n+1;
%         dR2 = binDiffCell{i};
%         [h,pvalDiff(n)] = ttest2(dRate, dR2);
%     end
%     
%     for i = 5:9 
%         rel = [rel binRelCell{i}]; 
%     end
%     n=0;
%     for i=7:17
%         n=n+1;
%     rel2 = binRelCell{i}; 
%     [h,pvalRel(n)] = ttest2(rel, rel2);
%     end
%     
%     figure; 
%     subplot(2,1,1);
%     bar(1./pvalDiff);
%     subplot(2,1,2);
%     bar(1./pvalRel);
    
    
%% some old plotting stuff that I may integrate at some point
%     shInds = 15:35; %17:37; % indices for shift window (around 25)
%     nshInds = 40:60; %42:62; % and non-shift (around 50, which is zero shift)
%     otherInds = setxor(setxor(1:100,shInds), nshInds);
%     nonShift = sum(N3(nshInds,:),1); % or mean % sum(N3(nshInds,:),1)./sum(N3,1);%
%     shift = sum(N3(shInds,:),1);    % or mean % sum(N3(shInds,:),1)./sum(N3,1);%
%     baseline = 0; %mean(N3(otherInds,:),1); %sum(N3(37:42,:),1)*4;
%     %shift = shift-sum(N2(37:42,:),1)*4 +mean(sum(N2(10:15,:),1))*4;
%     nonShift = nonShift-baseline; 
%     shift = shift-baseline;
%     figure; 
%     %plot(nonShift); 
%     plot(runmean(nonShift,2));
%     hold on;
%     %plot(shift,'g'); 
%     plot(runmean(shift,2),'g');
%     title('nonshift cells (b), shift cells (g)');
%     xlabel('pkPos');
%     ylabel('# cells/spatial bin');
    
%end