function [numPcNoCue] = noCueGroupDay()


% Clay 2020
% NOTE: This is currently to specifically process 190702 data
% Looks at all sessions and counts PCs for cueOmit and paired noCues
% sessions

cd('/Backup20TB/clay/DGdata/190702');

% choose start directory
dayPath = pwd;

% look through all folders in this day
dayDir = dir;

numPcNoCue = [];

for i = 3:length(dayDir)
    sessName = dayDir(i).name;
    try
        if isfolder(sessName) && (contains(sessName, '_cueOmit') || contains(sessName, '_noCues'))
            cd([dayPath '/' sessName]);
            
            undInds = strfind(sessName, '_'); % underscore indices to parse sessName
            mouseName = sessName(undInds(1)+1:undInds(2)-1);
            
            disp(['Processing file ' sessName]); tic;
            
            %% (put analysis in here)
            if contains(sessName, '_cueOmit')
                cueShiftStrucName = findLatestFilename('2PcueShiftStruc');
                load(cueShiftStrucName);
                [cueCellStruc] = findCueCells(cueShiftStruc, 'led', 0, 0);
                refLapType = findRefLapType(cueShiftStruc);
                pc = find(cueShiftStruc.PCLappedSessCell{refLapType}.Shuff.isPC);
                numPc = length(pc)-length(cueCellStruc.midCueCellInd);
            elseif contains(sessName, '_noCues')
                cueShiftStrucName = findLatestFilename('noCueShiftStruc');
                load(cueShiftStrucName);
                pc = find(cueShiftStruc.PCLappedSessCell{1}.Shuff.isPC);
                numPc = length(pc);
            end

            numPcNoCue = [numPcNoCue numPc];
        end
    catch e
        disp(['Some problem processing ' sessName ' so skipping']);
        fprintf(1,'The identifier was:\n%s', e.identifier);
        fprintf(1,', error message:\n%s', e.message);
        disp(' ');
        
    end
    cd(dayPath);
end

