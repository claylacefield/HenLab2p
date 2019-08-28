close all;  
pathCell = {}; %comment out to collect all mice

pathCell = [pathCell pwd];

  AllmiceActNumPC12=[]; AllmiceShuffNumPC12=[]; AllmiceActNumPC23=[]; AllmiceShuffNumPC23=[];
  AllmiceActNumMC12 =[]; AllmiceShuffNumMC12=[]; AllmiceActNumMC23=[];AllmiceShuffNumMC23=[];
  AllmiceActNumEC12=[]; AllmiceShuffNumEC12=[]; AllmiceActNumEC23 =[];AllmiceShuffNumEC23=[];
   AllmiceActNumNC12 =[]; AllmiceShuffNumNC12=[]; AllmiceActNumNC23=[];AllmiceShuffNumNC23=[];
  AllmicePC12=[]; AllmicePC23=[];   AllmiceMC12=[]; AllmiceMC23=[];   AllmiceEC12=[]; AllmiceEC23=[]; 
    AllmiceNC12=[]; AllmiceNC23=[];  
%
   AllmiceSessID =[];

AllmiceActNumNonandCue12=[]; AllmiceShuffNumNonandCue12=[]; AllmiceActNumNonandCue23 =[];AllmiceShuffNumNonandCue23=[];

AllmiceNumNonandCue12=[]; AllmiceNumNonandCue23=[]; 
load(findLatestFilename('sameCellCueShiftTuningStruc'));
[MvsNBootstrapStruc] = MidCuevsNonCueCellIdentityBootstrap (sameCellCueShiftTuningStruc);
save('MvsNBootstrapStruc.mat', 'MvsNBootstrapStruc');
%

AllmiceActNumPC12 = [AllmiceActNumPC12; BootstrapStruc.ActNumPC12];
AllmiceShuffNumPC12 = [AllmiceShuffNumPC12; BootstrapStruc.ShuffNumPC12;];
AllmiceActNumPC23 = [AllmiceActNumPC23;BootstrapStruc.ActNumPC23];
AllmiceShuffNumPC23 = [AllmiceShuffNumPC23; BootstrapStruc.ShuffNumPC23];
AllmicePC12=[AllmicePC12; BootstrapStruc.PC12]; 
AllmicePC23=[AllmicePC23; BootstrapStruc.PC23];   

AllmiceActNumMC12 = [AllmiceActNumMC12; BootstrapStruc.ActNumMC12];
AllmiceShuffNumMC12 = [AllmiceShuffNumMC12; BootstrapStruc.ShuffNumMC12;];
AllmiceActNumMC23 = [AllmiceActNumMC23;BootstrapStruc.ActNumMC23];
AllmiceShuffNumMC23 = [AllmiceShuffNumMC23; BootstrapStruc.ShuffNumMC23];
AllmiceMC12 = [AllmiceMC12; BootstrapStruc.MC12]; 
AllmiceMC23= [AllmiceMC23; BootstrapStruc.MC23];

AllmiceActNumEC12 = [AllmiceActNumEC12; BootstrapStruc.ActNumEC12];
AllmiceShuffNumEC12 = [AllmiceShuffNumEC12; BootstrapStruc.ShuffNumEC12;];
AllmiceActNumEC23 = [AllmiceActNumEC23;BootstrapStruc.ActNumEC23];
AllmiceShuffNumEC23 = [AllmiceShuffNumEC23; BootstrapStruc.ShuffNumEC23];
AllmiceEC12= [AllmiceEC12; BootstrapStruc.EC12]  ; 
AllmiceEC23= [AllmiceEC23; BootstrapStruc.EC23];

AllmiceActNumNC12 = [AllmiceActNumNC12; BootstrapStruc.ActNumNC12];
AllmiceShuffNumNC12 = [AllmiceShuffNumNC12; BootstrapStruc.ShuffNumNC12;];
AllmiceActNumNC23 = [AllmiceActNumNC23;BootstrapStruc.ActNumNC23];
AllmiceShuffNumNC23 = [AllmiceShuffNumNC23; BootstrapStruc.ShuffNumNC23];
 AllmiceNC12=[AllmiceNC12; BootstrapStruc.NC12]; 
 AllmiceNC23=[AllmiceNC23; BootstrapStruc.NC23];
%
 AllmiceSessID = [AllmiceSessID; MvsNBootstrapStruc.MultSessID];
