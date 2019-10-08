function [PCLapped1] = calcWithinSessStability(CueOmitLappedSess)
gPosRate = fspecial('Gaussian',[15, 1], 5);
goodBins = [zeros(100, 1); zeros(100, 1) + 1; zeros(100, 1)];
for S = 1:length(CueOmitLappedSess)
     PCLapped1{S}=CueOmitLappedSess{S}.PCLappedSessCue;
PCLappedSessOmit= CueOmitLappedSess{S}.PCLappedSessOmit;
        PCLapped1{S}.StabilityOE = [];
        PCLapped1{S}.StabilityFL = [];
        PCLapped1{S}.CorrToLapNum = [];
        for i = 1:length(PCLapped1{S}.Shuff.isPC)
            posRateBL = squeeze(PCLapped1{S}.ByLap.posRateRawByLap(i, :, :));
            posRateBL = posRateBL.*PCLapped1{S}.ByLap.rawOccuByLap';
                        
            n = 1:size(posRateBL, 2);
            
            rateByLap = nansum(posRateBL, 1)./nansum(PCLapped1{S}.ByLap.rawOccuByLap', 1);
            a = [n', rateByLap'];
            a = a(sum(isnan(a), 2) == 0, :);
            r = corrcoef(a);
            
            PCLapped1{S}.CorrToLapNum = [PCLapped1{S}.CorrToLapNum; r(1, 2)];
            
            kEven = mod(n, 2) == 0;
            kOdd = mod(n, 2) == 1;
            kFirst = 1:floor(length(n)/2);
            kLast = (floor(length(n)/2) + 1):length(n);
            
            evenField = nansum(posRateBL(:, kEven), 2)./nansum(PCLapped1{S}.ByLap.rawOccuByLap(kEven, :)', 2);
            oddField = nansum(posRateBL(:, kOdd), 2)./nansum(PCLapped1{S}.ByLap.rawOccuByLap(kOdd, :)', 2);
            firstField = nansum(posRateBL(:, kFirst), 2)./nansum(PCLapped1{S}.ByLap.rawOccuByLap(kFirst, :)', 2);
            lastField = nansum(posRateBL(:, kLast), 2)./nansum(PCLapped1{S}.ByLap.rawOccuByLap(kLast, :)', 2);
            
            allFields = [evenField, oddField, firstField, lastField];
            
            %%smoothing
            allFields = convWith(repmat(allFields, [3, 1]), gPosRate);
            allFields = allFields(goodBins == 1, :);
            
            rEO = nanCorrSimple(allFields(:, 1:2));
            rFL = nanCorrSimple(allFields(:, 3:4));
            PCLapped1{S}.StabilityOE = [PCLapped1{S}.StabilityOE; rEO(1, 2)];
            PCLapped1{S}.StabilityFL = [PCLapped1{S}.StabilityFL; rFL(1, 2)];
        end
    end
