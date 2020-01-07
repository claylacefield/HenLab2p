bayesReconstructionWrapper1 

medRefnonCue=[];
for i=1:length(MedianErrRef)
medRefnonCue = [medRefnonCue ; nanmedian(MedianErrRef{i})];
end


medShiftnonCue=[];
for i=1:length(MedianErrRef)
medShiftnonCue = [medShiftnonCue ; nanmedian(MedianErrShift{i})];
end

medShiftnonCue=[];
for i=1:length(MedianErrRef)
medShiftnonCue = [medShiftnonCue ; nanmedian(MedianErrShift{i})];
end



%%
X=[1,2,3,4,5,6,7,8,9,10]; 
Y1= [nanmedian(medRefallPC) nanmedian(medShiftallPC)  ...
    nanmedian(medRefEdgeCue) nanmedian(medShiftEdgeCue) ...
    nanmedian(medRefMidCue) nanmedian(medShiftMidCue) ...
    nanmedian(medRefnonCue) nanmedian(medShiftnonCue) ...
   nanmedian(medRefnonPC) nanmedian(medShiftnonPC)]; 
err1= [makeStdErrorOfMean(medRefallPC) makeStdErrorOfMean(medShiftallPC) ...
    makeStdErrorOfMean(medRefEdgeCue) makeStdErrorOfMean(medShiftEdgeCue)...
    makeStdErrorOfMean(medRefMidCue) makeStdErrorOfMean(medShiftMidCue)...
   makeStdErrorOfMean(medRefnonCue) makeStdErrorOfMean(medShiftnonCue) ...
    makeStdErrorOfMean(medRefnonPC) makeStdErrorOfMean(medShiftnonPC)]; 


 figure; bar(X,Y1, 'r'); hold on; er1 = errorbar(X,Y1, err1); 
 er1.Color=[0 0 0]; title(' MedianErr Ref Shift');
 set (gcf, 'Renderer', 'painters');
 %%
 
 X1= [nanmedian(medRefallPC); nanmedian(medRefEdgeCue); nanmedian(medRefMidCue);nanmedian(medRefnonCue); nanmedian(medRefnonPC)];
err1= [makeStdErrorOfMean(medRefallPC);makeStdErrorOfMean(medRefEdgeCue); makeStdErrorOfMean(medRefMidCue);makeStdErrorOfMean(medRefnonCue);makeStdErrorOfMean(medRefnonPC)]; 
 X2= [nanmedian(medShiftallPC); nanmedian(medShiftEdgeCue); nanmedian(medShiftMidCue);nanmedian(medShiftnonCue); nanmedian(medShiftnonPC)];
err2= [makeStdErrorOfMean(medShiftallPC);makeStdErrorOfMean(medShiftEdgeCue); makeStdErrorOfMean(medShiftMidCue);makeStdErrorOfMean(medShiftnonCue);makeStdErrorOfMean(medShiftnonPC)]; 


sz=100;
      Y1=[0 0.25 0.5 0.75 1];
      Y2=[0 0.25 0.5 0.75 1];

     figure; scatter(X1,Y1,sz, 'k', 'filled');
     hold on; eb(1) = errorbar (X1,Y1,err1, 'horizontal', 'LineStyle', 'none');
    hold on; scatter(X2,Y2,sz, 'r', 'filled');
    hold on; eb(2) = errorbar (X2,Y2,err2, 'horizontal', 'LineStyle', 'none');
%     
 set(eb, 'color', 'k', 'LineWidth', 2);
 
 %%
 PAll = [medRefallPC ;medRefEdgeCue; medRefMidCue;medRefnonCue; medRefnonPC; ...
     medShiftallPC ;medShiftEdgeCue; medShiftMidCue;medShiftnonCue; medShiftnonPC]; 
PGroup = [zeros(length(medRefallPC), 1) + 1; zeros(length(medRefEdgeCue), 1) + 2; zeros(length(medRefMidCue), 1) + 3; ...
    zeros(length(medRefnonCue), 1) + 4; zeros(length(medRefnonPC), 1) + 5; zeros(length(medShiftallPC), 1) + 6; ...
    zeros(length(medShiftEdgeCue), 1) + 7; zeros(length(medShiftMidCue), 1) + 8; zeros(length(medShiftnonCue), 1) + 9; ... 
    zeros(length(medShiftnonPC), 1) + 10];

[p,tbl,stats] = kruskalwallis(PAll, PGroup);
c = multcompare(stats);
%%
makeBootStrapOfMedEZ(bayesRecAll.errorInCm', [2.5, 97.5], 1000)
