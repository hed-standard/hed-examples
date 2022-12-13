(file-remodeling-tools-anchor)=
# File remodeling tools

**Remodeling** refers to the process of transforming a tabular file
into a different form in order to disambiguate the
information or to facilitate a particular analysis.
The remodeling operations are specified in a JSON (`.json`) file,
giving a record of the transformations performed.

There are two types of remodeling operations: **transformation** and **summarization**.
The **transformation** operations modify the tabular files,
while **summarization** produces an auxiliary information file but leaves
the tabular files unchanged.

The file remodeling tools can be applied to any tab-separated value (`.tsv`) file
but are particularly useful for restructuring files representing experimental events.
Please read the [**File remodeling quickstart**](./FileRemodelingQuickstart.md)
tutorials for an introduction and basic use of the tools.

The file remodeling tools can be applied to individual files using the 
[**HED online tools**](https://hedtools.ucsd.edu/hed) or to entire datasets 
using the [**remodel command-line interface**](remodel-command-line-interface-anchor)
either by calling Python scripts directly from the command line 
or by embedding calls in a Jupyter notebook.
The tools are also available as 
[**HED RESTful services**](./HedOnlineTools.md#hed-restful-services).
The online tools are particularly useful for debugging.

This user's guide contains the following topics:

* [**The remodeling process**](the-remodeling-process-anchor)
* [**Installing the remodel tools**](installing-the-remodel-tools-anchor)
* [**Remodel command-line interface**](remodel-command-line-interface-anchor)
* [**Remodel scripts**](remodel-scripts-anchor)
* [**Remodel with HED**](remodel-with-hed-anchor)
* [**Remodel data formats**](remodel-file-format-anchor)
  * [**Example remodel file**](example-remodel-file-anchor)
  * [**Example event file**](example-event-file-anchor)
  * [**Example json sidecar**](example-json-sidecar-anchor)
* [**Remodel transformations**](remodel-transformations-anchor)
  * [**Factor column**](factor-column-anchor) 
  * [**Factor HED tags**](factor-hed-tags-anchor) 
  * [**Factor HED type**](factor-hed-type-anchor)
  * [**Merge consecutive**](merge-consecutive-anchor)
  * [**Number groups**](number-groups-anchor)
  * [**Number rows**](number-rows-anchor)
  * [**Remap columns**](remap-columns-anchor)
  * [**Remove columns**](remove-columns-anchor) 
  * [**Remove rows**](remove-rows-anchor) 
  * [**Rename columns**](rename-columns-anchor)
  * [**Reorder columns**](reorder-columns-anchor)
  * [**Split event**](split-event-anchor)
* [**Remodel summarizations**](remodel-summarizations-anchor)
  * [**Summarize column names**](summarize-column-names-anchor)
  * [**Summarize column values**](summarize-column-values-anchor)
  * [**Summarize events to sidecar**](summarize-events-to-sidecar-anchor)
  * [**Summarize hed tags**](summarize-hed-tags-anchor)
  * [**Summarize hed type**](summarize-hed-type-anchor)
  * [**Summarize hed validation**](summarize-hed-validation-anchor)
* [**Remodel implementation**](remodel-implementation-anchor)


(the-remodeling-process-anchor)=
## The remodeling process

Remodeling consists of restructuring and/or extracting information from tab-separated
value files based on a specified list of operations contained in a JSON file.

Internally, the remodeling operations represent the tabular file using a
[**Pandas DataFrame**](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html).

(transformation-operations-anchor)=
### Transformation operations

**Transformation** operations, shown schematically in the following
figure, are designed to transform an incoming tabular file
into a new DataFrame without modifying the incoming data.

![Transformation operations](./_static/images/TransformationOperations.png)

Transformation operations are stateless and do not save any context information or
affect future applications of the transformation.

Transformations, themselves, do not have any output and just return a new,
transformed DataFrame.
In other words, transformations do not operate in place on the incoming DataFrame,
but rather, they create a new DataFrame containing the result.

Typically, the calling program is responsible for reading and saving the tabular file,
so the user can choose whether to overwrite or create a new file.

See the [**remodeling tool program interface**](remodel-command-line-interface-anchor)
section for information on how to call the operations.

(summarization-operations-anchor)=
### Summarization operations

**Summarization** operations do not modify the input DataFrame
but rather extract and save information from the input DataFrame 
in an internally stored context state as shown schematically in the following figure.

![Summary operations](./_static/images/SummaryOperation.png)

The dispatcher that executes remodeling operations can be interrogated at any time
for the state information contained in the context and can save the contexts.
Usually summaries are dumped at the end of processing to the `derivatives/remodel/summaries`
subdirectory under the dataset root.

Summarization operations may appear anywhere in the operation list,
and the same type of summary may appear multiple times under different names in order to track progress.

The dispatcher stores information from each uniquely named summarization operation 
as a separate context.
Within its context information, most summarization operations keep a separate 
summary for each individual file and have methods to create an overall summary
of the information for all the files that have been processed by the summarization..

Summarization results are available in JSON (`.json`) and text (`.txt) formats.

(available-operations-anchor)=
### Available operations

The following table summarizes the available remodeling operations with a brief example use case
and links to further documentation. Operations not listed in the summarization section are transformations.

(remodel-operation-summary-anchor)=
````{table} Summary of the HED remodeling operations for tabular files.
| Category | Operation | Example use case |
| -------- | ------- | -----|
| **clean-up** |  |  | 
|  | [*remove_columns*](remove-columns-anchor) | Remove temporary columns created during restructuring. |
|  | [*remove_rows*](remove-rows-anchor) | Remove rows with n/a values in a specified column. |
|  | [*rename_columns*](rename-columns-anchor) | Make columns names consistent across a dataset. |
|  | [*reorder_columns*](reorder-columns-anchor) | Make column order consistent across a dataset. |
| **factor** |   |   | 
|  | [*factor_column*](factor-column-anchor) | Extract factor vectors from a column of condition variables. |
|  | [*factor_hed_tags*](factor-hed-tags-anchor) | Extract factor vectors from search queries of HED annotations. |
|  | [*factor_hed_type*](factor-hed-type-anchor) | Extract design matrices and/or condition variables. |
| **restructure** |  |  | 
|  | [*merge_consecutive*](merge-consecutive-anchor) | Replace multiple consecutive events of the same type<br/>with one event of longer duration. |
|   | [*number_groups*](number-groups-anchor)  |   |
|   | [*number_rows*](number-rows-anchor)   |    | 
|  | [*remap_columns*](remap-columns-anchor) | Create m columns from values in n columns (for recoding). |
|  | [*split_event*](split-event-anchor) | Split trial-encoded rows into multiple events. |
| **summarize** |  |  | 
|  | [*summarize_column_names*](summarize-column-names-anchor) | Summarize column names and order in the files. |
|  | [*summarize_column_values*](summarize-column-values-anchor) | Count the occurrences of the unique column values. |
|  | [*summarize_events_to_sidecar*](summarize-events-to-sidecar-anchor) | Generate a sidecar template from an event file. |
|  | [*summarize_hed_tags*](summarize-hed-tags-anchor) | Summarize the HED tags present in the  <br/> HED annotations for the dataset. |
|  | [*summarize_hed_type*](summarize-hed-type-anchor) | Summarize the detailed usage of a particular type tag <br/> such as *Condition-variable* or *Task* <br/> (used to automatically extract experimental designs). |
|  | [*summarize_hed_validation*](summarize-hed-validation-anchor) | Validate the data files and report any errors. |
````

The **clean-up** operations are used at various phases of restructuring to assure consistency
across event files in the dataset.

The **factor** operations produce column vectors of the same length as the events file
and encode condition variables, design matrices, or other search criteria.
See the 
[**HED conditions and design matrices**](https://hed-examples.readthedocs.io/en/latest/HedConditionsAndDesignMatrices.html)
for more information on factoring and analysis.

The **restructure** operations modify the way that event files represent events.

The **summarize** operations produce dataset-wide summaries of various aspects of the data.

(installing-the-remodel-tools-anchor)=
## Installing the remodel tools 

The remodeling tools are available in the GitHub 
[**hed-python**](https://github.com/hed-standard/hed-python) repository
along with other tools for data cleaning and curation.
Although version 0.1.0 of this repository is available on [**PyPI**](https://pypi.org/)
as `hedtools`, the version containing the restructuring tools (Version 0.2.0)
is still under development and has not been officially released.
However, the code is publicly available on the `develop` brnach of the 
hed-python repository and
can be directly installed from GitHub using `pip`:

```text
pip install git+https://github.com/hed-standard/hed-python/@develop
```

The web services and online tools supporting restructuring are available
on the [**HED online tools dev server**](https://hedtools.ucsd.edu/hed_dev).
When version 0.2.0 of `hedtools` is officially released on PyPI, restructuring
will become available on the released [**HED online tools**](https://hedtools.ucsd.edu/hed).
A docker version is also under development.

The following diagram shows a schematic of the remodeling process.

![Event remodeling process](./_static/images/EventRemappingProcess.png)

Initially, the user creates a backup of the event files.
This backup is a mirror of the events.tsv files in the dataset,
but is located in the `derivatives/remodel/backups` directory and never modified once the backup is created.

Restructuring applies a sequence of remodeling operations specified in a JSON remodel file
to the backup versions of the specified event files.
The JSON file provides a record of the operations performed on the file.
If the user detects a mistake in the transformations,
he/she can correct the transformation file and rerun the transformations.

Restructuring always runs on the original backup version of the file rather than
the transformed version, so the transformations can always be corrected and rerun.
It is possible to by-pass the backup, particularly if only using summarization operations,
but this is not recommended and should be done with care.

(remodel-command-line-interface-anchor)=
## Remodel command-line interface

The remodeling toolbox provides Python scripts with command-line interfaces
to create or restore backups and to apply the transformations to the files in a dataset.
The file remodeling tools may be applied to datasets that are in free form under a directory root
or that are in [**BIDS-format**](https://bids.neuroimaging.io/).
Some operations use [**HED (Hierarchical Event Descriptor)**](https://hed-examples.readthedocs.io/en/latest/HedIntroduction.html) annotations.
See the [**Remodel with HED**](remodel-with-hed-anchor) section for a discussion
of these operations and how to use them in your transformations.

The remodeling command-line interface can be used from the command line,
called from another Python program, 
or used in a Jupyter notebooks.
Example notebooks can be found in the
[**Jupyter notebooks**](https://github.com/hed-standard/hed-examples/tree/main/hedcode/jupyter_notebooks/remodeling)
 to support remodeling.


(calling-remodel-tools-anchor)=
### Calling remodel tools

The remodeling tools provide three Python programs for backup (*run_remodel_backup*),
remodeling (*run_remodel*) and restoring (*run_remodel_restore) event files.
These programs can be called from the command line or from another Python program.

The programs use a standard command line argument list for specifying input as summarized in the following table.

(remodeling-operation-summary-anchor)=
````{table} Summary of command line arguments for the remodeling programs.
| Script name | Arguments | Purpose | 
| ----------- | -------- | ------- |
|*run_remodel_backup* | *data_dir*<br/>*-e -\\-extensions*<br/>*-f -\\-file-suffix*<br/>*-n -\\-backup-name*<br/>*-t -\\-task-names*<br/>*-v -\\-verbose*<br/>-x -\\-exclude-dirs*| Create a backup event files. |
|*run_remodel* | *data_dir*<br/>*model_path*<br/>*-b -\\-bids-format*<br/>*-e -\\-extensions*<br/>*-f -\\-file-suffix*<br/>*-i =\\-include-individual*<br/>*-n -\\-backup-name*<br/>*-j -\\-json-sidecar*<br/>*-r -\\-hed-version*<br/>*-s -\\-save-formats*<br/>*-t -\\-task-names*<br/>*-v -\\-verbose*<br/>*-x -\\-exclude-dirs* | Restructure or summarize the event files. |
|*run_remodel_restore* | *data_dir*<br/>*-n -\\-backup-name*<br/>*-v -\\-verbose* | Restore a backup of event files. |

````
All the scripts have a required argument, which is the full path of the dataset root (*data_dir*).
The *run_remodel* program has a required parameter which

(remodel-command-line-arguments-anchor)=
### Remodel command-line arguments

This section describes the arguments that are used for the remodeling command-line interface
with examples and more details.

#### Positional arguments

Positional arguments are required and must be given in the order specified.

`data_dir`
> The full path of dataset root directory.

`model_path`
> The full path of the JSON remodel file (for *run_remodel* only).
> 
#### Named arguments

Named arguments consist of a key starting with a hyphen and possibly a value.
Named arguments can be given in any order or omitted. 
If omitted, a specified default is used.
Argument keys and values are separated by spaces.
For argument values that are lists, the key is given followed by the items in the list,
all separated by spaces.
Each command has two different forms of the key name: a short form and a longer form.
Users are free to use either form.

`-b`, `--bids-format`
> If this flag present, the dataset is in BIDS format with sidecars. Tabular files are located using BIDS naming.

`-e`, `--extensions`
> This option is followed by a list of file extension(s) of the data files to process.
> The default is `.tsv`. Comma separated tabular files are not permitted.

`-f`, `--file-suffix`
> This option is followed by the suffix names of the files to be processed.
> For example `events` (the default) captures files named `events.tsv` if the default extension is used.
> The filename without the extension must end in one of the specified suffixes in order to be
> backed up or transformed.

`-i`, `--include-individual`
> If this flag is present, summary information for individual files as well as an overall dataset summary
> is reported for all summarization operations.

`-j`, `--json-sidecar`
> This option is followed by the full path of the JSON sidecar with HED annotations to be
> applied during the processing of HED-related remodeling operations.

`-n`, `--backup_name`
> The name of the backup used for the remodeling (`default_back` by default).

`-r`, `--hed-versions`
> This option is followed by one or more HED versions. Versions of the standard schema are specified
> by their semantic versions (e.g., 8.1.0), while library schema versions are prefixed by their
> library name (e.g., score_1.0.0). If more than one version is given,
> only one version can be unprefixed. The remaining versions must have short-name prefixes such as sc:
> to distinguish among them. These short names also prefix the tags used from the corresponding schema.

`-s`, `--save-formats`
> This option is followed by the extensions (including .) of the formats in which 
> to save summaries (defaults: '.txt' '.json').

`-t`, `--task-names`
> The name(s) of the tasks to be included (for BIDS-formatted files only).
> When a dataset includes multiple tasks, the event files are often structured 
> differently for each task and thus require different transformation files.
> This option allows the backups and operations to be restricted to a single task.
> If this option is omitted, all tasks are used.

`-v`, `--verbose`
> If present, more comprehensive messages documenting transformation progress
> are printed to standard output.

`-x`, `--exclude-dirs`
> The directories to exclude when gathering the data files to process.
> For BIDS datasets, these are typically `derivatives`, `stimuli`, and `sourcecode`.
> Any subdirectory named `remodel` is automatically excluded from remodeling, as
> these directories are reserved for storing backup, state, and result information for the remodeling process itself.

(remodel-scripts-anchor)=
## Remodel scripts

This section discusses the three main remodeling scripts with command-line interfaces
to support backup, remodeling, and restoring the tabular files used in the remodeling process.

(backing-up-events-anchor)=
### Backing up events

The `run_remodel_backup` Python program creates a backup of the specified files.
The backup is always created in the `derivatives/remodel/backups` subdirectory
under the dataset root as shown in the following example for the
sample dataset `eeg_ds003654s_hed_remodel`,
which can be found in the `datasets` subdirectory of the 
[**hed-examples**](https://github.com/hed-standard/hed-examples) GitHub repository.

![Remodeling backup structure](./_static/images/RemodelingBackupStructure.png)
 

The backup process creates a mirror of the directory structure of the source files to be backed up
in the directory `derivatives/backup_name/backup_root` as shown in the figure above. 
The default backup name is `default_back`.

In the above example, the backup has subdirectories `sub-002` and `sub-003` just
like the main directory of the dataset.
These subdirectories only contain backups of the files to be transformed 
(usually files with names ending in `events.tsv`)

In addition, the `default_back` directory also contains a dictionary of backup files
in the `backup_lock.json` file. This dictionary is used internally by the remodeling tools.
The backup should be created once and not modified by the user.

The following example shows how to run the `run_remodel_backup.py` program from the command line
to back up the dataset located at `/datasets/eeg_ds003654s_hed_remodel`.

(remodel-backup-anchor)=
````{admonition} Example command-line to backup the events.
:class: tip

```bash
python run_remodel_backup.py /datasets/eeg_ds003654s_hed_remodel -x derivatives stimuli

```
````

Since the `-f` and `-e` arguments are not given, the default file suffix and extension values
are used so only files of the form `*events.tsv` are backed up.
The `-x` option excludes any source files from the `derivatives` and `stimuli` subdirectories.
These choices can be overridden using additional command-line arguments.

The following shows how the `run_remodel_backup` program can be called from a 
Python program or a Jupyter notebook.
The command-line arguments are given in a list instead of on the command line.

(remodel-backup-jupyter-anchor)=
````{admonition} Example Jupyter notebook to run backup.
:class: tip

```python

import os
from hed.tools.remodeling.backup_manager import BackupManager
import hed.tools.remodeling.cli.run_remodel_backup as cli_backup

data_root = os.path.realpath(/datasets/eeg_ds003654s_hed_remodel')
arg_list = [data_root, '-x', 'derivatives', 'stimuli']
cli_backup.main(arg_list)

```
````

During remodeling, each file in the source is associated with a backup file using 
its relative path from the dataset root.
Remodeling is performed by reading the backup file, performing the operations specified in the
transformation file, and overwriting the source file.

Users can also create alternatively named backups by providing the `-n` argument with a backup name to
the run_remodel_backup program.
To use backup files from another named backup, call the remodeling program with
the `-n` argument and the correct backup name.
Named backups can provide the equivalent of checkpoints in order to execute
transformations from intermediate points.

**NOTE**: You should not delete backups, even if you have created multiple named backups.
The backups provide useful state and provenance information about the data.

(remodel-files-anchor)=
### Remodel files

Remodeling consists of applying a sequence of operations from the 
[**Remodel operation summary table**](remodel-operation-summary-anchor) 
to the backup files corresponding to the event files in the dataset.
If the dataset has no backup files in `data-`
The transformations are specified as a list of dictionaries in a JSON file in the
[**Remodel file format**](remodel-file-format-anchor) as discussed below.

Before running remodeling transformations on an entire dataset,
consider using the [**HED online tools**](https://hedtools.ucsd.edu/hed) 
to debug your remodeling operations on a single file.
You are expected create to [**create the backup**](backing-up-events-anchor) (just once) 
before running the remodeling operations.
The only time a backup is not necessary is if you are only doing summarization operations.

The transformation process always starts with the original backup files,
so the usual development path is to incrementally add operations to the end 
of your transformation JSON file as you develop and test on a single file
until you have the desired end result.

The following example shows how to run a remodeling script from the command line.
The example assumes that the backup has already been created for the dataset.

(run-remodel-anchor)=
````{admonition} Example of running remodeling from command line.
:class: tip

```bash
python run_remodel.py /datasets/eeg_ds003654s_hed_remodel /datasets/remove_extra_rmdl.json -x derivatives simuli

```
````

The script has two required arguments the dataset root and the path to the JSON remodel file.
Usually, the JSON remodel files are stored with the dataset itself in the 
`derivatives/remodel/transformations` subdirectory, but common scripts can be stored in a central place.
An additional keyword option, `-x` indicates that directory paths containing the component `derivatives`
or the component `stimuli` should be excluded.
Excluded directories do not have to be at the top level of the dataset.
Directory paths containing the `remodel` component are automatically excluded.

The command-line interface can also be used in a Jupyter notebook or as part of a larger Python
program by calling the `main` function with the equivalent command-line arguments provided
in a list with the positional arguments appearing first.

The following example shows Python code to remodel a dataset using the command-line interface.
This code can be used in a Jupyter notebook or in another Python program.

````{admonition} Example python code to call remodeling through command-line interface.
:class: tip

```python
import os
import hed.tools.remodeling.cli.run_remodel as cli_remodel

data_root = '/datasets/eeg_ds003654s_hed_remodel'
model_path = '/datasets/remove_extra_rmdl.json'
arg_list = [data_root, model_path, '-x', 'derivatives', 'stimuli']
cli_remodel.main(arg_list)

```
````

(restoring-event-files-anchor)=
### Restoring event files

Since remodeling always uses the backed up version of each event file,
there is no need to restore the event files to their original state
between running remodeling operation files.
However, when finished with an analysis, 
you may want to restore the event files to their original state.

The following example shows how to call `run_remodel_restore` to
restore the event files from the default backup.
The restore operation restores all the files in the specified backup.

(run-remodel-restore-anchor)=
````{admonition} Example of restoring the default backup using the command-line interface.
:class: tip

```bash
python run_remodel_restore.py /datasets/eeg_ds003654s_hed_remodel

```
````

(remodel-with-hed-anchor)=
## Remodel with HED

[**HED**](hed-introduction-anchor) (Hierarchical Event Descriptors) is a
system for annotating data in a manner that is both human-understandable and machine-actionable.
HED provides much more detail about the events and their meanings,
If you are new to HED see the 
[**HED annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/HedAnnotationQuickstart.html).

Currently, three remodeling operations rely on HED annotations: 
[**factor HED tags**](factor-hed-tags-anchor), [**factor HED type**](factor-hed-type-anchor),
and [**summarize HED type**](summarize-hed-type-anchor).
HED tags provide a mechanism for advance data analysis and for 
extracting experiment-specific information from the events file. 
However, since HED information is usually not stored in the event files themselves,
two additional informational items must be provided: a HED schema and a JSON sidecar.
The HED schema defines the allowed HED tag vocabulary, and the JSON sidecar
associates HED annotations with the information in the columns of the event files.

If you are not using any of the HED operations in your remodeling,
you do not have to provide this information.
If the remodeling uses HED information, you must provide this information to the remodeling tools.
There are two ways to provide this information: using BIDS and explicitly providing the information.


(extracting-hed-information-from-bids-anchor)=
### Extracting HED information from BIDS

The simplest way to use HED with the `run_remodel` interface is with the `-b` option, 
which indicates that the dataset is in BIDS format.
[**BIDS**](https://bids.neuroimaging.io/) 
(Brain Imaging Data Structure) is a standardized way of organizing neuroimaging data.
HED and BIDS are well integrated.
If you are new to HED use in BIDS, see the
[**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html).

A HED-annotated BIDS dataset provides the HED schema version in the `dataset_description.json`
file that must be located in the directory directly under the BIDS dataset root.

BIDS datasets must have filenames in a specific format, 
and the HED tools can locate the relevant JSON sidecars for each event file based on this information.


(directly-specifying-hed-information-anchor)=
### Directly specifying HED information

If your data is already in BIDS format, using the `-b` option is ideal since
the needed information can be located automatically.
However, early in the experimental process, 
your datafiles are not likely to be organized in BIDS format,
and this option will not be available if you want to use HED.

Without the `-b` option, the remodeling tools locate the appropriate files based
on specified filename suffixes and extensions.
In order to use HED operations, you must explicitly specify the HED versions
using the `-r` option.
The `-r` option supports a list of HED versions if library functions are used.
For example: `-r 8.1.0 sc:score_1.0.0` specifies that vocabulary will be drawn
from [HED version 8.1.0](https://www.hedtags.org/display_hed.html) and from
[HED SCORE library version 1.0.0](https://www.hedtags.org/display_hed_score.html).
Annotations containing tags from SCORE must be prefixed with `sc:`.

Usually, annotators will consolidate HED annotations in a single JSON sidecar file
located at the top-level of the dataset.
The path of this sidecar can be passed as a command-line argument using the `-j` option.
If more than one JSON file contains HED annotations, users will need to call the lower-level
remodeling functions to perform these operations.

The following example illustrates a command-line call that passes both a HED schema version and
the path to the JSON file with the HED annotations.

(run-remodel-with-hed-direct-anchor)=
````{admonition} Remodeling a non-BIDS dataset using HED.
:class: tip

```bash
python run_remodel.py /datasets/eeg_ds003654s_hed_remodel /datasets/summarize_conditions_rmdl.json \
-x derivatives simuli -r 8.1.0 -j /datasets/task-FacePerception_events.json

```
````

(remodel-file-format-anchor)=
## Remodel file format

All remodeling operations are specified in a standardized JSON remodel input file.
The following shows the contents of the JSON remodeling file `remove_extra_rmdl.json`,
which contains a single operation with instructions to remove the `value` and `sample` columns 
from an event file if the columns exist.

(example-remodel-file-anchor)=
### Example remodel file

````{admonition} JSON remodeling file with an operation to remove the value and sample columns if they exist.
:class: tip

```json
[
    {
        "operation": "remove_columns",
        "description": "Remove unwanted columns prior to analysis",
        "parameters": {
            "remove_names": ["value", "sample"],
            "ignore_missing": true
        }
    }
]

```
````

Each operation is specified in a dictionary with three top-level keys: "operation", "description",
and "parameters". The value of the "operation" is the name of the operation.
The "description" value should include the reason this operation was needed,
not just a description of the operation itself.
Finally, the "parameters" value is a dictionary mapping parameter name to 
parameter value. 

The parameters for each operation are listed in
[**Remodel transformations**](remodel-transformations-anchor) and
[**Remodel summarizations**](remodel-summarizations-anchor) and.
An operation may have both required and optional parameters.
Optional parameters may be omitted if unneeded, but all parameters are specified in
the "parameters" section of the dictionary.

The remodeling JSON files should have names ending in `_rmdl.json`.
Although these files can be stored anywhere, their preferred location is
in the `deriviatves/remodel/transformations` subdirectory under the dataset root so
that they can provide provenance for the dataset.

(example-event-file-anchor)=
### Example event file

The examples in this tutorial use the following excerpt of the stop-go task from sub-0013
of the AOMIC-PIOP2 dataset available on [OpenNeuro](https://openneuro.org) as ds002790.
The full events file is 
[sub-0013_task-stopsignal_acq-seq_events.tsv](./_static/data/sub-0013_task-stopsignal_acq-seq_events.tsv).

(sample-remodel-events-file-anchor)=
````{admonition} Excerpt from an event file from the stop-go task of AOMIC-PIOP2 (ds002790).
| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | |correct | right | female 
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(example-json-sidecar-anchor)=
### Example JSON sidecar


The *factor_hed_type* and *factor_hed_tags* also require HED annotations of
the events and require a JSON sidecar that includes HED annotations. 
The tutorial uses the following JSON excerpt to illustrate these operations.
The full JSON file can be found at:
[task-stopsiqnal_acq-seq_events.json](./_static/data/task-stopsignal_acq-seq_events.json).
These HED operations also require the HED schema. 
The tutorials use the latest version that is downloaded from the web.


(sample-remodel-sidecar-file-anchor)=
````{admonition} Excerpt of JSON sidecar with HED annotations for the stop-go task of AOMIC-PIOP2.
:class: tip

```json
{
    "trial_type": {
        "HED": {
            "succesful_stop": "Sensory-presentation, Visual-presentation, Correct-action, Image, Label/succesful_stop",
            "unsuccesful_stop": "Sensory-presentation, Visual-presentation, Incorrect-action, Image, Label/unsuccesful_stop",
            "go": "Sensory-presentation, Visual-presentation, Image, Label/go"
        }
    },
    "stop_signal_delay": {
        "HED": "(Auditory-presentation, Delay/# s)"
        },
    "sex": {
        "HED": {
            "male": "Def/Male-image-cond",
            "female": "Def/Female-image-cond"
        }
    },
    "hed_defs": {
        "HED": {
            "def_male": "(Definition/Male-image-cond, (Condition-variable/Image-sex, (Male, (Image, Face))))",
            "def_female": "(Definition/Female-image-cond, (Condition-variable/Image-sex, (Female, (Image, Face))))"
        }
    }
}
```
````

(remodel-transformations-anchor)=
## Remodel transformations

(factor-column-anchor)=
### Factor column

The factor column operation is used to append factor vectors to event files
based on the values in a specified event file column. 
The factor vector contains a 1 if the corresponding row had that column value in that
row and a 0 otherwise.
The factor column is used to reformat event files for analyses such as linear regression
based on column values.

(factor-column-parameters-anchor)=
#### Factor column parameters

```{admonition} Parameters for the *factor_column* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_name* | str | The name of the column to be factored.| 
| *factor_values* | list | Column values to be included as factors. |
| *factor_names* | list| Column names for created factors. |
```

If *column_name* is not a column in the data, a `ValueError` is raised.
If *factor_values* is empty, factors are created for each unique value in *column_name*.
These names of the columns for these factors are of the form *column_name.factor_value*.
The *factor_names* parameters must be the same length as *factor_values*.
If *factor_names* is empty, the newly created columns are of the 
form *column_name.factor_value*.

(factor-column-example-anchor)=
#### Factor column example

The *factor_column* operation in the following example specifies that factor columns
should be created for *succesful_stop* and *unsuccesful_stop* of the *trial_type* column.
The resulting columns are called *stopped* and *stop_failed*, respectively.


````{admonition} A sample *factor_column* operation.
:class: tip

```json
{ 
    "operation": "factor_column"
    "description": "Create factors for the succesful_stop and unsuccesful_stop values."
    "parameters": {
        "column_name": "trial_type",
        "factor_values": ["succesful_stop", "unsuccesful_stop"],
        "factor_names": ["stopped", "stop_failed"]
    }
}
```
````

The results of executing this *factor_column* operation on the 
[sample remodel events file](sample-remodel-events-file-anchor) are:

````{admonition} Results of factoring column XXX.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex | stopped | stop_failed |
| ----- | -------- | ---------- |  ----------------- | ------------- | ----------------- | ------------- | --- | ---------- | ---------- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female | 0 | 0 |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female | 0 | 1 |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female | 0 | 0 |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female | 1 | 0 |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male | 0 | 1 |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male | 0 | 0 |
````

(factor-hed-tags-anchor)=
### Factor HED tags

The factor HED tags operation is similar to the factor column operation
in that it produces factor vectors containing 0's and 1.
However, rather than basing these values the values in a specified column,
the factor values are based on whether a specified search is satisfied
on the assembled HED tags describing the events in the corresponding row.
A simple search example might be whether the event was tagged with a particular tag value.

The HED annotation assembly process is described [XXX]. 
HED searches are based on a list of query filters, which are applied in succession
to the assembled HED strings for the event file.
Only events that satisfy each query filter as applied in succession 
will have a 1 value in the row.

(factor-hed-tags-parameters-anchor)=
#### Factor HED tags parameters

```{admonition} Parameters for the *factor_hed_tags* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *factor_name* | str | Name of the column to create for the factor. | 
| *remove_types* | list | Structural HED tags to be removed (usually *Condition-variable* and *Task*). | 
| *filter_queries* | list | Queries to be applied in succession to filter. | 

```

(factor-hed-tags-example-anchor)=
#### Factor HED tags example

[FIX THIS]
The *factor_hed-tags* operation in the following example specifies . . .

````{admonition} Example *factor_hed_tags* operation.
:class: tip

```json
{ 
    "operation": "factor_hed_tags"
    "description": "xxx"
    "parameters": {
        "column_name": "match_side",
        "source_columns": ["response_accuracy", "response_hand"],
        "mapping": {
            "left": [["correct", "left"], ["incorrect", "right"]],
            "right": [["correct", "right"], ["incorrect", "left"]]
        }
    }
}
```
````

The results of executing this *factor_hed-tags* operation on the 
[sample remodel events file](sample-remodel-events-file-anchor) using the
[sample remodel sidecar file](sample-remodel-sidecar-file-anchor) for HED annotations is:


````{admonition} Results of *factor_hed_tags*.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- |---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````


(factor-hed-type-anchor)=
### Factor HED type

The factor HED type operation produces factor columns in an event file
based on values of the specified HED type tag. 
The most common type is the HED *Condition-variable* tag, which corresponds to
factor vectors based in the experimental design.
Other commonly use type tags include *Task*, *Control-variable*, and *Time-block*.

We assume that the dataset has been annotated using HED tags to properly document
the experiment conditions and focus on how such an annotated dataset can be
used with event remodeling to produce factor columns in the event file corresponding to these
condition variables.

For additional information on how to encode experimental designs using HED please see
[HED conditions and design matrices](https://hed-examples.readthedocs.io/en/latest/HedConditionsAndDesignMatrices.html).

(factor-hed-type-parameters-anchor)=
#### Factor HED type parameters

```{admonition} Parameters for *factor_hed_type* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *type_tag* | str | HED tag used to find the factors (most commonly *Condition-variable*).| 
| *type_values* | list | Values to factor for the *type_tag*.<br>If empty all values of that type_tag are used. |
| *factor_encoding* | str | Indicates type of encoding. Valid encodings are 'categorical' and 'one-hot'. |
```

(factor-hed-type-example-anchor)=
#### Factor HED type example

The *factor_hed_type* operation in the following example causes
additional columns to be appended to each event file corresponding to
each possible value of each condition variable.
The columns contain 1's for rows corresponding to events that satisify
that value of the condition variable and 0 otherwise.

````{admonition} Example *factor_hed_type* operation.
:class: tip

```json
{ 
    "operation": "factor_hed_type"
    "description": "Factor based on the sex of the images being presented."
    "parameters": {
        "type_tag": "Condition-variable",
        "type_values": [],
        "factor_encoding": "one-hot"
    }
}
```
````

In order to use the JSON file.  The full file is at:

The results of executing this *factor_hed-tags* operation on the 
[sample remodel events file](sample-remodel-events-file-anchor) using the
[sample remodel sidecar file](sample-remodel-sidecar-file-anchor) for HED annotations are:


````{admonition} Results of *factor_hed_type*.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex | Image-sex.Female-image-cond | Image-sex.Male-image-cond |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- | ------- | ---------- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female | 1 | 0 |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female | 1 | 0 |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female | 1 | 0 |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female | 1 | 0 |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male | 0 | 1 |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male | 0 | 1 |
````

(merge-consecutive-anchor)=
### Merge consecutive

Sometimes in experimental logs, a single long event is represented by multiple repeat events. 
Merges these same events occurring consecutively into one event with duration 
of the new event updated to encompass the extent of the merged events.

(merge-consecutive-parameters-anchor)=
#### Merge consecutive parameters

```{admonition} Parameters for the *merge_consecutive* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_name* | str | The name of the column to be merged.| 
| *event_code* | str, int, float | The value in *column_name* . | 
| *match_columns* | list | Columns of that must match to collapse events.  |
| *set_durations* | bool | If True, set durations based on merged events. |
| *ignore_missing* | bool | If True, missing *column_name* or *match_columns* does not raise an error. |  
```

If the *set_duration* parameter is true, the duration is calculated as though
the event began with the onset of the event starts with the first event in the sequence and
ended at the end of the final event in the sequence.
If the *set_duration parameter is false, duration is set to `n/a`.

(merge-consecutive-example-anchor)=
#### Merge consecutive example

The *merge_consecutive* operation in the following example causes consecutive
*succesful_stop* events whose *stop_signal_delay*, *response_hand*, and *sex* columns
have the same values to be merged into a single event.


````{admonition} A sample *merge_consecutive* operation.
:class: tip

```json
{ 
    "operation": "merge_consecutive"
    "description": "Merge consecutive *succesful_stop* events that match the *match_columns."
    "parameters": {
        "column_name": "trial_type",
        "event_code": "succesful_stop",
        "match_columns": ["stop_signal_delay", "response_hand", "sex"],
        "set_durations": true,
        "ignore_missing": true
    }
}
```
````

When this restructuring operation is applied to the following input file, 
the three events with `trial_type` value of `unsuccesful_stop` starting
at `onset` value 13.5939 are merged into a single event.

````{admonition} Input file for a *merge_consecutive* operation.

| onset | duration | trial_type | stop_signal_delay | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | right | female| 
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | right | female| 
| 9.5856 | 0.5084 | go | n/a | right | female| 
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | female| 
| 14.2 | 0.5083 | succesful_stop | 0.2 |  n/a | female| 
| 15.3 | 0.7083 | succesful_stop | 0.2 |  n/a | female| 
| 17.3 | 0.5083 | succesful_stop | 0.25 |  n/a | female| 
| 19.0 | 0.5083 | succesful_stop | 0.25 | n/a | female| 
| 21.1021 | 0.5083 | unsuccesful_stop | 0.25 | left | male| 
| 22.6103 | 0.5083 | go | n/a | left | male |
````

Notice that the `unsuccesful_stop` event is at `onset` 17.3 is not
merged because the `stop_signal_delay` column value does not match
with the previous event.
The final result is shown in the following table.

````{admonition} The results of the *merge_consecutive* operation.

| onset | duration | trial_type |  stop_signal_delay | response_hand | sex |
| ----- | -------- | ---------- | ------------------ | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | right | female |
| 9.5856 | 0.5084 | go | n/a | right | female |
| 13.5939 | 2.4144 | succesful_stop | 0.2 | n/a | female |
| 17.3 | 2.2083 | succesful_stop | 0.25 |  n/a | female |
| 21.1021 | 0.5083 | unsuccesful_stop | 0.25 | left | male |
| 22.6103 | 0.5083 | go | n/a | left | male |
````

(number-groups-anchor)=
### Number groups

... coming soon ...

(number-rows-anchor)=
### Number rows

... coming soon ...


(remap-columns-anchor)=
### Remap columns

This operation maps the values that appear in a specified *m* columns of an event file
into values in *n* columns using a defined mapping.
The remap columns operation is often used for recoding the event file. 
The mapping should have targets for all combinations of values that appear in the *m* columns.

(remap-columns-parameters-anchor)=
#### Remap columns parameters

```{admonition} Parameters for the *remap_columns* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *source_columns* | list | Columns with combinations of values to be mapped.| 
| *destination_columns* | list | Columns to be mapped into. |
| *map_list* | list | A list. Each element consists n + m elements<br/> corresponding to the lengths of the source and destination lists respectively. |  
| *ignore_missing* | bool | If false, a combination of 
```
The *map_list* parameter specifies how each unique combination of values from the source 
columns will be mapped into the destination columns.
If there are *m* source columns and *n* destination columns,
then each entry in *map_list must be a list with *n* + *m* elements.

(remap-columns-example-anchor)=
#### Remap columns example

The *remap_columns* operation in the following example creates a new column called *response_type*
based on the unique values in the combination of columns *response_accuracy* and *response_hand*.

````{admonition} An example *remap_columns* operation.
:class: tip

```json
{ 
    "operation": "remap_columns",
    "description": "Map response_accuracy and response hand into a single column.",
    "parameters": {
        "source_columns": ["response_accuracy", "response_hand"],
        "destination_columns": ["response_type"],
        "map_list": [["correct", "left", "correct_left"],
                     ["correct", "right", "correct_right"],
                     ["incorrect", "left", "incorrect_left"],
                     ["incorrect", "right", "incorrect_left"],
                     ["n/a", "n/a", "n/a"]],
        "ignore_missing": true
    }
}
```
````

The results of executing the previous *remap_column* command on the
[sample remodel events file](sample-remodel-events-file-anchor) are:

````{admonition} Mapping columns *response_accuracy* and *response_hand* into a *response_type* column.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex | response_type | 
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- |  --- | ------------------- | 
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female | correct_right | 
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female | correct_right | 
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female | correct_right | 
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female | n/a | 
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male | correct_left | 
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male | correct_left | 
````

Typically, the *remap_columns* operation is used often used to map single codes in the experimental log
into multiple columns in the final events file.

(remove-columns-anchor)=
### Remove columns

Remove the specified columns if present.
If one of the specified columns is not in the file and the *ignore_missing*
parameter is *false*, a `KeyError` is raised for missing column.

(remove-columns-parameters-anchor)=
#### Remove columns parameters

```{admonition} Parameters for the *remove_columns* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *remove_names* | list of str | A list of columns to remove.| 
| *ignore_missing* | boolean | If true, missing columns are ignored, otherwise raise an error. |
```
The *ignore_missing* flag is important if there is a possibility that an event
file might not have one of the columns to be removed and you don't want this to cause an error.

(remove-columns-example-anchor)=
#### Remove columns example

The *remove_column* operation in the following example removes the *stop_signal_delay* and
*response_accuracy* columns. The *face* column is not in the dataframe, but it is ignored,
since *ignore_missing* is True.

````{admonition} An example *remove_columns* operation.
:class: tip

```json
{   
    "operation": "remove_columns",
    "description": "Remove columns before the next step.",
    "parameters": {
        "remove_names": ["stop_signal_delay", "response_accuracy", "face"],
        "ignore_missing": true
    }
}
```
````

The results of executing this operation on the
[sample remodel events file](sample-remodel-events-file-anchor)
are shown below.
Although *face* is not the name of a column in the dataframe,
it is ignored because *ignore_missing* is true.
If *ignore_missing* had been false, a `KeyError` would have been generated.

```{admonition} Results of executing the *remove_column*.
| onset | duration | trial_type | response_time | response_hand | sex |
| ----- | -------- | ---------- | ------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | 0.565 | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.49 | right | female |
| 9.5856 | 0.5084 | go | 0.45 | right | female |
| 13.5939 | 0.5083 | succesful_stop | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.633 | left | male |
| 21.6103 | 0.5083 | go | 0.443 | left | male |
````

(remove-rows-anchor)=
### Remove rows

Remove rows eliminates rows in which the named column has one of the specified values.

(remove-rows-parameters-anchor)=
#### Remove rows parameters

```{admonition} Parameters for *remove_rows*.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_name* | str | The name of the column to be tested.| 
| *remove_values* | list | A list of values to be tested for removal. | 
```

(remove-rows-example-anchor)=
#### Remove rows example

The following *remove_rows* operation removes the rows whose *trial_type* column 
has either *succesful_stop* or *unsuccesful_stop*.

````{admonition} Sample *remove_rows* operation.
:class: tip

```json
{   
    "operation": "remove_rows",
    "description": "Remove rows where trial_type is either succesful_stop or unsuccesful_stop.",
    "parameters": {
        "column_name": "trial_type",
        "remove_values": ["succesful_stop", "unsuccesful_stop"]
    }
}
```
````

The results of executing the previous *remove_rows* operation on the 
[sample remodel events file](sample-remodel-events-file-anchor) are:

````{admonition} The results of executing the previous *remove_rows* operation.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

After removing rows with *trial_type* equal to *succesful_stop* or *unsuccesful_stop* only the
three *go* trials remain.

(rename-columns-anchor)=
### Rename columns

Rename columns by providing a dictionary mapping old names to new names.

(rename-columns-parameters-anchor)=
#### Rename columns parameters

```{admonition} Parameters for *rename_columns*.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_mapping* | dict | The keys are the old column names and the values are the new names.| 
| *ignore_missing* | bool | If false, a key error is raised if a dictionary key is not a column name. | 

```
The *rename_columns* operation in the following example specifies that *response_hand* column be 
renamed *hand_used* and that the *sex* column be renamed *image_sex*.
The *face* entry in the mapping will be ignored because *ignore_missing* is true.
If *ignore_missing* is false, a `KeyError` exception is raised if a column specified in
the mapping does not correspond to a column name in the dataframe.

(rename-columns-example-anchor)=
#### Rename columns example

The following example renames the `stop_signal_delay` column to be `stop_delay` and
the `response_hand` to be `hand_used`.

````{admonition} Example *rename_columns* operation.
:class: tip

```json
{   
    "operation": "rename_columns",
    "description": "Rename columns to be more descriptive.",
    "parameters": {
        "column_mapping": {
            "stop_signal_delay": "stop_delay",
            "response_hand": "hand_used"
        },
        "ignore_missing": true
    }
}

```
````

The results of executing the previous *rename_columns* operation on the
[sample remodel events file](sample-remodel-events-file-anchor) are:

````{admonition} After the *rename_columns* operation is executed, the sample events file is:
| onset | duration | trial_type | stop_delay | response_time | response_accuracy | hand_used | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(reorder-columns-anchor)=
### Reorder columns

The reorder columns reorders the specified columns in the specified order.
Additional parameters control what to do with columns that aren't mentioned
or are missing.

(reorder-columns-parameters-anchor)=
#### Reorder columns parameters

```{admonition} Parameters for the *reorder_columns* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_order* | list | A list of columns in the order they should appear in the data.| 
| *ignore_missing* | bool | If true and a column in *column_order* does not appear in the dataframe<br>a *ValueError* is raised, otherwise these columns are ignored. | 
| *keep_others* | bool | If true, existing columns that aren't in *column_order*<br/>are moved to the end in the same relative<br/>order that they originally appeared in the data,<br>otherwise these columns are dropped.| 

```

If *ignore_missing* is true,
and items in the reorder list do not exist in the file, these columns are ignored.
On the other hand, if *ignore_missing* is false,
a column name not appearing in the reorder list causes a *ValueError* to be raised.

The *keep_others* parameter controls whether columns in the dataframe that
do not appear in the reorder list are dropped (*keep_others* is false) or
put at the end of the dataframe in the order they appear (*keep_others* is true).

(reorder-columns-example-anchor)=
#### Reorder columns example

The *reorder_columns* operation in the following example specifies that the first four
columns of the dataset should be: *onset*, *duration*, *trial_type*, *response_hand*, and *response_time*.
Since *ignore_missing* is true, these will be the only columns retained.

````{admonition} Example *reorder_columns* operation.
:class: tip

```json
{   
    "operation": "reorder_columns",
    "description": "Reorder columns.",
    "parameters": {
        "column_order": ["onset", "duration", "response_time",  "trial_type"],
        "ignore_missing": true,
        "keep_others": false
    }
}
```
````


The results of executing the previous *reorder_columns* operation on the
[sample remodel events file](sample-remodel-events-file-anchor) are:

````{admonition} Results of *reorder_columns*.

| onset | duration | response_time | trial_type |
| ----- | -------- | ---------- | ------------- |
| 0.0776 | 0.5083 | 0.565 | go |
| 5.5774 | 0.5083 | 0.49 | unsuccesful_stop |
| 9.5856 | 0.5084 | 0.45 | go |
| 13.5939 | 0.5083 | n/a | succesful_stop |
| 17.1021 | 0.5083 | 0.633 | unsuccesful_stop |
| 21.6103 | 0.5083 | 0.443 | go |
````

(split-event-anchor)=
### Split event

The *split_event*, which is one of the more complicated remodeling operations, 
is often used to convert event files from using *trial-level* encoding to *event-level* encoding.
In *trial-level* encoding each row of the event file represents all the events in a single trial
(usually some variation of the cue-stimulus-response-feedback-ready sequence).
In *event-level* encoding, each row represents the marker for a single event.
In this case a trial consists of a sequence of multiple events.


(split-event-parameters-anchor)=
#### Split event parameters

```{admonition} Parameters for the *split_event* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *anchor_event* | str | The name of the column that will be used for split-event codes.| 
| *new_events* | dict | Dictionary whose keys are the codes to be inserted as new events<br>and whose values are dictionaries with<br>keys *onset_source*, *duration*, and *copy_columns*. | 
| *remove_parent_event* | bool | If true, remove parent event. | 

```


The *split_event* operation requires an *anchor_column*, which could be an existing
column or a column that must be added to the dataframe.
The purpose of the *anchor_column* is to hold the codes for the new events.

The *new_events* dictionary has the new events to be created.
The keys are the new event codes to be inserted into the *anchor_column*.
The values in *new_events* are themselves dictionaries.
Each of these dictionaries has three keys: 

- *onset_source*, a list specifying the items to be added to the *onset*
of the event row being split. These items can be any combination of numerical values and column names.
- *duration* a list of any combinations of numerical values and column names whose values are to be added
to compute the duration.
- *copy_columns* a list of column names whose values should be copied into the new events.
Unlisted columns are filled with `n/a`.


The *split_event* operation sorts the split events by the `onset` column and creates an error
if there is no such column. 
The `onset` column is converted to numeric values as part splitting process.

(split-events-example-anchor)=
#### Split events example

The *split_event* operation in the following example specifies that new rows should be added
to encode the response and stop signal. The anchor column is still trial_type.
In a full processing example, it might make sense to rename *trial_type* to be
*event_type* and to delete the *response_time* and the *stop_signal_delay*
since these items have been unfolded into separate events.

````{admonition} An example *split_event* operation.
:class: tip

```json
{
  "operation": "split_events",
  "description": "add response events to the trials.",
        "parameters": {
            "anchor_column": "trial_type",
            "new_events": {
                "response": {
                    "onset_source": ["response_time"],
                    "duration": [0],
                    "copy_columns": ["response_accuracy", "response_hand", "sex", "trial_number"]
                },
                "stop_signal": {
                    "onset_source": ["stop_signal_delay"],
                    "duration": [0.5],
                    "copy_columns": ["trial_number"]
                }
            },	
            "remove_parent_event": false
        }
    }
```
````

The results of executing this *split_event* operation on the
[sample remodel events file](sample-remodel-events-file-anchor) are:

````{admonition} Results of the previous *split_event* operation.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 0.6426 | 0 | response | n/a | n/a | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female |
| 5.7774 | 0.5 | stop_signal | n/a | n/a | n/a | n/a | n/a |
| 6.0674 | 0 | response | n/a | n/a | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 10.0356 | 0 | response | n/a | n/a | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 13.7939 | 0.5 | stop_signal | n/a | n/a | n/a | n/a | n/a |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 17.3521 | 0.5 | stop_signal | n/a | n/a | n/a | n/a | n/a |
| 17.7351 | 0 | response | n/a | n/a | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
| 22.0533 | 0 | response | n/a | n/a | correct | left | male |
````

Note that the event numbers are added before the splitting and then
copied as the new events are created.
This strategy results in a trial number column associated with the events,
an alternative to the more complicated process of adding a structure column after splitting.

(remodel-summarizations-anchor)=
## Remodel summarizations

(summarize-column-names-anchor)=
### Summarize column names

Summarize column names keeps track of the unique column name patterns in a dataset and
which event files these patterns are associated with. 
This summary is useful for determining whether there are any non-conforming event files.
Often the event files associated with different tasks have different event file column names,
and this summary can be used to verify that the files corresponding to the same task
have the same column names.
A more problematic issue is when some event files for the same task
have reordered column names or different column names.

(summarize-columns-names-parameters-anchor)=
#### Summarize column names parameters

The *summarize_column_names* operation only has the two parameters required of
all summaries. 

```{admonition} Parameters for the *summarize_column_names* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *summary_name* | str | A unique name used to identify this summary.| 
| *summary_filename* | str | A unique file basename to use for saving this summary. |
```
The *summary_name* is the unique key used to identify the
particular incarnation of this summary in the dispatcher.
Since a particular operation file may use a given operation multiple times,
care should be taken to make sure that it is unique.

The *summary_filename* should also be unique and is used for saving the summary upon request.
When the remodeler is applied to full datasets rather than single files,
the summaries are saved in the `derivatives/remodel/summaries` directory under the dataset root.
A time stamp and file extension are appended to the *summary_filename* when the
summary is saved.

(summarize-column-names-example-anchor)=
#### Summarize column names example

The following example shows the JSON for including this operation in a remodeling file.

````{admonition} Sample *summarize_column_names* operation.
:class: tip
```json   
{
    "operation": "summarize_column_names",
    "description": "Summarize column names.",
    "parameters": {
        "summary_name": "AOMIC_column_names",
        "summary_filename": "AOMIC_column_names"
    }    
}
```
````

When this operation is applied to the [sample remodel events file](sample-remodel-events-file-anchor),
the following JSON summary is produced.

````{admonition} Result of applying *summarize_column_names* to the sample remodel file.
:class: tip

```json
{
    "context_name": "AOMIC_column_names",
    "context_type": "column_names",
    "context_filename": "AOMIC_column_names",
    "summary": {
        "unique_patterns": 1,
        "files": 1,
        "column_name_patterns": {
            "0": {
                "column_names": [
                    "onset",
                    "duration",
                    "trial_type",
                    "stop_signal_delay",
                    "response_time",
                    "response_accuracy",
                    "response_hand",
                    "sex"
                ],
                "file_list": [
                    "aomic_sub-0013_excerpt_events.tsv"
                ]
            }
        }
    }
}
```
````

Since we are only summarizing one event file, there is only one unique pattern -- corresponding
to the columns: *onset*, *duration*, *trial_type*, *stop_signal_delay*, *response_time*, *response_accuracy*, *response_hand*, and *response_time*.
The output lists each unique pattern separately along with the names of the dataframes that have this pattern.

The text version of a summary is derived from the JSON summary by removing various
braces and extra spaces for readability.

````{admonition} Text summary of *summarize_column_names* operation on the sample remodel file.
:class: tip

```text
Context name: AOMIC_column_names
Context type: column_names
Context filename: AOMIC_column_names
Summary:
    unique_patterns: 1
    files: 1
    patterns: 
        0: 
            column_names: [
                onset
                duration
                trial_type
                stop_signal_delay
                response_time
                response_accuracy
                response_hand
                sex
            ]
            file_list: [
                aomic_sub-0013_excerpt_events.tsv
            ]
```
````


(summarize-column-values-anchor)=
### Summarize column values

The summarize column values operation provides a summary of the number of times various
column values appear in event files across the dataset. 


(summarize-columns-values-parameters-anchor)=
#### Summarize column values parameters

The following table lists the parameters required for using the summary.

```{admonition} Parameters for the *summarize_column_values* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *summary_name* | str | A unique name used to identify this summary.| 
| *summary_filename* | str | A unique file basename to use for saving this summary. |
| *skip_columns* | list | A list of column names to omit from the summary.| 
| *value_columns* | list | A list of columns to omit the listing unique values. |
```
The standard summary parameters, *summary_name* and *summary_filename* are required.
The *summary_name* is the unique key used to identify the
particular incarnation of this summary in the dispatcher.
Since a particular operation file may use a given operation multiple times,
care should be taken to make sure that it is unique.

The *summary_filename* should also be unique and is used for saving the summary upon request.
When the remodeler is applied to full datasets rather than single files,
the summaries are saved in the `derivatives/remodel/summaries` directory under the dataset root.
A time stamp and file extension are appended to the *summary_filename* when the
summary is saved.

In addition to the standard parameters, *summary_name* and *summary_filename* required of all summaries,
the *summarize_column_values* operation requires three additional lists to be supplied.
The *skip_columns* list specifies the names of columns to skip entirely in the summary.
Some columns, such as *onset* are usually skipped because they are required and each
event typically has a unique values.

For datasets that include multiple tasks, the event values for each task may be distinct.
The *summarize_column_values* operation currently does not separate by task.


(summarize-column-values-example-anchor)=
#### Summarize column values example

The following example shows the JSON for including this operation in a remodeling file.

````{admonition} Sample *summarize_column_values* operation.
:class: tip
```json
{
   "operation": "summarize_column_values",
   "description": "Summarize the column values in an excerpt.",
   "parameters": {
       "summary_name": "AOMIC_column_values",
       "summary_filename": "AOMIC_column_values",
       "skip_columns": ["onset", "duration"],
       "value_columns": ["response_time", "stop_signal_delay"]
   }
},  
```
````

The results of executing this operation on the
[sample remodel events file](sample-remodel-events-file-anchor)
are shown in the following example using the text format.

````{admonition} Sample *summarize_column_values* operation results in text format.
:class: tip
```text
Context name: AOMIC_column_values
Context type: column_values
Context filename: AOMIC_column_values
Summary:
    Summary name: AOMIC_column_values
    Categorical columns: 
        response_accuracy [categorical column] values: 
            correct: 5
            nan: 1    
        response_hand [categorical column] values: 
            left: 2
            right: 4
        sex [categorical column] values: 
            female: 4
            male: 2
        trial_type [categorical column] values: 
            go: 3
            succesful_stop: 1
            unsuccesful_stop: 2  
    Value columns: 
        response_time [value_column]: 6 values
        stop_signal_delay [value_column]: 6 values
```
````

Because the [sample remodel events file](sample-remodel-events-file-anchor)
only has 6 events, we expect that no value will be represented in more than 6 events.
The column names corresponding to value columns just have the event counts in them.

(summarize-events-to-sidecar-anchor)=
### Summarize events to sidecar

The summarize events to sidecar operation generates a sidecar template from the event
files in the dataset. 


(summarize-events-to-sidecar-parameters-anchor)=
#### Summarize events to sidecar parameters

The following table lists the parameters required for using the summary.

```{admonition} Parameters for the *summarize_events_to_sidecar* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *summary_name* | str | A unique name used to identify this summary.| 
| *summary_filename* | str | A unique file basename to use for saving this summary. |
| *skip_columns* | list | A list of column names to omit from the sidecar.| 
| *value_columns* | list | A list of columns to treat as value columns in the sidecar. |
```
The standard summary parameters, *summary_name* and *summary_filename* are required.
The *summary_name* is the unique key used to identify the
particular incarnation of this summary in the dispatcher.
Since a particular operation file may use a given operation multiple times,
care should be taken to make sure that it is unique.

The *summary_filename* should also be unique and is used for saving the summary upon request.
When the remodeler is applied to full datasets rather than single files,
the summaries are saved in the `derivatives/remodel/summaries` directory under the dataset root.
A time stamp and file extension are appended to the *summary_filename* when the
summary is saved.

In addition to the standard parameters, *summary_name* and *summary_filename* required of all summaries,
the *summarize_column_values* operation requires two additional lists to be supplied.
The *skip_columns* list specifies the names of columns to skip entirely in
generating the sidecar template.
The *value_columns* list specifies the names of columns to treat as value columns
when generating the sidecar template.

(summarize-events-to-sidecar-example-anchor)=
#### Summarize events to sidecar example

The following example shows the JSON for including this operation in a remodeling file.

````{admonition} Sample *summarize_events_to_sidecar* operation.
:class: tip
```json
{
    "operation": "summarize_events_to_sidecar",
    "description": "Generate a sidecar from the excerpted events file.",
    "parameters": {
        "summary_name": "AOMIC_generate_sidecar",
        "summary_filename": "AOMIC_generate_sidecar",
        "skip_columns": ["onset", "duration", "response_accuracy"],
        "value_columns": ["response_time", "stop_signal_delay"]
    }
}
  
```
````

The results of executing this operation on the
[sample remodel events file](sample-remodel-events-file-anchor)
are shown in the following example using the text format.

````{admonition} Sample *summarize_events_to_sidecar* operation results in text format.
:class: tip
```json
{
    "context_name": "AOMIC_generate_sidecar",
    "context_type": "events_to_sidecar",
    "context_filename": "AOMIC_generate_sidecar",
    "summary": {
        "trial_type": {
            "Description": "Description for trial_type",
            "HED": {
                "go": "(Label/trial_type, Label/go)",
                "succesful_stop": "(Label/trial_type, Label/succesful_stop)",
                "unsuccesful_stop": "(Label/trial_type, Label/unsuccesful_stop)"
            },
            "Levels": {
                "go": "Here describe column value go of column trial_type",
                "succesful_stop": "Here describe column value succesful_stop of column trial_type",
                "unsuccesful_stop": "Here describe column value unsuccesful_stop of column trial_type"
            }
        },
        "response_hand": {
            "Description": "Description for response_hand",
            "HED": {
                "left": "(Label/response_hand, Label/left)",
                "right": "(Label/response_hand, Label/right)"
            },
            "Levels": {
                "left": "Here describe column value left of column response_hand",
                "right": "Here describe column value right of column response_hand"
            }
        },
        "sex": {
            "Description": "Description for sex",
            "HED": {
                "female": "(Label/sex, Label/female)",
                "male": "(Label/sex, Label/male)"
            },
            "Levels": {
                "female": "Here describe column value female of column sex",
                "male": "Here describe column value male of column sex"
            }
        },
        "response_time": {
            "Description": "Description for response_time",
            "HED": "(Label/response_time, Label/#)"
        },
        "stop_signal_delay": {
            "Description": "Description for stop_signal_delay",
            "HED": "(Label/stop_signal_delay, Label/#)"
        }
    }
}
```
````

(summarize-hed-tags-anchor)=
### Summarize HED tags

The summarize HED tags operation extracts experimental design matrices or other
experimental structure.
This summary operation assumes that the structure in question is suitably 
annotated with HED (Hierarchical Event Descriptors). 
The [**HED conditions and design matrices**](https://hed-examples.readthedocs.io/en/latest/HedConditionsAndDesignMatrices.html)
explains how this works.

(summarize-hed-tags-parameters-anchor)=
#### Summarize HED tags parameters

The *summarize_column_names* operation only has the two parameters required of
all summarizes. 
The *summarize_column_names* operation only has the two parameters required of
all summarizes. 

```{admonition} Parameters for the *summarize_hed_tags* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *summary_name* | str | A unique name used to identify this summary.| 
| *summary_filename* | str | A unique file basename to use for saving this summary. |
| *type_tag* | str | Tag to produce a summary for (most often *condition-variable*).| 
```
The *summary_name* is the unique key used to identify the
particular incarnation of this summary in the dispatcher.
Since a particular operation file may use a given operation multiple times,
care should be taken to make sure that it is unique.

The *summary_filename* should also be unique and is used for saving the summary upon request.
When the remodeler is applied to full datasets rather than single files,
the summaries are saved in the `derivatives/remodel/summaries` directory under the dataset root.
A time stamp and file extension are appended to the *summary_filename* when the
summary is saved.

The *type_tag* can be any tag, but for experimental design summaries the *condition-variable*
tag is used.


(summarize-hed-tags-example-anchor)=
#### Summarize HED tags example

````{admonition} An example *summarize_hed_tags* operation.
:class: tip
```json
{
   "operation": "summarize_hed_tags",
   "description": "Summarize column names.",
   "parameters": {
       "summary_name": "AOMIC_condition_variables",
       "summary_filename": "AOMIC_condition_variables",
       "type_tag": "condition-variable"
   }
}
```
````

The results of executing this operation on the
[sample remodel events file](sample-remodel-events-file-anchor) are shown below.

````{admonition} Text summary of *summarize_hed_tags* operation on the sample remodel file.
:class: tip

```text
Context name: AOMIC_condition_variables
Context type: summarize_hed_tags
Context filename: AOMIC_condition_variables
Summary:
    image-sex: 
        variable_value: image-sex
        variable_type: condition-variable
        levels: 2
        direct_references: 0
        total_events: 6
        events: 6
        multiple_events: 0
        multiple_event_maximum: 1
        level_counts: 
            female-image-cond: 
                files: 1
                events: 4          
            male-image-cond: 
                files: 1
                events: 2
```
````

Because *summarize_hed_tags* is a HED operations, we must also provide information
about the HED annotations.
This summary was produced by using `hed_version="8.1.0"` when creating the `dispatcher`
and using the [HED aomic sidecar](sample-remodel-sidecar-file-anchor) in the `do_op`.
The sidecar provides the annotations that use the `condition-variable` tag in the summary.


(summarize-hed-type-anchor)=
### Summarize HED type

The summarize HED type operation is designed to extract experimental design matrices or other
experimental structure.
This summary operation assumes that the structure in question is suitably 
annotated with HED (Hierarchical Event Descriptors). 
The [**HED conditions and design matrices**](https://hed-examples.readthedocs.io/en/latest/HedConditionsAndDesignMatrices.html)
explains how this works.

(summarize-hed-type-parameters-anchor)=
#### Summarize HED type parameters

The *summarize_column_names* operation only has the two parameters required of
all summarizes. 
The *summarize_column_names* operation only has the two parameters required of
all summarizes. 

```{admonition} Parameters for the *summarize_hed_type* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *summary_name* | str | A unique name used to identify this summary.| 
| *summary_filename* | str | A unique file basename to use for saving this summary. |
| *type_tag* | str | Tag to produce a summary for (most often *condition-variable*).| 
```
The *summary_name* is the unique key used to identify the
particular incarnation of this summary in the dispatcher.
Since a particular operation file may use a given operation multiple times,
care should be taken to make sure that it is unique.

The *summary_filename* should also be unique and is used for saving the summary upon request.
When the remodeler is applied to full datasets rather than single files,
the summaries are saved in the `derivatives/remodel/summaries` directory under the dataset root.
A time stamp and file extension are appended to the *summary_filename* when the
summary is saved.

The *type_tag* can be any tag, but for experimental design summaries the *condition-variable*
tag is used.


(summarize-hed-type-example-anchor)=
#### Summarize HED type example

````{admonition} An example *summarize_hed_type* operation.
:class: tip
```json
{
   "operation": "summarize_hed_type",
   "description": "Summarize column names.",
   "parameters": {
       "summary_name": "AOMIC_condition_variables",
       "summary_filename": "AOMIC_condition_variables",
       "type_tag": "condition-variable"
   }
}
```
````

The results of executing this operation on the
[sample remodel events file](sample-remodel-events-file-anchor) are shown below.

````{admonition} Text summary of *summarize_hed_types* operation on the sample remodel file.
:class: tip

```text
Context name: AOMIC_condition_variables
Context type: summarize_hed_type
Context filename: AOMIC_condition_variables
Summary:
    image-sex: 
        variable_value: image-sex
        variable_type: condition-variable
        levels: 2
        direct_references: 0
        total_events: 6
        events: 6
        multiple_events: 0
        multiple_event_maximum: 1
        level_counts: 
            female-image-cond: 
                files: 1
                events: 4          
            male-image-cond: 
                files: 1
                events: 2
```
````

Because *summarize_hed_type* is a HED operations, we must also provide information
about the HED annotations.
This summary was produced by using `hed_version="8.1.0"` when creating the `dispatcher`
and using the [HED aomic sidecar](sample-remodel-sidecar-file-anchor) in the `do_op`.
The sidecar provides the annotations that use the `condition-variable` tag in the summary.

(summarize-hed-validation-anchor)=
### Summarize HED validation

The summarize HED validation operation is designed to extract experimental design matrices or other
experimental structure.
This summary operation assumes that the structure in question is suitably 
annotated with HED (Hierarchical Event Descriptors). 
The [**HED conditions and design matrices**](./HedConditionsAndDesignMatrices.md)
explains how this works.

(summarize-hed-validation-parameters-anchor)=
#### Summarize HED validation parameters

The *summarize_column_names* operation only has the two parameters required of
all summarizes. 
The *summarize_column_names* operation only has the two parameters required of
all summarizes. 

```{admonition} Parameters for the *summarize_hed_validation* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *summary_name* | str | A unique name used to identify this summary.| 
| *summary_filename* | str | A unique file basename to use for saving this summary. |
| *check_for_warnings* | bool | If true, warnings should be reported.| 
```
The *summary_name* is the unique key used to identify the
particular incarnation of this summary in the dispatcher.
Since a particular operation file may use a given operation multiple times,
care should be taken to make sure that it is unique.

The *summary_filename* should also be unique and is used for saving the summary upon request.
When the remodeler is applied to full datasets rather than single files,
the summaries are saved in the `derivatives/remodel/summaries` directory under the dataset root.
A time stamp and file extension are appended to the *summary_filename* when the
summary is saved.

The *check_for_warnings* flag indicates whether warnings should be reported.
**Add discussion of warnings versus errors**.


(summarize-hed-validation-example-anchor)=
#### Summarize HED validation example

````{admonition} An example *summarize_hed_type* operation.
:class: tip
```json
{
   "operation": "summarize_hed_type",
   "description": "Summarize column names.",
   "parameters": {
       "summary_name": "AOMIC_condition_variables",
       "summary_filename": "AOMIC_condition_variables",
       "type_tag": "condition-variable"
   }
}
```
````

The results of executing this operation on the
[sample remodel events file](sample-remodel-events-file-anchor) are shown below.

````{admonition} Text summary of *summarize_hed_types* operation on the sample remodel file.
:class: tip

```text
Context name: AOMIC_condition_variables
Context type: summarize_hed_type
Context filename: AOMIC_condition_variables
Summary:
    image-sex: 
        variable_value: image-sex
        variable_type: condition-variable
        levels: 2
        direct_references: 0
        total_events: 6
        events: 6
        multiple_events: 0
        multiple_event_maximum: 1
        level_counts: 
            female-image-cond: 
                files: 1
                events: 4          
            male-image-cond: 
                files: 1
                events: 2
```
````

Because *summarize_hed_validation* is a HED operation,
we must also provide information about the HED annotations.
This summary was produced by using `hed_version="8.1.0"` when creating the `dispatcher`
and using the [HED aomic sidecar](sample-remodel-sidecar-file-anchor) in the `do_op`.
The sidecar provides the annotations that use the `condition-variable` tag in the summary.

(remodel-implementation-anchor)=
## Remodel implementation

Operations are defined as classes that extent `BaseOp` regardless of whether 
they are transformations or summaries. However, summaries must also implement
an additional supporting class that extends `BaseContext` to hold the summary information.

In order to be executed by the remodeling functions, 
an operation must appear in the `valid_operations` dictionary.

All operations must provide a `PARAMS` dictionary, a constructor that calls the
base class constructor and the `check_parameters` function, and a `do_ops` method.

### The PARAMS dictionary

The class-wide `PARAMS` dictionary has `operation`, `required_parameters` and `optional_parameters` keys.
The `required_parameters` and `optional_parameters` have values that are themselves dictionaries
specifying the name and type of each parameter defined for the operations.

The following example shows the `PARAMS` dictionary for the `RemoveColumsnOp` class.

````{admonition} The class-wide PARAMS dictionary for the RemoveColumnsOp class.
:class: tip
```python
PARAMS = {
    "operation": "remove_columns",
    "required_parameters": {
        "remove_names": list,
        "ignore_missing": bool
    },
    "optional_parameters": {}
}
```
````
The `PARAMS` dictionary allows the remodeling tools to check the syntax of the remodel input file for errors.


(operation-class-constructor-anchor)=
### Operation class constructor

All the operation classes have constructors that start with a call to the superclass constructor and
then a call to the  `check_parameters` method defined in `BaseOp`.
The following example shows the constructor for the `RemoveColumnsOp` class.

````{admonition} The class-wide PARAMS dictionary for the RemoveColumnsOp class.
:class: tip
```python
   def __init__(self, parameters):
        super().__init__(PARAMS["operation"], PARAMS["required_parameters"], PARAMS["optional_parameters"])
        self.check_parameters(parameters)
        self.remove_names = parameters['remove_names']
        ignore_missing = parameters['ignore_missing']
        if ignore_missing:
            self.error_handling = 'ignore'
        else:
            self.error_handling = 'raise'
```
````

After the call to the base class method `check_parameters`, which checks the parameters
against the requirements of `PARAMS`, the constructor assigns the operation-specific
values to class properties and does any additional required class-specific checks
to assure that the parameters are valid.


(do_op-implementation-anchor)=
### The do_op implementation

The main method that must be implemented by each operation is `do_op`, which takes
an instance of the `Dispatcher` class as the first parameter and a Pandas `DataFrame`
representing the event file as the second parameter.
A third required parameter is a name used to identify the event file in error messages and summaries. 
This name is usually the filename or the filepath from the dataset root.
An additional optional argument, a sidecar containing HED annotations,
only need be included for HED operations.

The following example shows a sample implementation for `do_op`.

````{admonition} The implementation of do_op for the RemoveColumnsOp class.
:class: tip
```python

    def do_op(self, dispatcher, df, name, sidecar=None):
        return df.drop(self.remove_names, axis=1, errors=self.error_handling)
```
````

The `do_op` operation for summary operations has a slightly different form as it
serves primarily as a wrapper for the actual summary information as illustrated
by the following example.

(implementation-of-do-op_summarize-column-names-anchor)=
````{admonition} The implementation of do_op for the SummarizeColumnNamesOp class.
:class: tip
```python
    def do_op(self, dispatcher, df, name, sidecar=None):
        summary = dispatcher.context_dict.get(self.summary_name, None)
        if not summary:
            summary = ColumnNameSummary(self)
            dispatcher.context_dict[self.summary_name] = summary
        summary.update_context({"name": name, "column_names": list(df.columns)})
        return df

```
````

A `do_op` operation for a summary checks the `dispatcher` to see if it's
summary name is already in the dispatcher's `context_dict`. 
If that summary is not yet in the `context_dict`, 
the operation creates a `BaseContext` object for its summary (e.g., `ColumnNameSummary`)
and adds it to the dispatcher's `context_dict`,
otherwise the operation fetches the `BaseContext` object from 
It then asks its `BaseContext` object to update the context based on the dataframe
as explained in the next section.

(additional-requirements-for-summaries-anchor)=
### Additional requirements for summaries

Any summary operation must implement a supporting class that extends `BaseContext`.
This class is used to hold and accumulate the information specific to the summary.
This support class must implement two methods: `update_context` and `get_summary_details`.

The `update_context` method is called by its associated `BaseOp` operation during the `do_op`
to update the summary information based on the current dataframe.
The `update_context` information takes a single parameter, which is a dictionary of information
specific to this operation.

````{admonition} The update_context method required to be implemented by all BaseContext objects.
:class: tip
```python
  def update_context(self, new_context)
```
````

In the example [do_op for ColumnNamesOp](implementation-of-do-op_summarize-column-names-anchor),
the dictionary is contains keys for `name` and `column_names.

The `get_summary_details` returns a dictionary with the summary-specific information
currently in the summary.
The `BaseContext` provides universal methods for converting this summary to JSON or text format.


````{admonition} The get_summary_details method required to be implemented by all BaseContext objects.
:class: tip
```python
  get_summary_details(self, verbose=True)
```
````
The operation associated with this instance of it associated with a given informat
implementation