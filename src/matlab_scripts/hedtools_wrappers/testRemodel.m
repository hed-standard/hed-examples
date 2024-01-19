%% A test script for a wrapper function for run_remodel.

dataPath = 'G:\eeg_ds003645s_hed';

%% Backup the data using default backup name (only should be done once)
backup_args = {dataPath, '-x', 'stimuli', 'derivatives'};
runRemodelBackup(backup_args);

%% Run the remodeling file
remodelFile = 'G:\summarize_hed_types_rmdl.json';
dataPath = 'G:\eeg_ds003645s_hed';
remodel_args = {dataPath, remodelFile, '-b', '-x', 'stimuli', 'derivatives'};
runRemodel(remodel_args);

%% Restore the data files to originals (usually does not have to be done)
restore_args = {dataPath};
runRemodelRestore(restore_args);