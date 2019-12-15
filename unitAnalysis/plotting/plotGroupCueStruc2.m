function plotGroupCueStruc2(groupCueStruc, refLapType, usePC)

% for use with wrapCueShiftTuning

numLapTypes = length(groupCueStruc(1).pksCellCell);

if refLapType==0
    refLapType = findRefLapType(groupCueStruc(1)); % use ref lap from one with most laps
end

posRatesCell = cell(numLapTypes,1);
sessAvPosRatesCell = cell(numLapTypes,1);

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
    
    
    
    % now for all lap types with PCs
    for i = 1:numLapTypes
        %try
            posRates = groupCueStruc(j).PCLappedSessCell{i}.posRates;
            if usePC==1
                posRates = posRates(pc,:);
            end
            if length(posRatesCell)>0
            sessAvPosRatesCell{i} = [sessAvPosRatesCell{i}; mean(posRates,1)];
            posRatesCell{i} = [posRatesCell{i}; posRates];
            else
                sessAvPosRatesCell{i} = mean(posRates,1);
            posRatesCell{i} = posRates;
            end
        
%         catch
%             disp(['Prob with lap type ' num2str(i)]);
%         end
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
