### Jupyter notebooks to demo HED processing with BIDS

The Jupyter notebooks in this directory are useful for annotating,
validating, summarizing, and analyzing your BIDS datasets.

**Table 1:** Useful Jupyter notebooks for processing BIDS datasets.

| Notebooks                                                                                                                                                             | Purpose                                                                 | 
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------| 
| [`extract_json_template`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/extract_json_template.ipynb)                              | Creates a JSON sidecar based on all the event files in a dataset.       |
| [`find_event_combinations`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/find_event_combinations.ipynb)                          | Creates a spreadsheet of unique combinations of event values.           |
| [`merge_spreadsheet_into_sidecar`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/merge_spreadsheed_into_sidecar.ipynb)            | Merges a spreadsheet version of a sidecar into a JSON sidecar.          |
| [`sidecar_to_spreadsheet`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/sidecar_to_spreadsheet.ipynb)                            | Converts the HED portion of a JSON sidecar into a 4-column spreadsheet. |
| [`summarize_events`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/summarize_events.ipynb)                                        | Summarizes the contents of the event files, including value counts.     |  
| [`validate_bids_dataset`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/validate_bids_dataset.ipynb)                              | Validates the HED annotations in a BIDS dataset.                        |
| [`validate_bids_dataset_with_libraries`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/validate_bids_dataset_with_libraries.ipynb) | Demonstrates use of HED libraries in validation.                        |  
| [`validate_bids_datasets`](https://github.com/hed-standard/hed-examples/blob/main/src/jupyter_notebooks/bids/validate_bids_datasets.ipynb)                            | Validates the HED annotations in a list of BIDS datasets.               |  

These notebooks require HEDTools, which can be installed using `pip` or directly.

To use `pip` to install `hedtools` from PyPI:

   ```
       pip install hedtools
   ```

To install directly from the 
[GitHub](https://github.com/hed-standard/hed-python) repository:

   ```
       pip install git+https://github.com/hed-standard/hed-python/@master
   ```

HEDTools require python 3.8 or greater.

