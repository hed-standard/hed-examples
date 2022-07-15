# HED remodeling tools

This tutorial works through the process of restructuring event files using the HED event remodeling tools. The tools are designed to be run on an entire BIDS dataset.

* [**What is HED annotation?**](what-is-hed-annotation-anchor)  
* [**A recipe for simple annotation**](a-recipe-for-simple-annotation-anchor)  

(what-is-event-restructuring-anchor)=
## What is event restructuring?


(a-recipe-for-simple-annotation-anchor)=
## Installation and running of the restructuring

(remodeling-operations)=
## Remodeling operations


### Add structure

Use: Add trial or block markers --- used for epoching around the start of a trial. The duration is the duration of the trial or block respectively.



### Add trial numbers
Add a column with the trial numbers.



### Derive column

Create a new column or overwrite values in an existing column using a mapping from existing columns. Can also be used to overwrite values on existing columns, only values with the predefined combinations will be overwritten.


(parameters-for-derive-column-anchor)=
```{admonition} Standard HED tag selections for minimal annotation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```
The following example ....

```json
{ 
    "column_name": "match_side",
    "source_columns": ["response_accuracy", "response_hand"],
    "mapping": {
        "left": [["correct", "left"], ["incorrect", "right"]],
        "right": [["correct", "right"], ["incorrect", "left"]]
    }
}
```
Results in the following:

````{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````


### Factor column

Factor each of the specified values in the indicated column into a column containing 1’s and 0’s indicating presence and absence. If no values are specified, all unique values in that column are factored.

### Factor HED

Produce a list of factor columns based on the specified HED condition-variable values.

### Merge events
One long event is represented by multiple repeat events. Merges these same events occurring consecutively into one event with duration of the new event updated as the sum of all merged events.

### Remove columns

Remove the specified columns if present.


(parameters-for-remove-columns-anchor)=
```{admonition} Parameters for the remove_columns operation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_names | list of str | A list of columns to remove.| 
```

Example command:
```json
{ 
    "column_names": ["sample", "ethn_target", "ethn_distractor"] 
}
```

```{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````

### Remove rows

Remove rows where specified columns take particular values.

(parameters-for-remove-rows-anchor)=
```{admonition} Standard HED tag selections for minimal annotation.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```
The following example ....

```json
{ 
    "column_name": "match_side",
    "source_columns": ["response_accuracy", "response_hand"],
    "mapping": {
        "left": [["correct", "left"], ["incorrect", "right"]],
        "right": [["correct", "right"], ["incorrect", "left"]]
    }
}
```
Results in the following:

````{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````

### Rename columns

Rename columns by providing old name and new name.

(parameters-for-rename-columns-anchor)=
```{admonition} Parameters for rename_columns.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| mapping | dict | The keys are the old column names and the values are the new names.| 
| ignore_missing | bool | If false, an error is thrown if any keys are missing. | 

```
The following example ....

```json
{
    "mapping": {
        "face_type": "xxx",
        "hand": "response_hand"
    },
    "ignore_missing": true
}

```
Results in the following:

````{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````

### Reorder columns

Reorder the columns in the specified order. Columns not included are discarded or placed at the end. If a specified column is not in the data --- do what?

(parameters-for-reorder-columns-anchor)=
```{admonition} Parameters for reorder_columns.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_names | list of str | A list of columns in the order they should appear in the data.| 
| keep_missing | boolean | If true, existing columns that aren't in column_names are moved to the end and in the same relative order that they originally appeared in the data. | 

```


```json
{ 
    "column_names": ["onset", "duration", "trial_type", "response_time"],
    "keep_missing": false
}
```

Results in the following:

````{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````

### Split event

The split_event is the most complicated of the remodeling operations and generally 
Multiple information and responses are encoded in a single event. Split this event into multiple lines in the event file and adjust the meanings of the columns — usually this means removing the original event and replacing it with new events at various offsets.
The final result has rows ordered by increasing offsets.

Rename columns by providing old name and new name.

(parameters-for-split-event-anchor)=
```{admonition} Parameters for split_event.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column that will be used for split-event codes.|
| split_dict | dict | Dictionary specifying how the split should occur. | 
|remove_parent_event | bool | If true, remove parent event. | 

```

The `column_name` is the column that the split event codes are written.
If this column does not exist in the `events.tsv` file it is added prior to the split processing.

(parameters-for-split-dict-anchor)=
```{admonition} values for split_dict.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| onset_source | list | A list of column names and numbers representing values added to the onset of the parent event.|
| split_dict | dict | Dictionary specifying how the split should occur. | 
|remove_parent_event | bool | If true, remove parent event. | 

```

The 
The following example ....

```json
{
    "mapping": {
        "face_type": "xxx",
        "hand": "response_hand"
    },
    "ignore_missing": true
}

```
Results in the following:

````{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````
