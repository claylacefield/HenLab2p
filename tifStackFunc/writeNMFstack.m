function writeNMFstack(segStruc, goodSeg)



C = segStruc.C;
A = segStruc.A;

d1 = segStruc.d1;
d2 = segStruc.d2;
T = size(C,1);

stack = zeros(d1,d2,T);

for seg = 1:length(goodSeg)
    
    segNum = goodSeg(seg);
    
    disp(['Processing seg #' num2str(seg) ' out of ' num2str(length(goodSeg))]);
    tic;
    
    
    sega = A(segNum, :);    % spatial factor
    sega = sega/max(sega);
    
    segc = C(1:T,segNum);  % temporal factor
    segc = segc/max(segc);
    
    thresh = 3*std(segc);
    lockout = 20;
    
    pks = LocalMinima(-segc, lockout, -(mean(segc)+thresh));
    segc2 = zeros(T,1);
    prePk = 20;
    postPk = 50;
    
    for pkNum = 1:length(pks)
        if pks(pkNum)>prePk && pks(pkNum) < T-postPk
            segc2(pks(pkNum)-prePk:pks(pkNum)+postPk) = segc(pks(pkNum)-prePk:pks(pkNum)+postPk);
    %segc(segc<thresh)=0;
        end
    end
    
    for frNum = 1:T
        fr = sega*segc2(frNum);
        stack(:,:,frNum) = stack(:,:,frNum)+reshape(fr, d1,d2);
    end
    toc;
end

disp('Saving TIFF stack'); tic;
writeTifStack(stack, 'testCAstack4sd.tif');
toc;


