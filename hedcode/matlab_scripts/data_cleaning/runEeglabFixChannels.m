%% This script reads the channel.tsv files and updates the channels in
% the EEG.set files. This script optionally supports renaming particular
% channels in the EEG.chanlocs, reordering the channels in the 
% EEG.chanlocs, and resetting the EEg.urchanlocs. 
%
% The script also sets the type field in EEG.chanlocs to agree with the
% those in the BIDS files and write the X, Y. Z positions in the BIDS
% channels.tsv to agree with those in the EEG.chanlocs.
%
%% Set up the specifics for your dataset

% Sternberg requires reordering of channels as well as reset of urchanlocs.
rootPath = '/XXX/SternbergWorkingPhaseTwo';
log_name = 'sternberg_12_fix_eeglab_channels_log.txt';
resetUrchans = true;  % If true copies chanlocs into urchanlocs
reorderChans = true;  % If true reorders channels to be BIDS order
renameRemap = containers.Map();

%% Set the common variables
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
fprintf('Making the EEG channels and the BIDS channels compatible.\n');
for k = 1:length(fileList)
   [pathName, basename, ext] = fileparts(fileList{k});
   fprintf(fid, '%s:\n', basename);
   fprintf(fid, '\tLoading EEG.set file\n');
   EEG = pop_loadset(fileList{k});

   %% Load the channels.tsv file and make the channel map.
   fprintf(fid, '\tLoading channels.tsv file\n');
   chanFile = [pathName filesep basename(1:(end-3)) 'channels.tsv'];
   [chanMap, chanNames] = getChannelMap(chanFile);
   chanlocs = EEG.chanlocs;
   
   %% Reset the urchanlocs if requested.
   if resetUrchans
      EEG.urchanlocs = rmfield(chanlocs, 'urchan');
   end
   
   %% Rename channels if required.
   if ~isempty(renameRemap)
      mkeys = keys(renameRemap);
      chanlocs = renameChannels(chanlocs, renameRemap);
      fprintf(fid, '\Renaming channels [%s]\n', join(mkeys(:)', ' ')); 
   end
   
   %% Set the channel types in the chanlocs.
   [chanlocs, missing] = setChannelTypes(chanlocs, chanMap);
   if ~isempty(missing)
       missInfo = join(missing(:)', ' ');
       fprintf(fid, '\tWARNING---Missing channels [%s]\n', missInfo{1});
   end
   EEG.chanlocs = chanlocs;
   
   %% Now reorder the channels and data if requested.
   if reorderChans
       chanLabels = {chanlocs.labels};
       [C, ia, ib] = intersect(chanNames, chanLabels, 'stable');
       EEG.data = EEG.data(ib(:), :);
       EEG.chanlocs = chanlocs(ib);
   end

   %% Now write the electrode files.
   electrodePath = [pathName filesep basename(1:(end-3)) 'electrodes.tsv'];
   num_written = writeElectrodeFile(EEG.chanlocs, electrodePath);
   fprintf(fid, '\tWriting electrode file with %d electrodes\n', num_written);
   if num_written == 0
       fprintf(fid, '\tWARNING---EEG missing chanlocs.\n');
   end

   EEG = pop_saveset(EEG, 'savemode', 'resave', 'version', '7.3');
   fprintf(fid, '\tResaving the EEG.set file\n');
end

%% Closing the file.
fclose(fid);