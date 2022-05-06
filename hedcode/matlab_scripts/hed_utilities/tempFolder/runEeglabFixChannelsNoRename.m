%% This script reads the channel.tsv files and updates the channels in
% the EEG.set files.
%%

%% Set up the specifics for your dataset
rootPath = 'G:/AttentionShift/AttentionShiftWorkingPhaseTwo';
log_name = 'attention_shift_17_fix_eeglab_channels_log.txt';

sratePath = [rootPath filesep 'code'];
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
fileList = getFileList(rootPath, namePrefix, nameSuffix, ...
                           extensions, excludeDirs);

%% Open the log
fid = fopen([rootPath filesep 'code/curation_logs', filesep log_name], 'w');
fprintf(fid, 'Log of runEeglabFixChannels.m on %s\n', datetime('now'));

%% Rename the channels and set the channel types
fprintf('Renaming channels and setting the channel types\n');

for k = 1:length(fileList)
   EEG = pop_loadset(fileList{k});
  
   [pathName, basename, ext] = fileparts(fileList{k});
   fprintf(fid, '%s:\n', basename);
   fprintf(fid, '\tLoading EEG.set file\n');
   chanFile = [pathName filesep basename(1:(end-3)) 'channels.tsv'];  
   [chanlocs, missing] = setChanTypes(EEG.chanlocs, chanFile);
   fprintf(fid, '\tSetting the channel types\n');
   if ~isempty(missing)
       missInfo = join(missing(:)', ' ');
       fprintf(fid, '\tWARNING---Missing channels [%s]\n', missInfo{1});
   end

   electrodePath = [pathName filesep basename(1:(end-3)) 'electrodes.tsv'];
   num_written = writeElectrodeFile(chanlocs, electrodePath);
   fprintf(fid, '\tWriting electrode file with %d electrodes\n', num_written);
   if num_written == 0
       fprintf(fid, '\tWARNING---EEG missing chanlocs\n');
   end
   EEG.chanlocs = chanlocs;
   EEG = pop_saveset(EEG, 'savemode', 'resave', 'version', '7.3');
   fprintf(fid, '\tResaving the EEG.set file\n');
end

%% Closing the file.
fclose(fid);