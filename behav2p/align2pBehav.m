function [treadBehStruc] = align2pBehav();


[treadBehStruc] = readTDML();

[relFrTimes, absFrTimes, frInds] = get2pFrTimes();


treadBehStruc.relFrTimes = relFrTimes;
treadBehStruc.absFrTimes = absFrTimes;
treadBehStruc.frInds = frInds;

