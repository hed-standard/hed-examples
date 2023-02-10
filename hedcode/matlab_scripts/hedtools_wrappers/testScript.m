%% A test script for a wrapper function to validate HED in a BIDS dataset.

dataPath = 'H:\datasets\eeg_ds003645s_hed';
issueString = validateHedInBids(dataPath);
if isempty(issueString)
    fprintf('Dataset %s has no HED validation errors\n', dataPath);
else
    fprintf('Validation errors for dataset %s:\n%s\n', dataPath, issueString);
end