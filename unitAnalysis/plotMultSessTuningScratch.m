

% plot mean greatSeg spikes/position over sessions

colors = {'r', 'g', 'b'};
figure; hold on;
hsize = [1 200]; sigma = 40;
h = fspecial('gaussian', hsize, sigma);
for i = 1:length(multSessTuningStruc)
    greatSegPosPks = multSessTuningStruc(i).goodSegPosPkStruc.greatSegPosPks;
    av = mean(greatSegPosPks,1);
    avSpks(:,i) = decimate(av,2); %av;
    %fCaPos(i,:) = conv(segCaPos(i,:), h, 'same');
    avSpksG(:,i) = conv(interp1(1:20,decimate(av,2), 0:0.01:20, 'linear'), h, 'same');
    plot(decimate(av,2), colors{i});
    
end

figure; 
%plot(avSpksG(:,1));
imagesc(avSpksG(200:end-1,:)');




figure;
%avSpksG = 
imagesc(avSpks');

