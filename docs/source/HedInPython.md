# HED in Python

The HED (Hierarchical Event Descriptor) scripts and notebooks all assume
that the Python HedTools have been installed.
HedTools is not yet available on PyPI, so you will need to install them
directly from GitHub using:

```shell
 pip install git+https://github.com/hed-standard/hed-python/@master
```
There are several types of Jupyter notebooks supporting HED:
* [**Jupyter notebooks for HED in BIDS**](jupyter-notebooks-for-hed-in-bids-anchor)   
* [**Jupyter summary notebooks**](jupyter-summary-notebooks-anchor)  
* [**Jupyter data curation notebooks**](jupyter-data-curation-notebooks-anchor)   


(jupyter-notebooks-for-hed-in-bids-anchor)=
## Jupyter notebooks for HED in BIDS

The following notebooks are specifically designed to support HED annotation
for BIDS datasets.

[**Summarize BIDS event files**](summarize-bids-event-files)  
[**Extract a JSON sidecar from event files**](extract-a-json-sidecar-from-event-files)  
[**Validate HED in a BIDS dataset**](validate-hed-in-bids-dataset-anchor)  


(summarize-bids-event-files)=
### Summarize BIDS event files

A first step in annotating a BIDS dataset is to find out what is in the dataset
event files.
Sometimes event files include unexpected or incorrect codes.
It is a good idea to find out what is actually in the dataset
event files before starting the annotation process.

The [**bids_summarize_events.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_summarize_events.ipynb) Jupyter notebook summarizes the unique values
that appear in a BIDS dataset `events.tsv` files along with the number of occurrences. 

To use the notebook, supply the full path to the root directory of your BIDS dataset.
Optionally, you can supply a list of column names of columns to skip in the summary. 

The script returns the number of occurrences of each unique entry in each of the remaining
columns across the BIDS dataset.

(extract-a-json-sidecar-from-event-files)=
### Extract a JSON sidecar from event files

The usual strategy for producing machine-actionable event annotation using HED in BIDS is
to create a single `events.json` sidecar file in the BIDS dataset root directory.
Ideally, this sidecar will contain all the annotations needed for users to
understand and analyze the data.
(See the [**BIDS annotation quickstart**](BidsAnnotationQuickstart.md) for additional
information on this strategy.)

The [**bids_extract_sidecar.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_extract_sidecar.ipynb) Jupyter notebook creates an `events.json` sidecar
template based on the information in all of the `events.tsv` files in a BIDS dataset.

To use the script, you will need to provide the path to the BIDS dataset root directory.
You should also designate a list of column to skip and a list of columns to annotate
as a whole rather than by each individual unique value in that column.

[**Create a JSON template**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html#create-a-json-template) provides a step-by-step tutorial for using the
online tool that creates a template based on the information in a single `events.tsv` file.
For most datasets, this is sufficient.
In contrast, [**bids_extract_sidecar.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_extract_sidecar.ipynb)
bases the extracted template on the entire dataset.


(validate-hed-in-bids-dataset-anchor)=
### Validate HED in a BIDS dataset

Validating HED annotations as you develop them makes the annotation process easier and
faster to debug.

The [**bids_validate_hed.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_validate_hed.ipynb)
Jupyter notebook validates HED in a BIDS dataset using the `validate` method
of `BidsDataset`.
The method first  gathers all the relevant JSON sidecars for each event file
and validates the sidecars. It then validates the individual `events.tsv` files
based on applicable sidecars.

**Note:** This validation pertains to event files and HED annotation only.
It does not do a full BIDS validation.


(jupyter-summary-notebooks-anchor)=
## Jupyter summary notebooks

** This section is under development. **
These notebooks are used to produce JSON summaries of dataset events.

(jupyter-data-curation-notebooks-anchor)=
## Jupyter data curation notebooks

** This section is under development**

* [Dictionaries of filenames](dictionaries-of-filenames-anchor)  
* [Logging of processing steps](logging-of-processing-steps-anchor)


These notebooks are used to check the consistency of datasets and
to clean up minor inconsistencies in the `events.tsv` files.

Generally, we want the event files in a BIDS dataset to have the same
column names in the same order.
We would like good descriptions of the `events.tsv` columns as well
as of individual values.

These notebooks are used to process specific datasets.
Mainly these notebooks are used for detected and correcting errors
and refactoring or reorganizing dataset events.

(getting-a-list-of-files-anchor)=
### Getting a list of files

This describes getting a list of files.

(dictionaries-of-filenames-anchor)=
### Dictionaries of filenames

In order to compare the events coming from various BIDS events files,
many of the HED Jupyter notebooks rely on dictionaries of `key` to full path
for each type of file.
The HED data processing scripts make extensive use of the function
`make_file_dict`.

````{admonition} Making a file dictionary
:class: tip
```python
file_dict = make_file_dict(file_list, name_indices=name_indices)
```
````

Keys are calculated from the filename using a `name_indices` tuple,
which indicates the positions of the name-value entity pairs in the
BIDS file name to use.

````{admonition} Possible keys for a BIDS filename.

The BIDS filename `sub-001_ses-3_task-target_run-01_events.tsv` has
three name-value entity pairs (`sub-001`, `ses-3`, `task-target`,
and `run-01`) separated by underbars.

The tuple (0, 2) gives a key of `sub-001_task-target`,
while the tuple (0, 3) gives a key of `sub-001_run-01`.
Neither of these choices uniquely identifies the file.
The tuple (0, 1, 3) gives a unique key of `sub-001_ses-3_run-01`.
The tuple (0, 1, 2, 3) also works.
````
The Jupyter notebook
[go_nogo_initial_summary.ipynb](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/jupyter_notebooks/dataset_specific_processing/go_nogo/go_nogo_initial_summary.ipynb)
illustrates using this dictionary in a larger context.

(logging-of-processing-steps-anchor)=
### Logging of processing steps

Often event data files require considerable processing to assure
internal consistency and compliance with the BIDS specification.
Once this processing is done and the files have been transformed
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

The most common use for a logger is to create a file dictionary
using [**make_file_dict**](dictionaries-of-filenames-anchor)
and then to log each processing step using the file's key.
This allows a processing step to be applied to all files in the dataset.
After all the processing is complete, the `print_log` method
outputs the logged messages by key, thus showing all the
processing steps that hav been applied to each file
as shown in the [**previous example**](example-output-hed-logger-anchor).

(using-hed-logger-example-anchor)=
`````{admonition} Using the HED logger.
:class: tip
```python
status = HedLogger()
status.add(key, f"Concatenated the BIDS and EEG event files")

# ... after processing is complete output or save the log
status.print_log()
```
`````

The `HedLogger` is used throughout the processing notebooks
in this repository. 