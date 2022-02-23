# HED Matlab utilities

**This tutorial is underdevelopment.**

* [**]
* [**Dumping EEGLAB event files**](dump-eeglab-event-file-anchor)  
* [**Dumping EEGLAB event files1**](dump-eeglab-event-file-anchor1)  


(dump-eeglab-event-file-anchor)=
## Dumping EEGLAB event files

EEGLAB stores EEG files in `.set` format or as a combination of two files
in `.set` and `.fdt` format, respectively.
The events in the recording are stored in the `.set` file,
and you may want to compare the internally stored events with the
events stored in an external `_events.tsv` file.

The following scripts in MATLAB assume that you have a directory tree
(possibly in BIDS format) and that EEGLAB is in your MATLAB path.
For additional information on installation of EEGLAB, see the
[EEGLAB website](https://eeglab.org/).

The `dumpEEGLABEventFiles.m` function takes
you are starting with a dataset that is in EEGLAB format, and you wish to

(dump-eeglab-event-file-anchor1)=
## Dumping EEGLAB event files1