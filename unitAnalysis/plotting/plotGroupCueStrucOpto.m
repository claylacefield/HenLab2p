function plotGroupCueStruc2(groupCueStruc, refLapType, usePC)

% for use with wrapCueShiftTuning, compileCueShiftStrucAutoDay

%numLapTypes = length(groupCueStruc(1).pksCellCell);

if refLapType==0
    refLapType = findRefLapType(groupCueStruc(1)); % use ref lap from one with most laps
end

posRatesCell = {}; %cell(numLapTypes,1);
sessAvPosRatesCell = {}; %cell(numLapTypes,1);

for j = 1:length(groupCueStruc)
    % select place cells
    pc = find(groupCueStruc(j).PCLappedSessCell{refLapType}.Shuff.isPC==1);
    % Now compile PCs from all types
    % pc=[];
    % for i=1:numLapTypes
    %     pcType = find(cueShiftStruc.PCLappedSessCell{i}.Shuff.isPC==1);
    %     %pcType = find(cueShiftStruc.PCLappedSessCell{i}.InfoPerSpk>=3.5);
    %     pc = [pc; pcType];
    % end
    % pc = sort(unique(pc));
    
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
            if length(posRatesCell)>=goodLapTypes
                sessAvPosRatesCell{goodLapTypes} = [sessAvPosRatesCell{goodLapTypes}; mean(posRates,1)];
                posRatesCell{goodLapTypes} = [posRatesCell{goodLapTypes}; posRates];
            else
                sessAvPosRatesCell{goodLapTypes} = mean(posRates,1);
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

pkRates = posRates(:,maxInd-10:maxInd+10);

cueCellInds = find(maxInd>40 & maxInd<70);
posRates2 = posRates(cueCellInds,:);
posRates2b = posRatesCell{3}(cueCellInds,:);
[maxVal2, maxInd2] = max(posRates2');
for cellN = 1:size(posRates2,1)
dPFrates(cellN) = mean(posRates2b(cellN,maxInd2(cellN)-10:maxInd2(cellN)+10)) - mean(posRates2(cellN,maxInd2(cellN)-10:maxInd2(cellN)+10));
PFrates(cellN) = mean(posRates2(cellN,maxInd2(cellN)-10:maxInd2(cellN)+10));
end

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
        colormap(jet);
        posRates = posRatesCell{j};
        imagesc(posRates(sortInd,:));
        %colorbar;
        xlabel('position');
        if i==1
            cl = caxis;
            %title(cueShiftStruc.filename(1:strfind(cueShiftStruc.filename,'cueShift')-2));
        else
            caxis(cl);
            title(['LapType '  num2str(j)]);
        end

    catch
    end
    %numCell{i}=num2str(j);
end

% and mean of each
subplot(2,numCols,numLapTypes+1); hold on;
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k'};
for i = 1:numLapTypes
    try
        plot(mean(posRatesCell{i},1), colors{i});
    catch
    end
    numCell{i}=num2str(i);
end
%title('posRates1=b, posRates2=g');
legend(numCell);

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