AllmiceActNumNonandCue12 = [AllmiceActNumNonandCue12; MvsNBootstrapStruc.ActNumNonandCue12];
AllmiceShuffNumNonandCue12 = [AllmiceShuffNumNonandCue12; MvsNBootstrapStruc.ShuffNumNonandCue12;];
AllmiceActNumNonandCue23 = [AllmiceActNumNonandCue23;MvsNBootstrapStruc.ActNumNonandCue23];
AllmiceShuffNumNonandCue23 = [AllmiceShuffNumNonandCue23; MvsNBootstrapStruc.ShuffNumNonandCue23];
AllmiceNumNonandCue12=[AllmiceNumNonandCue12;MvsNBootstrapStruc.NumNonandCue12]; 
AllmiceNumNonandCue23=[AllmiceNumNonandCue23; MvsNBootstrapStruc.NumNonandCue23];




%
MvsNIRToneMintTactBootstrap.AllmiceSessID = AllmiceSessID;
MvsNIRToneMintTactBootstrap.AllmiceActNumNonandCue12 = AllmiceActNumNonandCue12; 
MvsNIRToneMintTactBootstrap.AllmiceShuffNumNonandCue12 = AllmiceShuffNumNonandCue12; 
MvsNIRToneMintTactBootstrap.AllmiceActNumNonandCue23 = AllmiceActNumNonandCue23;
MvsNIRToneMintTactBootstrap.AllmiceShuffNumNonandCue23 = AllmiceShuffNumNonandCue23;
MvsNIRToneMintTactBootstrap.AllmiceNumNonandCue12 = AllmiceNumNonandCue12;
MvsNIRToneMintTactBootstrap.AllmiceNumNonandCue23 = AllmiceNumNonandCue23;

  save('MvsNIRToneMintTactBootstrap.mat', 'MvsNIRToneMintTactBootstrap');
 %
AllIRIAAmintBootstrap.AllmiceActNumPC12 = AllmiceActNumPC12;
AllIRIAAmintBootstrap.AllmiceShuffNumPC12 = AllmiceShuffNumPC12;
AllIRIAAmintBootstrap.AllmiceActNumPC23 = AllmiceActNumPC23;
AllIRIAAmintBootstrap.AllmiceShuffNumPC23 = AllmiceShuffNumPC23; 
AllIRIAAmintBootstrap.AllmicePC12 = AllmicePC12; 
AllIRIAAmintBootstrap.AllmicePC23 = AllmicePC23; 

AllIRIAAmintBootstrap.AllmiceActNumMC12 = AllmiceActNumMC12; 
AllIRIAAmintBootstrap.AllmiceShuffNumMC12 = AllmiceShuffNumMC12; 
AllIRIAAmintBootstrap.AllmiceActNumMC23 = AllmiceActNumMC23;
AllIRIAAmintBootstrap.AllmiceShuffNumMC23 = AllmiceShuffNumMC23; 
AllIRIAAmintBootstrap.AllmiceMC12 = AllmiceMC12; 
AllIRIAAmintBootstrap.AllmiceMC23 = AllmiceMC23; 

AllIRIAAmintBootstrap.AllmiceActNumEC12 = AllmiceActNumEC12; 
AllIRIAAmintBootstrap.AllmiceShuffNumEC12 = AllmiceShuffNumMC12;
AllIRIAAmintBootstrap.AllmiceActNumEC23 = AllmiceActNumEC23;
AllIRIAAmintBootstrap.AllmiceShuffNumEC23 = AllmiceShuffNumEC23; 
AllIRIAAmintBootstrap.AllmiceEC12 = AllmiceEC12; 
AllIRIAAmintBootstrap.AllmiceEC23 = AllmiceEC23; 

AllIRIAAmintBootstrap.AllmiceActNumNC12 = AllmiceActNumNC12;
AllIRIAAmintBootstrap.AllmiceShuffNumNC12 = AllmiceShuffNumNC12; 
AllIRIAAmintBootstrap.AllmiceActNumNC23 = AllmiceActNumNC23;
AllIRIAAmintBootstrap.AllmiceShuffNumNC23 = AllmiceShuffNumNC23; 
AllIRIAAmintBootstrap.AllmiceNC12 = AllmiceNC12; 
AllIRIAAmintBootstrap.AllmiceNC23 = AllmiceNC23; 


