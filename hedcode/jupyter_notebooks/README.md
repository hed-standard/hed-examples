## Jupyter notebooks to demo HED tagging

These notebooks demonstrate the HED processing using the HED tools.
A related GitHub repository
[**hed-curation**](https://github.com/hed-standard/hed-curation)
is holds code related to curation.


### BIDS processing notebooks

## Useful notebooks for processing BIDS datasets

The Jupyter notebooks in this directory are useful for annotating,
validating, summarizing, and analyzing your BIDS datasets.

**Table 1:** Useful Jupyter notebooks for processing BIDS datasets.

|Script                    | Purpose                            | 
| ------------------------ | ---------------------------------- | 
| `bids_generate_sidecar`  | Creates a JSON sidecar based on all the event files in a dataset. |
| `bids_merge_sidecar`    | Merges a spreadsheet version of a sidecar into a JSON sidecar. |
| `bids_sidecar_to_spreadsheet` | Converts the HED portion of a JSON sidecar into a 4-column spreadsheet. |
| `bids_summarize_events` | Summarizes the contents of the event files, including value counts.
| `bids_validate_dataset`   | Validates the HED annotations in a BIDS dataset. |  
| `bids_validate_dataset_with_libraries`   | Demonstrates use of HED libraries in validation. |  
