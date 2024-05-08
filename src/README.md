# HED code examples

This repository contains user supporting code and documentation
for using the Hierarchical Event Descriptor (HED) system for
annotating data. 

The [**HED GitHub organization repository**](https://github.com/hed-standard/)
gathers the HED supporting resources, all of which are open source.

The main documentation for this and other HED resources
is available through the
[**HED-resources**](https://www.hed-resources.org) documentation,
whose source is contained in the 
[**docs**](https://github.com/hed-standard/hed-examples/tree/main/docs)
subdirectory of this repository.

The [**src**](https://github.com/hed-standard/hed-examples/tree/main/src)
subdirectory of the [**hed-examples**] GitHub repository contains Python Jupyter 
notebooks with examples of how to call the HEDTools.

For MATLAB support for HED see the [**hed-matlab**](https://github.com/hed-standard/hed-matlab)
GitHub repository.

The [**datasets**](https://github.com/hed-standard/hed-examples/tree/main/datasets)
subdirectory contains datasets for testing various aspects of HED.
These datasets have stubs for actual imaging data in order to reduce their size.
Most of these datasets have complete versions available on 
[**openNeuro**](https://openneuro.org/).

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
