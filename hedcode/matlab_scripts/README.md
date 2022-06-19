## MATLAB Scripts for HED processing

The MATLAB scripts for processing are in two directories: 
**hed_services** and **hed_utilities**.

### HED MATLAB services

The HED MATLAB services are located in the
[**hed_services**](https://github.com/hed-standard/hed-examples/tree/main/hedcode/matlab_scripts/web_services)
subdirectory of [**hed-examples**](https://github.com/hed-standard/hed-examples).

These scripts access HED Rest services.
They rely on the HED online services to be running somewhere,
either on a local Docker module or remotely.

Access to the HED services are also available online through
the [**HED Online Tools](https://hedtools.ucsd.edu/hed).

You can read more about these services in
[**HED services in MATLAB**](https://hed-examples.readthedocs.io/en/latest/HedInMatlab.html#hed-services-in-matlab).

### HED MATLAB utilities

Some MATLAB utilities are available in
[**hed_utilities](https://github.com/hed-standard/hed-examples/tree/main/hedcode/matlab_scripts/hed_utilities).
These utilities are main used for processing events and other information from EEGLAB `.set` files.

EEGLAB also has a number of HED tools which are available as plugins for processing BIDS datasets
in the EEGLAB environment.
