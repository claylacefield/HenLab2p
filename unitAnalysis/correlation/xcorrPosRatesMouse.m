function [xcorrShiftStruc] = xcorrPosRatesMouse()

%% USAGE: [xcorrShiftStruc] = xcorrPosRatesMouse();

toPlot=1;

mousePath = uigetdir(); % select dir of days folder, e.g. Backup20TB/clay/DGdata
cd(mousePath);
mouseDir = dir;

pkShiftPC = []; % initialize output arrays
pkShiftCell = {};
pkPosPC = [];
pkPosCell = {};
pathCell = {}; cueShiftNameCell={};
posBinFracCell={}; posInfoCell={};

for j=3:length(mouseDir)    % go through all days
    dayName = mouseDir(j).name;
    try
        cd([mousePath '/' dayName]);
        dayDir = dir;
        
        for i = 3:length(dayDir) % and all sessions
            try
                if (contains(dayDir(i).name, '18') || contains(dayDir(i).name, '19') || contains(dayDir(i).name, '20')) %&& contains(dayDir(i).name, 'mit')
                    cd([mousePath '/' dayName '/' dayDir(i).name]);
                    %sessDir = dir;
                    cueShiftStrucName = findLatestFilename('cueShiftStruc'); % load latest cueShiftStruc
%                     if ~isempty(cueShiftStrucName)
%                         load(cueShiftStrucName);
%                     else
%                         [cueShiftStruc, pksCell] = quickTuning();
%                         cueShiftStrucName = findLatestFilename('cueShiftStruc');
%                     end
                    
                    load(cueShiftStrucName);
                    
                    % make sure it's cueShift
                    if contains(dayDir(i).name, 'hift') %&& ~isempty(find(lapTypeArr==0)) || contains(dayDir(i).name, 'mit') || 
                        disp(['Processing Omit file ' dayDir(i).name]); tic;
                        toPlot=0; 
                        [pkShiftPCsess, pkPosPCsess] = xcorrPosRates(cueShiftStruc, toPlot); % main function, xcorr posRates for normal/shift
                        
                        % save session data to output arrays
                        pkShiftPC = [pkShiftPC pkShiftPCsess]; % shift magnitude for all cells
                        pkShiftCell = [pkShiftCell pkShiftPCsess];
                        pkPosPC = [pkPosPC pkPosPCsess];    % posRate pk pos for all cells
                        pkPosCell = [pkPosCell pkPosPCsess];
                        currPath = pwd;
                        pathCell = [pathCell; currPath]; % just save path and name for each session used
                        cueShiftNameCell = [cueShiftNameCell; cueShiftStrucName];

                    else
                        disp([dayDir(i).name ' is not cueShift']);
                    end
                end
            catch
                disp(['Some problem processing ' dayDir(i).name ' so skipping']);
            end
            cd([mousePath '/' dayName]);
        end
        
    catch
        disp(['Prob processing so moving to next directory']);
    end
    
    cd(mousePath);
    
end

% pack all vars in output struc
xcorrShiftStruc.pathCell = pathCell;
xcorrShiftStruc.cueShiftNameCell = cueShiftNameCell;
xcorrShiftStruc.pkShiftPC = pkShiftPC;
xcorrShiftStruc.pkShiftCell = pkShiftCell;
xcorrShiftStruc.pkPosPC = pkPosPC;
xcorrShiftStruc.pkPosCell = pkPosCell;


%% save and plot
try
    
save(['xcorrShiftStruc_' date '.mat'], 'xcorrShiftStruc');

if toPlot
    
    figure; plot(pkPosPC, pkShiftPC,'.');
    %try title(filename); catch; end
    xlabel('pkPos'); ylabel('pkShift');
    
    
    nBins = 20;
    [N, edges, bins] = histcounts(pkPosPC,nBins);
    for j=1:nBins
        binPkShift = pkShiftPC(bins==j);
        avShift(j) = nanmean(binPkShift);
        semShift(j) = nanstd(binPkShift)/sqrt(length(binPkShift));
        [h,pval(j)] = ttest(binPkShift);
    end
    figure; bar(avShift); hold on
    errorbar(avShift, semShift, '.');
    xlabel('posBin'); ylabel('xcorr pk shift (bins out of 100)');
    %try title(filename); catch; end
    
    % 2D histogram
    x(:,1) = pkPosPC;
    x(:,2) = pkShiftPC;
    N = hist3(x,[100 100]);
    N=N';
    N2 = N(end:-1:1,:);
    N3 = imgaussfilt(N2,2);
    figure; imagesc(N2);
    colormap(jet);
    caxis([0,25]);
    figure; imagesc(N3); colormap(jet); caxis([0.25,12]);
    for i=1:10; ylab{i}=10*i-50; end
    set(gca, 'YTickLabel', ylab);
    %ylim([10 65]);
    
    shInds = 15:35; %17:37; % indices for shift window (around 25)
    nshInds = 40:60; %42:62; % and non-shift (around 50, which is zero shift)
    otherInds = setxor(setxor(1:100,shInds), nshInds);
    nonShift = sum(N3(nshInds,:),1); % or mean % sum(N3(nshInds,:),1)./sum(N3,1);%
    shift = sum(N3(shInds,:),1);    % or mean % sum(N3(shInds,:),1)./sum(N3,1);%
    baseline = 0; %mean(N3(otherInds,:),1); %sum(N3(37:42,:),1)*4;
    %shift = shift-sum(N2(37:42,:),1)*4 +mean(sum(N2(10:15,:),1))*4;
    nonShift = nonShift-baseline; 
    shift = shift-baseline;
    figure; 
    %plot(nonShift); 
    plot(runmean(nonShift,2));
    hold on;
    %plot(shift,'g'); 
    plot(runmean(shift,2),'g');
    title('nonshift cells (b), shift cells (g)');
    xlabel('pkPos');
    ylabel('# cells/spatial bin');
    
end


catch
end



