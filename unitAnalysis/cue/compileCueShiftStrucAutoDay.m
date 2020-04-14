function [groupCueStruc] = compileCueShiftStrucAutoDay(tag)


% clay2019


dayPath = uigetdir();
cd(dayPath);
dayDir = dir;

%groupCueStruc = struct;

for i = 3:length(dayDir)
    if (~isempty(strfind(dayDir(i).name, '18')) ||  ~isempty(strfind(dayDir(i).name, '19')) ||  ~isempty(strfind(dayDir(i).name, '20'))) && isfolder(dayDir(i).name) && ~isempty(strfind(dayDir(i).name, tag))%'TSeries')
        cd(dayDir(i).name);
        sessDir = dir;
        %try
        if ~isempty(findLatestFilename('cueShiftStruc'))
        %catch
            %try
                cueShiftStrucName = findLatestFilename('cueShiftStruc');
            disp(['compiling: ' cueShiftStrucName]);
            load(cueShiftStrucName);
            if ~exist('groupCueStruc')
                groupCueStruc = cueShiftStruc;
            else
            groupCueStruc = [groupCueStruc; cueShiftStruc];
            end
%             catch
%                 disp('Error processing this file');
%             end
        end
    end
    cd(dayPath);
end

slashInds = strfind(dayPath,'/');
dayName = dayPath(slashInds(end)+1:end);
save([dayName '_groupCueStruc_' date '.mat'], 'groupCueStruc');