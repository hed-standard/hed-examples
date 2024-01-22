### Jupyter notebooks to demo HED processing with BIDS

The Jupyter notebooks in this directory are useful for annotating,
validating, summarizing, and analyzing your BIDS datasets.

**Table 1:** Useful Jupyter notebooks for processing BIDS datasets.

| Notebooks                                                                                                                                                                   | Purpose                                                                 | 
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------| 
| [`extract_json_sidecar`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/extract_json_sidecar.ipynb)                                       | Creates a JSON sidecar based on all the event files in a dataset.       |
| [`find_event_combinations`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/find_event_combinations.ipynb)                                 | Creates a spreadsheet of unique combinations of event values.           |
| [`merge_spreadsheet_into_sidecar`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_merge_sidecarmerge_spreadsheet_into_sidecar.ipynb) | Merges a spreadsheet version of a sidecar into a JSON sidecar.          |
| [`sidecar_to_spreadsheet`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/sidecar_to_spreadsheet.ipynb)                                   | Converts the HED portion of a JSON sidecar into a 4-column spreadsheet. |
| [`summarize_events`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/summarize_events.ipynb)                                               | Summarizes the contents of the event files, including value counts.     |  
| [`validate_bids_dataset`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/validate_bids_dataset.ipynb)                                     | Validates the HED annotations in a BIDS dataset.                        |
| [`validate_bids_dataset_with_libraries`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/validate_bids_dataset_with_libraries.ipynb)       | Demonstrates use of HED libraries in validation.                        |  
| [`validate_bids_datasets`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/validate_bids_datasets.ipynb)                                   | Validates the HED annotations in a list of BIDS datasets.               |  

These notebooks require HEDTools, which can be installed using `pip` or directly.

**NOTE:  These notebooks have been updated to use the HEDTOOLS version on the develop branch of the HedTools.
These tools must be installed directly from GitHub until the newest version of HEDTools is released.**

To install directly from the 
[GitHub](https://github.com/hed-standard/hed-python) repository:

   ```
       pip install git+https://github.com/hed-standard/hed-python/@master
   ```


To use `pip` to install `hedtools` from PyPI:

   ```
       pip install hedtools
   ```


HEDTools require python 3.7 or greater.

