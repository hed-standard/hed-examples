# Event file restructuring

**UNDER DEVELOPMENT**

This tutorial works through the process of restructuring event files using the HED event remodeling tools. The tools are designed to be run on an entire BIDS dataset.

* [**What is restructuring?**](what-is-event-file-restructuring-anchor)  
* [**Installation of remodeling tools**](installation-of-remodeling-tools-anchor)
* [**Running remodeling tools**](running-remodeling-tools-anchor)
* [**Remodeling operations**](remodeling-operations-anchor) 
  * [**Add structure column**](add-structure-column-anchor) Docs not written
  * [**Add structure events**](add-structure-events-anchor) Docs not written
  * [**Add structure numbers**](add-structure-numbers-anchor) Docs not written
  * [**Derive column**](derive-column-anchor) Docs not written
  * [**Factor column**](factor-column-anchor) Docs not written
  * [**Factor HED**](factor-column-anchor) Docs not written
  * [**Merge events**](merge-events-anchor) Docs not written
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
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | right | female |
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

(factor-hed-anchor)=
### Factor HED

**NOT WRITTEN - PLACEHOLDER**

Produce a list of factor columns based on the specified HED condition-variable values.

(parameters-for-factor-hed-anchor)=
```{admonition} Parameters for *factor_hed* command.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_name | str | The name of the column to be created or modified.| 
| source_columns | list of str | A list of columns to be used for remapping. | 
| mapping | dict | The keys are the values to be placed in the derived columns and the values are each an array |  
```

The *factor_hed* command in the following example specifies . . .

````{admonition} Example *factor_hed* command.
:class: tip

```json
{ 
    "command": "factor_hed"
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

The results of executing this *factor_hed* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of *factor_hed*.

| onset | duration | trial_type | match_side | stop_signal_delay | response_time | response_accuracy | response_hand | sex |
| ----- | -------- | ---------- | ---------- | ----------------- | ------------- | ----------------- | ------------- | --- |
| 0.0776 | 0.5083 | go |<b>right</b> | n/a | 0.565 | correct | right | female |
| 5.5774 | 0.5083 | unsuccesful_stop | <b>right</b> | 0.2 | 0.49 | correct | right | female |
| 9.5856 | 0.5084 | go | n/a | 0.45 | correct | right | female |
| 13.5939 | 0.5083 | succesful_stop | 0.2 | n/a | n/a | right | female |
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
the dataframe columns not included are discarded.
On the other hand, if *ignore_missing* is false,
column names that do not appear in the reorder list are moved to the end
of the dataframe in the same order that they appear.

(parameters-for-reorder-columns-anchor)=
```{admonition} Parameters for *reorder_columns*.
:class: tip

|  Parameter   | Type | Description | 
| ------------ | ---- | ----------- | 
| column_order | list | A list of columns in the order they should appear in the data.| 
| ignore_missing | boolean | If false, existing columns that aren't in column_names<br/>are moved to the end and in the same relative<br/>order that they originally appeared in the data. | 

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
        "column_order": ["onset", "duration", "trial_type", "response_hand", "response_time"],
        "ignore_missing": true
    }
}
```
````


The results of executing the previous *reorder_columns* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of *reorder_columns*.

| onset | duration | trial_type | response_hand | response_time |
| ----- | -------- | ---------- | ------------- | ------------- |
| 0.0776 | 0.5083 | go | right | 0.565 |
| 5.5774 | 0.5083 | unsuccesful_stop | right | 0.49 |
| 9.5856 | 0.5084 | go | right | 0.45 |
| 13.5939 | 0.5083 | succesful_stop | n/a | n/a |
| 17.1021 | 0.5083 | unsuccesful_stop | left | 0.633 |
| 21.6103 | 0.5083 | go | left | 0.443 |
````

(split-event-anchor)=
### Split event

The *split_event* is the most complicated of the remodeling operations and is often used to
convert event files from using *trial-level* encoding to *event-level* encoding.
In *trial-level* encoding each row of the event file represents all the events in a single trial
(usually some variation of cue-stimulus-response-feedback-ready sequence).
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
| event_selection | dict | Dictionary which events should be split (currently ignored and all events are split). | 
| new_events | dict | Dictionary whose keys are the codes to be inserted as new events and whose values are dictionaries with keys *onset_source*, *duration*, and *copy_columns*. | 
| add_event_numbers | boolean | If true, a column of event numbers are added before the split. |
| remove_parent_event | boolean | If true, remove parent event. |

```

The *split_event* command in the following example specifies that *response_hand* 
column be renamed *hand_used* and that the *sex* column be renamed *image_sex*.
The *face* entry in the mapping will be ignored because *ignore_missing* is true.
If *ignore_missing* is false, a `KeyError` exception is raised if a column specified in
the mapping does not correspond to a column name in the dataframe.

````{admonition} An example split_event command.
:class: tip

```json
{ 
    "command": "split_event",
    "description": "Takes trial-level encoding and turns it into event-level encoding.",
    "parameters": {
        "anchor_column": "trial_type",
        "event_selection": {},
        "new_events": {
            "response": {
                "onset": ["response_time"],
                "duration": [0],
                "column_columns": ["response_accuracy", "response_hand", "sex"]
            },
            "stop_signal": {
                "onset": ["stop_signal_delay"],
                "duration": [0.5],
                "column_columns": ["response_accuracy", "response_hand", "sex"]
            }            
        },
        "add_event_numbers": true,
        "remove_parent_event": false
    }
}
```
````

The results of executing this *split_event* command on the [sample events file](sample-remodeling-events-file-anchor) are:

````{admonition} Results of the split_event command.
| onset | duration | trial_type | response_accuracy | response_hand | sex | trial_number |
| ----- | -------- | ---------- | ----------------- | ------------- | --- | ------------ |
| 0.0776 | 0.5083 | go | correct | right | female | 1 |
| 0.6426 | 0.0 | response | correct | right | female | 1 |
| 5.5774 | 0.5083 | unsuccesful_stop | correct | right | female | 2 |
| 5.7774 | 0.5 | stop_signal | correct | right | female | 2 |
| 6.0674 | 0.0 | response | correct | right | female | 2 |
| 9.5856 | 0.5084 | go | correct | right | female | 3 |
| 10.0356 | 0.0 | response | correct | right | female | 3 |
| 13.5939 | 0.5083 | succesful_stop | n/a | n/a | female | 4 |
| 13.7939 | 0.5 | stop_signal | n/a | right | female | 4 |
| 17.1021 | 0.5083 | unsuccesful_stop | correct | left | male | 5 |
| 17.3521 | 0.5 | stop_signal | correct | left | male | 5 |
| 17.7351 | 0.0 | response | correct | left | male | 5 |
| 21.6103 | 0.5083 | go | correct | left | male | 6 |
| 22.0533 | 0.0 | response | correct | left | male | 6 |
````