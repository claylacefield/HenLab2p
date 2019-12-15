function cueCellPlast(C, cueCells)


%cueCells = find(randCueCellStruc.isCueCell);



for i=1:length(cueCells)
[pks, amps] = clayCaTransients(C(cueCells(i),:), 15,1,2); title(cueCells(i));
end

mdl = fitlm(1:length(amps),amps)