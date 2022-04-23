%% This script deletes files whose name contains a particular string.

%% Set up the specifics for your dataset
rootPath = 'G:/Sternberg/SternbergWorking';
sratePath = [rootPath filesep 'code'];
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set', '.fdt'};
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
keyString = '_task-Experiment_';

%% Delete the files with keyString in the basename
for k = 1:length(fileList)
   [filepath, basename, ext] = fileparts(fileList{k});
   pos = strfind(basename, keyString);
   if (isempty(pos))
       continue
   else
       delete(fileList{k});
       fprintf('Deleted %s\n', fileList{k});
   end
end
