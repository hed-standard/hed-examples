%% This imports the _events.tsv into the corresponding EEG.set file

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
%rootPath = 'f:/ARLBidsStart/RSVPExpertiseWorking';
%rootPath = 'f:/ARLBidsStart/SpeedControlWorking';
%rootPath = 'f:/ARLBidsStart/TrafficComplexityWorking';
%rootPath = 's:/bcit/AuditoryCueingWorkingPhaseTwo';
%rootPath = 's:/bcit/SpeedControlWorking';

% rootPath = 's:/bcit/AdvancedGuardDutyWorkingPhaseTwo';
% setname = 'BCIT Advanced Guard Duty';
% log_name = 'bcit_advanced_guard_duty_10_import_events_log.txt';
% 
% rootPath = 's:/bcit/AuditoryCueingWorkingPhaseTwo';
% setname = 'BCIT Auditory Cueing';
% log_name = 'bcit_auditory_cueing_10_import_events_log.txt';

rootPath = 's:/bcit/BaselineDrivingWorkingPhaseTwo';
setname = 'BCIT Baseline Driving';
log_name = 'bcit_baseline_driving_10_import_events_log.txt';

% rootPath = 's:/bcit/BasicGuardDutyWorkingPhaseTwo';
% setname = 'BCIT Basic Guard Duty';
% log_name = 'bcit_basic_guard_duty_10_import_events_log.txt';

% rootPath = 's:/bcit/CalibrationDrivingWorkingPhaseTwo';
% setname = 'BCIT Calibration Driving';
% log_name = 'bcit_calibration_driving_10_import_events_log.txt';

% rootPath = 's:/bcit/MindWanderingWorkingPhaseTwo';
% setname = 'BCIT Mind Wandering';
% log_name = 'bcit_mind_wandering_10_import_events_log.txt';

% rootPath = 's:/bcit/SpeedControlWorkingPhaseTwo';
% setname = 'BCIT Speed Control';
% log_name = 'bcit_speed_control_10_import_events_log.txt';

% rootPath = 's:/bcit/TrafficComplexityWorkingPhaseTwo';
% setname = 'BCIT Traffic Complexity';
% log_name = 'bcit_traffic_complexity_10_import_events_log.txt';

excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};

% Designate the columns that are numeric (rest are char)
columnTypes = {'onset', 'double'; 
               'duration', 'double'; 
               'sample', 'int32'};
renameColumns = {'value', 'type'; 'onset', 'latency'};
convertLatency = true; 

%% Open the log
fid = fopen([rootPath filesep 'code/curation_logs', filesep log_name], 'w');
fprintf(fid, 'Log of runEeglabEventsImport.m on %s\n', datetime('now'));

%% Generate json file.
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
for k = 1:length(fileList)
   EEG = pop_loadset(fileList{k});
   [pathName, basename, ext] = fileparts(fileList{k});
   fprintf(fid, '%s:\n', basename);
   eventsFile = [pathName filesep basename(1:(end-3)) 'events.tsv'];
   eventTable = getEventTable(eventsFile, columnTypes, renameColumns);
   fprintf(fid, '\tCreate a table from the events file\n');
   if convertLatency
       eventTable.('latency') = eventTable.('latency')*EEG.srate + 1;
       fprintf(fid, '\tConvert the latency column to samples\n');
   end
   fprintf('%s: EEG.event has %d events and BIDS event file has %d events\n', ...
           basename, length(EEG.event), size(eventTable,1));
   EEG.urevent = table2struct(eventTable)';
   fprintf(fid, '\tSet the EEG.urevent\n');
   eventTable.('urevent') = transpose(1:size(eventTable));
   EEG.event = table2struct(eventTable)';
   fprintf(fid, '\tSet the EEG.event\n');
   if ~isempty(setname)
      EEG.setname = [setname basename];
   end
   fprintf(fid, '\tResave the EEG.set file\n');
   EEG = pop_saveset(EEG, 'savemode', 'resave', 'version', '7.3');
end
fclose(fid);