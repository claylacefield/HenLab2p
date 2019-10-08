Path=uigetdir();
cd(Path);
sessDir=dir;
for i=3:length(sessDir)
    if ~isempty(strfind(sessDir(i).name,'MultDay'))
        cd(sessDir(i).name);
        load(findLatestFilename('sameCellCueShiftTuningStruc'));
 [posRateStruc] = makenewposRateStruc (sameCellCueShiftTuningStruc);
    end
    cd(Path);
end

%%
% clear all;
%         load(findLatestFilename('sameCellCueShiftTuningStruc'));
% [SameCellTypeRemapStruc]= SameCellTypeRemap (sameCellCueShiftTuningStruc);    

%%
Path=uigetdir();
cd(Path);
sessDir=dir;

MatchedFirst1=[];MatchedFirst2=[];MatchedFirst3=[];
MatchedSecond1=[];MatchedSecond2=[];MatchedSecond3=[];
MatchedThird1=[];MatchedThird2=[];MatchedThird3=[];

for i=3:length(sessDir)
    if ~isempty(strfind(sessDir(i).name,'MultDay'))
        cd(sessDir(i).name);
load(findLatestFilename('posRateStruc'));
 MatchedFirst1=[MatchedFirst1;posRateStruc.posRatesPCinFirst{1,1}];
    MatchedFirst2=[MatchedFirst2;posRateStruc.posRatesPCinFirst{1,2}];
    MatchedFirst3=[MatchedFirst3;posRateStruc.posRatesPCinFirst{1,3}];

     MatchedSecond1=[MatchedSecond1;posRateStruc.posRatesPCinSecond{1,1}];
    MatchedSecond2=[MatchedSecond2;posRateStruc.posRatesPCinSecond{1,2}];
    MatchedSecond3=[MatchedSecond3;posRateStruc.posRatesPCinSecond{1,3}];
    
     MatchedThird1=[MatchedThird1;posRateStruc.posRatesPCinThird{1,1}];
    MatchedThird2=[MatchedThird2;posRateStruc.posRatesPCinThird{1,2}];
    MatchedThird3=[MatchedThird3;posRateStruc.posRatesPCinThird{1,3}];
    end
       
        cd(Path);
end

 MatchedFirst = {MatchedFirst1,MatchedFirst2,MatchedFirst3};
  MatchedSecond={MatchedSecond1,MatchedSecond2,MatchedSecond3};
  MatchedThird={MatchedThird1,MatchedThird2,MatchedThird3};
  posRatesStruc.MatchedFirst=MatchedFirst;
  posRatesStruc.MatchedSecond = MatchedSecond;
  posRatesStruc.MatchedThird=MatchedThird;
  
  