function gatherSuite2PFolders()

baseFolder = uigetdir();
statFiles1 = rdir([baseFolder, '/**/stat.npy']);

statFiles = {};
for i = 1:length(statFiles1)
    statFiles{end + 1} = statFiles1(i).name;
end

gatherFolder = 'Suite2pSessions';
mkdir([baseFolder, '/', gatherFolder]);
for i = 1:length(statFiles)
    folderToCopy = fileparts(statFiles{i});
    newFolderName = folderToCopy((length(baseFolder) + 2):end);
    f = strfind(newFolderName, '/suite2p/');
    newFolderName = newFolderName(1:(f - 1));
    newFolderName(newFolderName == '/') = '_';
    newFolderName = [baseFolder, '/', gatherFolder, '/', newFolderName];
    d = dir(newFolderName);
    if ~isempty(d)
        disp([newFolderName, ' already exists. Skipping...']);
    else
        copyfile(folderToCopy, newFolderName);
        disp(['Copied: ', folderToCopy, ' to ', newFolderName]);
        save([newFolderName, '\sourceDir.mat'], 'folderToCopy');
    end
end