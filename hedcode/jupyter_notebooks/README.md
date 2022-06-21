### Jupyter notebooks to demo HED processing with BIDS

The Jupyter notebooks in this directory are useful for annotating,
validating, summarizing, and analyzing your BIDS datasets.

**Table 1:** Useful Jupyter notebooks for processing BIDS datasets.

|Notebooks                 | Purpose                            | 
| ------------------------ | ---------------------------------- | 
| [`bids_generate_sidecar`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_generate_sidecar.ipynb)  | Creates a JSON sidecar based on all the event files in a dataset. |
| [`bids_merge_sidecar`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_merge_sidecar.ipynb)    | Merges a spreadsheet version of a sidecar into a JSON sidecar. |
| [`bids_sidecar_to_spreadsheet`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_sidecar_to_spreadsheet.ipynb) | Converts the HED portion of a JSON sidecar into a 4-column spreadsheet. |
| [`bids_summarize_events`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_summarize_events.ipynb) | Summarizes the contents of the event files, including value counts.
| [`bids_validate_dataset`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_validate_dataset.ipynb)   | Validates the HED annotations in a BIDS dataset. |  
| [`bids_validate_dataset_with_libraries`](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_validate_dataset_with_libraries.ipynb)   | Demonstrates use of HED libraries in validation. |  

These notebooks require HEDTOOLS, which can be installed using `pip` or directly.

To use `pip` to install `hedtools` from PyPI:

   ```
       pip install hedtools
   ```

To install directly from the 
[GitHub](https://github.com/hed-standard/hed-python) repository:

   ```
       pip install git+https://github.com/hed-standard/hed-python/@master
   ```

HEDTools require python 3.7 or greater.

A related GitHub repository
[**hed-curation**](https://github.com/hed-standard/hed-curation)
is holds code related to curation.