(eeglab-integration-anchor)=
## EEGLAB plug-in integration
EEGLAB is the most widely used EEG software environment for analysis of 
human electrophsyiological (and related) data.
EEGLAB combines graphical and command-line user interfaces,
making it friendly for both beginners who may who prefer a visual,
and automated way of analyzing data as well as experts,
who can easily customize, extend, and automate the EEGLAB tool environment by writing new 
EEGLAB-compatible scripts and functions.

HED is fully integrated into EEGLAB via the *HEDTools* plug-in, allowing users to annotate their
EEGLAB STUDY and datasets with HED,
as well as enabling HED-based data manipulation and processing.

### Installing *HEDTools*

*HEDTools* EEGLAB plug-in can be installed using one of the following ways:

#### Method 1: EEGLAB Extension Manager: 

Launch EEGLAB. From the main GUI select:

> **File --> Manage EEGLAB extension**

The extension manager GUI will pop up. 

From this GUI look for and select the plug-in *HEDTools* from the main window,
then click into the *Install/Update* button to install the plug-in.


#### Method 2: Download and unzip

Download the zip file with the content of the plug-in *HEDTools* either from
[**HED Matlab EEGLAB plugins**](https://github.com/hed-standard/hed-matlab/blob/master/EEGLABPlugin)
or from the EEGLAB [**plug-ins summary page**](https://sccn.ucsd.edu/eeglab/plugin_uploader/plugin_list_all.php). 

Unzip file into the folder *../eeglab/plugins* and restart the *eeglab* function in a MATLAB session.

(annotating-datasets-anchor)=
### Annotating datasets

We will start by adding HED annotations to the EEGLAB tutorial dataset.

After installing the *HEDTools* open the EEGLAB main window and load the dataset by selecting the menu item:  

> **File --> Load existing dataset** .

Selecting the tutorial dataset under your eeglab installation _eeglab/sample_data/eeglab_data.set_. 

Read a description of the dataset and of its included event codes by selecting:  

> **Edit --> About this dataset**:

<img src="_static/images/I15about_this_dataset.png" alt="I15about_this_dataset" align="center" style="zoom:100%;" />

The description gives a general idea of the codes found in the event structure.
Yet, inquisitive researchers interested in the nature of the stimuli
(e.g., color and exact location of the squares on the screen)
would have to look up the referenced paper for details.

Our goal in using HED tags is to describe the experimental events that are recorded 
in the *EEG.event* data structure in sufficient detail that anyone using the dataset
in the future will not need to find and read a separate, detailed description of the dataset
or study to understand the recorded experimental events. 
As demonstrated below, such annotation will allow us to extract epochs using meaningful
HED tags instead of the alpha-numeric codes often associated with shared EEG data.

#### Launching EEGLAB HEDTools
To add and view HED tags for the dataset, from EEGLAB menu, select:  

> **Edit --> Add/Edit event HED tags**.  

_HEDTools_ will extract information from the *EEG.event* structure,
automatically detecting the event structure fields and their unique values.  

The _HEDTools_ ignore the fields the event structure fields *.latency*, *.epoch*, and *.urevent*. 

A window will appear asking you to verify/select categorical fields:

<img src="_static/images/CTagger_categorical_field.jpg" alt="categorical_fields" />

Here both *position* and *type* are categorical fields. 
*HEDTools* automatically selects fields with less than 20 unique values to be categorical,
but the user can modify which values are chosen.

CTagger (for 'Community Tagger') is a graphical user interface (GUI) built to facilitate
the process of adding HED tags to recorded events in existing datasets.
Clicking *Continue* brings up the *CTagger* interface:

![CTagger](_static/images/CTagger_interface.jpg)

The CTagger GUI is organized using a split window strategy.
The left window shows the items to be tagged,
and the right window shows the current HED tags associated with the selected item.
The *Show HED schema* button brings up a browser for the HED vocabulary. 

Through the CTagger GUI, users can explore the HED schema,
quickly look up and add tags (or tag groups) to the desired event codes,
and use import/export features to reuse tags on from other data recordings in the same study.

The process of tagging is simply choosing tags from the available vocabulary
(using the HED schema browser) and associating these tags with each event code.

Once familiar with HED and the vocabulary, most users just type the tags directly in the tag window
shown on the right. 

CTagger is used as part of the HEDTools plug-in in this tutorial,
but it can also be used as a standalone application. 

Instructions on downloading and using the standalone version of CTagger,
as well as step-by-step guide on how to add HED annotation with CTagger,
can be found at in [**Tagging with CTagger**](./TaggingWithCTagger.md).

#### Tagging the events
A brief step-by-step guide to selecting tags can be found at
[**HED annotation quickstart**](./HedAnnotationQuickstart.md).
The following shows example annotations using the process suggested in the quickstart. we will import the annotation saved in the _events.json file format. 
Download the file [**eeglab-tutorial_events.json**](./_static/data/eeglab-tutorial_events.json) then select:

> **File --> Import --> Import BIDS events.json file**

to import it to CTagger. You can now review all the tags via:

> **File --> Review all tags** 

![review tag](_static/images/review-all-tags.jpg)

#### Validation
The last step of the annotation process is to validate the HED annotations.
Click on the *Validate all* button at the bottom pane.
A window will pop up showing validation results.
If there are issues with the annotation, there will be a line for each of the issues found.

Here is an example of validation log file with issues:

![validation-issues](_static/images/validation-error.jpg)

If the annotation was correct, a message will appear confirming the validity:

![validation-success](_static/images/validation-success.jpg)

Click *Finish* on the main CTagger window to end the annotation. 

The tag review window will show up again for a final review and the option to save
the annotation into an _events.json file for distribution just as with the *eeglab-tutorial_events.json*.
Hit *Ok* to continue after that.

A last window will pop up asking what you would like to overwrite the old dataset with the
tagged one or save new dataset as a separate file. Click **Ok** when you're done. 

![new-set](_static/images/pop_newset.jpg)

You just finished tagging! *HEDTools* generates the final HED string for each event
by concatenating all tags associated with the event values of that event (separated by commas).
The final concatenated version is put the string in a new field **HED** in EEG.event. 

### HED-based epoching

The EEGLAB *pop_epoch* function extracts data epochs that are time locked to specified event types.
This function allows you to epoch on one of a specified list of event types as defined by the
*EEG.event.type* field of the EEG structure. 

*HEDTools* provides a simple way for extracting data epochs from annotated datasets using 
a much richer set of conditions. 
To use HED epoching, you must have annotated the EEG dataset. 

If the dataset is not tagged, please refer to [Annotating datasets](#annotating-datasets)
on how to tag a dataset.

Start by choosing the menu option:

> **Tools --> Extract epochs by tags**:

<img src="_static/images/extract-epoch-selection.png" alt="extract-epoch-selection" style="zoom:50%;" />


This will bring up a window to specify the options for extracting data epochs:

<img src="_static/images/epoch-options.png" alt="extract-epoch-selection" style="zoom:50%;" />

The *pop_epochhed* menu is almost identical to the EEGLAB *pop_epoch* menu with the 
exceptions of the first input field (**Time-locking HED tag(s)**) and the second 
input field (**Exclusive HED tag(s)**). 

Instead of passing in or selecting from a group of unique event types,
the user passes in a comma separated list of HED tags.
For each event all HED tags in this list must be found for a data epoch to be generated. 

Clicking the adjacent button (with the label …) will open a search tool to help you select
HED tags retrieved from the dataset.

<img src="_static/images/epoch-tags.png" alt="extract-epoch-selection" style="zoom:50%;" />

When you type something in the search bar, the dialog displays a list below containing possible matches.
Pressing the "up" and "down" arrows on the keyboard while the cursor is in the search bar moves to the
next or previous tag in the list.

Pressing "Enter" selects the current tag in the list and adds the tag to the search bar.
You can continue search and add tags after adding a comma after each tag.
When done, click the **Ok** button to return to the main epoching menu. 
