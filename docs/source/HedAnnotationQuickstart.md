# HED annotation quickstart

This tutorial takes you through the steps of annotating the events
using HED (Hierarchical Event Descriptors).
The tutorial focuses on how to make good choices of HED annotations
to make your data usable for downstream analysis.
The mechanics of putting your selected HED annotations into
[BIDS (Brain Imaging Data Structure)](https://bids.neuroimaging.io/) format
is covered in the [**BIDS annotation quickstart**](./BidsAnnotationQuickstart.md) guide.

* [**What is HED annotation?**](what-is-hed-annotation-anchor)  
* [**A recipe for simple annotation**](a-recipe-for-simple-annotation-anchor)  

(what-is-hed-annotation-anchor)=
## What is HED annotation?

A HED annotation consists of a comma separated list of tags selected from
a HED vocabulary or schema.
An important reason for using an agreed-upon vocabulary rather than
free-form tagging for annotation is to avoid confusion and ambiguity
and to promote data-sharing.

The basic terms are organized into trees for easier access and search.
The [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html) allows
you to explore these terms.

(a-recipe-for-simple-annotation-anchor)=
## A recipe for simple annotation
In thinking about how to annotate an event, you should always start
by selecting a tag from the *Event* subtree to indicate the general event category.
Possible choices are: *Sensory-event*, *Agent-action*, *Data-feature*, *Experiment-control*,
*Experiment-procedure*, *Experiment-structure*, and *Measurement-event*.
See the [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html)
to view the available tags.

Most experiments will only have a few types of distinct events.
The simplest way to create a minimal HED annotation for your events is:

1. Select one of the 7 tags from the *Event* subtree to designate the general category of the event.  
2. Use the following table to select the appropriate supporting tags given that event type.

(standard-hed-tag-selections-anchor)=
```{admonition} Standard HED tag selections for minimal annotation.
:class: tip

|  Event tag    | Support tag type |  Example tags  | Reason | 
| ------------- | -------------------- | ------------ | ------ |
| **<em>Sensory-event</em>** | *Sensory-presentation* | *Visual-presentation*<br>*Auditory-presentation*| Which sense? | 
|              | *Task-event-role* | *Experimental-stimulus*<br>*Instructional* | What task role? | 
|              | *Task-stimulus-role* | *Cue*<br>*Target* | Stimulus purpose? |  
|              | *Item*  | *(Face, Image)*<br>*Siren* | What is presented? | 
|              | *Sensory-attribute* | *Red* | What modifiers are needed? | 
| **<em>Agent-action</em>** | *Agent-task-role* | *Experiment-participant* | Who is agent? |  
|                | *Action*          | *Move*<br>*Press* | What action is performed? | 
|                | *Task-action-type* | *Appropriate-action*<br>*Near-miss* | What task relationship? | 
|                | *Item*            | *Arm*<br>*Mouse-button* | What is action target? | 
| **<em>Data-feature</em>** | *Data-source-type* | *Expert-annotation*<br>*Computed-feature* | Where did the feature come from? |  
|                | *Label*            | *Label/Blinker_BlinkMax* | Tool name?<br>Feature type? | 
|                | *Data-value*       | *Percentage/32.5* <br>*Time-interval/1.5 s* | Feature value or type? | 
| **<em>Experiment-control</em>** | *Agent* | *Controller-Agent* | What is the controller? | 
|                      | *Informational* | *Label/Stop-recording* | What did the controller do? |
| **<em>Experiment-procedure</em>** | *Task-event-role* | *Task-activity* | What procedure? | 
| **<em>Experiment-structure</em>** | *Organizational-property* | *Time-block*<br>*Condition-variable* | What structural property? | 
| **<em>Measurement-event</em>** | *Data-source-type*  | *Instrument-measurement*<br>*Observation* | Source of the data. | 
|                | *Label*            | *Label/Oximeter_O2Level* | Instrument name?<br>Measurement type? |
|                | *Data-value*       | *Percentage/32.5* <br>*Time-interval/1.5 s* | What value or type? 
```


As in BIDS, we assume that the event metadata is given in tabular form.
Each table row represents the metadata associated with a single data event marker,
as shown in the following excerpt of the `events.tsv` file for a simple Go/No-go experiment.
The `onset` column gives the time in seconds of the marker relative
to the beginning of the associated data file. 

(example-go-no-go-event-table-anchor)=
````{admonition} Event file from a simple Go/No-go experiment.

| onset | duration | event_type | value | stim_file | 
| ----- | -------- | ---------- | ----- | --------- | 
| 5.035 | n/a | stimulus | animal_target | 105064.jpg | 
| 5.370 | n/a | response | correct_response | n/a | 
| 6.837 | n/a | stimulus | animal_distractor | 38068.jpg |
| 8.651 | n/a | stimulus | animal_target | 136095.jpg |
| 8.940 | n/a | response | correct_response | n/a |
| 10.801 | n/a | stimulus | animal_distractor | 38014.jpg |
| 12.684 | n/a | stimulus | animal_distractor | 82063.jpg |
| 12.943 | n/a | response | incorrect_response | n/a |
````

In the Go/No-go experiment, the experimental participant is presented
with a series of target and distractor animal images.
The participant is instructed to lift a finger off a button
when a target animal image appears.
Since in this experiment, the `value` column has distinct values
for all possible unique event types, the `event_type` column is redundant.
In this case, we can choose to assign all the annotations to
the `value` column as demonstrated in the following example.

````{admonition} Version 1: Assigning all annotations to the value column.

| value | Event category |  Supporting tags |  
| ------- | -------------- | --------------- |   
| animal_target | *Sensory-event* | *Visual-presentation*, *Experimental-stimulus*,<br>*Target*, (*Animal*, *Image*) |  
| animal_distractor | *Sensory-event* | *Visual-presentation*, *Experimental-stimulus*,<br>*Non-target*, *Distractor*, (*Animal*, *Image*) |  
| correct_response | *Agent-action* | *Experiment-participant*, (*Lift*, *Finger*), *Correct-action* |  
| incorrect_response | *Agent-action* | *Experiment-participant*, (*Lift*, *Finger*), *Incorrect-action* |  

````

The table above shows the event category and the supporting tags as suggested in the
[**Standard hed tags for minimal annotation**](standard-hed-tag-selections-anchor) table.

A better format for your annotations is the 
[**4-column spreadsheet format**](four-column-spreadsheet-format-anchor) described in
[**BIDS annotation quickstart**](BidsAnnotationQuickstart.md), since there are online
tools to convert this format into a JSON sidecar that can be deployed directly in
a BIDS dataset. 

````{admonition} 4-column spreadsheet format for the previous example.

| column_name| column_value | description | HED |  
| ------- | -------------- | ----------- | ------- |  
| value | animal_target | An target animal image was<br>presented on a screen. |*Sensory-event*, *Visual-presentation*,<br>*Experimental-stimulus*,<br>*Target*, (*Animal*, *Image*) |  
| value | animal_distractor | A non-target animal distractor<br>image was presented<br>on a screen.  | *Sensory-event*, *Visual-presentation*,<br>*Experimental-stimulus*, *Non-target*,<br>*Distractor*, (*Animal*, *Image*)|  
| value | correct_response | Participant correctly<br>lifted finger off button.  | *Agent-action*, *Experiment-participant*,<br>(*Lift*, *Finger*), *Correct-action* |  
| value | incorrect_response | Participant lifted finger off<br>the button but should not have. | *Agent-action*, *Experiment-participant*,<br>(*Lift*, *Finger*), *Incorrect-action* |  

````

HED tools assemble the annotations for each event into a single HED tag string.
An exactly equivalent version of the previous example splits the HED tag annotation between
the `event_type` and `value` columns as shown in the next example.

````{admonition} Version 2: Assigning annotations to multiple event file columns.

| column_name | column_value | description | HED |  
| ------- | -------------- | --------------- | ------ |  
| event_type | stimulus | An image of an animal<br>was presented on a<br>computer screen.| *Sensory-event*, <br>*Visual-presentation*,<br>*experimental-stimulus* |  
| event_type | response | Participant lifted finger<br>off button.| *Agent-action*,<br> *Experiment-participant*,<br>(*Lift*, *Finger*) |  
| value | animal_target | A target animal image. | *Target*, (*Animal*, *Image*) |  
| value | animal_distractor | A non-target animal image<br>meant as a distractor. | *Non-target*, *Distractor*,<br>(*Animal*, *Image*) |  
| value | correct_response | The previous stimulus<br>was a target animal. | *Correct-action* |  
| value | incorrect_response | The previous stimulus<br>was not a target animal. | *Incorrect-action* |  
| stim_file | n/a | Filename of stimulus image. | (*Image*, *Pathname/#*) |  
````
In version 2, the annotations that are common
to all stimuli and responses are assigned to `event_type`.
We have also included the annotation for the `stim_file` column in the last row
of this table. 

The assembled annotation for the first event (with onset 5.035) in the 
[**event file excerpt from go/no-go**](example-go-no-go-event-table-anchor) above is:

> *Sensory-event*, *Visual-presentation*, *Experimental-stimulus*, *Target*, (*Animal*, *Image*), (*Image*, *Pathname/105064.jpg*)

Mapping annotations and column information across multiple column values often makes
the annotation process simpler, especially when annotations become more complex.
Multiple column representation also can make analysis easier,
particularly if the columns represent information such as design variables.

See [**BIDS annotation quick start**](BidsAnnotationQuickstart.md#bids-annotation-quickstart) for how to
create templates to fill in with your annotations using online tools.
Once you have completed the annotation and converted it to a sidecar,
you simply need to place this sidecar in the root directory of your BIDS dataset.

This quick start demonstrates the most basic HED annotations.
HED is capable of much more extensive and expressive annotations as
explained in a series of tutorials on this site.