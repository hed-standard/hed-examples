%% This script dumpts all of the EEG.set events to files named _events_temp.tsv.
% You must provide the root path to your dataset directory tree and excude directories to skip

%% Set up the specifics for your dataset
%rootPath = 'G:/Sternberg/SternbergWorking';
%rootPath = 'G:/AuditoryOddball/AuditoryOddballWorking';
%rootPath = 'G:/GoNogo/GoNogoWorking';
%rootPath = 'G:/ImaginedEmotion/ImaginedEmotionWorking';
rootPath = 'G:\AttentionShift\AttentionShiftWorking';
%rootPath = 'f:/ARLBidsStart/AdvancedGuardDutyWorking';
%rootPath = 'f:/ARLBidsStart/AuditoryCueingWorking';
%rootPath = 'f:/ARLBidsStart/BaselineDrivingWorking';
%rootPath = 'f:/ARLBidsStart/BasicGuardDutyWorking';
%rootPath = 'f:/ARLBidsStart/CalibrationDrivingWorking';
%rootPath = 'f:/ARLBidsStart/MindWanderingWorking';
%rootPath = 'f:/ARLBidsStart/RSVPBaselineWorking';
%rootPath = 'f:/ARLBidsStart/RSVPExpertiseWorking';
%rootPath = 'f:/ARLBidsStart/SpeedControlWorking';
%rootPath = 'f:/ARLBidsStart/TrafficComplexityWorking';
sratePath = [rootPath filesep 'code'];
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);

%% Generate the events_temp.tsv files and srate file from EEG.set files

% Output a list of ifiles
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
    
% Use eeglabEventsToTsv to save EEG.set events to tsv file
saveSuffix = '_events_temp.tsv';
nameSuffix = '_eeg';
srateMap = eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);


% Save the return list of sampling rates
if ~isfolder(sratePath)
    mkdir(sratePath);
end
srateFile = fopen([sratePath filesep 'samplingRates.tsv'], 'w');
theKeys = keys(srateMap);
for k = 1:length(theKeys)
    fprintf(srateFile, '%s\t%g\n', theKeys{k}, srateMap(theKeys{k}));
end
fclose(srateFile);
