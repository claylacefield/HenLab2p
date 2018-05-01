function [dupSegGroup] = findDupSegGroup(dupPairs);

%% USAGE: [dupSegGroup] = findDupSegGroup(dupPairs);

% Clay May 2018
% Takes output from findDuplSeg.m 
% and finds groups of segments that may be the same cell


k=0;
dp = dupPairs;
for i = 1:max(dp(:))
    try
        rows = [find(dp(:,1)==i); find(dp(:,2)==i)];
        
        arr = dp(rows,:);
        dp(rows,:) = [];
        arr2 = sort(unique(arr(:)));
        
        for j = 1:length(arr2)
            rows = [find(dp(:,1)==arr2(j)); find(dp(:,2)==arr2(j))];
            segs = dp(rows,:);
            arr = [segs(:); arr2];
            dp(rows,:) = [];
            arr2 = sort(unique(arr(:)));
            
            for m = 1:length(arr2)
                rows = [find(dp(:,1)==arr2(m)); find(dp(:,2)==arr2(m))];
                segs = dp(rows,:);
                arr = [segs(:); arr2];
                dp(rows,:) = [];
                arr2 = sort(unique(arr(:)));
            end
            
        end
        if length(arr2>1)
            k = k+1;
            dupSegGroup{k} = arr2';
        end
    catch
    end
end