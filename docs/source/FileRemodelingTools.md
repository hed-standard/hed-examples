# File remodeling tools

Restructuring or **remodeling** refers to the process of transforming a tabular file
(usually representing dataset events) into a different form to disambiguate the
information or to facilitate a particular analysis.

The file remodeling tools can be applied to any tab-separated value (`.tsv`) file
but are particularly useful for restructuring files representing experimental events.
Please read the [**Event file restructuring quickstart**](https://hed-examples.readthedocs.io/en/latest/EventFileRestructuringQuickstart.html)
tutorials for an introduction to file restructuring and basic use of the tools.

The tools can be applied to individual files using the 
[**HED online tools**](https://hedtools.ucsd.edu/hed) or to entire datasets 
using the [**Remodel command line interface**](remodel-command-line-interface-anchor)
either by calling directly or by embedding in a Jupyter notebook.
The tools are also available as [**HED RESTful services**](https://hed-examples.readthedocs.io/en/latest/HedOnlineTools.html#hed-restful-services).
The online tools are particularly useful for debugging.

This user's guide contains the following topics:

* [**Event remodeling overview**](event-remodeling-overview-anchor)
* [**Installing remodeling tools**](installing-remodeling-tools-anchor)
* [**Remodel command-line interface**](remodel-command-line-interface-anchor) 
   * [**Calling-remodel-tools**](calling-remodel-tools-anchor)
   * [**Remodel command arguments**](remodel-command-arguments-anchor)
   * [**Backing up events**](backing-up-events-anchor)
   * [**Restructuring event files**](restructuring-event-files-anchor)
   * [**Restoring event files**](restoring-event-files-anchor)
   * [**Remodeling with HED and BIDS**](remodeling-with-hed-and-bids-anchor)
* [**Remodel file formats**](remodel-file-formats-anchor)
* [**Remodeling operations**](remodeling-operations-anchor)
  * [**Create event**](create-event-anchor)
  * [**Factor column**](factor-column-anchor) 
  * [**Factor HED tags**](factor-hed-tags-anchor) 
  * [**Factor HED type**](factor-hed-type-anchor)
  * [**Merge consecutive**](merge-consecutive-anchor)
  * [**Number groups**](number-groups-anchor)
  * [**Number rows**](number-rows-anchor)
  * [**Remap columns**](remap-columns-anchor)
  * [**Remove columns**](remove-columns-anchor) 
  * [**Rename columns**](rename-columns-anchor)
  * [**Reorder columns**](reorder-columns-anchor)
  * [**Split event**](split-event-anchor)
  * [**Summarize column names**](summarize-column-names-anchor)
  * [**Summarize column values**](summarize-column-values-anchor)
  * [**Summarize hed type**](summarize-hed-type-anchor)
* [**Remodeling implementation details**](remodeling-implementation-details-anchor)


(event-remodeling-overview-anchor)=
## Event remodeling overview

Remodeling consists of restructuring event files based on a specified list of operations.
The most common type of operation is a **transformation**, shown schematically in the following
figure:

![Transformation operations](./_static/images/TransformationOperations.png)

These operations are designed to transform an incoming tabular file 
(internally a [Pandas dataframe](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html))
into a new dataframe (without modifying the incoming data).
After all requested operations have been performed, the remodeling tools write the new dataframe.

The other type of operation supported by the remodeling tools is the **summary**.
These operations compute information about the data but do not modify the input data
as shown schematically in the following figure:

![Summary operations](./_static/images/SummaryOperation.png)

The information is accumulated in a summary context object, which, depending on the type of summary,
may be kept individually for files or combined for files across the dataset.
Summary operations may appear anywhere in the operation list, and the same type of summary may
appear multiple times under different names in order to track progress of the transformations.
Usually summaries are dumped at the end of processing to the `derivatives/remodel/summaries`
subdirectory under the dataset root.

The following table summarizes the available remodeling operations with a brief example use case
and links to further documentation. Operations not listed in the summarization section are transformations.

(remodeling-operations-summary-anchor)=
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
|  | [*create_event*](create-event-anchor) |   |   |
|  | [*merge_consecutive*](merge-consecutive-anchor) | Replace multiple consecutive events of the same type<br/>with one event of longer duration. |
|   | [*number_groups*](number-groups-anchor)  |   |
|   | [*number_rows*](number-rows-anchor)   |    | 
|  | [*remap_columns*](remap-columns-anchor) | Create m columns from values in n columns (for recoding). |
|  | [*split_event*](split-event-anchor) | Split trial-encoded rows into multiple events. |
| **summarization** |  |  | 
|  | [*summarize_column_names*](summarize-column-names-anchor) | Summarize column names and order in the files. |
|  | [*summarize_column_values*](summarize-column-values-anchor) |Count the occurrences of the unique column values. |
|  | [*summarize_hed_type*](summarize-hed-type-anchor) | Create a detailed summary of a HED in dataset <br/>(used to automatically extract experimental designs). |
````

The **clean-up** operations are used at various phases of restructuring to assure consistency
across event files in the dataset.

The **factor** operations produce column vectors of the same length as the events file
in order to encode condition variables, design matrices, or satisfaction of other search criteria.
See the 
[**HED conditions and design matrices**](https://hed-examples.readthedocs.io/en/latest/HedConditionsAndDesignMatrices.html)
for more information on factoring and analysis.

The **restructure** operations modify the way that event files represent events.

The **summarization** operations produce dataset-wide summaries of various aspects of the data.

(installing-remodeling-tools-anchor)=
## Installing remodeling tools 

The remodeling tools are available in the GitHub 
[**hed-python repository**](https://github.com/hed-standard/hed-python)
along with other tools for data cleaning and curation.
Although version 0.1.0 of this repository is available on [**PyPI**](https://pypi.org/)
as `hedtools`, the version containing the restructuring tools (Version 0.2.0)
is still under development and has not been officially released.
However, the code is publicly available on the hed-python repository and
can be directly installed from GitHub using `pip`:

```text
pip install git+https://github.com/hed-standard/hed-python/@develop
```

The web services and online tools supporting restructuring are available
on the [**HED online tools dev server**](https://hedtools.ucsd.edu/hed_dev).
When version 0.2.0 of `hedtools` is officially released on PyPI, restructuring
will become available on the [**HED online tools**](https://hedtools.ucsd.edu/hed).
A docker version is also under development.

The following diagram shows a schematic of the remodeling process.


![Event remodeling process](./_static/images/EventRemappingProcess.png)

Initially, the user creates a backup of the event files.
Restructuring applies a sequence of remodeling operations given in a JSON transformation file
to the backup versions corresponding to the specified event files.
The transformation file provides a record of the operations performed on the file.
If the user detects a mistake in the transformation,
he/she can correct the transformation file and rerun the transformations.
Restructuring always runs on the backup version of the file rather than
the transformed version, so the transformations can always be corrected and rerun.

(remodel-command-line-interface-anchor)=
## Remodel command-line interface

The remodeling toolbox provides Python scripts with command-line interfaces
to create or restore backups and to apply the transformations to the files in a dataset.
The file remodeling tools may be applied to datasets that are in free form under a directory root
or that are in [**BIDS-format**](https://bids.neuroimaging.io/).

BIDS (Brain Imaging Data Structure) is a standardized format for storing neuroimaging data.
The file names have a specific format related to their location in the directory tree.
The [**HED (Hierarchical Event Descriptor)**](https://hed-examples.readthedocs.io/en/latest/HedIntroduction.html)
operations are only available for BIDS-formatted datasets.
The HED operations are mainly used at analysis time. 
However, event file restructuring also can take place at data acquisition time before the data is formatted.
In this case, the data is assumed to be in a single directory tree,
and the event files are located by their file-suffix and extension.

(calling-remodel-tools-anchor)=
### Calling remodel tools

The basic scripts are summarized in the following table.
All the scripts have a required parameter, which is the full path of the dataset root.

(remodeling-operation-summary-anchor)=
````{table} Summary of the remodeling scripts.
| Script name | Arguments | Purpose | 
| ----------- | -------- | ------- |
|*run_remodel_backup* | *data_dir*<br/>*-n --backup_name*<br/>*-t --task-names*<br/>*-e --extensions*<br/>*-f --file-suffix*<br/>*-x --exclude_dirs*<br/>*-v --verbose* | Create a backup event files. |
|*run_remodel* | *data_dir*<br/>*model_path*<br/>*-n --backup_name*<br/>*-t --task-names*<br/>*-e --extensions*<br/>*-f --file-suffix*<br/>*-h --hed-version*<br/>*-j --json-sidecar*<br/>*-s --save-formats*<br/>*-x --exclude-dirs*<br/>*-b --bids-format*<br/>*-v --verbose* | Restructure or summarize the event files. |
|*run_remodel_restore* | *data_dir*<br/>*-n --backup_name*<br/>*-v --verbose* | Restore a backup of event files. |

````

(remodel-command-arguments-anchor)=
### Remodel command arguments

This section describes the arguments that are used for the remodeling command-line interface
with examples and more details.

#### Positional arguments

Positional arguments are required and must be given in the order specified.

`data_dir`
> The full path of dataset root directory.

`model_path`
> The full path of the JSON remodel file.
> 
#### Named arguments

Named arguments consist of a key starting with a hyphen and possibly a value.
Named arguments can given in any order or omitted. 
If omitted, a specified default is used.
Argument keys and values are separated by spaces.
For argument values that are lists, the key is given followed by the items in the list,
all separated by spaces.

`-b`, `--bids-format`
> If this flag present, the dataset is in BIDS format with sidecars. HED analysis is available.


`-e`, `--extensions`
> This option is followed by the file extension(s) of the tab-separated data files to process. The default is `.tsv`.


`-f`, `--file-suffix`
> This option is followed by the suffix names of the files to be processed (`events` by default).

`-h`, `--hed-versions`
> This option is followed by one or more HED versions. Versions of the base schema are specified
> by their semantic versions (e.g., 8.1.0), while library schema versions are prefixed by their
> library name (e.g., score_1.0.0). If more than one version is given,
> only one version can be unprefixed. The remaining must have short-name prefixes such as sc:
> to distinguish them. These short names also prefix the tags used from the corresponding schema.

`-j`, `--json-sidecar`
> This option is followed by the full path of the JSON sidecar with HED annotations to be
> applied during the processing of HED-related remodelng operations.

`-n`, `--backup_name`
> The name of the backup used for the remodeling (`default_back` by default).

    
`-s`, `--save-formats`
> This option is followed by the extensions (including .) in which to save any Format for saving any summaries, if any. If empty, then no summaries are saved.


`-t`, `--task-names`
> The name(s) of the tasks to be included (for BIDS-formatted files only).
> 
> Often, when a dataset includes multiple tasks, the event files are structured 
> differently for each task and thus require different transformation files.

`-v`, `--verbose`
> If present, output informative messages as computation.

`-x`, `--exclude-dirs`
> The directories to exclude when gather the data files to process.
> For BIDS datasets this is often `derivatives`, `stimuli`, and `sourcecode`.

(backing-up-events-anchor)=
### Backing up events

The `run_remodel_backup` python program creates a backup of the specified files.
The backup is always created in the `derivatives/remodel/backups` subdirectory
under the dataset root as shown in the following example for the
sample dataset `eeg_ds003654s_hed_remodel`,
which can be found in the `datasets` subdirectory of the 
[**hed-examples**](https://github.com/hed-standard/hed-examples) GitHub repository.

![Remodeling backup structure](./_static/images/RemodelingBackupStructure.png)

The backup could be created by running the following script, assuming that the dataset was
located in the `/datasets` subdirectory on your system.

(remodel-backup-anchor)=
````{admonition} Example command to backup the events.
:class: tip

```bash
python run_remodel_backup.py /datasets/eeg_ds003654s_hed_remodel -x derivatives stimuli

```
````
By default, the backup is called `default_back` and the files to be backed up are 
of the form `*_events.tsv`.
The `-x` option excludes any source files from the `derivatives` and `stimuli` subdirectories.
These choices can be overridden using additional command-line arguments.

The backup process creates a mirror of the directory structure of the source files to be backed up
in the backup directory.
The `default_back` directory contains a `backup_root` directory containing a mirror
of the directory structure of the files to be backed up.
Thus, we see that the backup has subdirectories `sub-002` and `sub-003` just
like the main directory of the dataset.
In addition, the `default_back` directory also contains a dictionary of backup files
in the `backup_lock.json`, which is used by the remodeling tools for file lookup.
The backup should be created once and not modified by the user.

The following shows how the `run_remodel_backup` program can be called from a 
Python program or a Jupyter notebook.
The command-line arguments are given a list instead of on the command line.


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
remodeling file, and overwriting the source file.

Users can also create named backups by providing the *-n* argument with a backup name to
the run_remodel_backup program.
To use backup files from another named backup, call the remodeling operations with
the `-n` argument and the correct backup name.

**NOTE**: You should not delete backups, even if you have created multiple named backups.
The backups provide useful state and provenance information about the data.

(restructuring-event-files-anchor)=
### Restructuring event files

Restructuring consists of applying a sequence of transformations from the 
[**Operation summary table**](remodeling-operations-summary-anchor) 
to the backup files corresponding to each event file in the dataset.
The transformations are specified as a list of dictionaries in a JSON file in the
[**JSON remodel file format**}(json-remodel-file_format) as discussed below.

Before running remodeling transformations on an entire dataset,
consider using the [**HED online tools](https://hedtools.ucds.edu/hed) 
to debug your remodeling operations on a single file.
You are also required to [**create the backup**](backing-up-events-anchor) (once) 
before running the transformations.
Since the transformation process always starts with the original backup,
add operations to the end of the original transformation JSON file
to perform additional operations.

The following example shows how to run a remodeling script from the command line.
The example assumes that the backup has already been created in the dataset.

(run-remodel-anchor)=
````{admonition} Example of running remodeling from command line.
:class: tip

```bash
python run_remodel.py /datasets/eeg_ds003654s_hed_remodel /datasets/remove_extra_rmdl.json -x derivatives simuli

```
````

The script has two required arguments the dataset root and the path to the JSON remodel file.
Usually, these JSON operation files are stored with the dataset itself in the 
`derivatives/remodel/models` subdirectory.

The following example shows Python code to remodel a dataset using the command-line interface.
The command-line arguments are given in a list, with the positional arguments appearing first.
This code can be used in a Jupyter notebook.

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

The following shows the contents of the JSON remodeling file `remove_extra_rmdl.json`
to remove the `value` and `sample` columns if they exist.
See [**Remodel file formats**](remodel-file-formats-anchor) for
more details on the format, and
[**Remodeling operations**](remodeling-operations-anchor) 
for more details on usage of individual operations.

(example-remodel-file-anchor)=
````{admonition} JSON remodeling file to remove the value and sample columns if they exist.
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

(remodeling-with-hed-and-bids-anchor)=
### Remodeling with HED and BIDS

[**HED**](hed-introduction-anchor) (Hierarchical Event Descriptors) is a
system for annotating data in a manner that is both human-understandable
and machine-actionable. [**BIDS**](https://bids.neuroimaging.io/) 
(Brain Imaging Data Structure) is a standardized way of organizing neuroimaging data.
HED and BIDS are well integrated.
If you are new to HED and BIDS see the 
[**HED annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/HedAnnotationQuickstart.html)
and the [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html).

Currently, three remodeling operations rely on HED annotations: 
[**factor HED tags**](factor-hed-tags-anchor), [**factor HED type**](factor-hed-type-anchor),
and [**summarize HED type**](summarize-hed-type-anchor).
HED tags provide a mechanism for advance data analysis and for 
extracting experiment-specific information from the events file. 
However, since HED information is usually not stored in the event files themselves,
two additional informational items must be provided: a HED schema and a JSON sidecar.
The HED schema defines the allowed HED tag vocabulary, and the JSON sidecar
associates HED annotations with the information in the columns of the event file.

If you are not using any of the HED operations in your remodeling,
you do not have to provide this information.
If the remodeling uses HED information, you must provide this information to the remodeling tools.

The simplest way to use HED with the `run_remodel` interface is with the `-b` option, 
which indicates that the dataset is in BIDS format.
A HED-annotated BIDS dataset provides the HED schema version in the `dataset_description.json`
file that must be located in the directory directly under the BIDS dataset root.
BIDS datasets must have filenames in a specific format, 
and the HEDTools can locate the relevant JSON sidecars for each event file based on this information.

If your data is already in BIDS format, using the `-b` option is ideal since
the needed information can be located individually.
However, early in the experimental process, 
your datafiles are not likely to be organized in BIDS format,
and this option will not be available if you want to use HED.

Without the `-b` option, the remodeling tools locate the appropriate files based
on specified filename suffixes and extensions.
In order to use HED operations, you must explicitly specify the HED versions
using the `-c` option as well as the path of the appropriate JSON sidecar using the `-j` option.
Usually, annotators will consolidate HED annotations in a single JSON sidecar file
located at the top-level of the dataset.
If more than one JSON file contains HED annotations, users will need to call the lower-level
remodeling functions to perform these operations.

(run-remodel-with-hed-direct-anchor)=
````{admonition} Remodeling a non-BIDS dataset using HED.
:class: tip

```bash
python run_remodel.py /datasets/eeg_ds003654s_hed_remodel /datasets/summarize_conditions_rmdl.json \
-x derivatives simuli -h 8.1.0 -j /datasets/task-FacePerception_events.json

```
````



(remodel-file-formats-anchor)=
## Remodel file formats

(the-json-remodel-input-file-anchor)=
### The JSON remodel input file

The remodeling process is controlled by a required JSON remodel input file,
which consists of a list of operation dictionaries in JSON format.
The [**simple example remodel file**](example-remodel-file-anchor) in the
previous section shows an example with a dictionary representing a single operation.

Each operation dictionary has three top-level keys: "operation", "description",
and "parameters". The value of the "operation" is the name of the operation.
The "description" value should include the reason this operation was needed,
not just a description of the operation itself.
Finally, the "parameters" value is a dictionary mapping parameter name to 
parameter value. An operation may have both required and optional parameters.
The parameters for each operation are listed in the 
[**Remodeling operations**](remodeling-operations-anchor) section.
Optional parameters, which may be omitted if unneeded, are explicitly 
identified in this section as optional.

The remodeling JSON files should have names ending in `_rmdl.json`.
Although these files can be stored anywhere, their preferred location is
in the `deriviatves/remodel/models` subdirectory under the dataset root so
that they can provide provenance for the dataset.

(remodel-summary-files-anchor)=
### Remodel summary files

Most remodeling operations are transformations
Operations that are categories as summaries, keep state that is updated


(remodeling-operations-anchor)=
## Remodeling operations

The examples in this tutorial use the following excerpt of the stop-go task from sub-0013
of the AOMIC-PIOP2 dataset available on [OpenNeuro](https://openneuro.org) as ds002790.
The full events file is 
[sub-0013_task-stopsignal_acq-seq_events.tsv](./_static/data/sub-0013_task-stopsignal_acq-seq_events.tsv).

(sample-remodeling-events-file-anchor)=
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

The *factor_hed_type* and *factor_hed_tags* also require HED annotations of
the events and require a JSON sidecar that includes HED annotations. 
The tutorial uses the following JSON excerpt to illustrate these operations.
The full JSON file can be found at:
[task-stopsiqnal_acq-seq_events.json](./_static/data/task-stopsignal_acq-seq_events.json).
These HED operations also require the HED schema. 
The tutorials use the latest version that is downloaded from the web.


(sample-remodeling-sidecar-file-anchor)=
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

(create-event-anchor)=
### Create event

... coming soon ...

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
[sample events file](sample-remodeling-events-file-anchor) are:

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
[sample events file](sample-remodeling-events-file-anchor) using the
[sample sidecar file](sample-remodeling-sidecar-file-anchor) for HED annotations is:


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
[sample events file](sample-remodeling-events-file-anchor) using the
[sample sidecar file](sample-remodeling-sidecar-file-anchor) for HED annotations are:


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
[sample events file](sample-remodeling-events-file-anchor) are:

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
[sample events file](sample-remodeling-events-file-anchor)
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
####Remove rows parameters

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
[sample events file](sample-remodeling-events-file-anchor) are:

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
[sample events file](sample-remodeling-events-file-anchor) are:

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
[sample events file](sample-remodeling-events-file-anchor) are:

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
[sample events file](sample-remodeling-events-file-anchor) are:

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

(summarize-column-names-anchor)=
### Summarize column names

The *summarize_column_values* operation produces a summary


(summarize-column-values-anchor)=
### Summarize column values

...Coming soon ...

(summarize-hed-type-anchor)=
### Summarize HED type

...Coming soon...

(remodeling-implementation-details-anchor)=
## Remodeling implementation details

...Coming soon...