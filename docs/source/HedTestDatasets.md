# HED test datasets

This repository contains a set of
[HED-annotated](https://hed-specification.readthedocs.io/en/latest/index.html)
datasets in [BIDS-compatible](https://bids.neuroimaging.io/) format.
These datasets can be useful for:

1. Writing lightweight software tests.
1. Serving as examples of how to incorporate HED into BIDS-structured data.

The datasets have **empty raw data files**.
However, some data headers containing the metadata are still intact.

Datasets that are derived from datasets on [OpenNeuro](https://openneuro.org)
are identified by their OpenNeuro accession number plus 's' plus a modifier.
Datasets focused on particular a particular modality may have the modality
prepended to the name.
For example, eeg_ds003645s identifies a reduced dataset derived the EEG data
in OpenNeuro dataset ds003645.
The suffix modifier indicates what this dataset is designed to test.

| Dataset | Description |
| ----------------- | ------------|
| [eeg_ds003645s_hed](eeg_ds003645s_hed_anchor)| Short-form tags with definitions. |
| [eeg_ds003645s_hed_inheritance](eeg_ds003645s_hed_inheritance_anchor) | Multiple sidecars with inheritance. |
| [eeg_ds003645s_hed_library](eeg_ds003645s_hed_library_anchor) | Multiple HED library schemas. |
| [eeg_ds003645s_hed_longform](eeg_ds003645s_hed_longform_anchor) | Long-form with definitions. |
| [fmri_soccer21_hed](fmri_soccer21_hed_anchor) | Annotation with single column. |

(eeg_ds003645s_hed_anchor)=
## eeg_ds003645s_hed

This dataset was originally released as a multi-modal dataset by 

Detailed case study in using HED for tagging:

> Robbins, K., Truong, D., Appelhoff, S., Delorme, A., & Makeig, S. (2021, May 7). 
> Capturing the nature of events and event context using Hierarchical Event Descriptors (HED). 
> BioRxiv, 2021.05.06.442841. 
> [https://doi.org/10.1101/2021.05.06.442841](https://doi.org/10.1101/2021.05.06.442841)

(eeg_ds003645s_hed_inheritance_anchor)=
## eeg_ds003645s_hed_inheritance

This is eeg_ds003645s_hed_inheritance 

(eeg_ds003645s_hed_library_anchor)=
## eeg_ds003645s_hed_library

This dataset is designed to test the HED library schema facility.
It uses HED 8.0.0 as a base schema and as the "test" library schema.
In addition, this dataset uses the SCORE library version 1.0.0 as a library schema.

The schema used are specified in the `dataset_description.json` file using the 
proposed format.

(eeg_ds003645s_hed_longform_anchor)=
## eeg_ds003645s_hed_longform
This dataset is used to test that tools work with either long-form or short-form HED tags.

(fmri_soccer21_hed_anchor)=
## fmri_soccer21_hed
This dataset is designed to illustrate a basic FMRI pipeline.


## BIDS validation

For general information on the `bids-validator`, including installation, configuration, and usage,
see the [bids-validator README file](https://github.com/bids-standard/bids-validator#quickstart).

**Example:** The following command validates the  `eeg_ds003645s_hed` dataset:

```sh
bids-validator eeg_ds003645s_hed --config.ignore=99
```

This example assumes that `npm` and the `bids-validator` npm package
have been installed on the local machine.
The command is run from the directory above the dataset root directory.
The `--config.ignore=99` flag tells the bids-validator to ignore empty data files
rather than to report the empty file error.

For additional information on BIDS validation,
see the [bids-examples](https://github.com/bids-standard/bids-examples#readme).
