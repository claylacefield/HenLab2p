function writeTifStack(Y, filename)

% clay 2016
% write an image matrix to a TIFF stack file

for i = 1:size(Y,3)
    
    if mod(i,100) == 0
        disp(['Saving frame number ' num2str(i) ' of ' num2str(size(Y,3))]);
    end
    
    imwrite(Y(:,:,i), filename, 'writemode', 'append');
end