# HED test datasets

The [**hed-examples**](https://github.com/hed-standard/hed-examples) repository contains
a set of HED-annotated datasets in 
[**BIDS**](https://bids.neuroimaging.io/)-compatible format.
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

| Dataset | Description | OpenNeuro |
| ----------------- | ------------| ----- |
| [**eeg_ds002893s_hed_attention_shift**](eeg_ds002893s_hed_attention_shift_anchor)| Shift between auditory and visual modalities. | [**ds002893**](https://openneuro.org/datasets/ds002893)   |
| [**eeg_ds003645s_hed**](eeg_ds003645s_hed_anchor)| Short-form tags with definitions. | [**ds003645**](https://openneuro.org/datasets/ds003645) |   |
| [**eeg_ds003645s_hed_column**](eeg_ds003645s_hed_column_anchor) | Some events.tsv files contain a `HED` column. |   |
| [**eeg_ds003645s_hed_inheritance**](eeg_ds003645s_hed_inheritance_anchor) | Multiple sidecars with inheritance. |   |
| [**eeg_ds003645s_hed_library**](eeg_ds003645s_hed_library_anchor) | Multiple HED library schemas. |    |
| [**eeg_ds003645s_hed_longform**](eeg_ds003645s_hed_longform_anchor) | Long-form with definitions. |   |
| [**eeg_ds004105s_hed_longform**](eeg_ds004105s_hed_anchor) | BCIT auditory cueing  | [**ds004105**](https://openneuro.org/datasets/ds004105)  |
| [**eeg_ds004106s_hed_longform**](eeg_ds004106s_hed_anchor) | BCIT advanced guard duty  | [**ds004106**](https://openneuro.org/datasets/ds004106)  |
| [**eeg_ds004117s_hed_sternberg**](eeg_ds004117s_hed_sternberg_anchor) | Sternberg working memory task  | [**ds004117**](https://openneuro.org/datasets/ds004117)  |
| [**fmri_ds002790s_hed_aomic**](fmri_ds002790s_hed_aomic_anchor) | Annotation with single column. | [**ds002790**](https://openneuro.org/datasets/ds002790) |
| [**fmri_soccer21_hed**](fmri_soccer21_hed_anchor) | Annotation with single column. |   |

(eeg_ds002893s_hed_attention_shift_anchor)=
## eeg_ds002893s_hed

This dataset includes rapid shifts in instructed attention between visual and
auditory modalities. 
The dataset is mentioned as an example in the OHBM 2022 tutorial
[**Annotating the timeline of neuroimaging time series data using
Hierarchical Event Descriptors**](https://www.youtube.com/playlist?list=PLeII6cRFsP6L5S6icwRrJp0DHkhOHtbp-).

(eeg_ds003645s_hed_anchor)=
## eeg_ds003645s_hed

This dataset was originally released as multi-modal dataset 
[**ds000117**](https://openneuro.org/datasets/ds000117) by Daniel Wakeman and Richard Henson.
The dataset events in [**ds003645**](https://openneuro.org/datasets/ds003645)
have been reorganized from the original and additional events added
from the experimental logs. The dataset includes MEEG and behavioral data.
HED tags have been added.

The dataset is used as a HED case study in:

> Robbins, K., Truong, D., Appelhoff, S., Delorme, A., & Makeig, S. (2021).   
> Capturing the nature of events and event context using Hierarchical Event Descriptors (HED).   
> Neuroimage 2021 Dec 15;245:118766. doi: 10.1016/j.neuroimage.2021.118766. Epub 2021 Nov 27.  
> [https://www.sciencedirect.com/science/article/pii/S1053811921010387?via%3Dihub](https://www.sciencedirect.com/science/article/pii/S1053811921010387?via%3Dihub).   


(eeg_ds003645s_hed_column_anchor)=
## eeg_ds003645s_hed_column 

This is a modification of ds003645s_hed where some `events.tsv` files contain a `HED` column.

(eeg_ds003645s_hed_inheritance_anchor)=
## eeg_ds003645s_hed_inheritance

This is a modification of ds003645s_hed where multiple sidecars containing HED
tags are included to test that HED tools correctly handle BIDS inheritance rules.

(eeg_ds003645s_hed_library_anchor)=
## eeg_ds003645s_hed_library

This dataset is designed to test the HED library schema facility.
It uses HED 8.0.0 as a base schema and as the "test" library schema.
In addition, this dataset uses the SCORE library version 1.0.0 as a library schema.

The schemas are specified in the `dataset_description.json` file.

(eeg_ds003645s_hed_longform_anchor)=
## eeg_ds003645s_hed_longform
This is a modification of ds003645s_hed where the HED tags include a mix
of tags in long and short forms to test that tools work with either long-form or short-form HED tags.

(eeg_ds004105s_hed_anchor)=
## eeg_ds004105s_hed
Subjects in the Auditory Cueing study performed a long-duration simulated driving
task with perturbations and audio stimuli in a visually sparse environment.
The dataset is part of a collection of 10 datasets 
from the BCIT program designed to test EEG mega-analysis.

(eeg_ds004106s_hed_anchor)=
## eeg_ds004106s_hed
BCIT Advanced Guard Duty study was designed to measure sustained 
vigilance in realistic settings by having subjects verify information on 
replica ID badges. The dataset is part of a collection of 10 datasets 
from the BCIT program designed to test EEG mega-analysis.

(eeg_ds004117s_hed_sternberg_anchor)=
## eeg_ds004117s_hed_sternberg

Sternberg working memory dataset, described in 
[**Onton et al. 2005**](https://pubmed.ncbi.nlm.nih.gov/15927487/),
is used in a number of HED case studies including
the OHBM 2022 tutorial
[**Annotating the timeline of neuroimaging time series data using
Hierarchical Event Descriptors**](https://www.youtube.com/playlist?list=PLeII6cRFsP6L5S6icwRrJp0DHkhOHtbp-) and the book chapter
[**2.3 End-to-end processing of M/EEG data with BIDS, HED, and EEGLAB**](https://osf.io/8brgv/) by Thruong et al. in
[**Methods for analyzing large neuroimaging datasets**](https://osf.io/d9r3x/) edited by Whelan and Lemaitre.

The study was also selected for replication in the 
[**EEGManyLabs**](https://www.sciencedirect.com/science/article/pii/S0010945221001106) initiative.

(fmri_ds002790s_hed_aomic_anchor)=
## fmri_ds002790s_hed_aomic
This dataset is part of the [**Amsterdam OpenMRI Collection (AOMIC)**](https://nilab-uva.github.io/AOMIC.github.io/). 

The dataset is used as a case study for the book chapter
[**2.4 Actionable event annotation and analysis in fMRI: A practical guide to event handling**](https://osf.io/93km8/) by Denissen et al. in
[**Methods for analyzing large neuroimaging datasets**](https://osf.io/d9r3x/) edited by Whelan and Lemaitre.

(fmri_soccer21_hed_anchor)=
## fmri_soccer21_hed
This dataset is designed to illustrate a basic FMRI pipeline.
The dataset is used as a case study for the book chapter
[**2.4 Actionable event annotation and analysis in fMRI: A practical guide to event handling**](https://osf.io/93km8/) by Denissen et al. in
[**Methods for analyzing large neuroimaging datasets**](https://osf.io/d9r3x/) edited by Whelan and Lemaitre.

## BIDS validation

For general information on the `bids-validator`, including installation, configuration, and usage,
see the [bids-validator README file](https://github.com/bids-standard/bids-validator/blob/master/README.md).

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
