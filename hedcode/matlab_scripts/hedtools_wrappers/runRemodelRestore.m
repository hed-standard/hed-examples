function runRemodelRestore(restore_args)
% Restore the specified remodeling backup.
% 
% Parameters:
%    restore_args  - cell array with restore arguments.

    py.importlib.import_module('hed');
    py.hed.tools.remodeling.cli.run_remodel_restore.main(restore_args);
