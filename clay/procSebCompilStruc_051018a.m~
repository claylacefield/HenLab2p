
% Clay 2018
% process sebnem compilation structure for 3 session reward location switch



sess1rates = []; sess1fracPCs = [];
sess2rates = []; sess2fracPCs = [];
sess3rates = []; sess3fracPCs = [];

inCell = MoveADiPlaceInfo;
%inCell = MoveWTPlaceInfo;

for i = 1:length(inCell)
    filename = inCell{i}.filename;
    
    posRates = inCell{i}.PosRatePC;
    fracPCs = sum(inCell{i}.PlaceAnalysis.Shuff.isPC)/length(inCell{i}.PlaceAnalysis.Shuff.isPC);
    
    if strfind(filename, '1500-001')
        sess1rates = [sess1rates; posRates];
        sess1fracPCs = [sess1fracPCs fracPCs];
    elseif strfind(filename, '1500-002')
        sess2rates = [sess2rates; posRates];
        sess2fracPCs = [sess2fracPCs fracPCs];
    elseif ~isempty(strfind(filename, '0500-003')) || ~isempty(strfind(filename, '_500-001'))
        sess3rates = [sess3rates; posRates];
        sess3fracPCs = [sess3fracPCs fracPCs];
    end
end

figure;
hold on; 
plotMeanSEMshaderr(sess1rates', 'r');
plotMeanSEMshaderr(sess2rates', 'g');
plotMeanSEMshaderr(sess3rates', 'b');

figure; hold on;
bar(1:3, [mean(sess1fracPCs) mean(sess2fracPCs) mean(sess3fracPCs)]);
errorbar(1:3, [mean(sess1fracPCs) mean(sess2fracPCs) mean(sess3fracPCs)], [std(sess1fracPCs) std(sess2fracPCs) std(sess3fracPCs)],'.');
