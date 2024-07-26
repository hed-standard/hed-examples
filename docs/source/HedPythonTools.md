# HED Python tools

The primary codebase for HED support is in Python.
Source code for the HED Python tools is available in the 
[**hed-python**](https://github.com/hed-standard/hed-pythong) GitHub repository
See the [**HED tools API documentation**](https://hed-python.readthedocs.io/en/latest/) for 
detailed information about the HED Tools API.

Many of the most-frequently used tools are available using the
[**HED remodeling tools**](https://www.hed-resources.org/en/latest/HedRemodelingTools.html).
Using the remodeling interface, users specify operations and parameters in a JSON
file rather than writing code. 

The [**HED online tools**](https://hedtools.org/hed) provide an easy-to-use GUI and web service for accessing the tools.
See the [**HED online tools documentation**](https://www.hed-resources.org/en/latest/HedOnlineTools.html)
for more information.

The [**HED MATLAB tools**](https://www.hed-resources.org/en/latest/HedMatlabTools.html)
provide a MATLAB wrapper for the HED Python tools.
For users that do not have an appropriate version of Python installed for their MATLAB,
the tools access the online tool web service to perform the operation.

## HED Python tool installation
The HED (Hierarchical Event Descriptor) scripts and notebooks assume
that the Python HedTools have been installed.
The HedTools package is available on PyPi and can be installed using:

```shell
 pip install hedtools
```
Prerelease versions of HedTools are available on the `develop` branch of the
[**hed-python**](https://github.com/hed-standard/hed-pythong) GitHub repository
and can be installed using:

```shell
 pip install git+https://github.com/hed-standard/hed-python/@develop
```


(jupyter-notebooks-for-hed-anchor)=
## Jupyter notebooks for HED

The following notebooks are specifically designed to support HED annotation
for BIDS datasets.


* [**Extract JSON template**](extract-json-template-anchor)  
* [**Find event combinations**](find-event-combinations-anchor)
* [**Merge spreadsheet into sidecar**](merge-spreadsheet-into-sidecar-anchor)
* [**Sidecar to spreadsheet**](sidecar-to-spreadsheet-anchor)
* [**Summarize events**](summarize-events-anchor)
* [**Validate BIDS dataset**](validate-bids-dataset-anchor)
* [**Validate BIDS dataset with libraries**](validate-bids-dataset-with-libraries-anchor)
* [**Validate BIDS datasets**](validate-bids-datasets-anchor)

(extract-json-template-anchor)=
### Extract JSON template

The usual strategy for producing machine-actionable event annotation using HED in BIDS is to 
create a single `events.json` sidecar file in the BIDS dataset root directory.
Ideally, this sidecar will contain all the annotations needed for users to understand and analyze the data.

See the [**BIDS annotation quickstart**](BidsAnnotationQuickstart.md) for additional information on this strategy 
and an online version of the tools. 
The [**Create a JSON template**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html#create-a-json-template) tutorial provides a step-by-step tutorial for using the online tool 
that creates a template based on the information in a single `events.tsv` file.
For most datasets, this is sufficient.
In contrast, the [**extract_json_template.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/extract_json_template.ipynb)
Jupyter notebook bases the extracted template on the entire dataset.

To use this notebook, substitute the specifics of your BIDS
dataset for the following variables:

```{admonition} Variables to set in the extract_json_template.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| `dataset_path` | Full path to root directory of dataset.|
| `exclude_dirs` | List of directories to exclude when constructing the list of event files. |
| `skip_columns`  |  List of column names in the `events.tsv` files to skip in the template |
| `value_columns` | List of columns names in the `events.tsv` files that will be annotated<br>as a whole rather than by individual column value. |   
| `output_path` | Full path of output file. If None, then output is printed.   |    
```
The `exclude_dirs` should usually include the `code`, `stimuli`, `derivatives`, and `sourcedata` subdirectories.
The `onset`, `duration` and `sample` columns are almost always skipped, since these are predefined in BIDS.

Columns designated as value columns are annotated with a single annotation that always includes a `#` placeholder. This placeholder marks the position in the annotation where each individual column value is substituted when the annotation is assembled.

All columns not designated as skip columns or value columns are considered to be categorical columns. Each individual value in a categorical column has its own This annotation that must include a `#` indicating where each value in the value column is substituted when the annotation is assembled. You should take care to correctly identify the skip columns and the value columns, as the individual values in a column such as `onset` are usually unique across the data, resulting in a huge number of annotations.


(find-event-combinations-anchor)=
### Find event combinations

The [**find_event_combinations.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/find_event_combinations.ipynb)
Jupyter notebook extracts a spreadsheet containing the unique combination of values in the
specified `key_columns`.
The setup requires the following variables for your dataset:

```{admonition} Variables to set in the find_event_combinations.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| `dataset_path` | Full path to root directory of dataset.                                   |
| `exclude_dirs`      | List of directories to exclude when constructing file lists.              |
| `key_columns`       | List of column names in the events.tsv files to combine.                  |
| `output_path`       | Output path for the spreadsheet template. If None, then print the result. |
```

The result will be a tabular file (tab-separated file) whose columns are the `key_columns` in the order given. The values will be all unique combinations of the `key_columns`, sorted by columns from left to right.

This can be used to remap the columns in event files to use a new recoding. The resulting spreadsheet is also useful for deciding whether two columns contain redundant information.



(merge-spreadsheet-into-sidecar-anchor)=
### Merge spreadsheet into sidecar

Often users find it easier to work with a spreadsheet rather than a JSON file when creating
annotations for their dataset.
For this reason, the HED tools offer the option of creating a 4-column spreadsheet from 
a BIDS JSON sidecar and using it to create annotations. The four columns are: 
`column_name`, `column_value`, `description`, and `HED`. 
See [**task-WorkingMemory_example_spreadsheet.tsv**](https://github.com/hed-standard/hed-examples/blob/main/docs/source/_static/data/task-WorkingMemory_example_spreadsheet.tsv)
The [**sidecar_to_spreadsheet.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/sidecar_to_spreadsheet.ipynb)

```{admonition} Variables to set in the extract_json_template.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| `spreadsheet_path` | Full path to spreadsheet (4-column tsv file). |
| `sidecar_path`     | Path to sidecar to merge into. If None, then just convert. |
| `description_tag`  | (bool) If True, then the contents of the description column<br/>is added to the annotation using the `Description` tag. |
| `output_path`       | The output path of the merged sidecar. If None, then just print it. |
```

(sidecar-to-spreadsheet-anchor)=
### Sidecar to spreadsheet

If you have a BIDS JSON event sidecar or a sidecar template,
you may find it more convenient to view and edit the HED annotations in
spreadsheet rather than working with the JSON file directly as explained in the
[**Spreadsheet templates**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html#spreadsheet-templates-anchor)
tutorial.

The [**sidecar_to_spreadsheet.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/sidecar_to_spreadsheet.ipynb)
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
If you don't wish to save the spreadsheet, assign `spreadsheet_filename` to be `None`
and the result is just printed.


(summarize-events-anchor)=
### Summarize events

Sometimes event files include unexpected or incorrect codes.
It is a good idea to find out what is actually in the dataset
event files and whether the information is consistent before starting the annotation process.

The [**summarize_events.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/sidecar_to_spreadsheet.ipynb) finds the dataset event files and outputs
the column names and number of events for each event file.
You can visually inspect the output to make sure that the event file column names
are consistent across the dataset.
The script also summarizes the unique values
that appear in different event file columns across the dataset.

To use this notebook, substitute the specifics of your BIDS
dataset for the following variables:

```{admonition} Variables to set in the summarize_events.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| `dataset_path` | Full path to root directory of dataset.|
| `exclude_dirs` | List of directories to exclude when constructing the list of event files. |
| `skip_columns`  |  List of column names in the `events.tsv` files to skip in the template |
| `value_columns` | List of columns names in the `events.tsv` files that will be annotated<br>as a whole rather than by individual column value. |   
| `output_path` | Full path of output file. If None, then output is printed.   |    
```

These same variables are required for the [**Extract JSON template**](extract-json-template-anchor) operation.

For large datasets, be sure to skip columns such as
`onset` and `sample`, since the summary produces counts of the number of times
each unique value appears somewhere in dataset event files.

(validate-bids-dataset-anchor)=
### Validate BIDS dataset

Validating HED annotations as you develop them makes the annotation process easier and
faster to debug.
The [**HED validation guide**](https://hed-examples.readthedocs.io/en/latest/HedValidationGuide.html)
discusses various HED validation issues and how to fix them.

The [**validate_bids_dataset.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/sidecar_to_spreadsheet.ipynb)
Jupyter notebook validates HED in a BIDS dataset using the `validate` method
of `BidsDataset`.
The method first  gathers all the relevant JSON sidecars for each event file
and validates the sidecars. It then validates the individual `events.tsv` files
based on applicable sidecars.


```{admonition} Variables to set in the validate_bids_dataset.ipynb Jupyter notebook.
:class: tip
| Variable | Purpose |
| -------- | ------- |
| `dataset_path` | Full path to root directory of dataset.|
| `check_for_warnings` | Boolean, which if True returns warnings as well as errors |
```

The script requires you to set the `check_for_warnings` flag and the root path to
your BIDS dataset.

**Note:** This validation pertains to event files and HED annotation only.
It does not do a full BIDS validation.

(validate-bids-dataset-with-libraries-anchor)=
### Validate BIDS dataset with libraries


The [**validate_bids_dataset_with_libraries.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/validate_bids_dataset_with_libraries.ipynb)
Jupyter notebook validates HED in a BIDS dataset using the `validate` method of `BidsDataset`.
The example uses three schemas and also illustrates how to manually override the
schema specified in `dataset_description.json` with schemas from other places.
This is very useful for testing new schemas that are underdevelopment.

(validate-bids-datasets-anchor)=
### Validate BIDS datasets

The [**validate_bids_datasets.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/validate_bids_datasets.ipynb) is similar to the other validation notebooks, but it takes a list of datasets to validate as a convenience.
