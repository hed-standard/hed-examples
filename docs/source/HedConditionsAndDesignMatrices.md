# HED conditions and design matrices

This tutorial discusses how information from neuroimaging experiments should be
stored and annotated so that the underlying experimental design and experimental conditions
for a dataset can be automatically extracted, summarized, and used in analysis.
The mechanisms for doing this use HED (Hierarchical Event Descriptors) in conjunction
with a [BIDS](https://bids.neuroimaging.io/)
(Brain Imaging Data Structure) representation of the dataset.

The tutorial assumes that you have a basic understanding of HED and
how HED annotations are used in BIDS.
Please review [**Annotating a BIDS dataset**](https://bids.neuroimaging.io/getting_started/tutorials/annotation.html), 
the [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html), and the
[**HED annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/HedAnnotationQuickstart.html)
tutorials as needed.

The [**Experimental design concepts**](experimental-design-concepts-anchor)
section at the end of this tutorial provides a basic introduction to the ideas
of factor vectors and experimental design if you are unfamiliar with these topics.

* [**HED annotations for conditions**](hed-annotations-for-conditions-anchor)
  * [**Direct condition variables**](direct-condition-variables-anchor)
  * [**Defined condition variables**](defined-condition-variables-anchor)
  * [**Direct vs defined approaches**](direct-vs-defined-approaches-anchor)
  * [**Column vs row annotations**](column-vs-row-annotations-anchor)
* [**Experimental design concepts**](experimental-design-concepts-anchor)
  * [**Design matrices and factor variables**](design-matrices-and-factor-variables-anchor) 
  * [**Types of condition encoding**](types-of-condition-encoding-anchor)

This tutorial introduces tools and strategies for encoding information
about the experimental design as part of a dataset metadata
without excessive effort on the part of the researcher.
The discussion mainly focuses on categorical variables.

(hed-annotations-for-conditions-anchor)=
## HED annotations for conditions

As mentioned above, HED (Hierarchical Event Descriptors) provide several mechanisms for easily
annotating the experimental conditions represented by a BIDS dataset so that
the information can be automatically extracted, summarized, and used by tools.

HED has three ways of annotating experimental conditions: condition variables without definitions,
condition variables with definitions but no levels, and condition variables with levels.
All three mechanisms use the *Condition-variable* tag as part of the annotation.
The three mechanisms can be used in any combination to document the experimental design
for a dataset.

(direct-condition-variables-anchor)=
### Direct condition variables

The simplest way to encode experimental conditions is to use named *Condition-variable*
tags for each condition value. The following is a sample excerpt from
a simplified event file for an experiment to distinguish brain responses
for houses and faces. 

(sample-house-face-example-anchor)=
````{admonition} Example 1. Excerpt from a sample event file from a simplified house-face experiment.
| onset | duration | event_type | stim_file |
| ----- | -------- |----------- | ---------- |
| 2.010 |  0.1     | show_house  | ranch1.png |
| 3.210 |  0.1     | show_house  | colonial68.png |   
| 4.630 |  0.1     | show_face   | female43.png | 
| 6.012 |  0.1     | show_house  | castle2.png | 
| 7.440 |  0.1     | show_face  | male81.png  |   
````

As explained in [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html), 
the most commonly used strategy for annotating events in a BIDS dataset is
to create a single JSON file located in the dataset root containing the annotations
for the columns. The following shows a minimal example:

````{admonition} Example 2: Minimal JSON sidecar with HED annotations for Example 1.
:class: tip

```json
{
   "event_type": {
      "HED": {
         "show_house": "Sensory-presentation, Visual-presentation, Experimental-stimulus, (Image, Building/House), Condition-variable/House-cond",
         "show_face": "Sensory-presentation, Visual-presentation, Experimental-stimulus, (Image, Face), Condition-variable/Face-cond"
      }
   },
   "stim_file": {
      "HED": "(Image, Pathname/#)"
   }
}
```
````

Each row in an `events.tsv` file represents a time marker in the corresponding data recording.
At analysis time, HED tools look up each `events.tsv` column value in the JSON file and concatenate the
corresponding HED annotation into a single string representing the annotation for that row.
Annotations without #'s are used directly, while annotations with # have the corresponding
column values substituted when the annotation is assembled. 

Example 3 shows the HED annotation for the first row in the `events.tsv` file of Example 1.

````{admonition} Example 3: HED annotation for first event in Example 1 using JSON sidecar of Example 2.
:class: tip

> "*Sensory-presentation*, *Visual-presentation*, *Experimental-stimulus*,  
> (*Image*, *Building/House*), *Condition-variable/House-cond*,  
> (*Image*, *Pathname/ranch1.png*)"
````

Notice that *Building/House* is a partial path rather than a single tag.
This is because *House* is currently not part of the base HED vocabulary.
However, users are allowed to extend tags at most nodes in the HED schema,
but they must use a path that includes at least one ancestor in the HED schema.

HED tools have the capability of automatically detecting *Condition-variable*
tags in annotated HED datasets to create factor vectors and summaries automatically.
Example 4 shows the event file after HED tools have appended one-hot factor vectors
for the two condition variables *Condition-variable/House-cond* and
*Condition-variable/Face-cond*. 
The 1's and 0's *house_cond* and *face-cond* columns indicate presence or absence
of the corresponding condition variables.


````{admonition} Example 4. Event file from Example 2 after one-hot factor vector extraction.

| onset | duration | event_type | stim_file | house-cond | face-cond |
| ----- | -------- |----------- |-------- | ---------- |----------- |
| 2.010 |  0.1     | show_house      | ranch1.png |    1  |   0    |
| 3.210 |  0.1     | show_house      | colonial68.png |  1  |  0  | 
| 4.630 |  0.1     | show_face       | female43.png |  0   |  1 |
| 6.012 |  0.1     | show_house      | castle2.png |  1    |  0 |
| 7.440 |  0.1     | show_face       | male81.png  |  0    | 1 |
````

Example 5 shows a JSON summary that HED tools can extract from a single events file
once a dataset has been annotated using HED. 
This very simple example only had two condition variables
and only used direct references to these condition variables. 
Dataset-wide summaries can also be extracted.


````{admonition} Example 5: The HED tools summary of condition variables for Example 4.
:class: tip

```json
{
   "house-cond": {
      "name": "house-cond",
      "variable_type": "condition-variable",
      "levels": 0,
      "direct_references": 3,
      "total_events": 5,
      "number_type_events": 3,
      "number_multiple_events": 0,
      "multiple_event_maximum": 1,
      "level_counts": {}
   },
   "face-cond": {
      "name": "face-cond",
      "variable_type": "condition-variable",
      "levels": 0,
      "direct_references": 2,
      "total_events": 5,
      "number_type_events": 2,
      "number_multiple_events": 0,
      "multiple_event_maximum": 1,
      "level_counts": {}
   }
}
````
The summary shows that of the 5 events in the file: 3 events were under
the house condition and 2 events were under the face condition.
There were no events in multiple categories of the same condition variables
(which would not be possible since these condition variables were referenced
directly rather than using assigned levels).
All names are translated to lower case as HED is case-insensitive with respect to analysis,
and the summary and factorization tools convert to lower case before processing.

These HED summaries can be created for other tags besides *Condition-variable*,
hence the *variable_type* is given in the summary of Example 5.
Other commonly created summaries are for *Task* and *Control-variable*.

In this example, the two conditions: *house-cond* and *face-cond* are
treated as though they were unrelated. These direct condition variables
are very easy to annotate--- just make up a name and stick the tags anywhere
you want to create factor variables or summaries.
However, a more common situation is for a condition variable to have multiple levels,
which direct use condition variables does not support.

Another disadvantage of direct condition variables is that there is
no information about what the conditions represent beyond the arbitrarily chosen condition names.

A third disadvantage is that direct condition variables can not be used to
anchor events with temporal extent.

The next section introduces defined condition variables,
which address both of these disadvantages.

(defined-condition-variables-anchor)=
### Defined condition variables


````{admonition} Example 6: A revised JSON sidecar using defined conditions for Example 1.
:class: tip

```json
{
   "event_type": {
      "HED": {
         "show_house": "Sensory-presentation, Visual-presentation, Experimental-stimulus, (Image, Building/House), Def/House-cond",
         "show_face": "Sensory-presentation, Visual-presentation, Experimental-stimulus, (Image, Face), Def/Face-cond"
      }
   },
   "stim_file": {
      "HED": "(Image, Pathname/#)"
   },
   "my_definitions": {
      "HED": {
          "house_cond_def": "(Definition/House-cond, (Condition-variable/Presentation-type, (Image, Building/House)))",
          "face_cond_def": "(Definition/Face-cond, (Condition-variable/Presentation-type, (Image, Face)))"
}
```
````

Example 6 defines a condition variable called *Presentation-type* with two levels:
*House-cond* and *Face-cond*.
The definitions of *House-cond* and *Face-cond* both include the same *Presentation-type*
*Condition-variable* so tools recognize these as levels of the same variable and
automatically extract the 2-factor experimental design.

Notice that the (*Image*, *Building/House*) tags are included both in the definition of
the *House-cond* level of the *Presentation-type* condition variable
and in the tags for the *event_type* column value *show_house*.
Similarly, the (*Image*, *Face*) tags appear in both the definition of the
*Face-cond* level of the *Presentation-type* condition variable
and in the tags for the *event_type* column value *show_face*.
We have included these tags in both places because generally the condition variable definitions
are removed prior to searching for HED tags. The tags in the definitions
define the meaning of the conditions.

````{admonition} Example 7: The summary extracted when the JSON sidecar of Example 6 is used.
:class: tip

```json
{
   "presentation-type": {
      "name": "presentation-type",
      "variable_type": "condition-variable",
      "levels": 2,
      "direct_references": 0,
      "total_events": 5,
      "number_type_events": 5,
      "number_multiple_events": 0,
      "multiple_event_maximum": 1,
      "level_counts": {
         "house-cond": 3,
         "face-cond": 2
      }
  }
}
```
````

(direct-vs-defined-approaches-anchor)=
### Direct vs defined approaches

Table 1 compares the two approaches for encoding experimental conditions and design in HED.
Both approaches use the *Condition-variable* tag.
While direct condition variables (just using a *Condition-variable* tag without defining it)
is very easy, it provides limited information about meaning in downstream summaries.
In general defined condition variables, while more work, provide a more complete picture.

(direct-vs-defined-anchor)=
````{table} **Table 1:** Comparison of direct versus definition conditions.
| Approach | Advantages  | Disadvantages |
| -------- | ----------  | ------------- |
| **Direct**   | Easy to use--just a label.<br/>Can appear in summaries.<br/>Can generate factor vectors. | Give no information about meaning.<br/>No levels for condition variables.<br/>Limited information about experimental design.<br/>Do not support event temporal extent. |
| **Defined** | Better information in summaries.<br/>Encode condition variables with levels.<br/>Can give factor vectors for levels.<br/>Better experimental design information.</br>Can anchor events with temporal extent.| Must give definitions. |
````

It should be noted that other tags, particularly those in the HED `Structural-property` subtree such
as `Task` can be summarized and used as factor vectors in a way similar to *Condition-variable*.


(column-vs-row-annotations-anchor)=
### Column vs row annotations

In this section, we look at a more complicated example based on the Wakeman-Henson face-processing dataset. 
This dataset, which is available on [OpenNeuro](https://openneuro.org) under accession number
ds003645, was used in as a case study on HED annotation described in the 
[Capturing the nature of events paper](https://www.sciencedirect.com/science/article/pii/S1053811921010387).
The experiment is based on a 3 x 3 x 2 experimental design: face type x repetition status x key choice.

The experimental stimulus in each trial was the visual presentation of one of 3 possible types of images:
a well-known face, an unfamiliar face, and a scrambled face image. 
The type of face was randomized across trials.

The repetition status condition variable also had one of three possible values and indicated
whether the stimulus image had not been seen before (first show), 
was just seen in the previous trial (immediate repeat),
or had been last seen several trials ago (delayed repeat). 
The repetition status was randomized across trials.

The final condition variable in the experimental design was the key assignment.
In the right symmetry condition, participants pressed the right mouse button
to indicate that the presented face had above average symmetry, 
while in the left symmetry condition, participants pressed the left mouse button
to indicate that the presented face had above average symmetry.
The key assignment was held constant for each recording, but the key choice was 
counter-balanced across participants.

Example 8 shows an excerpt from the event file of sub-002 run-1.
(You may find it useful to look at the full event file [sub-002_task-FacePerception_run-1_events.tsv](./_static/data/sub-002_task-FacePerception_run-1_events.tsv) and the dataset's
JSON sidecar with full HED annotations:
[task-facePerception_events.json](./_static/data/task-FacePerception_events.json)

(sample-design-matrix-events-file-anchor)=
```{admonition} Example 8: An excerpt from the Wakeman-Henson face-processing dataset.

| onset | duration | event_type | face_type | rep_status | trial | rep_lag | value | stim_file |
| ----- | -------- | ---------- | --------- | ---------- | ----- | ------- | ----- | --------- |
| 0.004 | n/a | setup_right_sym | n/a | n/a | n/a | n/a | 3 | n/a |
| 24.2098 | n/a | show_face_initial | unfamiliar_face | first_show | 1 | n/a | 13 | u032.bmp |
| 25.0353 | n/a | show_circle | n/a | n/a | 1 | n/a | 0 | circle.bmp |
| 25.158 | n/a | left_press | n/a | n/a | 1 | n/a | 256 | n/a |
| 26.7353 | n/a | show_cross | n/a | n/a | 2 | n/a | 1 | cross.bmp |
| 27.2498 | n/a | show_face | unfamiliar_face | immediate_repeat | 2 | 1 | 14 | u032.bmp |
| 27.8971 | n/a | left_press | n/a | n/a | 2 | n/a | 256 | n/a |
| 28.0998 | n/a | show_circle | n/a | n/a | 2 | n/a | 0 | circle.bmp |
| 29.7998 | n/a | show_cross | n/a | n/a | 3 | n/a | 1 | cross.bmp |
| 30.3571 | n/a | show_face | unfamiliar_face | first_show | 3 | n/a | 13 | u088.bmp |
```

Example 8 illustrates two different ways of using defined conditions for encoding:
**inserting an event with temporal extent** or using **column encoding**.

The key assignment condition is marked by inserting an event with *event_type* equal to
*setup_right_sym* at the beginning of the file. 
As we shall see below, this event is annotated with having temporal extent,
as defined by HED *Onset* and *Offset* tags,
so the condition is in effect until the event's extent ends.

In the column strategy, an event file column represents the condition variable,
and the values in that column represent the levels.
With this encoding, the condition variable is only applicable at a particular
level when that level name appears in the column.
An n/a value in that column indicates the condition does not apply to that event.

Example 9 shows the portion of the
[**task-facePerception_events.json**](./_static/data/task-FacePerception_events.json)
that encodes information about the *setup_right_sym* event found as the first event
in the event file excerpt of Example 8.
This excerpt only contains the relevant definition and the relevant annotation.


````{admonition} Example 9: Excerpt of the JSON sidecar relevant to the *setup_right_sym* event.
:class: tip

```json
{
   "event_type": {
      "HED": {
         "setup_right_sym": "Experiment-structure, (Def/Right-sym-cond, Onset), (Def/Initialize-recording, Onset)"
      }
   },
   "hed_def_conds": {
      "HED": {
        "right_sym_cond_def": "(Definition/Right-sym-cond, (Condition-variable/Key-assignment, ((Index-finger, (Right-side-of, Experiment-participant)), (Behavioral-evidence, Symmetrical)), ((Index-finger, (Left-side-of, Experiment-participant)), (Behavioral-evidence, Asymmetrical)), Description/Right index finger key press indicates a face with above average symmetry.))"
      }
   }
}
```
````

Only the *event_type* column is relevant for assembling the annotations for the first row
of Example 8, since the other annotated columns have n/a values.
The assembled HED annotation for the first row of Example 8 is shown in Example 10.

````{admonition} Example 10: The HED annotation of the first row of Example 8.
:class: tip
> "*Experiment-structure*, 
> (*Def/Right-sym-cond*, *Onset*), 
> (*Def/Initialize-recording*, *Onset*)"

````

HED represents events of temporal extent using HED definitions with the *Onset* 
and *Offset* tags grouped with a user-defined term.
The (*Def/Right-sym-cond*, *Onset*) specifies that an event defined by
*Right-sym-cond* begins at the time-marker represented by this row in the event file.
This event continues until the end of the file or until an event marker with
(*Def/Right-sym-cond*, *Offset*) occurs.
In this case, no *Offset* marker for *Right-sym-cond* appears in the file,
so the event represented by *Right-sym-cond* occurs over the entire recording.

The user-defined term is prefixed with *Def/* and indicates what the event
of temporal extent represents.
If the definition includes a *Condition-variable*,
then the event represents the occurrence of that experimental condition.
The user-defined terms are usually defined in the `events.json` file
located at the top-level of the BIDS dataset.


Example 11 shows a more readable form for the definition of *Right-sym-cond*.

````{admonition} Example 11: The contents of the definition for *Right-sym-cond*.
:class: tip

```text
(  
   Definition/Right-sym-cond, (  
      Condition-variable/Key-assignment,   
      ((Index-finger, (Right-side-of, Experiment-participant)), (Behavioral-evidence, Symmetrical)),  
      ((Index-finger, (Left-side-of, Experiment-participant)), (Behavioral-evidence, Asymmetrical)),  
      Description/Right index finger key press indicates a face with above average symmetry.  
   )  
)
```
````
The primary use of the definitions for condition variables is to encode
the experimental design in an actionable format.
Thus, as a general practice, *Defs* representing condition variables are
removed prior to searching for other tags to avoid repeats.
Notice that both *Right-side-of* and *Left-side-of* appear in the definition.
Thus, if these *Defs* were included, every event would have both left and right tags.

Once a dataset includes the appropriate annotations,
HED tools can automatically extract the experimental design.
Example 12 shows the result of extraction of categorical factor vectors for
the event file of Example 8.

```{admonition} Example 12: HED tools categorical form extraction of the design matrix for Example 8.

| onset | key-assignment | face-type | repetition-type | 
| ----- | -------------- | --------- | --------------- |
| 0.004 | right-sym-cond | n/a | n/a |
| 24.2098 | right-sym-cond | unfamiliar-face-cond | first-show-cond |
| 25.0353 | right-sym-cond | n/a | n/a |
| 25.158 | right-sym-cond | n/a | n/a |
| 26.7353 | right-sym-cond | n/a | n/a | 
| 27.2498 | right-sym-cond | unfamiliar-face-cond | immediate-repeat-cond |
| 27.8971 | right-sym-cond | n/a | n/a |
| 28.0998 | right-sym-cond | n/a | n/a |
| 29.7998 | right-sym-cond | n/a | n/a | 
| 30.3571 | right-sym-cond | unfamiliar-face-cond | first-show-cond | 

````

In the categorical representation,
HED uses the condition variable name as the column name.
The level values appear in the columns for event markers at which 
the condition variable at that level applies.
Notice that *right-sym-cond* appears in every row because it was used in an event
that extended to the end of the file. 
On the other hand, the other condition variables were encoded using
columns and only appear when present in the column.

Note that if an event has multiple levels of the same condition,
categorical and ordinal encoding cannot be used.
Only one-hot encoding supports multiple levels in the same event.

Example 13 below shows the condition variable summary that HED produces for the
full [sub-002_task-FacePerception_run-1_events.tsv](./_static/data/sub-002_task-FacePerception_run-1_events.tsv) 
and JSON sidecar 
[task-facePerception_events.json](./_static/data/task-FacePerception_events.json).

````{admonition} Example 13: The condition variable summary extracted from the full event file.
:class: tip

```json
{
   "key-assignment": {
      "name": "key-assignment",
      "variable_type": "condition-variable",
      "levels": 1,
      "direct_references": 0,
      "total_events": 552,
      "number_type_events": 552,
      "number_multiple_events": 0,
      "multiple_event_maximum": 1,
      "level_counts": {
         "right-sym-cond": 552
      }
   },
   "face-type": {
      "name": "face-type",
      "variable_type": "condition-variable",
      "levels": 3,
      "direct_references": 0,
      "total_events": 552,
      "number_type_events": 146,
      "number_multiple_events": 0,
      "multiple_event_maximum": 1,
      "level_counts": {
         "unfamiliar-face-cond": 47,
         "famous-face-cond": 49,
         "scrambled-face-cond": 50
      }
   },
   "repetition-type": {
      "name": "repetition-type",
      "variable_type": "condition-variable",
      "levels": 3,
      "direct_references": 0,
      "total_events": 552,
      "number_type_events": 146,
      "number_multiple_events": 0,
      "multiple_event_maximum": 1,
      "level_counts": {
         "first-show-cond": 75,
         "immediate-repeat-cond": 36,
         "delayed-repeat-cond": 35
      }
    }
}
```
````

The file has 552 events.
Since the *key-assignment* condition variable with level *right-sym-cond*
applies to every event in this file, the *number_type_events* is also 552.
On the other hand, the *face-type* condition variable is only applicable in 146 events.

All the condition variables have *number_multiple_events* equal to 0,
so any of the three possible encodings: categorical, ordinal, or one-hot can be used.


(experimental-design-concepts-anchor)=
## Experimental design concepts

Traditional neuroimaging experiments are carefully designed to control and
document the external conditions under which the experiment is conducted.
Often an experiment varies a few items such as the task or the properties of a stimulus 
as the stimulus is presented and participant responses
are recorded. 

For example, in an experiment to test for differences in 
brain responses to pictures of houses versus pictures of faces,
the researcher would label time points in the recording corresponding
to presentations of the respective pictures so that differences in
brain responses between the two types of pictures could be observed.
An fMRI analysis might determine which brain regions
showed a significant response differential between the two types of responses.
An EEG/MEG analysis might also focus on the differences in time courses
between the responses to the two types of images. 

Thus, the starting point for many analyses is the association of
labels corresponding to different **experimental conditions** with
time points in the data recording.
In BIDS, this association is stored an `events.tsv` file paired
with the data recording,
but this information may also be stored as part of the recording
itself, depending on the technology and the format of the recording.

(design-matrices-and-factor-variables-anchor)=
### Design matrices and factor variables

The type of information included for the experimental conditions
and how this information is stored depends very much on the experiment.
Most analysis tools require a vector (sometimes called a **factor vector**)
of elements associated with the event markers for each type of experimental condition. 

For linear modeling and other types of regression, these factor vectors are assembled
into **design matrix** to use as input for the analysis.
Design matrices can also include other types of columns depending on the modeling strategy.

(types-of-condition-encoding-anchor)=
### Types of condition encoding

Consider the simple example introduced above of an experiment which 
varies the stimuli between pictures of houses and faces to measure
differences in response.
The following example shows three possible types of encodings
(**categorical**, **ordinal**, and **one-hot**) that might be used
for this association. The table shows an excerpt from a putative events file,
with the onset column (required by BIDS) containing the time of the event marker
relative to the start of the associated data recording.
The duration column (also required by BIDS) contains the duration of the
image presentation in seconds.

(different-encodings-of-design-variables-anchor)=
````{admonition} Example 14: Illustration of categorical and one-hot encoding of categorical variables.
| onset | duration | categorical | ordinal | one_hot.house | one_hot.face |
| ----- | -------- |----------- |-------- | ------------- | ------------ |
| 2.010 |  0.1     | house      |     1   |      1        |     0        | 
| 3.210 |  0.1     | house      |     1   |      1        |     0        |  
| 4.630 |  0.1     | face       |     2   |      0        |     1        |  
| 6.012 |  0.1     | house      |     1   |      1        |     0        |  
| 7.440 |  0.1     | face       |     2   |      0        |     1        |  
````

The **categorical** encoding assigns laboratory-specific names to the
different types of stimuli.
In theory, this categorical column consisting of the strings *house* and *face*
could be used as a factor vector or as part of a design matrix for regression.
However, many analysis tools require that these names be assigned numerical
values.

The **ordinal** encoding assigns an arbitrary sequence of numbers corresponding
to the unique values.
If there are only 2 values, the values -1 and 1 are often used.
Ordinal encodings impose an order based on the values
chosen, which may have undesirable affects on the results of analyses such
as regression if the ordering/relative sizes do not reflect the 
properties of the encoded experimental conditions.

In Example 14, the experimental conditions houses and faces do not
have an ordering/size relationship reflected by the encoding (house=1, face=2).
In addition, neither categorical nor ordinal encoding
can represent items falling into multiple categories of the same condition at the same time.
For these reasons, many statistical tools require one-hot encoding.

In **one-hot** encoding, each possible value of the condition is represented
by its own column with 1's representing the presence of that condition value
and experimental conditions and 0's otherwise. One-hot encodes all values
without bias and allows for a given event to be a member of multiple categories.
This representation is required for many machine-learning models.
A disadvantage is that it can generate a large number of columns if there
are many unique categorical values. It can also cause a problem if not all
files contain the same values, as then different files may have different columns.
