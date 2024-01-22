function issueString = validateHedInBids(dataPath)
% Validate the HED annotations in a BIDS dataset
% 
% Parameters:
%    dataPath  - Full path to the root directory of a BIDS dataset.
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
%
    py.importlib.import_module('hed');
    bids = py.hed.tools.BidsDataset(dataPath);
    issues = bids.validate();
    issueString = string(py.hed.get_printable_issue_string(issues));
