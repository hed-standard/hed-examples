%% Call getFileList to find fullpaths of files of form *_eeg.set
%rootPath = 'G:/Sternberg/SternbergWorking';
%rootPath = 'G:/AuditoryOddball/AuditoryOddballWorking';
%rootPath = 'G:/GoNogo/GoNogoWorking';
rootPath = 'G:/ImaginedEmotion/ImaginedEmotionWorking';
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