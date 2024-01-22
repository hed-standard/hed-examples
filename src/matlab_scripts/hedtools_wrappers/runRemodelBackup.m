function runRemodelBackup(backup_args)
% Create a remodeling backup.
% 
% Parameters:
%    backup_args  - cell array with backup arguments.

    py.importlib.import_module('hed');
    py.hed.tools.remodeling.cli.run_remodel_backup.main(backup_args);
