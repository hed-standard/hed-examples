# HED in Python
**This tutorial is underdevelopment.**

The HED scripts and notebooks all assume that HedTools have been installed.
HedTools is not yet available on PyPI, so you will need to install them
directly from GitHub using:

```shell
 pip install git+https://github.com/hed-standard/hed-python/@master
```

* [**Jupyter notebooks for HED in BIDS**](jupyter-notebooks-for-hed-in-bids-anchor)  
* [**Validation notebooks**](validation-notebooks-anchor)   
* [**Summary notebooks**](summary-notebooks-anchor)  
* [**Dataset-specific notebooks**](dataset-specific-notebooks-anchor)  


(jupyter-notebooks-for-hed-in-bids-anchor)=
## Jupyter notebooks for HED in BIDS

The following notebooks are specifically designed to support HED annotation
and use in BIDS datasets.

[**Summarize BIDS event files**](summarize-bids-event-files)
[**Extract a JSON sidecar from event files**](extract-a-json-sidecar-from-event-files) 
[**Validate HED in a BIDS dataset**](validate-hed-in-bids-dataset-anchor)


(summarize-bids-event-files)=
### Summarize BIDS event files

A first step in annotating a BIDS dataset is to find out what is in the dataset
event files.
Sometimes event files will have a few unexpected or incorrect codes.
It is usually a good idea to find out what is actually in the dataset
event files before starting the annotation process.

The [**bids_summarize_events.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_summarize_events.ipynb) Jupyter notebook summarizes the unique values
that appear in a BIDS dataset `events.tsv` files along with the number of occurrences.

(extract-a-json-sidecar-from-event-files)=
### Extract a JSON sidecar from event files

General strategy for machine-actionable annotation using HED in BIDS is
to create a single `events.json` sidecar file in the BIDS dataset root directory.
Ideally, this sidecar will contain all the annotations needed for users to
understand and analyze the data.
(See the [**BIDS annotation quickstart**](BidsAnnotationQuickstart.md) for additional
information on this strategy.)

The [**bids_extract_sidecar.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_extract_sidecar.ipynb) Jupyter notebook creates an `events.json` sidecar
template based on the information in all of the `events.tsv` files in a BIDS dataset.

To use the script, you will need to provide the path to the BIDS dataset root directory.
You should also designate a list of column to skip and a list of columns to annotate
as a whole rather than by each individual value in that column.

For an online tool that creates a template based on the information in a
single `events.tsv` file see [**Create a JSON template**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html#create-a-json-template).


(validate-hed-in-bids-dataset-anchor)=
### Validate HED in a BIDS dataset

Validating HED annotationsas you develop them makes the annotation process much easier and
faster to debug.

The [**bids_validate_hed.ipynb**](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids_processing/bids_validate_hed.ipynb)
Jupyter notebook validates HED in a BIDS dataset.

**Note:** This validation pertains to event files and HED annotation only.
It does not do a full BIDS validation.


(validation-notebooks-anchor)=
## Validation notebooks
 
These notebooks are used to validate BIDS event files and HED tagging.


(summary-notebooks-anchor)=
## Summary notebooks

These notebooks are used to produce JSON summaries of dataset events.

(dataset-specific-notebooks-anchor)=
## Dataset-specific notebooks

These notebooks are used to process specific datasets.
Mainly these notebooks are used for detected and correcting errors
and refactoring or reorganizing dataset events.

