%% A test script for a wrapper function to validate HED in a BIDS dataset.

dataPath = 'G:\eeg_ds003645s_hed';

%% Make backup if it doesn't exist

backup_args = {dataPath, '-x', 'stimuli', 'derivatives'};
issueString = runRemodelBackup(backup_args);
fprintf('Validation errors for dataset %s:\n%s\n', dataPath, issueString);