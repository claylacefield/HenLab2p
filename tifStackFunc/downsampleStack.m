function [Y] = downsampleStack(Y, spatDs, tempDs)

[ydim, xdim, t] = size(Y);

tic;
if spatDs > 1
    disp(['Downsampling spatial by ' num2str(spatDs) 'x']);
    spatDs = 1/spatDs;
    for frNum = 1:t
        Y2(:,:,frNum) = imresize(Y(:,:,frNum),spatDs);
    end
else
    disp('No spatial downsampling');
    Y2 = Y;
end
toc;

[ydim, xdim, t] = size(Y2);


tic;
if tempDs >1
    disp(['Downsampling temporal by ' num2str(tempDs) 'x']); 
    Y3 = reshape(Y2, (ydim*xdim), t);
    Y4 = zeros((ydim*xdim), t/tempDs);
    for pixNum = 1:size(Y3,1)
        Y4(pixNum,:) = decimate(double(Y3(pixNum,:)), tempDs);
    end
    Y = reshape(Y4,ydim, xdim, t/tempDs);
else
    disp('No temporal downsampling');
    Y = Y2;
end
toc;



%Y = uint16(Y);