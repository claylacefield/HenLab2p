
% Clay Dec. 2017
% script to take intermediate step of Ziv registration on DG place cells
% and find cells active in subsets of sessions (or are place cells in
% subsets of
% sessions?)

figure; pie([229 35 8 42]);

n=0;m=0;p=0;q=0;

for i = 1:size(sameCellPlaceBool,1)
    pcs = sameCellPlaceBool(i,:); % whether cell present in all sessions is a place cell in each
    if pcs==[1,0,0]
        n=n+1;
        firstOnly(n) = i;
    elseif pcs==[0,1,1]
        m=m+1;
        lastTwoOnly(m) = i;
        elseif pcs==[0,1,0]
        p=p+1;
        secondOnly(p) = i;
        elseif pcs==[0,0,1]
        q=q+1;
        lastOnly(q) = i;
    end
end