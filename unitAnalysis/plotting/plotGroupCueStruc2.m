function [posRatesCell] = plotGroupCueStruc2(groupCueStruc, refLapType, usePC, toNorm)

% for use with wrapCueShiftTuning, compileCueShiftStrucAutoDay

%numLapTypes = length(groupCueStruc(1).pksCellCell);

if refLapType==0
    refLapType = findRefLapType(groupCueStruc(1)); % use ref lap from one with most laps
end

posRatesCell = {}; %cell(numLapTypes,1);
sessAvPosRatesCell = {}; %cell(numLapTypes,1);

for j = 1:length(groupCueStruc)
    % select place cells
    if usePC==2  % Now compile PCs from all types
        pc=[];
        for i=1:length(groupCueStruc(1).PCLappedSessCell)
            pcType = find(groupCueStruc(j).PCLappedSessCell{i}.Shuff.isPC==1);
            %pcType = find(cueShiftStruc.PCLappedSessCell{i}.InfoPerSpk>=3.5);
            pc = [pc; pcType];
        end
        pc = sort(unique(pc));
    else
        pc = find(groupCueStruc(j).PCLappedSessCell{refLapType}.Shuff.isPC==1);
    end
    
    numLapTypes = length(groupCueStruc(j).pksCellCell);
    goodLapTypes = 0;
    
    % now for all lap types with PCs
    for i = 1:numLapTypes

        try
            posRates = groupCueStruc(j).PCLappedSessCell{i}.posRates; % this fails for bad lap types
            goodLapTypes = goodLapTypes+1;
            if usePC==1
                posRates = posRates(pc,:);
            end
            if toNorm==1
                for k=1:size(posRates,1)
                   posRates(k,:) = posRates(k,:)/max(posRates(k,:)); 
                end
            end
            if length(posRatesCell)>=goodLapTypes
                sessAvPosRatesCell{goodLapTypes} = [sessAvPosRatesCell{goodLapTypes}; nanmean(posRates,1)];
                posRatesCell{goodLapTypes} = [posRatesCell{goodLapTypes}; posRates];
            else
                sessAvPosRatesCell{goodLapTypes} = nanmean(posRates,1);
                posRatesCell{goodLapTypes} = posRates;
            end
            
        catch
            disp(['Prob with lap type ' num2str(i)]);
        end
    end
    
end

%% Sort units
% find PCs and posRates for reference lap type
posRates = posRatesCell{refLapType};

% if usePC == 1
%     posRates = posRates(pc,:);
% end

[maxVal, maxInd] = max(posRates');
[newInd, oldInd] = sort(maxInd);
sortInd = oldInd;
% posRates = posRates(sortInd,:);
% posRatesCell{refLapType} = posRates;


%%
figure('Position', [0 0 1000 800]);

numCols = ceil((numLapTypes+2)/2);

lapTypeList = 1:numLapTypes;
if refLapType~=1
    lapTypeList = [refLapType lapTypeList(lapTypeList~=refLapType)];
end

for i = 1:numLapTypes
    j = lapTypeList(i);
    try
        subplot(2,numCols,i);
        colormap(hot);
        posRates = posRatesCell{j};
        imagesc(posRates(sortInd,:));
        %colorbar;
        xlabel('position');
        if i==1
            if length(toNorm)==1
            cl = caxis;
            else
                caxis(toNorm);
                cl = caxis;
            end
            title(groupCueStruc(1).filename(1:6));
        else
            caxis(cl);
            title(['LapType '  num2str(j)]);
        end
        
%         if i==numLapTypes
%             colorbar;
%         end

    catch
    end
    %numCell{i}=num2str(j);
end

% and mean of each
subplot(2,numCols,numLapTypes+1); hold on;
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k'};
for i = 1:numLapTypes
    try
        plot(nanmean(posRatesCell{i},1), colors{i});
    catch
    end
    numCell{i}=num2str(i);
end
%title('posRates1=b, posRates2=g');
legend(numCell);
ylabel('mean rate');
xlabel('position');

% and mean of each
subplot(2,numCols,numLapTypes+2); 
%figure;
hold on;
%colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k'}; %jet(numLapTypes);
for i = 1:numLapTypes
    %try
        plotMeanSEMshaderr(sessAvPosRatesCell{i}',colors{i});
%     catch
%     end
    numCell{i}=num2str(i);
end
ylabel('mean rate');
xlabel('position');