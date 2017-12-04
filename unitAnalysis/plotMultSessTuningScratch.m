

%% plot mean greatSeg spikes/position over sessions

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

% normalized per session
for i = 1:length(multSessTuningStruc)
    av = avSpksG(:,i);
    av = av - nanmean(av);
    av = av/max(av);
    avSpksGn(:,i) = av;
end
figure;
imagesc(avSpksGn(200:end-1,:)');

%%

greatSegPosPks = multSessTuningStruc(i).goodSegPosPkStruc.greatSegPosPks;


pks = goodSegEvents{n};    % and the spike frNum
       
       ca = zeros(length(ca),1); % create vector of spikes from spk times
       ca(pks) = 1;
       [caPosVelStruc] = caVsPosVel(treadBehStruc, ca, numbins, 2);





