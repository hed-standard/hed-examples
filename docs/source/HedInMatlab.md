# HED in MATLAB
**Note: This tutorial is in the process of being developed.** 

MATLAB has support for  

* [**HED services in MATLAB**](hed-services-matlab-anchor) 
* [**HED MATLAB scripts**](hed-matlab-scripts-anchor) 
* [**EEGLAB integration**](eeglab-integration-anchor)  


(hed-services-matlab-anchor)=
## HED services in MATLAB





(hed-matlab-scripts-anchor)=
## HED MATLAB scripts

**This tutorial is underdevelopment.**

* [**Find files in directory tree**](find-files-directory-tree-anchor)
* [**EEGLAB events to a tsv file**](eeglab-events-to-a-tsv-file-anchor)  


(find-files-directory-tree-anchor)=
### Find files in directory tree

The [**getFileList**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_utilities/getFileList.m)
function returns a cell array of full path names of
the files in a directory tree satisfying specified criteria.

`````{admonition} Example call to getFileList.
:class: tip
````matlab
%% Call getFileList to find fullpaths of files of form *_eeg.set
rootPath = '/local/data/Sternberg';
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, extensions, excludeDirs);

%% Output the list of filenames
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
````
`````

The `getFileList` function is useful in scripts designed to apply
an operation to all files of a particular type in a directory tree.

(eeglab-events-to-a-tsv-file-anchor)=
### EEGLAB events to a tsv file

[**EEGLAB**](https://eeglab.org/) stores EEG files in `.set` format or as a
combination of two files in `.set` and `.fdt` format, respectively.
The EEGLAB `.set` format stores the data in a Matlab `EEG` structure.

The events in the recording are stored internally in the `.set` file
in the `EEG.event` substructure.
Assuming that your dataset is in 
[**BIDS**](https://bids-specification.readthedocs.io/en/stable/) format,
you may want to compare the events stored internally in `EEG.event` with
the events stored in an external `events.tsv` file required by BIDS.

The [`eeglabEventsToTsv`](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_utilities/eeglabEventsToTsv.m)
function takes a list of full pathnames of EEGLAB `.set` files and creates `.tsv` files
containing the `EEG.event` structure in tab-separated-value form in the same
directories as the corresponding `.set` files.

`````{admonition} Example call to eeglabEventsToTsv.
:class: tip
````matlab
% Use eeglabEventsToTsv to save EEG.set events to a tsv file
saveSuffix = '_events.tsv';
nameSuffix = '_eeg';
eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);
````
`````

In this example, `/local/data/Sternberg/sub-01_task-memory_run-1_eeg.set`
will produce an event file `/local/data/Sternberg/sub-01_task-memory_run-1_events.tsv`.
The `nameSuffix` and extension are removed from the filename, and the 
`saveSuffix` is appended.

(eeglab-integration-anchor)=
## EEGLAB integration

This is where a description of use in EEGLAB with links.