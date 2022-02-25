# HED in Python
**This tutorial is underdevelopment.**

## Jupyter notebooks



This tutorial works through the use of various Jupyter notebooks that use the HedTools.

* [**Annotation notebooks**](annotation-notebooks-anchor)  
* [**Validation notebooks**](validation-notebooks-anchor)   
* [**Summary notebooks**](summary-notebooks-anchor)  
* [**Dataset-specific notebooks**](dataset-specific-notebooks-anchor)  


(annotation-notebooks-anchor)=
## Annotation notebooks

### Removing files of a certain type

2


Consider the below situation:

.. code-block:: python

   import os
   from hed.util import get_file_list
    
   bids_root_path = 'G:\Sternberg\SternbergWorkingNew'
   file_list = get_file_list(bids_root_path, extensions=[".tsv"], name_suffix="_temp")
   for file in file_list:
       os.remove(file)

These notebooks are used to assist in creating annotation templates and
other annotation activities.

``` python

[import os
   from hed.util import get_file_list
    
   bids_root_path = 'G:\Sternberg\SternbergWorkingNew'
   file_list = get_file_list(bids_root_path, extensions=[".tsv"], name_suffix="_temp")
   for file in file_list:
       os.remove(file)]()
```

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

