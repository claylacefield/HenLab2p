function binByPos(vars, pfPos, binSize)

% Clay 2020
% Simple function to plot some measure of cells by that cell's place field
% position

numbins = 100/binSize;

for i=1:numbins
    binIndsCell{i} = find(pfPos>(i-1)*binSize & pfPos<=i*binSize);
    binVarCell{i} = vars(binIndsCell{i});
end

%figure;
barSem(binVarCell);