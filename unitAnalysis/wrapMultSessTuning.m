function [multSessTuningStruc] = wrapMultSessTuning(varargin)


if nargin == 1
    multSessTuningStruc = varargin{1};
    disp('Appending to previous multSessTuningStruc');
else
    multSessTuningStruc = struct();
    disp('Creating new multSessTuningStruc');
end

if length(multSessTuningStruc)>1
    numSess = length(multSessTuningStruc);
else
    numSess = 0;
end

% loop through and select Caiman output segDict for each session
stillAdding = 1;
while stillAdding
    try
        foldername = uigetdir(pwd, 'Select session folder to process and add to multSessTuningStruc');
        cd(foldername);
        
        try
            disp(['Adding ' foldername ' to multSessTuningStruc']);
            
            segName = findLatestFilename('segDict');
            load(segName);
            
            [treadBehStruc] = procHen2pBehav('auto');
            
            numBins = 40;
            [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning(C, treadBehStruc, numBins);
            
            numSess = numSess + 1;
            slashInds = strfind(foldername, '/');
            multSessTuningStruc(numSess).mouseName = foldername(slashInds(end-2)+1:slashInds(end-1)-1);
            multSessTuningStruc(numSess).dayName = foldername(slashInds(end-1)+1:slashInds(end)-1);
            multSessTuningStruc(numSess).sessName = foldername(slashInds(end)+1:end);
            %multSessTuningStruc(numSess).sessPath = foldername;
            multSessTuningStruc(numSess).C = C;
            multSessTuningStruc(numSess).A = A;
            multSessTuningStruc(numSess).d1 = d1;
            multSessTuningStruc(numSess).d2 = d2;
            multSessTuningStruc(numSess).treadBehStruc = treadBehStruc;
            multSessTuningStruc(numSess).goodSegPosPkStruc = goodSegPosPkStruc;
            multSessTuningStruc(numSess).circStatStruc = circStatStruc;
            
            wellTunedInd = find(circStatStruc.uniform(:,1)<0.01);
            multSessTuningStruc(numSess).placeCellStruc.goodRay = wellTunedInd;
        catch
            disp(['Couldnt process ' foldername ' (probably some file missing']);
        end
    catch
        stillAdding = 0;
        disp('Canceled folder selection so aborting.');
    end
    cd ..;
end




