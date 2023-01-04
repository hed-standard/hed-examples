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
%
    issueString = '';
    pyrun("bids = hed.tools.BidsDataset(dataPath)")
    pyrun("issues = bids.validate()")
    pyrun("issueString = hed.get_printable_issue_string(issues))")
