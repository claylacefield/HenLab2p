function [infoSp, infoSec] = makeInfoPerSpikeAndSec(binnedRate, binnedOccu)
%function [infoSp, infoSec] = makeInfoPerSpikeAndSec(binnedRate, binnedOccu)

l1 = binnedRate./mean(binnedRate);
kL = find(l1 > 0);

normOccL = binnedOccu/sum(binnedOccu);

infoSp = sum(l1(kL).*log2(l1(kL)).*normOccL(kL));
infoSec = sum(binnedRate(kL).*log2(l1(kL)).*normOccL(kL));