%% This script dumps the channel labels to a JSON file.

%% Set up the specifics for your dataset
%rootPath = 'G:/Sternberg/SternbergWorking';
%rootPath = 'G:/AuditoryOddball/AuditoryOddballWorking';
%rootPath = 'G:/GoNogo/GoNogoWorking';
%rootPath = 'G:/ImaginedEmotion/ImaginedEmotionWorking';
%rootPath = 'G:/AttentionShift/AttentionShiftWorking';
%rootPath = 'f:/ARLBidsStart/AdvancedGuardDutyWorking';
%rootPath = 'f:/ARLBidsStart/AuditoryCueingWorking';
%rootPath = 'f:/ARLBidsStart/BaselineDrivingWorking';
%rootPath = 'f:/ARLBidsStart/BasicGuardDutyWorking';
%rootPath = 'f:/ARLBidsStart/CalibrationDrivingWorking';
%rootPath = 'f:/ARLBidsStart/MindWanderingWorking';
%rootPath = 'f:/ARLBidsStart/RSVPBaselineWorking';
rootPath = 'f:/ARLBidsStart/RSVPExpertiseWorking';
%rootPath = 'f:/ARLBidsStart/SpeedControlWorking';
%rootPath = 'f:/ARLBidsStart/TrafficComplexityWorking';
sratePath = [rootPath filesep 'code'];
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
channelsJson = 'channelsOriginal.json';

%% Generate json file.
fprintf('Creating a JSON file with channel labels for %d EEG.set files...\n', length(fileList));
channelMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
for k = 1:length(fileList)
   EEG = pop_loadset(fileList{k});
   [pathName, basename, ext] = fileparts(fileList{k});
   channelMap([basename ext]) = {EEG.chanlocs.labels}; 
end
y = jsonencode(channelMap);
fileName = [rootPath filesep 'code' filesep channelsJson];
fp = fopen(fileName, 'w');
fprintf(fp, '%s', y);
fclose(fp); 