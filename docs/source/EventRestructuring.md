# Event restructuring

This tutorial works through the process of restructuring event files using the HED event remodeling tools. The tools are designed to be run on an entire BIDS dataset.

* [**What is HED annotation?**](what-is-hed-annotation-anchor)  
* [**A recipe for simple annotation**](a-recipe-for-simple-annotation-anchor)  

(what-is-event-restructuring-anchor)=
## What is event restructuring?


(a-recipe-for-simple-annotation-anchor)=
## Installation and running of the restructuring


(standard-hed-tag-selections-anchor)=
```{admonition} Standard HED tag selections for minimal annotation.
:class: tip

|  Event tag    | Support tag type |  Example tags  | Reason | 
| ------------- | -------------------- | ------------ | ------ |
| **<em>Sensory-event</em>** | *Sensory-presentation* | *Visual-presentation*<br>*Auditory-presentation*| Which sense? | 
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