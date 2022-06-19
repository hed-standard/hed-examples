# HED in Python

The HED (Hierarchical Event Descriptor) scripts and notebooks assume
that the Python HedTools have been installed.
The HedTools package is not yet available on PyPI, so you will need to install it
directly from GitHub using:

```shell
 pip install git+https://github.com/hed-standard/hed-python/@master
```
There are several types of Jupyter notebooks and other HED support tools:
* [**Jupyter notebooks for HED in BIDS**](jupyter-notebooks-for-hed-in-bids-anchor) - aids for HED annotation in BIDS.
* [**Jupyter notebooks for data curation**](jupyter-curation-notebooks-anchor) - aids for
summarizing and reorganizing event data.
* [**Calling HED tools**](calling-hed-tools-anchor) - specific useful functions/classes.


(jupyter-notebooks-for-hed-in-bids-anchor)=
## Jupyter notebooks for HED in BIDS

The following notebooks are specifically designed to support HED annotation
for BIDS datasets.

* [**Summarize BIDS event files**](summarize-bids-event-files-anchor) 
* [**Extract a JSON sidecar template from event files**](extract-a-json-sidecar-template-anchor)  
* [**Convert a JSON sidecar to a 4-column spreadsheet**](sidecar-to-spreadsheet-anchor)  
* [**Validate HED in a BIDS dataset**](validate-hed-in-bids-dataset-anchor)  


(summarize-bids-event-files-anchor)=
### Summarize BIDS event files

Sometimes event files include unexpected or incorrect codes.
It is a good idea to find out what is actually in the dataset
event files and whether the information is consistent before starting the annotation process.

The [**bids_summarize_events.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_summarize_events.ipynb) finds the dataset event files and outputs
the column names and number of events for each event file.
You can visually inspect the output to make sure that the event file column names
are consistent across the dataset.
The script also summarizes the unique values
that appear in different event file columns across the dataset.

To use this notebook, substitute the specifics of your BIDS
dataset for the following variables:

```{admonition} Variables to set in the bids_summarize_events.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| bids_root_path | Full path to root directory of dataset.|
| exclude_dirs | List of directories to exclude when constructing the list of event files. |
| entities  | Tuple of entity names used to construct a unique keys representing filenames. <br>(See [Dictionaries of filenames](dictionaries-of-filenames-anchor) for examples of how to choose the keys.)|
| name_indices  | Indices used to construct a unique keys representing event filenames.<br>(See [Dictionaries of filenames](dictionaries-of-filenames-anchor) for examples of how to choose these indices.)|
| skip_columns  |  List of column names in the `events.tsv` files to skip in the analysis. |
```

For large datasets, be sure to skip columns such as
`onset` and `sample`, since the summary produces counts of the number of times
each unique value appears somewhere in dataset event files.

(extract-a-json-sidecar-template-anchor)=
### Extract a JSON sidecar template

The usual strategy for producing machine-actionable event annotation using HED in BIDS is
to create a single `events.json` sidecar file in the BIDS dataset root directory.
Ideally, this sidecar will contain all the annotations needed for users to
understand and analyze the data.

