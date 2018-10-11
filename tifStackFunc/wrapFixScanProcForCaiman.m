function wrapFixScanProcForCaiman()

% fix 2p scan line problem, then filter, downsample and save

[Y, badFrStart] = fix2pLines(); 

procMcH5forCaiman(Y);







