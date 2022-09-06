
# HED example datasets

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
| eeg_ds002893s_hed_attention_shift | Auditory-visual attention shift data.<br>Illustrates remapping of multiple event columns. |
| eeg_ds003654s_hed | Wakeman-Henson data using short form tags and definitions. |
| eeg_ds003654s_hed_column | Wakeman-Henson data with tags in events.tsv HED column. |
| eeg_ds003654s_hed_inheritance |  Wakeman-Henson data with multiple sidecars. |
| eeg_ds003654s_hed_library |  Wakeman-Henson data using HED libraries. |
| eeg_ds003654s_hed_longform |  Wakeman-Henson data using long form tags and definitions. |
| eeg_ds004105s_hed | BCIT Driving with auditory cueing data.<br>Part of a test data corpus for BIDS-MEGA testing. |
| eeg_ds004106s_hed | BCIT Advanced guard duty data.<br> Part of a test data corpus for BIDS-MEGA testing. |
| eeg_ds004117s_hed_sternberg | Sternberg working memory task.<br>Chosen as a replication study for [**EEGManyLabs**](https://osf.io/yb3pq/).|
| fmri_soccer21_hed | HED tags using a single column.<br>Used for fMRI processing examples. |


### Validating examples using the BIDS validator

For general information on the `bids-validator`, including installation, configuration, and usage,
see the [bids-validator README file](https://github.com/bids-standard/bids-validator#quickstart).

**Example:** The following command validates the `eeg_ds003645s_hed` dataset:

```code
bids-validator eeg_ds003645s_hed --config.ignore=99
```

This example assumes that `npm` and the `bids-validator` npm package
have been installed on the local machine.
The command is run from the directory above the dataset root directory.
The `--config.ignore=99` flag tells the `bids-validator` to ignore empty data
files rather than to report the empty file error.

For FMRI datasets you also need to use the `--ignoreNiftiHeaders` option.

**Example:** The following command validates `fmri_soccer21s_hed` dataset:

```code
bids-validator fmri_soccer21s_hed --config.ignore=99 --ignoreNiftiHeaders
```

For additional information on BIDS validation,
see the [bids-examples](https://github.com/bids-standard/bids-examples#readme).
