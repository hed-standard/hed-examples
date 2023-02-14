%% This script dumps the channel labels to a JSON file.

%% Set up the specifics for your dataset
rootPath = '/XXX/AdvancedGuardDutyWorking';
%rootPath = /XXX/AuditoryCueingWorking';
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
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);
extChannels = {'EXG1', 'EXG2', 'EXG3', 'EXG4', 'EXG5', 'EXG6'};
mapSet = {'LHEOG', 'RHEOG', 'UVEOG', 'LVEOG', 'LMAST', 'RMAST'};
chanMap = containers.Map(extChannels, mapSet);
eogChannels = {'LHEOG', 'RHEOG', 'UVEOG', 'LVEOG'};
miscChanels = {'LMAST', 'RMAST'};  
            
%% Rename the channels in the EEG.set file.
fprintf('Saving events from %d EEG.set files...\n', length(fileList));
channelMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
for k = 1:length(fileList)
   EEG = pop_loadset(fileList{k});
   chanlocs = EEG.chanlocs;
   for n = 1:length(chanlocs)
       chan = chanlocs(n).labels;  
       if (sum(strcmpi(extChannels, chan)) == 0)
           chanlocs(n).type = 'EEG';
           continue;
       end
       chanlocs(n).labels = chanMap(chan);
       if (sum(strcmpi(eogChannels, chanMap(chan))) > 0)
           chanlocs(n).type = 'EOG';
       else
           chanlocs(n).type = 'MISC';
       end 
   end
   EEG.chanlocs = chanlocs;
   pop_saveset(EEG, 'filepath', fileList{k}, ...
               'savemode', 'onefile', 'version', '7.3');
  
end
