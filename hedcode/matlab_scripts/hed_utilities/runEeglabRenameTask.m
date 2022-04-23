%% This script dumpts all of the EEG.set events to files named _events_temp.tsv.
% You must provide the root path to your dataset directory tree and excude directories to skip

%% Set up the specifics for your dataset
rootPath = 'G:/Sternberg/SternbergWorking';
sratePath = [rootPath filesep 'code'];
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
oldTask = '_task-Experiment_';
newTask = '_task-WorkingMemory_';

%% Make a copy of the files
errorList = [];
for k = 1:length(fileList)
   EEG = pop_loadset(fileList{k});
   [filepath, basename, ext] = fileparts(fileList{k});
   pos = strfind(basename, oldTask);
   if (isempty(pos))
       fprintf('%s does not have old task\n', fileList{k});
       errorList(end+1) = k;
   else
       firstPart = basename(1:(pos(1) - 1));
       lastPart = basename(pos(1)+17:end);
       newName = [firstPart newTask lastPart ext];
       newPath = [filepath filesep newName];
       pop_saveset(EEG, 'filepath', newPath, ...
           'savemode', 'twofiles', 'version', '7.3');
   end
end
