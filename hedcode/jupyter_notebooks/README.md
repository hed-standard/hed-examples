## Jupyter notebooks to demo HED tagging

These notebooks demonstrate the HED processing using the HED tools.


### BIDS processing notebooks

## Useful notebooks for processing BIDS datasets

The Jupyter notebooks in this directory are useful for preparing your BIDS dataset. 

**Table 1:** Useful Jupyter notebooks for preparing BIDS datasets.

|Script                    | Purpose                            | 
| ------------------------ | ---------------------------------- | 
| `bids_generate_sidecar`  | Creates a JSON sidecar based on all the event files in a dataset. |
| `bids_merge_sidecar`    | Merges a spreadsheet version of a sidecar into a JSON sidecar. |
| `bids_sidecar_to_spreadsheet` | Converts the HED portion of a JSON sidecar into a 4-column spreadsheet. |
| `bids_validate_dataset`   | Validates the HED annotations in a BIDS dataset. |  
| `bids_validate_dataset_with_libraries`   | Demonstrates use of HED libraries in validation. |  


### Event file restructuring notebooks

**This section is out of date and will be updated soon.**
The demo scripts use data in `../data/sternberg` and in the reduced
attention shift dataset: 

[https://github.com/hed-standard/hed-examples/data/eeg_ds0028932](https://github.com/hed-standard/hed-examples/data/eeg_ds0028932).

The notebooks are designed to be executed in the following order:  

1. `summarize_events.ipynb` gather all of the unique values in the columns of
all of the events files in a BIDS dataset.  

2. `create_template.ipynb`  gathers all of the unique combinations of values in
a specified group of columns (the key columns) and creates a template file
for you to specify the mapping between each unique key and values in target columns.
This is the **event design** that must be filled in by the user.  

3. `remap_events.ipynb` creates new event files using the template from the previous
step to remap columns.

4. `tag_columns.ipynb` demonstrates how to create a list of the unique
values in the specified columns in a flattened form so that they can be tagged.