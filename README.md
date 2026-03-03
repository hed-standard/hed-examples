# HED-examples
This repository contains user supporting code and documentation
for using the Hierarchical Event Descriptor (HED) system for
annotating, summarizing, and analyzing data.
The repository is organized into three subdirectories:

The [**datasets**](https://github.com/hed-standard/hed-examples/tree/main/datasets)
subdirectory contains [HED-annotated](https://hed-specification.readthedocs.io/en/latest/index.html)
datasets in [BIDS-compatible](https://bids.neuroimaging.io/) format.
These datasets can be useful for:

1. Writing lightweight software tests.
1. Serving as examples of how to incorporate HED into BIDS-structured data.

The datasets have **empty raw data files**.
However, some data headers containing the metadata are still intact.

Datasets that are derived from datasets on [OpenNeuro](https://openneuro.org)
are identified by their OpenNeuro accession number plus 's' plus a modifier.
Datasets focused on a particular modality may have the modality prepended to the name.
For example, `eeg_ds003645s` identifies a reduced dataset derived from the EEG data
in OpenNeuro dataset ds003645.
The suffix modifier indicates what this dataset is designed to test.

| Dataset                           | Description                                                                                                   |
|-----------------------------------|---------------------------------------------------------------------------------------------------------------|
| eeg_ds002893s_hed_attention_shift | Auditory-visual attention shift data.<br>Illustrates remapping of multiple event columns.                     |
| eeg_ds003645s_hed                 | Face Perception data using short form tags and definitions.                                                   |
| eeg_ds003645s_hed_column          | Face Perception data to test annotations in HED column.                                                       |
| eeg_ds003645s_hed_demo            | Face Perception data demonstrating full usage of HED in tsv.                                                  |
| eeg_ds003645s_hed_library         | Face Perception data using HED libraries.                                                                     |
| eeg_ds003645s_hed_partnered       | Face Perception data using HED partnered libraries.                                                           |
| eeg_ds003645s_hed_remodel         | Face Perception data in remodeling.                                                                           |
| eeg_ds004105s_hed                 | BCIT Driving with auditory cueing data.<br>Part of a test data corpus for BIDS-MEGA testing.                  |
| eeg_ds004106s_hed                 | BCIT Advanced guard duty data.<br>Part of a test data corpus for BIDS-MEGA testing.                           |
| eeg_ds004117s_hed_sternberg       | Sternberg working memory task.<br>Chosen as a replication study for [**EEGManyLabs**](https://osf.io/yb3pq/). |
| fmri_ds002790s_hed_aomic          | AOMIC data example.                                                                                           |
| fmri_soccer21s_hed                | HED tags using a single column.<br>Used for fMRI processing examples.                                         |

### Validating datasets using the BIDS validator

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

**Example:** The following command validates the `fmri_soccer21s_hed` dataset:

```code
bids-validator fmri_soccer21s_hed --config.ignore=99 --ignoreNiftiHeaders
```

For additional information on BIDS validation,
see the [bids-examples](https://github.com/bids-standard/bids-examples#readme).

The [**src**](https://github.com/hed-standard/hed-examples/tree/main/src)
subdirectory contains Python Jupyter notebooks demonstrating calls to HedTools.
For MATLAB support for HED see the [**hed-matlab**](https://github.com/hed-standard/hed-matlab)
GitHub repository.

HED documentation and tutorials are available at [**hed-resources**](https://www.hedtags.org/hed-resources).
The [**HED GitHub organization**](https://github.com/hed-standard/)
gathers the HED supporting resources, all of which are open source.


