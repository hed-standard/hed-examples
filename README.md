[![Documentation Status](https://readthedocs.org/projects/hed-examples/badge/?version=latest)](https://www.hed-resources.org/en/latest/?badge=latest)
[![@HEDstandard](http://img.shields.io/twitter/follow/hedstandard.svg?style=social)](https://twitter.com/HEDstandard)

# HED-examples
This repository contains user supporting code and documentation
for using the Hierarchical Event Descriptor (HED) system for
annotating, summarizing, and analyzing data.
The repository is organized into three subdirectories:

The [**datasets**](https://github.com/hed-standard/hed-examples/tree/main/datasets)
subdirectory contains datasets for testing various aspects of HED.
These datasets have stubs for actual imaging data in order to reduce their size.
Most of these datasets have complete versions available on 
[**openNeuro**](https://openneuro.org/).
See [**datasets/README.md**](./datasets/README.md) for details.

The [**hedcode**](https://github.com/hed-standard/hed-examples/tree/main/hedcode)
subdirectory contains MATLAB scripts, Python Jupyter Notebooks,
and Python scripts with direct calls to HedTools.
The repository also contains example code in python and matlab. 
See [**hedcode/README.md**](src/README.md) for details.
The Python scripts and notebooks require the installation of
`hedtools` whose [**installation**](./README.md#installation-of-hedtools)
is described below.

The [**docs**](https://github.com/hed-standard/hed-examples/tree/main/docs)
subdirectory contains the main documentation for this and other HED resources.
The [**HED GitHub organization repository**](https://github.com/hed-standard/)
gathers the HED supporting resources, all of which are open source.


### Installation of hedtools

The most of the Python-related resources in this repository
require the installation of the HEDTools Python module, which can be
installed using `pip` or directly from its GitHub repository as follows:

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
