function [y] = fixPos2(y)

% Clay 2020 (mod of fixPos 2018)
% This is to fix weirdness that can occur at end of lap
% NOTE: there also needs to be a fix after resampling (but this is to fix
% jitter around lap end

% calc diff position
dy = [0 diff(y)];

% find points of large discontinuities
[pkVals, posPks] = findpeaks(dy, 'MinPeakHeight', 500);
[pkVals, negPks] = findpeaks(-dy, 'MinPeakHeight', 500);

% % test plot
% t = 1:length(pos);
% figure;
% plot(pos); hold on;
% plot(t(posPks(1)), pos(posPks(1)), 'g.');
% plot(t(negPks), pos(negPks), 'r.');

% for periods post-positive discont, does it belong with prev or latter?
% (i.e. it flips back and forth around end of belt)
y2=y;
for i = 1:length(posPks)
    prevDrop = max(negPks(negPks<posPks(i))); 
    %nextDrop = min(negPks(negPks>posPks(i))); 
    
    y2(prevDrop-1:posPks(i)+1) = y(prevDrop-1);
    
%     if y(prevDrop-1)<2000
%         y2(prevDrop:posPks(i)-1) = y(prevDrop:posPks(i)-1) + y(prevDrop-1);
%     end
%     
%     if y(nextDrop)>50
%         y2(posPks(i):nextDrop-1) = y(posPks(i):nextDrop-1) - min(y(posPks(i):nextDrop-1));
%     end
    
end

% figure;
% plot(y); hold on;
% plot(y2,'g');

% and fix where it misses a lap RFID

[pkVals, negPks2] = findpeaks(-[0 diff(y2)], 'MinPeakHeight', 500); % need to recalc negPks

pkLevs = y2(negPks2);
badNegPks2 = negPks2(y2(negPks2)>50);
y3=y2;
for i = 1:length(badNegPks2)
    pkInd = badNegPks2(i);
    lapStartPos = y2(pkInd);
    prevLev = y2(pkInd-1);
    
    preEp = y2(pkInd-100:pkInd-1);
    
    [val, ind] = min(abs(prevLev-preEp-lapStartPos));
    
    y3(pkInd-100+ind:pkInd-1) = y3(pkInd-100+ind:pkInd-1) - y3(pkInd-100+ind);
    
end

% y = y3;

% and fix weird returns at lap (e.g. slow decrease from 2000-0)

[vals, negPks] = findpeaks(-y3, 'MinPeakHeight', -100, 'MinPeakDistance', 200);
[vals, posPks] = findpeaks(y3, 'MinPeakHeight', 1800, 'MinPeakDistance', 200);

% walk back from here until you get to max
y4=y3;
%y4=y;
for i=1:length(negPks)
    prevPosPk = posPks(find(posPks<negPks(i),1,'last'));
    if negPks(i)-prevPosPk > 1
    y4(prevPosPk+1:negPks(i)-1) = 0;
    end
end
%figure; plot(y,'g'); hold on; plot(y4);


y = y4;
