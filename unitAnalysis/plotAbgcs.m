function plotAbgcs(A,C, abgcs)

d1= size(A,2);
d2= size(A,3);

abIm = zeros(d1, d2);

for i = 1:length(abgcs)
    segIm = squeeze(A(abgcs(i),:,:));
    abIm = abIm + segIm/max(segIm(:));
    
    abCa(i,:) = C(abgcs(i),:);
    
end

figure;
subplot(1,2,1);
%imagesc(abIm);
imshow(abIm);

for seg = 1:length(abgcs)
    spat = squeeze(A(abgcs(seg),:,:));
    [pk, ind] = max(spat(:));
    [y,x] = ind2sub([d1 d2],ind);
    text(x+10,y+10, sprintf('%d', abgcs(seg)), 'Units', 'data', 'Color', 'white');
end



%figure; 
subplot(1,2,2);
hold on;
for i = 1:length(abgcs)
plot(abCa(i,:)'+i/20);
text(50,i/20+0.02, sprintf('%d', abgcs(i)), 'Units', 'data');
end