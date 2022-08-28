%% This script dumps all of the EEG.set events to files _eventstemp.tsv.
% You must provide the root path to your dataset directory tree 
% and also the exclude directories to skip.

%% Set up the specifics for your dataset
%rootPath = '/XXX/SternbergWorking';
%rootPath = '/XXX/AuditoryOddballWorking';
%rootPath = '/XXX/GoNogoWorking';
%rootPath = '/XXX/ImaginedEmotionWorking';
%rootPath = '/XXX/AttentionShiftWorking';
%rootPath = '/XXX/AdvancedGuardDutyWorking';
rootPath = '/XXX/AuditoryCueingWorking';
%rootPath = '/XXX/BaselineDrivingWorking';
%rootPath = '/XXX/BasicGuardDutyWorking';
%rootPath = '/XXX/CalibrationDrivingWorking';
%rootPath = '/XXX/MindWanderingWorking';
%rootPath = '/XXX/RSVPBaselineWorking';
%rootPath = '/XXX/RSVPExpertiseWorking';
%rootPath = '/XXX/SpeedControlWorking';
%rootPath = '/XXX/TrafficComplexityWorking';
sratePath = [rootPath filesep 'code'];
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);

%% Generate the eventstemp.tsv files and srate file from EEG.set files

% Output a list of ifiles
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
    
% Use eeglabEventsToTsv to save EEG.set events to tsv file
saveSuffix = '_eventstemp.tsv';
nameSuffix = '_eeg';
srateMap = eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);


% Save the return list of sampling rates
if ~isfolder(sratePath)
    mkdir(sratePath);
end
srateFile = fopen([sratePath filesep 'samplingRates.tsv'], 'w');
theKeys = keys(srateMap);
fprintf(srateFile, 'file_basename\tsampling_rate\n');
for k = 1:length(theKeys)
    fprintf(srateFile, '%s\t%g\n', theKeys{k}, srateMap(theKeys{k}));
end
fclose(srateFile);
