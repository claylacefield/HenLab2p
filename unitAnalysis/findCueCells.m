function findCueCells(cueShiftStruc)

%% USAGE: findCueCells(cueShiftStruc);
% This calculates the shift in PC unit firing for single cueShift
% positions.

% take PCs from normal laps
pc = find(cueShiftStruc.PCLappedSessCell{1}.Shuff.isPC==1);

% extract posRates for all cells in diff lap types
posRates1 = cueShiftStruc.PCLappedSessCell{1}.posRates;
posRates2 = cueShiftStruc.PCLappedSessCell{2}.posRates;

% find the center of mass for each cell
com1 = centerOfMass(posRates1);
com2 = centerOfMass(posRates2);

com1=com1(pc); com2=com2(pc);   % and just use PCs

% difference in center of mass for each cell
dcom = com1-com2;

% plot lapType xcorr peak lags and plot
for i=1:length(pc)
   [val, lag] = max(xcorr(posRates1(pc(i),:),posRates2(pc(i),:))); 
   lags(i)=100-lag;
end
figure; plot(lags); title('xcorr lags by cell');

% bin diff center of mass
for i = 1:20 %length(dcom)
    binInds = find(com1>=((i-1)*5) & com1<(i*5)); % find cells with centerOfMass in this bin
    if length(binInds)>0
        binDcom(i)=nanmean(dcom(binInds)); % mean of diff(centerOfMass) for all cells with peak in this bin
    else
        binDcom(i)=0;
    end
end

figure; bar(binDcom); title('diff(centerOfMass) by position');
