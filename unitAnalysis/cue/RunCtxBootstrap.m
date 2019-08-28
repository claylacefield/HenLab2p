close all;  
% 
% pathCell = {}; 
%   AllmiceActNumPC12=[]; AllmiceShuffNumPC12=[]; 
%   AllmiceActNumPC23=[]; AllmiceShuffNumPC23=[];
%   AllmicePC12=[]; AllmicePC23=[];   
% AllmiceActNumNonandPlace12=[]; AllmiceShuffNumNonandPlace12=[]; 
% AllmiceActNumNonandPlace23 =[];AllmiceShuffNumNonandPlace23=[];
% AllmiceNumNonandPlace12=[]; AllmiceNumNonandPlace23=[]; 
% AllmiceOverlapFrac =[];
% PCMatchedAny = {}; PCMatchedAll = {};
% PCAnyCorrCoef121323 = []; PCAnyShuffSig121323 = [];
% PCMatchedAny1 = []; PCMatchedAny2 = []; PCMatchedAny3 = []; 
% PCAllCorrCoef121323 = []; PCAllShuffSig121323 = [];
% PCMatchedAll1 = []; PCMatchedAll2 = []; PCMatchedAll3 = []; 


load(findLatestFilename('sameCellTuningStruc'));
load(findLatestFilename('remapStruc'));
% load(findLatestFilename('CtxBootstrapStruc'));

[CtxBootstrapStruc] = CellinCtxIdentityBootstrap (sameCellTuningStruc);
save('CtxBootstrapStruc.mat', 'CtxBootstrapStruc');

%%
pathCell = [pathCell pwd];
AllmiceOverlapFrac= [AllmiceOverlapFrac; CtxBootstrapStruc.OverlapFrac];

AllmiceActNumPC12 = [AllmiceActNumPC12; CtxBootstrapStruc.ActNumPC12];
AllmiceShuffNumPC12 = [AllmiceShuffNumPC12; CtxBootstrapStruc.ShuffNumPC12;];
AllmiceActNumPC23 = [AllmiceActNumPC23;CtxBootstrapStruc.ActNumPC23];
AllmiceShuffNumPC23 = [AllmiceShuffNumPC23; CtxBootstrapStruc.ShuffNumPC23];
AllmicePC12=[AllmicePC12; CtxBootstrapStruc.PC12]; 
AllmicePC23=[AllmicePC23; CtxBootstrapStruc.PC23];   

%
AllmiceActNumNonandPlace12 = [AllmiceActNumNonandPlace12; CtxBootstrapStruc.ActNumNonandPlace12];
AllmiceShuffNumNonandPlace12 = [AllmiceShuffNumNonandPlace12; CtxBootstrapStruc.ShuffNumNonandPlace12;];
AllmiceActNumNonandPlace23 = [AllmiceActNumNonandPlace23;CtxBootstrapStruc.ActNumNonandPlace23];
AllmiceShuffNumNonandPlace23 = [AllmiceShuffNumNonandPlace23; CtxBootstrapStruc.ShuffNumNonandPlace23];
AllmiceNumNonandPlace12=[AllmiceNumNonandPlace12;CtxBootstrapStruc.NumNonandPlace12]; 
AllmiceNumNonandPlace23=[AllmiceNumNonandPlace23; CtxBootstrapStruc.NumNonandPlace23];


%remap struc by animals


PCMatchedAny1 = [PCMatchedAny1; remapStruc.PCMatchedAny{1,1}];
PCMatchedAny2 = [PCMatchedAny2; remapStruc.PCMatchedAny{1,2}];
PCMatchedAny3 = [PCMatchedAny3; remapStruc.PCMatchedAny{1,3}];
PCAnyCorrCoef121323 = [PCAnyCorrCoef121323; remapStruc.PCAnyCorrCoeff121323];
PCAnyShuffSig121323 = [PCAnyShuffSig121323; remapStruc.PCAnyShuffSig121323];
PCMatchedAll1 = [PCMatchedAll1; remapStruc.PCMatchedAll{1,1}];
PCMatchedAll2 = [PCMatchedAll2; remapStruc.PCMatchedAll{1,2}];
PCMatchedAll3 = [PCMatchedAll3; remapStruc.PCMatchedAll{1,3}];
PCAllCorrCoef121323 = [PCAllCorrCoef121323; remapStruc.PCCorrCoeff121323];
PCAllShuffSig121323 = [PCAllShuffSig121323; remapStruc.ShuffSig121323];


%%

AllIRCtxBootstrapStruc.pathCell = pathCell;
 %cell identity
AllIRCtxBootstrapStruc.AllmiceActNumPC12 = AllmiceActNumPC12;
AllIRCtxBootstrapStruc.AllmiceShuffNumPC12 = AllmiceShuffNumPC12;
AllIRCtxBootstrapStruc.AllmiceActNumPC23 = AllmiceActNumPC23;
AllIRCtxBootstrapStruc.AllmiceShuffNumPC23 = AllmiceShuffNumPC23; 
AllIRCtxBootstrapStruc.AllmicePC12 = AllmicePC12; 
AllIRCtxBootstrapStruc.AllmicePC23 = AllmicePC23; 
AllIRCtxBootstrapStruc.AllmiceOverlapFrac=AllmiceOverlapFrac;
AllIRCtxBootstrapStruc.AllmiceActNumNonandPlace12 = AllmiceActNumNonandPlace12; 
AllIRCtxBootstrapStruc.AllmiceShuffNumNonandPlace12 = AllmiceShuffNumNonandPlace12; 
AllIRCtxBootstrapStruc.AllmiceActNumNonandPlace23 = AllmiceActNumNonandPlace23;
AllIRCtxBootstrapStruc.AllmiceShuffNumNonandPlace23 = AllmiceShuffNumNonandPlace23;
AllIRCtxBootstrapStruc.AllmiceNumNonandPlace12 = AllmiceNumNonandPlace12;
AllIRCtxBootstrapStruc.AllmiceNumNonandPlace23 = AllmiceNumNonandPlace23;
%rate
PCMatchedAny = {PCMatchedAny1,PCMatchedAny2,PCMatchedAny3};
AllIRCtxBootstrapStruc.PCMatchedAny=PCMatchedAny;
PCMatchedAll = {PCMatchedAll1,PCMatchedAll2,PCMatchedAll3};
AllIRCtxBootstrapStruc.PCMatchedAll=PCMatchedAll;
AllIRCtxBootstrapStruc.PCAnyCorrCoef121323=PCAnyCorrCoef121323;
AllIRCtxBootstrapStruc.PCAnyShuffSig121323=PCAnyShuffSig121323;
AllIRCtxBootstrapStruc.PCAllCorrCoef121323=PCAllCorrCoef121323;
AllIRCtxBootstrapStruc.PCAllShuffSig121323=PCAllShuffSig121323;

  save('AllIRCtxBootstrapStruc.mat', 'AllIRCtxBootstrapStruc');
