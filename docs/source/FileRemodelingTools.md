# File remodeling tools

The file remodeling tools can be applied to any tab-separated value (`.tsv`) file,
but are particularly useful for restructuring files representing experimental events.
You should read the [**Event file restructuring quickstart**](https://hed-examples.readthedocs.io/en/latest/EventFileRestructuring.html)
tutorials if you are not familiar with file restructuring.
This guide describes the syntax and usage of the tools.tutorial on how use the remodeling tools is available at of restructuring event files using the HED event remodeling tools.
The tools, which are written in Python, are designed to be run on an entire dataset.
The tools can be called in Jupyter notebook or run via command-line scripts.
They are also available as a web service or through an online interface for application
to processing a single file. This is useful for debugging the remodeling script.

* [**Remodeling tool overview**](remodeling-tool-overview-anchor)
* [**Installing remodeling tools**](installing-remodeling-tools-anchor)
* [**Command line interface**](remodel-command-line-interface-anchor) 
   * [**Command line arguments**](remodel-command-arguments-anchor)
   * [**Remodel event files**](remodel-event-files-anchor)
   * [**Backup event files**](backup-event-files-anchor)
   * [**Restore event files**](restore-event-files-anchor)
   * [**Remove event files**](remove-event-files-anchor)
* [**JSON remodel file format**](json-remodel-file-format-anchor)
* [**Remodeling operations**](remodeling-operations-anchor)
  * [**Create event**](create-event-anchor)
  * [**Factor column**](factor-column-anchor) 
  * [**Factor HED tags**](factor-hed-tags-anchor) 
  * [**Factor HED type**](factor-hed-type-anchor)
  * [**Label context**](label-context-anchor)
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

(remodeling-tool-overview-anchor)=
## Remodeling tool overview

Give an overview of the tools
(remodeling-operations-summary-anchor)=
````{table} Summary of the HED remodeling commands for tabular files.
| Category | Command | Example use case |
| -------- | ------- | -----|
| **clean-up** |  |  | 
|  | *remove_columns* | Remove temporary columns created during restructuring. |
|  | *remove_rows* | Remove rows with n/a values in a specified column. |
|  | *rename_columns* | Make columns names consistent across a dataset. |
|  | *reorder_columns* | Make column order consistent across a dataset. |
| **factor** |   |   | 
|  | *factor_column* | Extract factor vectors from a column of condition variables. |
|  | *factor_hed_tags* | Extract factor vectors from search queries of HED annotations. |
|  | *factor_hed_types* | Extract design matrices and/or condition variables. |
| **restructure** |  |  | 
|  | *create_event* |   |   |
|  | *label_context*  |   |   |
|  | *merge_consecutive* | Replace multiple consecutive events of the same type<br/>with one event of longer duration. |
|   | *number_groups*  |   |
|   | *number_rows*   |    | 
|  | *remap_columns* | Create m columns from values in n columns (for recoding). |
|  | *split_event* | Split trial-encoded rows into multiple events. |
| **summarization** |  |  | 
|  | *summarize_column_names* | Summarize column names and order in the files. |
|  | *summarize_column_values* |Count the occurrences of the unique column values. |
|  | *summarize_hed_type* | Create a detailed summary of a HED in dataset <br/>(used to automatically extract experimental designs). |
````

The **clean-up** commands are used at various phases of restructuring to assure consistency
across event files in the dataset.

The **factor** commands produce column vectors of the same length as the events file
that encode condition variables, design matrices, or satisfaction of other search criteria.
See the 
[**HED conditions and design matrices**](https://hed-examples.readthedocs.io/en/latest/HedConditionsAndDesignMatrices.html)
for more information on factoring and analysis.

The **restructure** commands modify the way that event files represent events.

The **summarization** commands produce dataset-wide summaries of various aspects of the data.

(installing-remodeling-tools-anchor)=
## Installing remodeling tools 

The remodeling tools are available in the GitHub 
[**hed-python repository**](https://github.com/hed-standard/hed-python)
along with other tools for data cleaning and curation.
Although version 0.1.0 of this repository is available on [**PyPI**](https://pypi.org/)
as hedtools, the version containing the restructuring tools (Version 0.2.0)
is still under development and has not been officially released.
However, the code is publicly available on the hed-python repository and
can be directly installed from GitHub using PIP:

```text
pip install git+https://github.com/hed-standard/hed-python/@master
```

When version 0.2.0 is officially released on PyPI, restructuring
of single event files will become available through a web-service
through a web-interface on the [**HED online tools**](https://hedtools.ucsd.edu/hed).
A docker version is also under development.

The following diagram shows a schematic of the remodeling process.


The remodeling process is summarized in the following figure.

![Event remodeling process](./_static/images/EventRemappingProcess.png)

Initially, the user creates a backup of the event files.
Restructuring applies a sequence of remodeling commands given in a JSON transformation file
to produce a final result.
The transformation file provides a record of the operations performed on the file.
If the user detects a mistake in the transformation,
he/she can correct the transformation file and restore the backup to rerun.

(remodel-command-line-interface-anchor)=
## Command-line interface 
The remodeling toolbox provides several scripts to apply the transformations
to the files in a dataset. 
All the scripts have a required parameter, which is the full path of the dataset root.
The basic scripts are summarized in the following table.

(remodeling-operation-summary-anchor)=
````{table} Summary of the remodeling scripts.
| Script name | Arguments | Purpose | 
| ----------- | -------- | ------- |
|*run_remodel* | *data_dir*<br/>*-m model-path*<br/>*-t task_name*<br/>*-e extensions*<br/>*-x extensions*<br/>*-f file-suffix*<br/>*-s save-formats*<br/>*-b bids-format*<br/>*-v verbose* | Remodel the event files. |
|*run_remodel_backup* | *data_dir*<br/>*-t task_name*<br/>*-b backup-type*<br/>*-e exclude_dirs* | Backup the event files. |
|*run_restore* | *data_dir*<br/>*-t task_name*<br/>*-b backup-type*<br/>*-e exclude_dirs* | Restore the event files. |
|*run_remove* | *data_dir*<br/>*-t task_name*<br/>*-b backup-type*<br/>*-e exclude_dirs* | Remove the backup event files. |
````
The remainder of this section discusses the arguments for command-line processing in more detail.
Datasets may be in free form under a directory root or may be in [BIDS-format](https://bids.neuroimaging.io/).
BIDS (Brain Imaging Data Structure) is a standardized format for storing neuroimaging data.
The file names have a specific format related to where they are located in the directory tree.
The HED (Hierarchical Event Descriptor) operations are only available for BIDS-formatted datasets.
The HED operations are mainly used at analysis time. 
However, event file restructuring also can take place at data acquisition time, before the data is formatted.
In this case, the data is assumed to be in a single directory tree and the event files are located by 
their file-suffix and extension.

(remodel-command-arguments-anchor)=
### Command-line arguments

#### Positional arguments

`data_dir`
> The full path of dataset root directory.

#### Named arguments

`-m`, `--model-path`
> The full path of the JSON remodeling file.

`-t`, `--task-names`
> The name(s) of the tasks to be included. (For BIDS-formatted files only.)
> Often, when a dataset includes multiple tasks, the event files are structured 
> differently for each task and thus require different transformation files.

`-e`, `--extensions`
> The file extension(s) of the tab-separated data files to process. The default is `.tsv`.

`-x`, `--exclude-dirs`
> The directories to exclude when gather the data files to process.
> For BIDS datasets this is often `derivatives`, `stimuli`, and `sourcecode`.

`-f`, `--file-suffix`
> Filename suffix excluding file type of items to be analyzed (events by default).
    
`-s`, `--save-formats`
>Format for saving any summaries, if any. If empty, then no summaries are saved.

`-b`, `--bids-format`
> If present, the dataset is in BIDS format with sidecars. HED analysis is available.

`-v`, `--verbose`
> If present, output informative messages as computation.


(remodel-event-files-anchor)=
### Remodel event files

The event remodeling process is given by the following example:

(remodel-run-anchor)=
````{admonition} Example command to remodel the events.
:class: tip

```bash
python run_remodel.py t:\ds002790-data -m derivatives/models/simple_rmdl.json -e derivatives code simulus_files

```
````

(backup-event-files-anchor)=
### Backup event files
Before any remodeling is performed, you should always back up the event files.
Usually this is just done once, before any remodeling is done.
There are two strategies for doing the backup: *in-place* and *full-tree*.

The *in-place* strategy makes a copy of each event file in the same directory
as the event file using the suffix `_eventsorig.tsv` to distinguish
these backup files from the active event files (which end in `_events.tsv`).
The *in-place* strategy is simple, but the extra files prevent the dataset from
validating with the BIDS validator.

The *full-tree* strategy creates a complete tree backup in the
`code/event_backup` directory of the BIDS dataset.
This strategy is more expensive, but does not prevent validation
or interfere with other processing.

(remodel-backup-anchor)=
````{admonition} Example command to backup the events.
:class: tip

```bash
python run_backup.py t:\ds002790-data -b full-tree -e derivatives code simulus_files

```
````

(restore-event-files-anchor)=
### Restore event files

Explain restoring event files....

(remove-event-files-anchor)=
### Remove event files

Explain removing event files....

(json-remodel-file-format-anchor)=
## JSON remodel file format

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

The *factor_hed_types* and *factor_hed_tags* also require HED annotations of
the events and require a JSON sidecar that includes HED annotations. 
The tutorial uses the following JSON excerpt to illustrate these operations.
The full JSON file can be found at:
[task-stopsiqnal_acq-seq_events.json](./_static/data/task-stopsignal_acq-seq_events.json).
These HED commands also require the HED schema. 
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

For each of the specified values in the indicated column create a column containing 1’s and 0’s
indicating presence or absence of the value.


(parameters-for-factor-column-anchor)=
```{admonition} Parameters for the *factor_column* command.
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

The *factor_column* command in the following example specifies that factor columns
should be created for *succesful_stop* and *unsuccesful_stop* of the *trial_type* column.
The resulting columns are called *stopped* and *stop_failed*, respectively.


````{admonition} A sample *factor_column* command.
:class: tip

```json
{ 
    "command": "factor_column"
    "description": "Create factors for the succesful_stop and unsuccesful_stop values."
    "parameters": {
        "column_name": "trial_type",
        "factor_values": ["succesful_stop", "unsuccesful_stop"],
        "factor_names": ["stopped", "stop_failed"]
    }
}
```
````

The results of executing this *factor_column* command on the 
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

Produce a one-hot factor based on a HED tag search.
The search is based on a list of query filters, which are applied in succession
to the assembled HED strings for the event file.
Only events that satisfy each query filter as applied in succession 
will have 1 for the factors.
If an event fails one of the queries it does not get a factor 

(parameters-for-factor-hed-tags-anchor)=
```{admonition} Parameters for *factor_hed_tags* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *factor_name* | str | Name of the column to create for the factor. | 
| *remove_types* | list | Structural HED tags to be removed (usually *Condition-variable* and *Task*). | 
| *filter_queries* | list | Queries to be applied in succession to filter. | 

```

The *factor_hed-tags* command in the following example specifies . . .

````{admonition} Example *factor_hed_tags* command.
:class: tip

```json
{ 
    "command": "factor_hed_tags"
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

The results of executing this *factor_hed-tags* command on the 
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

(parameters-for-factor-hed-type-anchor)=
```{admonition} Parameters for *factor_hed_type* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *type_tag* | str | HED tag used to find the factors (most commonly *Condition-variable*).| 
| *type_values* | list | Values to factor for the *type_tag*.<br>If empty all values of that type_tag are used. |
| *factor_encoding* | str | Indicates type of encoding. Valid encodings are 'categorical' and 'one-hot'. |
```

To simplifyThe *factor_hed_type* command in the following example specifies . . .

````{admonition} Example *factor_hed_type* command.
:class: tip

```json
{ 
    "command": "factor_hed_type"
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

The results of executing this *factor_hed-tags* command on the 
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
(label-context-anchor)=
### Label context

... coming soon ...

(merge-consecutive-anchor)=
### Merge consecutive

Sometimes in experimental logs, a single long event is represented by multiple repeat events. 
Merges these same events occurring consecutively into one event with duration 
of the new event updated to encompass the extent of the merged events..

(parameters-for-merge-consecutive-anchor)=
```{admonition} Parameters for the *merge_consecutive* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_name* | str | The name of the column to be merged.| 
| *event_code* | str, int, float | The value in *column_name* . | 
| *match_columns* | list | Columns of that must match to collapse events.  |
| *set_durations* | bool | If True, set durations based on merged events. |
| *ignore_missing* | bool | If True, missing *column_name* or *match_columns* does not raise an error. |  
```

The *merge_consecutive* command in the following example specifies . . .

````{admonition} A sample *merge_consecutive* command.
:class: tip

```json
{ 
    "command": "merge_consecutive"
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

The following sample file has several `succesful_stop` events to be merged into a single event of longer duration.

````{admonition} Input file for a *merge_consecutive* command.

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

The results of executing the previous *merge_consecutive* command this file are:

````{admonition} The results of the *merge_consecutive* command.

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

This command maps the values that appear in a specified *m* columns of an event file
into values in *n* columns using a defined mapping.
This command is often used for recoding the event file. 
The mapping should have targets for all combinations of values that appear in the *m* columns.



(parameters-for-remap-columns-anchor)=
```{admonition} Parameters for the *remap_columns* command.
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

The *remap_columns* command in the following example creates a new column called *response_type*
based on the unique values in the combination of columns *response_accuracy* and *response_hand*.

````{admonition} An example *remap_columns* command.
:class: tip

```json
{ 
    "command": "remap_columns",
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

Typically, the *remap_columns* command is used often used to map single codes in the experimental log
into multiple columns in the final events file.

(remove-columns-anchor)=
### Remove columns

Remove the specified columns if present.
If one of the specified columns is not in the file and the *ignore_missing*
parameter is *false*, a `KeyError` is raised for missing column.


(parameters-for-remove-columns-anchor)=
```{admonition} Parameters for the *remove_columns* operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *remove_names* | list of str | A list of columns to remove.| 
| *ignore_missing* | boolean | If true, missing columns are ignored, otherwise raise an error. |
```

The *remove_column* command in the following example removes the *stop_signal_delay* and
*response_accuracy*  columns. The *face* column is not in the dataframe, but it is ignored,
since *ignore_missing* is True.

````{admonition} An example *remove_columns* command.
:class: tip

```json
{   
    "command": "remove_columns",
    "description": "Remove columns before the next step.",
    "parameters": {
        "remove_names": ["stop_signal_delay", "response_accuracy", "face"],
        "ignore_missing": true
    }
}
```
````

The results of executing this command on the
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

Remove rows in which the named column has one of the specified values.

(parameters-for-remove-rows-anchor)=
```{admonition} Parameters for remove_rows.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_name* | str | The name of the column to be tested.| 
| *remove_values* | list | A list of values to be tested for removal. | 
```

The following example *remove_rows* command removes the rows whose *trial_type* column 
has either *succesful_stop* or *unsuccesful_stop*.

````{admonition} Sample remove_rows command.
:class: tip

```json
{   
    "command": "remove_rows",
    "description": "Remove rows where trial_type is either succesful_stop or unsuccesful_stop.",
    "parameters": {
        "column_name": "trial_type",
        "remove_values": ["succesful_stop", "unsuccesful_stop"]
    }
}
```
````

The results of executing the previous *remove_rows* command on the 
[sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} The results of executing the previous *remove_rows* command.

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

Rename columns by providing a dictionary of old names to new names.

(parameters-for-rename-columns-anchor)=
```{admonition} Parameters for *rename_columns*.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_mapping* | dict | The keys are the old column names and the values are the new names.| 
| *ignore_missing* | bool | If false, a key error is raised if a dictionary key is not a column name. | 

```
The *rename_columns* command in the following example specifies that *response_hand* column be 
renamed *hand_used* and that the *sex* column be renamed *image_sex*.
The *face* entry in the mapping will be ignored because *ignore_missing* is true.
If *ignore_missing* is false, a `KeyError` exception is raised if a column specified in
the mapping does not correspond to a column name in the dataframe.

````{admonition} Example *rename_columns* command.
:class: tip

```json
{   
    "command": "rename_columns",
    "description": "Remove columns before splitting events.",
    "parameters": {
        "column_mapping": {
            "random_column": "new_random_column",
            "stop_signal_delay": "stop_delay",
            "response_hand": "hand_used",
            "sex": "image_sex"
        },
        "ignore_missing": true
    }
}

```
````

The results of executing the previous *rename_columns* command on the
[sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} After the *rename_columns* command is executed, the sample events file is:
| onset | duration | trial_type | stop_delay | response_time | response_accuracy | hand_used | image_sex |
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

Reorder the columns in the specified order. If *ignore_missing* is true,
and items in the reorder list do not exist in the file, these columns are ignored.
On the other hand, if *ignore_missing* is false,
a column name not appearing in the reorder list causes a *ValueError* to be raised.

The *keep_others* parameter controls whether or not columns in the dataframe that
do not appear in the reorder list are dropped (*keep_others* is false) or
put at the end of the dataframe in the order they appear (*keep_others* is true).

(parameters-for-reorder-columns-anchor)=
```{admonition} Parameters for *reorder_columns*.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *column_order* | list | A list of columns in the order they should appear in the data.| 
| *ignore_missing* | bool | If true and a column in *column_order* does not appear in the dataframe<br>a *ValueError* is raised, otherwise these columns are ignored. | 
| *keep_others* | bool | If true, existing columns that aren't in *column_order*<br/>are moved to the end in the same relative<br/>order that they originally appeared in the data,<br>otherwise these columns are dropped.| 

```

The *reorder_columns* command in the following example specifies that the first four
columns of the dataset should be: *onset*, *duration*, *trial_type*, *response_hand*, and *response_time*.
Since *ignore_missing* is true, these will be the only columns retained.

````{admonition} Example *reorder_columns* command.
:class: tip

```json
{   
    "command": "reorder_columns",
    "description": "Reorder columns.",
    "parameters": {
        "column_order": ["onset", "duration", "response_time",  "trial_type"],
        "ignore_missing": true,
        "keep_others": false
    }
}
```
````


The results of executing the previous *reorder_columns* command on the
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

The *split_event* command requires an *anchor_column*, which could be an existing
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
Unlisted columns are filled with n/a.


(parameters-for-split-event-anchor)=
```{admonition} Parameters for *split_event*.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| *anchor_event* | str | The name of the column that will be used for split-event codes.| 
| *new_events* | dict | Dictionary whose keys are the codes to be inserted as new events<br>and whose values are dictionaries with<br>keys *onset_source*, *duration*, and *copy_columns*. | 
| *remove_parent_event* | bool | If true, remove parent event. | 

```

The *split_event* command in the following example specifies that new rows should be added
to encode the response and stop signal. The anchor column is still trial_type.
In a full processing example, it might make sense to rename *trial_type* to be
*event_type* and to delete the *response_time* and the *stop_signal_delay*
since these items have been unfolded into separate events.

````{admonition} An example *split_event* command.
:class: tip

```json
{
  "command": "split_events",
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

The results of executing this *split_event* command on the
[sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of the previous *split_event* command.

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

...Coming soon...


(summarize-column-values-anchor)=
### Summarize column values

...Coming soon ...

(summarize-hed-type-anchor)=
### Summarize HED type

...Coming soon...
