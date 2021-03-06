function [multSessSegStruc] = wrapMultSessStrucSelect(varargin);

%% USAGE: [multSessSegStruc] = wrapMultSessStrucSelect(varargin);
% Start with multSessTuninStruc or create new, selecting folders to
% compile.
% NOTE: abort file open dialog to stop adding new sessions.


if nargin == 1
    multSessSegStruc = varargin{1};
    disp('Appending to previous multSessTuningStruc');
else
    multSessSegStruc = struct();
    disp('Creating new multSessTuningStruc');
end

if length(multSessSegStruc)>1
    numSess = length(multSessSegStruc);
else
    numSess = 0;
end

% loop through and select Caiman output segDict for each session
stillAdding = 1;
while stillAdding
    try
        [segDictName, path] = uigetfile('*.mat', 'Select session segDict file to add to multSessTuningStruc');
        cd(path);
        
        try
            [goodSegName, path] = uigetfile('*.mat', 'Select goodSeg file for this segDict');
            
            disp(['Adding ' segDictName ' to multSessTuningStruc']);
        
            load(segDictName);
            
            %segName = findLatestFilename('segDict');
            load(goodSegName);
            
            [treadBehStruc] = procHen2pBehav('auto');
            
%             numBins = 100 ; rayThresh = 0.05;
%             [goodSegPosPkStruc, circStatStruc] = wrapUnitTuning(C, treadBehStruc, numBins, rayThresh);
            
            % put other things to calculate here, e.g.
            % xxxxx
            
            numSess = numSess + 1;
            slashInds = strfind(foldername, '/');
            multSessSegStruc(numSess).mouseName = foldername(slashInds(end-2)+1:slashInds(end-1)-1);
            multSessSegStruc(numSess).dayName = foldername(slashInds(end-1)+1:slashInds(end)-1);
            multSessSegStruc(numSess).sessName = foldername(slashInds(end)+1:end);
            %multSessTuningStruc(numSess).sessPath = foldername;
            multSessSegStruc(numSess).C = C;
            multSessSegStruc(numSess).A = A;
            multSessSegStruc(numSess).d1 = d1;
            multSessSegStruc(numSess).d2 = d2;
            multSessSegStruc(numSess).treadBehStruc = treadBehStruc;
            
            
            multSessSegStruc(numSess).goodSeg = goodSeg; % includes greatSeg but not in's and ok's
            multSessSegStruc(numSess).greatSeg = greatSeg;
            
            try
            multSessSegStruc(numSess).okSeg = okSeg;
            multSessSegStruc(numSess).inSeg = inSeg;
            catch
                disp('No okSegs or INs');
            end
            
            
%             multSessTuningStruc(numSess).goodSegPosPkStruc = goodSegPosPkStruc;
%             wellTunedInd = find(circStatStruc.uniform(:,1)<0.01);
%             multSessTuningStruc(numSess).placeCellStruc.goodRay = wellTunedInd;
            
            % multSessTuningStruc(numSess).xxxx
            
        catch
            disp(['Couldnt process ' foldername ' (probably some file missing']);
        end
    catch
        stillAdding = 0;
        disp('Canceled folder selection so aborting.');
    end
    cd ..;
end




