# Event file restructuring

**UNDER DEVELOPMENT**

This tutorial works through the process of restructuring event files using the HED event remodeling tools. The tools are designed to be run on an entire BIDS dataset.

* [**What is restructuring?**](what-is-event-file-restructuring-anchor) Docs in process
* [**Installation of remodeling tools**](installation-of-remodeling-tools-anchor) Docs in process
* [**Running remodeling tools**](running-remodeling-tools-anchor) Docs in process
* [**Remodeling operations**](remodeling-operations-anchor) Docs in process
  * [**Add structure column**](add-structure-column-anchor) Docs in process
  * [**Add structure events**](add-structure-events-anchor) Docs in process
  * [**Add structure numbers**](add-structure-numbers-anchor) Docs in process
  * [**Derive column**](derive-column-anchor) Docs in process
  * [**Factor column**](factor-column-anchor) 
  * [**Factor HED tags**](factor-hed-tags-anchor) Docs in process
  * [**Factor HED type**](factor-hed-type-anchor) Docs in process
  * [**Merge events**](merge-events-anchor) Docs in process
  * [**Remove columns**](remove-columns-anchor) 
  * [**Rename columns**](rename-columns-anchor)
  * [**Reorder columns**](reorder-columns-anchor)
  * [**Split event**](split-event-anchor)


(what-is-event-file-restructuring-anchor)=
## What is event file restructuring?

**Need brief introduction to event remodeling here**

(installation-of-remodeling-tools-anchor)=
## Installation of remodeling tools 

**Need information about installation.**

(running-remodeling-tools-anchor)=
## Running remodeling tools 

**Need information about how to run**

(remodeling-operations-anchor)=
## Remodeling operations

