# HED conditions and design matrices

This tutorial discusses how information from neuroimaging experiments should be
stored and annotated so that the underlying experimental design and experimental conditions
for a dataset can be automatically extracted, summarized, and used in analysis.
The mechanisms for doing this use HED (Hierarchical Event Descriptors) in conjunction
with a [BIDS](https://bids.neuroimaging.io/)
(Brain Imaging Data Structure) representation of the dataset.

The tutorial assumes that you have a basic understanding of HED and
how HED annotations are used in BIDS.
Please review [**Annotating a BIDS dataset**](https://bids-standard.github.io/bids-starter-kit/tutorials/annotation.html), 
the [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html), and the
[**HED annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/HedAnnotationQuickstart.html)
tutorials as needed.



* [**Neuroimaging experimental design**](neuroimaging-experimental-anchor)
  * [**Design matrices and factor variables**](design-matrices-and-factor-variables-anchor) 
  * [**Types of condition encoding**](types-of-condition-encoding-anchor)
* [**Installation of remodeling tools**](installation-of-remodeling-tools-anchor) Docs in process
* [**Running remodeling tools**](running-remodeling-tools-anchor) Docs in process
* [**Remodeling operations**](remodeling-operations-anchor) Docs in process
  * [**Add structure column**](add-structure-column-anchor) Docs in process
  * [**Add structure events**](add-structure-events-anchor) Docs in process

This tutorial introduces tools and strategies for including this information
as part of a dataset without excessive effort on the part of the researcher.
The discussion mainly focuses on categorical variables, but HED
also can encode numerical values as discussed later in the tutorial.

(neuroimaging-experimental-anchor)=
## Neuroimaging experimental design
Traditional neuroimaging experiments are carefully designed to control and
document the external conditions under which the experiment is conducted.
Often a few items such as the task or the properties of a stimulus are
systematically varied as the stimulus is presented and participant responses
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
(**categorical**, **ordinal**, and **one-hot**) that might be sued
for this association. The table shows an excerpt from a putative events file,
with the onset column (required by BIDS) containing the time of the event marker
relative to the start of the associated data recording.
The duration column (also required by BIDS) contains the duration of the
image presentation in seconds.

(different-encodings-of-design-variables-anchor)=
````{admonition} Example 1: Different encodings of a column with categorical values.
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

In the example above, the experimental conditions houses and faces do not
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

(hed-annotation-for-conditions-anchor)
## HED annotation for conditions

As mentioned above, HED (Hierarchical Event Descriptors) provide several mechanisms for easily
annotating the experimental conditions represented by a BIDS dataset so that
the information can be automatically extracted, summarized and used by tools.

HED has three ways of annotating experimental conditions: condition variables without definitions,
condition variables with definitions but no levels, and condition variables with levels.
All three mechanisms use the *Condition-variable* tag as part of the annotation.
The three mechanisms can be used in any combination to document the experimental design
for a dataset.

(condition-variables-without-definitions-anchor)=
### Condition variables without definitions

The simplest way to encode experimental conditions is to use named *Condition-variable*
tags for each condition value. The following is a sample excerpt from
a possible event file for the experiment to distinguish brain responses
for houses and faces. We assume that the participant has been 
instructed to push a button to indicate that he/she has identified
the image as a either a house or a face.

(sample-house-face-example-anchor)=
````{admonition} Example 2. Excerpt from a sample event file from house-face experiment.
| onset | duration | event_type | response_time | stim_file |
| ----- | -------- |----------- |-------- | ---------- |
| 2.010 |  0.1     | house      |   0.23  | ranch1.png |
| 3.210 |  0.1     | house      |   0.12  | colonial68.png |   
| 4.630 |  0.1     | face       |   0.41  | female43.png | 
| 6.012 |  0.1     | house      |   0.35  | castle2.png | 
| 7.440 |  0.1     | face       |   0.32  | male81.png  |   
````

As explained in [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html), 
the most commonly used strategy for annotating events in a BIDS dataset is
to create a single JSON file located in the dataset root containing the annotations
for the columns. The following shows a minimal example

````{admonition} Example 3: Minimal JSON sidecar with HED annotations for Example 1.
:class: tip

```json
{
  "event_type": {
    "HED": {
      "house": "Sensory-presentation, Visual-presentation, Experimental-stimulus, (Image, Building/House), Condition-variable/House-cond",
      "face": "Sensory-presentation, Visual-presentation, Experimental-stimulus, (Image, Face), Condition-variable/Face-cond"
    }
  },
  "response_time": {
    "HED": "(Participant-response, (Press, Push-button), Delay/#)"
  },
  "stim_file": {
    "HED": "(Image, Pathname/#)"
  }
}
```
````

Each row in an `events.tsv` file represents a time marker in the corresponding data recording.
At analysis time, HED tools look up each column value in the JSON file and concatenate the
corresponding HED annotation into a single string representing the annotation for that row.
Annotations without #'s are used directly, while annotations with # have the corresponding
column values substituted when the annotation is assembled. 

````{admonition} Example 3: HED annotation for first event in Example 1 using JSON sidecar of Example 2.
:class: tip
> "*Sensory-presentation*, *Visual-presentation*, *Experimental-stimulus*, 
> (*Image*, *Building/House*), *Condition-variable/House-cond*, 
> (*Participant-response*, (*Press*, *Push-button*), *Delay/0.23*),
> (*Image*, *Pathname/ranch1.png*)"
````

HED tools have the capability of automatically detecting *Condition-variable*
tags in annotated HED datasets and creating factor vectors and summaries automatically.
Example 4 shows the event file after HED tools have appended one-hot factor vectors.


````{admonition} Example 4. Example 2 after HED tools have extracted one-hot factor vectors.
| onset | duration | event_type | response_time | stim_file | House-cond | Face-cond |
| ----- | -------- |----------- |-------- | ---------- |----------- | ----------- |
| 2.010 |  0.1     | house      |   0.23  | ranch1.png |    1  |   0    |
| 3.210 |  0.1     | house      |   0.12  | colonial68.png |  1  |  0  | 
| 4.630 |  0.1     | face       |   0.41  | female43.png |  0   |  1 |
| 6.012 |  0.1     | house      |   0.35  | castle2.png |  1    |  0 |
| 7.440 |  0.1     | face       |   0.32  | male81.png  |  0    | 1 |
````

Example 5 shows the JSON summary that HED tools can extract once a dataset has been
annotated using HED. This very simple example only had two condition variables
and only used direct references to condition variables.
The summary shows that of the total of 5 events in the file 3 events were under
the house condition and 2 events were under the face condition.

````{admonition} Example 5: The HED tools summary of condition variables for Example 4.
:class: tip

```json
{
  "house-cond": {
    "name": "house-cond",
    "variable_type": "condition-variable",
    "levels": 0,
    "direct_references": 3,
    "total events": 5,
    "number events": 3,
      "number_multiple": 0,
      "multiple maximum": 1,
      "level counts": {}
  },
  "face-cond": {
    "name": "face-cond",
    "variable_type": "condition-variable",
    "levels": 0,
    "direct_references": 2,
    "total events": 5,
    "number events": 2,
      "number_multiple": 0,
      "multiple maximum": 1,
      "level counts": {}
  }
}
````
There were no events in multiple categories of the same condition variables
(which would not be possible since these condition variables were referenced
directly rather than assigned levels).
All names are translated to lower case as HED is case-insensitive with respect to analysis.

These HED summaries can be created for other tags besides *Condition-variable*,
hence the variable_type is given in the summary of Example 5.
Other commonly created summaries are for *Task* and *Control-variable*.


## Definitions
(sample-design-matrix-events-file-anchor)=
````{admonition} Excerpt from event file for a stop-go task.

| onset | duration | sample | event_type | face_type | rep_status | trial | rep_lag | value | stim_file |
| ----- | -------- | ------ | ---------- | --------- | ---------- | ----- | ------- | ----- | --------- |
| 0.004 | n/a | 1.0 | setup_right_sym | n/a | n/a | n/a | n/a | 3 | n/a |
| 24.2098181818 | n/a | 6052.4545 | show_face_initial | unfamiliar_face | first_show | 1 | n/a | 13 | u032.bmp |
| 25.0352727273 | n/a | 6258.8182 | show_circle | n/a | n/a | 1 | n/a | 0 | circle.bmp |
| 25.158 | n/a | 6289.5 | left_press | n/a | n/a | 1 | n/a | 256 | n/a |
| 26.7352727273 | n/a | 6683.8182 | show_cross | n/a | n/a | 2 | n/a | 1 | cross.bmp |
| 27.2498181818 | n/a | 6812.4545 | show_face | unfamiliar_face | immediate_repeat | 2 | 1 | 14 | u032.bmp |
| 27.8970909091 | n/a | 6974.2727 | left_press | n/a | n/a | 2 | n/a | 256 | n/a |
| 28.0998181818 | n/a | 7024.9545 | show_circle | n/a | n/a | 2 | n/a | 0 | circle.bmp |
| 29.7998181818 | n/a | 7449.9545 | show_cross | n/a | n/a | 3 | n/a | 1 | cross.bmp |
| 30.3570909091 | n/a | 7589.2727 | show_face | unfamiliar_face | first_show | 3 | n/a | 13 | u088.bmp |
````



