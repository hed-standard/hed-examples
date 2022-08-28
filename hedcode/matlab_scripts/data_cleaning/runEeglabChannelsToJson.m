%% This script dumps the channel labels to a JSON file.

%% Set up the specifics for your dataset
%rootPath = '/XXX/SternbergWorking';
%rootPath = '/XXX/AuditoryOddballWorking';
%rootPath = '/XXX/GoNogoWorking';
%rootPath = '/XXX/ImaginedEmotionWorking';
%rootPath = '/XXX/AttentionShiftWorking';
%rootPath = '/XXX/AdvancedGuardDutyWorking';
%rootPath = '/XXX/AuditoryCueingWorking';
%rootPath = '/XXX/BaselineDrivingWorking';
%rootPath = '/XXX/BasicGuardDutyWorking';
%rootPath = '/XXX/CalibrationDrivingWorking';
%rootPath = '/XXX/MindWanderingWorking';
%rootPath = '/XXX/RSVPBaselineWorking';
rootPath = '/XXX/RSVPExpertiseWorking';
%rootPath = '/XXX/SpeedControlWorking';
%rootPath = '/XXX/TrafficComplexityWorking';
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