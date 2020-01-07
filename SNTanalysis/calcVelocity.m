%MotVel = [];
V=[];
for I= 1:size(multSessSegStruc,2)
    totalFrames = size(multSessSegStruc(I).C,2);
    resampY = multSessSegStruc(I).treadBehStruc.resampY;
    downSamp = round(length(resampY)/totalFrames);
    treadPos = resampY(1:downSamp:end);
    treadPos = treadPos/max(treadPos);
    T = multSessSegStruc(I).treadBehStruc.adjFrTimes(1:downSamp:end);
    [movEpochs, velocity] =calcMovEpochs1(treadPos, T);
    Vel= nanmean(velocity);
    V = [V, Vel];
end

MotVel = [MotVel; V];
