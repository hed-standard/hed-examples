
# HED-examples

This repository contains a set of [HED-annotated](https://www.hedtags.org)
datasets in [BIDS-compatible](https://bids.neuroimaging.io/) format.
These datasets can be useful for:

1. writing lightweight software tests
1. serving as examples of how to incorporate HED into BIDS-structured data.


The datasets have **empty raw data files**. However for some of the data, the 
headers containing the metadata are still intact. Some of the actual full
datasets corresponding to these examples have been deposited on 
[OpenNeuro](https://openneuro.org). For these datasets, their OpenNeuro
accession number + 's' (e.g., ds003645s for the OpenNeuro dataset ds003645) 
will be appended to the dataset name for identification.

## Validating examples using the BIDS validator

For general information on the `bids-validator`, including installation and usage, see the
[bids-validator README file](https://github.com/bids-standard/bids-validator#quickstart).

Since all raw data files in this repository are empty,
the `bids-validator` must to be configured to not report empty data files as errors.
(See more on bids-validator configuration in the
[bids-validator README](https://github.com/bids-standard/bids-validator#configuration).)

Just run the validator as follows (using the `eeg_ds003645s` dataset as an example,
and assuming you are in a command line at the root of the `hed-examples` repository):

`bids-validator eeg_ds003645s --config.ignore=99`

The `--config.ignore=99` "flag" tells the bids-validator to ignore empty data files rather than to report the "empty file" error.

For datasets that contain NIfTI `.nii` files, you also need to add the `ignoreNiftiHeaders` flag
to the `bids-validator` call, to suppress the issue that NIfTI headers are not found.

For example:

`bids-validator ds003 --config.ignore=99 --ignoreNiftiHeaders`

For additional information on BIDS validation,
see the [bids-examples](https://github.com/bids-standard/bids-examples#readme).