See the [**BIDS annotation quickstart**](BidsAnnotationQuickstart.md) for additional
information on this strategy and an online version of the tools.
The [**Create a JSON template**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html#create-a-json-template) section
provides a step-by-step tutorial for using the online tool that creates a 
template based on the information in a single `events.tsv` file.
For most datasets, this is sufficient.
In contrast, the [**bids_generate_sidecar.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_generate_sidecar.ipynb)
notebook bases the extracted template on the entire dataset.

To use this notebook, substitute the specifics of your BIDS
dataset for the following variables:

```{admonition} Variables to set in the bids_extract_sidecar.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| bids_root_path | Full path to root directory of dataset.|
| exclude_dirs | List of directories to exclude when constructing the list of event files. |
| entities  | Tuple of entity names used to construct a unique keys representing filenames. <br>(See [Dictionaries of filenames](dictionaries-of-filenames-anchor) for examples of how to choose the keys.)|
| skip_columns  |  List of column names in the `events.tsv` files to skip in the analysis. |
| value_columns | List of columns names in the `events.tsv` files to annotate as<br>as a whole rather than by individual column value. |
```

For large datasets, be sure to skip columns such as
`onset` and `sample`, since the summary produces counts of the number of times
each unique value appears somewhere in dataset event files.

(sidecar-to-spreadsheet-anchor)=
### JSON sidecar to spreadsheet

If you have a BIDS JSON event sidecar or a sidecar template,
you may find it more convenient to view and edit the HED annotations in
spreadsheet rather than working with the JSON file directly as explained in the
[**Spreadsheet templates**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html#spreadsheet-templates-anchor)
tutorial.

The [**bids_sidecar_to_spreadsheet.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_sidecar_to_spreadsheet.ipynb)
notebook demonstrates how to extract the pertinent
HED annotation to a 4-column spreadsheet (Pandas dataframe) corresponding
to the HED content of a JSON sidecar.
A spreadsheet representation is useful for quickly reviewing and editing HED annotations.
You can easily merge the edited information back into the BIDS JSON events sidecar.

Here is an example of the spreadsheet that is produced by converting a JSON sidecar
template to a spreadsheet template that is ready to edit.
You should only change the values in the **description** and the **HED** columns.

```{admonition} Example 4-column spreadsheet template for HED annotation.
| column_name | column_value | description | HED |
| --------------- | ---------------- | --------------- | ------- |
| event_type | setup_right_sym | Description for setup_right_sym | Label/setup_right_sym |
| event_type | show_face | Description for show_face | Label/show_face |
| event_type | left_press | Description for left_press | Label/left_press |
| event_type | show_circle | Description for show_circle | Label/show_circle |
| stim_file | n/a | Description for stim_file | Label/# |
```
To use this notebook, you will need to provide the path to the JSON sidecar and a path to
save the spreadsheet if you want to save it.
If you don't wish to save the spreadsheet, assign `spreadsheet_filename` to be None.

The [**bids_merge_sidecar.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_merge_sidecar.ipynb) notebook shows the complete process,
from extracting the initial sidecar, to converting to a spreadsheet and then
merging in another sidecar.

(validate-hed-in-bids-dataset-anchor)=
### Validate HED in a BIDS dataset

Validating HED annotations as you develop them makes the annotation process easier and
faster to debug.
The [**HED validation guide**](https://hed-examples.readthedocs.io/en/latest/HedValidation.html)
discusses various HED validation issues and how to fix them.

The [**bids_validate_dataset.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_validate_dataset.ipynb)
Jupyter notebook validates HED in a BIDS dataset using the `validate` method
of `BidsDataset`.
The method first  gathers all the relevant JSON sidecars for each event file
and validates the sidecars. It then validates the individual `events.tsv` files
based on applicable sidecars.

The script requires you to set the `check_for_warnings` flag and the root path to
your BIDS dataset.

**Note:** This validation pertains to event files and HED annotation only.
It does not do a full BIDS validation.

The [**bids_validate_dataset_with_libraries.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_validate_dataset_with_libraries.ipynb)
Jupyter notebook validates HED in a BIDS dataset using the `validate` method of `BidsDataset`.
The example uses three schemas and also illustrates how to manually override the
schema specified in `dataset_description.json` with schemas from other places.
This is very useful for testing new schemas that are underdevelopment.
 
(jupyter-curation-notebooks-anchor)=
## Jupyter notebooks for data curation

All data curation notebooks and other examples can now be found
in the [**hed-curation**](https://github.com/hed-standard/hed-curation) repository.


(consistency-of-BIDS-event-files-anchor)=
### Consistency of BIDS event files

Some neuroimaging modalities such as EEG, typically contain event information
encoded in the data recording files, and the BIDS `events.tsv` files are
generated post hoc. 

In general, the following things should be checked before data is released:
1. The BIDS `events.tsv` files have the same number of events as the data
recording and that onset times of corresponding events agree.
2. The associated information contained in the data recording and event files is consistent.
3. The relevant metadata is present in both versions of the data.

The example data curation scripts discussed in this section assume that two versions
of each BIDS event file are present: `events.tsv` and a corresponding `events_temp.tsv` file.
The example datasets that are using for these tutorials assume that the recordings
are in EEG.set format.
We used the [runEeglabEventsToFiles](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_utilities/runEeglabEventsToFiles.m)
MATLAB script to dump the events stored in the data.


(calling-hed-tools-anchor)=
## Calling HED tools

This section shows examples of useful processing functions provided in HedTools:

* [**Getting a list of filenames**](getting-a-list-of-files-anchor)  
* [**Dictionaries of filenames**](dictionaries-of-filenames-anchor) 
* [**Logging processing steps**](logging-processing-steps-anchor) 


(getting-a-list-of-files-anchor)=
### Getting a list of files

Many situations require the selection of files in a directory tree based on specified criteria.
The `get_file_list` function allows you to pick out files with a specified filename
prefix and filename suffix and specified extensions

The following example returns a list of full paths of the files whose names end in `_events.tsv`
or `_events.json` that are not in any `code` or `derivatives` directories in the `bids_root_path`
directory tree.
The search starts in the directory root `bids_root_path`:

````{admonition} Get a list of specified files in a specified directory tree.
:class: tip
```python
file_list = get_file_list(bids_root_path, extensions=[ ".json", ".tsv"], name_suffix="_events",
                          name_prefix="", exclude_dirs=[ "code", "derivatives"])
```
````

(dictionaries-of-filenames-anchor)=
### Dictionaries of filenames

The HED tools provide both generic and BIDS-specific classes for dictionaries of filenames.


The 
Many of the HED data processing tools make extensive use of dictionaries specif

#### BIDS-specific dictionaries of files

Files in BIDS have unique names that indicate not only what the file represents, 
but also where that file is located within the BIDS dataset directory tree.

##### BIDS file names and keys
A BIDS file name consists of an underbar-separated list of entities,
each specified as a name-value pair, 
followed by suffix indicating the data modality.

For example, the file name `sub-001_ses-3_task-target_run-01_events.tsv`
has entities subject (`sub`), task (`task`), and run (`run`).
The suffix is `events` indicating that the file contains events.
The extension `.tsv` gives the data format.

Modality is not the same as data format, since some modalities allow
multiple formats. For example, `sub-001_ses-3_task-target_run-01_eeg.set`
and `sub-001_ses-3_task-target_run-01_eeg.edf` are both acceptable
representations of EEG files, but the data is in different formats.

The BIDS file dictionaries represented by the class `BidsFileDictionary`
and its extension `BidsTabularDictionary` use a set combination of entities
as the file key.

For a file name `sub-001_ses-3_task-target_run-01_events.tsv`,
the tuple ('sub', 'task') gives a key of `sub-001_task-target`,
while the tuple ('sub', 'ses', 'run) gives a key of `sub-001_ses-3_run-01`.
The use of dictionaries of file names with such keys makes it
easier to associate related files in the BIDS naming structure.

Notice that specifying entities ('sub', 'ses', 'run) gives the
key `sub-001_ses-3_run-01` for all three files:
`sub-001_ses-3_task-target_run-01_events.tsv`, `sub-001_ses-3_task-target_run-01_eeg.set`
and `sub-001_ses-3_task-target_run-01_eeg.edf`.
Thus, the expected usage is to create a dictionary of files of one modality.

````{admonition} Create a key-file dictionary for files ending in events.tsv in bids_root_path directory tree.
:class: tip
```python
from hed.tools import FileDictionary
from hed.util import get_file_list

file_list = get_file_list(bids_root_path, extensions=[ ".set"], name_suffix="_eeg", 
                          exclude_dirs=[ "code", "derivatives"])
file_dict = BidsFileDictionary(file_list, entities=('sub', 'ses', 'run) )
```
````

In this example, the `get_file_list` filters the files of the appropriate type,
while the `BidsFileDictionary` creates a dictionary with keys such as
`sub-001_ses-3_run-01` and values that are `BidsFile` objects.
`BidsFile` can hold the file name of any BIDS file and keeps a parsed
version of the file name.



#### A generic dictionary of filenames


````{admonition} Create a key-file dictionary for files ending in events.json in bids_root_path directory tree.
:class: tip
```python
from hed.tools import FileDictionary
from hed.util import get_file_list

file_list = get_file_list(bids_root_path, extensions=[ ".json"], name_suffix="_events", 
                          exclude_dirs=[ "code", "derivatives"])
file_dict = FileDictionary(file_list, name_indices=name_indices)
```
````

Keys are calculated from the filename using a `name_indices` tuple,
which indicates the positions of the name-value entity pairs in the
BIDS file name to use.

The BIDS filename `sub-001_ses-3_task-target_run-01_events.tsv` has
three name-value entity pairs (`sub-001`, `ses-3`, `task-target`,
and `run-01`) separated by underbars.

The tuple (0, 2) gives a key of `sub-001_task-target`,
while the tuple (0, 3) gives a key of `sub-001_run-01`.
Neither of these choices uniquely identifies the file.
The tuple (0, 1, 3) gives a unique key of `sub-001_ses-3_run-01`.
The tuple (0, 1, 2, 3) also works giving `sub-001_ses-3_task-target_run-01`.

If you choose the `name_indices` incorrectly, the keys for the event files
will not be unique, and the notebook will throw a `HedFileError`.
If this happens, modify your `name_indices` key choice to include more entity pairs.

The Jupyter notebook
[go_nogo_01_initial_summary.ipynb](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/jupyter_notebooks/dataset_specific_processing/go_nogo/go_nogo_01_initial_summary.ipynb)
illustrates using this dictionary in a larger context.

For example, to compare the events stored in a recording file and the events
in the `events.tsv` file associated with that recording,
we might dump the recording events in files with the same name, but ending in `events_temp.tsv`.
The `FileDictionary` class allows us to create a keyed dictionary for each of these event files.


(logging-processing-steps-anchor)=
### Logging processing steps

Often event data files require considerable processing to assure
internal consistency and compliance with the BIDS specification.
Once this processing is done and the files have been transformed,
it can be difficult to understand the relationship between the
transformed files and the original data.

The `HedLogger` allows you to document processing steps associated
with the dataset by identifying key as illustrated in the following
log file excerpt:

(example-output-hed-logger-anchor)=
`````{admonition} Example output from HED logger.
:class: tip
```text
sub-001_run-01
	Reordered BIDS columns as ['onset', 'duration', 'sample', 'trial_type', 'response_time', 'stim_file', 'value', 'HED']
	Dropped BIDS skip columns ['trial_type', 'value', 'response_time', 'stim_file', 'HED']
	Reordered EEG columns as ['sample_offset', 'event_code', 'cond_code', 'type', 'latency', 'urevent', 'usertags']
	Dropped EEG skip columns ['urevent', 'usertags', 'type']
	Concatenated the BIDS and EEG event files for processing
	Dropped the sample_offset and latency columns
	Saved as _events_temp1.tsv
sub-002_run-01
	Reordered BIDS columns as ['onset', 'duration', 'sample', 'trial_type', 'response_time', 'stim_file', 'value', 'HED']
	Dropped BIDS skip columns ['trial_type', 'value', 'response_time', 'stim_file', 'HED']
	Reordered EEG columns as ['sample_offset', 'event_code', 'cond_code', 'type', 'latency', 'urevent', 'usertags']
	Dropped EEG skip columns ['urevent', 'usertags', 'type']
	Concatenated the BIDS and EEG event files for processing
	. . .
```
`````

Each of the lines following a key represents a print message to the logger.

The most common use for a logger is to create a file dictionary
using [**make_file_dict**](dictionaries-of-filenames-anchor)
and then to log each processing step using the file's key.
This allows a processing step to be applied to all the relevant files in the dataset.
After all the processing is complete, the `print_log` method
outputs the logged messages by key, thus showing all the
processing steps that hav been applied to each file
as shown in the [**previous example**](example-output-hed-logger-anchor).

(using-hed-logger-example-anchor)=
`````{admonition} Using the HED logger.
:class: tip
```python
from hed.tools import HedLogger
status = HedLogger()
status.add(key, f"Concatenated the BIDS and EEG event files")

# ... after processing is complete output or save the log
status.print_log()
```
`````

The `HedLogger` is used throughout the processing notebooks in this repository.
