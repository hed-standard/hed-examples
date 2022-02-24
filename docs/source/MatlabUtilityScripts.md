# HED Matlab utilities

**This tutorial is underdevelopment.**

* [**Find files in directory tree**](find-files-directory-tree-anchor)
* [**EEGLAB event files to tsv**](eeglab-events-to-tsv-anchor)  
* [**Dumping EEGLAB event files1**](dump-eeglab-event-file-anchor1)  

(find-files-directory-tree-anchor)=
### Find files in directory

The `getFileList` function returns a cell array of full path names of
the files in a directory tree satisfying specified criteria.

```matlab
%% Call getFileList to find fullpaths of files of form *_eeg.set
rootPath = 'G:/Sternberg/SternbergWorking';
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, extensions, excludeDirs);

%% Output the list of filenames
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
```
The `getFileList` function is useful as part of scripts designed to apply
an operation to all files of a particular type

(eeglab-events-to-tsv-anchor)=
## EEGLAB events to tsv

[**EEGLAB**](https://eeglab.org/) stores EEG files in `.set` format or as a
combination of two files in `.set` and `.fdt` format, respectively.
The EEGLAB `.set` format stores the data in a Matlab `EEG` structure.

The events in the recording are stored internally in the `.set` file
in the `EEG.event` substructure.
Assuming that your dataset is in 
[**BIDS**](https://bids-specification.readthedocs.io/en/stable/) format,
you may want to compare the events stored internally in `EEG.event` with
the events stored in an external `events.tsv` file required by BIDS.
The [`eeglabEventsToTsv`]() function 

````matlab
% Use eeglabEventsToTsv to save EEG.set events to tsv file
saveSuffix = '_events_temp.tsv';
nameSuffix = '_eeg';
eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);

````

The following scripts in MATLAB assume that you have a directory tree
(possibly in BIDS format) and that EEGLAB is in your MATLAB path.
For additional information on installation of EEGLAB, see the
[EEGLAB website](https://eeglab.org/).

The `dumpEEGLABEventFiles.m` function takes
you are starting with a dataset that is in EEGLAB format, and you wish to

(dump-eeglab-event-file-anchor1)=
## Dumping EEGLAB event files1