## MATLAB Scripts for HED processing

The MATLAB scripts for processing are in two directories: 
**web_services** and **utility_scripts**.

### HED MATLAB services

The HED MATLAB services are located in the
[**web_services**](https://github.com/hed-standard/hed-examples/tree/main/hedcode/matlab_scripts/web_services)
subdirectory of [**hed-examples**](https://github.com/hed-standard/hed-examples).

These scripts access HED Rest services.
They rely on the HED online services to be running somewhere,
either in a local Docker module or remotely.

Access to the HED services are also available online through
the [**HED Online Tools**](https://hedtools.ucsd.edu/hed).

You can read more about these services in
[**HED services in MATLAB**](https://hed-examples.readthedocs.io/en/latest/HedInMatlab.html#hed-services-in-matlab).

### HED MATLAB utilities

Some MATLAB utilities are available in
[**utility_scripts**](https://github.com/hed-standard/hed-examples/tree/main/hedcode/matlab_scripts/utility_scripts).
These utilities are main used for processing events and other information from EEGLAB `.set` files.

Additional MATLAB tools for working with EEG `.set` files in
BIDS datasets are available in the
[**matlab_utility_scripts**](https://github.com/hed-standard/hed-curation/tree/main/src/curation/matlab_utility_scripts)
directory of the [**hed-curation**](https://github.com/hed-standard/hed-curation) GitHub repository.

[**EEGLAB**](https://sccn.ucsd.edu/eeglab/index.php) also has a number
of HED tools which are available as plugins for processing BIDS datasets
in the EEGLAB environment.
