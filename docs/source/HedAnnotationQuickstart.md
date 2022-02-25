# HED annotation quickstart

**This tutorial is underdevelopment.**

This tutorial takes you through the steps of annotating the events
using HED (Hierarchical Event Descriptors).
This tutorial focuses on how to make good choices of HED annotations
to make your data usable for downstream analysis.
The mechanics of putting your selected HED annotations into
[BIDS (Brain Imaging Data Structure)](https://bids.neuroimaging.io/) format
is covered in the [**BIDS annotation quickstart**](./BidsAnnotationQuickstart.md) guide.

* [**What is HED annotation?](what-is-hed-annotation-anchor)

(what-is-hed-annotation-anchor)=
## What is HED annotation?

A HED annotation consists of a comma separated list of tags selected from
a HED vocabulary or schema.
An important reason for using an agreed-upon vocabulary rather than
free-form tagging for annotation is to avoid confusion and ambiguity
and to promote data-sharing.

The basic terms are organized into trees for easier access and search.
The [Expandable browser](https://www.hedtags.org/display_hed.html) allows
you to explore these terms.

## Annotating an event
In thinking about how to annotate an event, you should always start
by selecting a tag from the *Event* subtree to indicate the general event category.
Possible choices are: *Sensory-event*, *Agent-action*, *Data-feature*, *Experiment-control*,
*Experiment-procedure*, *Experiment-structure*, and *Measurement-event*.

```{admonition} Standard HED tag selections for minimal annotation
|  Event tag    | Support tag category |  Example tags  | Reason | 
| ------------- | -------------------- | ------------ | ------ |
| *Sensory-event* | *Sensory-presentation* | *Visual-presentation*<br>*Auditory-presentation*| Which sense is being used? | 
|              | *Task-event-role* | *Experimental-stimulus*<br>*Instructional* | What is the role wrt task? | 
|              | Task-stimulus-role | *Cue*<br>*Target* | If stimulus, what purpose? | 
| *Agent-action* | Task-stimulus-role | *Cue*<br>*Target* | If stimulus, what purpose? | 
| *Data-feature* | Task-stimulus-role | *Cue*<br>*Target* | If stimulus, what purpose? | 
| *Experiment-control* | Task-stimulus-role | *Cue*<br>*Target* | If stimulus, what purpose? | 
| *Experiment-procedure* | Task-stimulus-role | *Cue*<br>*Target* | If stimulus, what purpose? | 
| *Experiment-structure* | *Organizational-property | *Time-block*<br>*Condition-variable* | Used to mark structural organization in the data. | 
| *Measurement-event* | Task-stimulus-role | *Cue*<br>*Target* | If stimulus, what purpose? | 
```



We assume that the event metadata is given in tabular form with each row
representing the metadata about a data event marker as shown in the following table:


````{admonition} A simplified excerpt from an event file.
| onset	| duration | sample | event_type | face_type | rep_status | trial | rep_lag | value | stim_file |
| ----- | -------- | ------ | ---------- | --------- | ---------- | ----- | ------- | ----- | --------- |
| 0.004 | n/a | 1.0 | setup_right_sym | n/a | n/a | n/a | n/a | 3 | n/a |
| 24.2098	| n/a | 6052 | show_face | unfamiliar_face | first_show | 1 | n/a | 13 | u032.bmp |
| 25.0353 | n/a | 6259 | show_circle | n/a | n/a | 1 | n/a | 0 | circle.bmp |
| 25.158 | n/a | 6290 | left_press | n/a | n/a | 1 | n/a | 256 | n/a |
````

Each of the columns in this table provides information about the event marker
corresponding to that row.
The annotation process involves assigning HED tags to the values in the
various columns.

Notice that some columns such as `event_type` have a relatively small number of distinct values.
We refer to these columns as "categorical" columns because the columns
provide categorical information about the event.
Other columns such as `trial` or `stim_file` have many distinct values.
For these "value" columns, we use annotation to describe the general
characteristics that the values in such a column share.


The single most important tag in the
The goal is to construct a single `events.json` file located in the root directory
of your dataset, with all the annotations needed for users to understand and
analyze your data.