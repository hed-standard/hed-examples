%% This script dumpts all of the EEG.set events to files named _events_temp.tsv.
% You must provide the root path to your dataset directory tree and excude directories to skip

%% Set up the specifics for your dataset
%rootPath = 'G:/Sternberg/SternbergWorking';
%rootPath = 'G:/AuditoryOddball/AuditoryOddballWorking';
%rootPath = 'G:/GoNogo/GoNogoWorking';
%rootPath = 'G:/ImaginedEmotion/ImaginedEmotionWorking';
%rootPath = 'G:\AttentionShift\AttentionShiftWorking';
rootPath = 'G:/Sternberg/SternbergWorking';
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);

%% Output the list
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
    
% Use eeglabEventsToTsv to save EEG.set events to tsv file
saveSuffix = '_events_temp.tsv';
nameSuffix = '_eeg';
eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);