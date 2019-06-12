for i = 1:length (multSessSegStruc)
temp = multSessSegStruc(i).A;
temp = temp';
temp = full(temp);
footprints = reshape(temp,size(temp,1),multSessSegStruc(i).d1,multSessSegStruc(i).d2);
save(['footprints' num2str(i)],'footprints')
end