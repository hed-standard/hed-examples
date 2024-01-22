%% Import the _events.tsv into the corresponding EEG.event structure

%% Set up the specifics for your dataset
rootPath = 'T:/summaryTests/ds004106-download';
setname = 'BCITAdvancedGuardDuty_';
excludeDirs = {'sourcedata', 'code', 'stimuli', 'derivatives', 'phenotype'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};


% Designate the columns that are numeric (rest are char)
columnTypes = containers.Map({'onset', 'duration', 'sample'}, ...
                             {'double', 'double', 'int32'});
% Designate the columns that should be renamed
renameColumns = containers.Map({'onset'}, {'latency'});
convertLatency = true; 

%% Generate json file.
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
for k = 1:length(fileList)
   EEG = pop_loadset(fileList{k});
   [pathName, basename, ext] = fileparts(fileList{k});
   fprintf('%s:\n', basename);
   eventsFile = [pathName filesep basename(1:(end-3)) 'events.tsv'];
   eventTable = getEventTable(eventsFile, columnTypes, renameColumns);
   fprintf('\tCreate a table from the events file\n');
   if convertLatency
       eventTable.('latency') = eventTable.('latency')*EEG.srate + 1;
       fprintf('\tConvert the latency column to samples\n');
   end
   fprintf('%s: EEG.event has %d events and BIDS event file has %d events\n', ...
           basename, length(EEG.event), size(eventTable,1));
   fprintf('\tReset the EEG.event.urevent\n');
   eventTable.('urevent') = transpose(1:size(eventTable));
   fprintf('\tSet the EEG.event\n');
   EEG.event = table2struct(eventTable)';
   fprintf('\tSet the EEG.urevent\n');
   EEG.urevent = EEG.event;
   if ~isempty(setname)    
      EEG.setname = [setname basename];
      fprintf('\tSet the EEG.setname\n');
   end
   fprintf('\tResave the EEG.set file\n');
   EEG = pop_saveset(EEG, 'savemode', 'resave', 'version', '7.3');
end