The examples in this chapter use the following excerpt from sub-0013
stop-go task of the AOMIC-PIOP2 dataset available on [OpenNeuro](https://openneuro.org) as ds002790.

(sample-remodeling-events-file-anchor)=
````{admonition} Excerpt from event file for a stop-go task.
| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(add-structure-column-anchor)=
### Add structure column

**NOT WRITTEN - PLACEHOLDER**

Add a column of numbers corresponding to a structure elements such as trials or blocks. 

(parameters-for-add-structure-column-anchor)=
```{admonition} Parameters for the *add_structure_column* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list | Names of the columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```

The *add_structure_column* command in the following example specifies . . .


````{admonition} An example *add_structure_column* command.
:class: tip

```json
{ 
    "column_name": "add_structure_column",
    "source_columns": ["response_accuracy", "response_hand"],
    "mapping": {
        "left": [["correct", "left"], ["incorrect", "right"]],
        "right": [["correct", "right"], ["incorrect", "left"]]
    }
}
```
````

The results of executing this *add_structure_column* command on the [sample events file](sample-remodeling-events-file-anchor) are:


````{admonition} Results of the previous *add_structure_column* command.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | right | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(add-structure-events-anchor)=
### Add structure events

**NOT WRITTEN - PLACEHOLDER**

Add events representing the start of a structural element such as a trial or a block.

(parameters-for-add-structure-event-anchor)=
```{admonition} Parameters for the *add_structure_events* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list | Names of the columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```

The *add_structure_events* command in the following example specifies . . .

````{admonition} An example *add_structure_events* command.
:class: tip

```json
{ 
    "column_name": "add_structure_events",
    "source_columns": ["response_accuracy", "response_hand"],
    "mapping": {
        "left": [["correct", "left"], ["incorrect", "right"]],
        "right": [["correct", "right"], ["incorrect", "left"]]
    }
}
```
````

The results of executing this *add_structure_events* command on the [sample events file](sample-remodeling-events-file-anchor) are:


````{admonition} Results of the previous *add_structure_events* command.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(add-structure-numbers-anchor)=
### Add structure numbers

**NOT WRITTEN - PLACEHOLDER**

Add a column with numbers corresponding to a structural element.  

**TODO** clarify the difference between add_structure_numbers and add_structure_column.

(parameters-for-add-structure-numbers-anchor)=
```{admonition} Parameters for the *add_structure_numbers* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```
The *add_structure_numbers* command in the following example specifies . . .

````{admonition} An example .
:class: tip

```json
{ 
    "command": "add_structure_numbers"
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

The results of executing this *add_structure_numbers* command on the [sample events file](sample-remodeling-events-file-anchor) are:


````{admonition} Results of executing the previous *add_structure_numbers* command.

| onset | duration | trial_type | match_side | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go |<b>right</b> | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | right | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(derive-column-anchor)=
### Derive column

**NOT WRITTEN - PLACEHOLDER**

Create a new column or overwrite values in an existing column using a mapping from existing columns.
This command can be used to overwrite values particular values in existing columns
based on predefined combinations of values in other columns.


(parameters-for-derive-column-anchor)=
```{admonition} Parameters for the *derive_column* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```
The *derive_column* command in the following example specifies . . .

````{admonition} An example *derive_column* command.
:class: tip

```json
{ 
    "command": "derive_column"
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

The results of executing the previous *derive_column* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Adding a *match_side* column using the *derive_column* command.

| onset | duration | trial_type | match_side | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go |<b>right</b> | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | right | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(factor-column-anchor)=
### Factor column

For each of the specified values in the indicated column create a column containing 1’s and 0’s
indicating presence or absence of the value.
If no values are specified, all unique values in that column are factored.

(parameters-for-factor-column-anchor)=
```{admonition} Parameters for the *factor_column* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be factored.| 
| factor_values | list | A list of column values to be included as factors. |
| factor_names | list| A list of column names for created factors<br>of the same length as factor_values. |
| ignore_missing| bool | If true, columns corresponding to factor values<br>that do not appear in column are included. |
| overwrite_existing| bool | If true an existing factor column is overwritten. |
```
The *factor_column* command in the following example specifies that factor columns
should be created for *succesful_stop* and *unsuccesful_stop* of the *trial_type* column.
The resulting columns are called *stopped* and *stop_failed*, respectively.
If the *factor_values* is an empty list, 
factors are created for all unique values in the *column_name* column.
The *factor_names* parameters must be the same length as *factor_values*.
If *factor_names* is empty, the newly created columns are of the 
form *column_name.factor_value*.


````{admonition} A sample *factor_column* command.
:class: tip

```json
{ 
    "command": "factor_column"
    "description": "Create factors for the succesful_stop and unsuccesful_stop values."
    "parameters": {
        "column_name": "trial_type",
        "factor_values": ["succesful_stop", "unsuccesful_stop"],
        "factor_names": ["stopped", "stop_failed"],
        "ignore_missing": false,
        "overwrite_existing": true
    }
}
```
````

The results of executing this *factor_column* command on the [sample events file](sample-remodeling-events-file-anchor) are:

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

**NOT WRITTEN - PLACEHOLDER**

Produce a list of factor columns based on the specified HED condition-variable values.

(parameters-for-factor-hed-tags-anchor)=
```{admonition} Parameters for *factor_hed_tags* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
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

The results of executing this *factor_hed-tags* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of *factor_hed_tags*.

| onset | duration | trial_type | match_side | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go |<b>right</b> | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(factor-hed-type-anchor)=
### Factor HED type

**NOT WRITTEN - PLACEHOLDER**

Produce a list of factor columns based on the specified HED condition-variable values.

(parameters-for-factor-hed-type-anchor)=
```{admonition} Parameters for *factor_hed_type* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```

The *factor_hed-type* command in the following example specifies . . .

````{admonition} Example *factor_hed-type* command.
:class: tip

```json
{ 
    "command": "factor_hed_type"
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

The results of executing this *factor_hed-type* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of *factor_hed_type*.

| onset | duration | trial_type | match_side | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go |<b>right</b> | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

(merge-events-anchor)=
### Merge events

**NOT WRITTEN - PLACEHOLDER**

One long event is represented by multiple repeat events. Merges these same events occurring consecutively into one event with duration of the new event updated as the sum of all merged events.

(parameters-for-merge-events-anchor)=
```{admonition} Parameters for the *merge_events* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```

The *merge_events* command in the following example specifies . . .

````{admonition} A sample *merge_events* command.
:class: tip

```json
{ 
    "command": "merge_events"
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

The results of executing the previous *merge_events* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} The results of the *merge_events* command.

| onset | duration | trial_type | match_side | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go |<b>right</b> | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | right | female |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male |
````

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
| remove_names | list of str | A list of columns to remove.| 
| ignore_missing | boolean | If true, missing columns are ignored, otherwise raise an error. |
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
[sample events file](sample-remodeling-events-file-anchor) are shown below.
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
| column_name | str | The name of the column to be tested.| 
| remove_values | list | A list of values to be tested for removal. | 
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
| column_mapping | dict | The keys are the old column names and the values are the new names.| 
| ignore_missing | bool | If false, a key error is raised if a dictionary key is not a column name . | 

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

The results of executing the previous *rename_columns* command on the [sample events file](sample-remodeling-events-file-anchor) are:

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
| column_order | list | A list of columns in the order they should appear in the data.| 
| ignore_missing | bool | If true and a column in column_order does not appear in the dataframe<br>a ValueError is raised, otherwise these columns are ignored. |
| keep_others | bool | If true, existing columns that aren't in column_order<br/>are moved to the end in the same relative<br/>order that they originally appeared in the data,<br>otherwise these columns are dropped.| 

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


The results of executing the previous *reorder_columns* command on the [sample events file](sample-remodeling-events-file-anchor) are:

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
```{admonition} Parameters for split_event.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| anchor_event | str | The name of the column that will be used for split-event codes.|
| new_events | dict | Dictionary whose keys are the codes to be inserted as new events<br>and whose values are dictionaries with<br>keys *onset_source*, *duration*, and *copy_columns*. | 
| add_event_numbers | bool | If true, adds a column called *event_numbers*. |
| remove_parent_event | bool | If true, remove parent event. |

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
            "event_numbers_column": "trial_number",
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

The results of executing this *split_event* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of the previous *split_event* command.

| onset | duration | trial_type | stop_signal_delay | response_time | response_accuracy | response_hand | sex | trial_number |
| ----- | -------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- | -------- |
| 0.0776 | 0.5083 | go | n/a | 0.565 | correct | right | female | 1 |
| 0.6426 | 0 | response | n/a | n/a | correct | right | female | 1 |
| 5.5774 | 0.5083 | unsuccesful_stop | 0.2 | 0.49 | correct | right | female | 2 |
| 5.7774 | 0.5 | stop_signal | n/a | n/a | n/a | n/a | n/a | 2 |
| 6.0674 | 0 | response | n/a | n/a | correct | right | female | 2 |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female | 3 |
| 10.0356 | 0 | response | n/a | n/a | correct | right | female | 3 |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | n/a | female | 4 |
| 13.7939 | 0.5 | stop_signal | n/a | n/a | n/a | n/a | n/a | 4 |
| 17.1021 | 0.5083 | unsuccesful_stop | 0.25 | 0.633 | correct | left | male | 5 |
| 17.3521 | 0.5 | stop_signal | n/a | n/a | n/a | n/a | n/a | 5 |
| 17.7351 | 0 | response | n/a | n/a | correct | left | male | 5 |
| 21.6103 | 0.5083 | go | n/a | 0.443 | correct | left | male | 6 |
| 22.0533 | 0 | response | n/a | n/a | correct | left | male | 6 |
````

Note that the event numbers are added before the splitting and then
copied as the new events are created.
This strategy results in a trial number column associated with the events,
an alternative to the more complicated process of adding a structure column after splitting.