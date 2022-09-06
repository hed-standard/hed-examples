**This section is out of date and will be updated soon.**
The demo scripts use data in `../data/sternberg` and in the reduced
attention shift dataset: 

[https://github.com/hed-standard/hed-examples/data/eeg_ds0028932](https://github.com/hed-standard/hed-examples/data/eeg_ds0028932).

The notebooks are designed to be executed in the following order:  

1. `summarize_events.ipynb` gather all of the unique values in the columns of
all of the events files in a BIDS dataset.  

2. `create_template.ipynb`  gathers all of the unique combinations of values in
a specified group of columns (the key columns) and creates a template file
for you to specify the mapping between each unique key and values in target columns.
This is the **event design** that must be filled in by the user.  

3. `remap_events.ipynb` creates new event files using the template from the previous
step to remap columns.

4. `tag_columns.ipynb` demonstrates how to create a list of the unique
values in the specified columns in a flattened form so that they can be tagged.


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
