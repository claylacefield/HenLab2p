function [goodSeg] = findGoodSegsCaiman(C,fps)


n=0;
for i = 1:size(C,1)
    
    [pks] = clayCaTransients(C(i,:), fps);
    
    if length(pks) > spkNumThresh
        n=n+1;
        goodSeg(n)=i;
        unitEvInds{n} = pks;
    end
    
end



