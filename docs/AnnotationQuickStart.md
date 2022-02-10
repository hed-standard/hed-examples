# 1. Annotation quick start (online tools)

**Note: This tutorial is in the process of being developed.** 

This tutorial takes you through the steps of annotating the events in your BIDS dataset
using HED (Hierarchical Event Descriptors).
The goal is to construct a single `events.json` file located in the root directory
of your dataset, with all the annotations needed for users to understand and
analyze your data. 


1. [Extract a JSON sidecar template from an event file.](#extract-a-json-sidecar-template-from-an-event-file)
2. [Extract a HED spreadsheet from the JSON sidecar.](#extract-a-hed-spreadsheet-from-the-json-sidecar)
3. [Insert your annotations into the spreadsheet.](#insert-your-annotations-into-the-spreadsheet)
4. [Merge spreadsheet annotation into JSON sidecar](#merge-spreadsheet-annotation-into-json-sidecar)
5. [Place the resulting sidecar in dataset root directory](#place-the-resulting-sidecar-in-dataset-root-directory)

Note that annotation is usually an iterative process.
Once you have done the initial annotation, you can either edit the
JSON sidecar or the annotation spreadsheet.
If you change the annotation spreadsheet you just need to remerge
the annotations into the sidecar.

This guide focuses on the mechanics of event annotation, particularly
for [BIDS Brain Imaging Data Structure](https://bids-specification.readthedocs.io/en/stable/) datasets.
See the [Basic HED annotation guide](Basic HED annotation guide) for a
walk-through of how to select HED tags for your annotation.

The online tools are available at [HED online tools](https://hedtools.ucsd.edu/hed).


### Extract a JSON sidecar template from an event file 

Go to the [Events](https://hedtools.ucsd.edu/hed/events) page of the HED online tools.


![Screenshot 1](./_static/EventExtractSidecarShot2.png)

Select the *Extract sidecar template* action and upload your `events.tsv` file
using the *Browse* button.

In this quickstart we use an
[abbreviated version](./tutorial_data/sub-002_task-FacePerception_run-1_events.tsv) of the `events.tsv`
file from subject 002 run 1 from
[openNeuro](https.openneuro.org) dataset ds003654s.

When the file has been uploaded, the form will expand to show the available
columns to include in the template: 

![Screenshot 1](./_static/EventExtractSidecarShot2.png)

You should check boxes corresponding to the columns you wish to include in the
annotation template. 

Check only the categorical columns (checkboxes on right) that have
columns values that you wish to annotate individually.

Press the browse button and save the resulting JSON template as a file.
We created this [extracted template](./tutorial_data/sub-002_task-FacePerception_run-1_events_extracted.json)
from the [abbreviated version](./tutorial_data/sub-002_task-FacePerception_run-1_events.tsv) of the `events.tsv`
file from subject 002 run 1 from
[openNeuro](https.openneuro.org) dataset ds003654s described above.

### Extract a HED spreadsheet from the JSON sidecar

Now go to the [Sidecar menu](https://hedtools.ucsd.edu/hed/sidecar) in the
online HED tools and select the *Extract HED to spreadsheet* action and
upload the JSON sidecar template created from the previous step:

![Screenshot 1](./_static/EventExtractSidecarShot2.png)

Press the process button and download the resulting `.tsv` file to edit
in offline.

### Insert your annotations into the spreadsheet

You should start by writing a clear, one-sentence description of each
entry in the `description` column of the spreadsheet.
This description will appear in the `Levels` section of the sidecar
and/or in the `Description` tag in the HED annotation,
depending on the options you select below when merging.

See [Basic HED annotation guide](Basic HED annotation guide) for a
walk-through of how to do HED annotation.

See the [CTagger Annotation Guide](CTaggerAnnotationGuide.md) for
instructions on how to select HED tags using a user-friendly
GUI.

### Merge spreadsheet annotation into JSON sidecar

Once you have completed a draft of your annotation spreadsheet,
go to the [Spreadsheet menu](https://hedtools.ucsd.edu/hed/spreadsheet) in the
online HED tools and select the *Merge HED to sidecar* action and
upload the edited HED spreadsheet from the previous step and the 
previously created JSON sidecar:

![Screenshot 1](./_static/EventExtractSidecarShot2.png)

Press the process button and download the resulting sidecar file.

After merging our [HED annotation spreadsheet]()

### Place the resulting sidecar in dataset root directory

We annotated a sWhile it is possible to edit annotations directly into the JSON sidecar,
many users find dealing with the JSON format to be inconvenient.
We recommend transforming the annotation part of the sidecar into 
![Screenshot 1](./_static/EventExtractSidecarShot2.png)

