rootPath = 'G:\Sternberg\SternbergWorkingNew';
excludeDirs = {'sourcedata'};

%% Example of using getFileList
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
    
% Example using dumpEEGLABEventFiles
dumpSuffix = 'events_temp.tsv';
nameSuffix = 'eeg'
dumpEEGLABEventFiles(selectedList, nameSuffix, dumpSuffix);