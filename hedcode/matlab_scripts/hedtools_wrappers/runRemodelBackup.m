function issueString = runRemodelBackup(remodel_args)
% Validate the HED annotations in a BIDS dataset
% 
% Parameters:
%    dataPath  - Full path to the root directory of a BIDS dataset.
%
% Returns:
%     issueString - A string with the validation issues suitable for
%                   printing (has newlines).
%
    backup_dir = [remodel_args{1} filesep 'derivatives' filesep, ...
        'remodeling' filesep, 'backups'];
    py.importlib.import_module('hed');
    issues = py.hed.tools.remodeling.cli.run_remodel_backup.main(remodel_args);
    issueString = 'to here';
