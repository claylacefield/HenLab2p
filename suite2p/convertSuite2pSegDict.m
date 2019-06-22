function convertSuite2pSegDict()

filename = findLatestFilename('_seg2P_');
load(filename);
basename = filename(1:strfind(filename, '_seg2P_')-1);

C = seg2P.C2p;
pksCell = seg2P.pksCell;
A = seg2P.A2p;
d1 = seg2P.d12p;
d2 = seg2P.d22p;

save([basename '_segDict_S2p_' date '.mat'], 'C', 'pksCell', 'A', 'd1', 'd2');