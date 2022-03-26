%% This script dumpts all of the EEG.set events to files named _events_temp.tsv.
% You must provide the root path to your dataset directory tree and excude directories to skip

%% Set up the specifics for your dataset
%rootPath = 'G:/Sternberg/SternbergWorking';
%rootPath = 'G:/AuditoryOddball/AuditoryOddballWorking';
%rootPath = 'G:/GoNogo/GoNogoWorking';
%rootPath = 'G:/ImaginedEmotion/ImaginedEmotionWorking';
%rootPath = 'G:\AttentionShift\AttentionShiftWorking';
%rootPath = 'G:\AttentionShift\AttentionShiftWorking';
%rootPath = 'f:/ARLBidsStart/AdvancedGuardDutyWorking';
%rootPath = 'f:/ARLBidsStart/AuditoryCueingWorking';
%rootPath = 'f:/ARLBidsStart/BaselineDrivingWorking';
%rootPath = 'f:/ARLBidsStart/BasicGuardDutyWorking';
%rootPath = 'f:/ARLBidsStart/CalibrationDrivingWorking';
%rootPath = 'f:/ARLBidsStart/MindWanderingWorking';
%rootPath = 'f:/ARLBidsStart/RSVPBaselineWorking';
%rootPath = 'f:/ARLBidsStart/RSVPExpertiseWorking';
%rootPath = 'f:/ARLBidsStart/SpeedControlWorking';
rootPath = 'f:/ARLBidsStart/TrafficComplexityWorking';
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
srateList = eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);