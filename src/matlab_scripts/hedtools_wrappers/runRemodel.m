function runRemodel(remodel_args)
% Run the remodeling tools.
% 
% Parameters:
%    remodel_args  - Full path to the root directory of a BIDS dataset.
%
    py.importlib.import_module('hed');
    py.hed.tools.remodeling.cli.run_remodel.main(remodel_args);
  
