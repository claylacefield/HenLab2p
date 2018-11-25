function [resampY2] = fixResampY(resampY);


% 112518 fix resampY to elim interp that splits lap boundary
dy = [0 diff(resampY)];
%[vals, inds] = findpeaks(-dy, 'MinPeakHeight', 500, 'MinPeakDistance', 5);
inds = find(-dy>100)-1;

resampY2 = resampY;
for i = 1:length(inds)
   if resampY2(inds(i))< resampY2(inds(i)-1)
       resampY2(inds(i))=resampY2(inds(i)-1)+(resampY2(inds(i)-1)-resampY2(inds(i)-2));
   end
end

%figure; plot(resampY, '.'); hold on; plot(resampY2, 'r.');

