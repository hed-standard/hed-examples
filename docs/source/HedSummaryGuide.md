(hed-summary-guide-anchor)=
# HED summary guide

The HED [**HED remodeling tools**](https://www.hed-resources.org/en/latest/HedRemodelingTools.html) provide a number of event summaries
and event file transformations that are very useful during curation and analysis.

The summaries described in this guide are:

* [**Column value summary**](column-value-summary-anchor)
* [**HED tag summary**](hed-tag-summary-anchor)
* [**Experimental design summary**](experimental-design-summary-anchor)

As described in more detail in the [**HED remodeling quickstart**](https://www.hed-resources.org/en/latest/HedRemodelingQuickstart.html) tutorial and the
[**HED remodeling tools**](https://www.hed-resources.org/en/latest/HedRemodelingTools.html)
user manual, these tools have as input, a JSON file with a list of remodeling commands and
an event file. Summaries involving HED also require a HED schema version and possibly a
JSON sidecar containing HED annotations.

The summary tools produce text and/or JSON summaries of the tabular files (usually event files).
Summaries accumulate the results for each tabular file that is input.
When the results are output, the summary tools produce an overall summary of all input
files that have been processed and, if requested, also include an individual summary
for each input file.

The examples in this tutorial use the Wakeman-Hanson Face Processing dataset as an example.
A [**reduced version**](https://github.com/hed-standard/hed-examples/tree/main/datasets/eeg_ds003645s_hed) 
containing 2 subjects and no imaging data is used to produce the summaries in the examples.
The reduced dataset has 6 event files each containing 200 events.
The full dataset is available on OpenNeuro as [**ds003645**](https://openneuro.org/datasets/ds003645/versions/2.0.0).

Each example only shows the overall summary with links to the full summaries that
include individual summaries. The summaries use a **[number events, number files]**
display of the counts of how many events and files an item appears in.

(column-value-summary-anchor)=
## Column value summary

The `summarize_column_value` operation produces a summary of three types of columns:

- **categorical column**: the summary counts the number of events (rows) and files for each unique column value. 


- **value column**: the summary counts the number of files containing the column and 
total number of rows in the column.


- **skip columns**: are ignored.

The categorical column information is useful for spotting inconsistencies and unexpected values. For example, if a trial consists of **stimulus-->key-press-->feedback** and
there are fewer key-press events in a file than stimulus or feedback events,
you can conclude that either the participant failed to respond in some trials or
the responses were not properly recorded.

The value column information in the current release of the remodeling tools is limited.
However, if a value column file count is different from the number of event files
in the dataset, you can conclude that some event files are missing that column or 
have that column multiple times.
More extensive information reporting for value columns is planned for future releases.

A sample JSON remodeling file with the command for creating a column value summary 
is shown in the following example. The remodeling file specifies how columns are treated.
Columns that are not listed as *skip_columns* or *value_columns* are assumed to be
categorical columns.

````{admonition} Example JSON remodeling file for a column value summary.
:class: tip

```json
[{
   "operation": "summarize_column_values",
   "description": "Summarize the column values in an excerpt.",
   "parameters": {
       "summary_name": "column_values_summary",
       "summary_filename": "column_values_summary",
       "skip_columns": ["onset", "duration"],
       "value_columns": ["stim_file", "trial"]
   }
}] 
```
````


The following excerpt shows the dataset portion of the resulting summary in text format:

````{admonition} Text format excerpt with dataset-level summary of column values.
```text
Context name: column values summary
Context type: column_values
Context filename: column_values_summary

Overall summary:
Dataset: Total events=1200 Total files=6
   Categorical column values[Events, Files]:
      event_type:
         double_press[1, 1] left_press[83, 4] right_press[168, 6] setup_right_sym[6, 6] show_circle[316, 6] show_cross[310, 6] show_face[310, 6] show_face_initial[6, 6]
      face_type:
         famous_face[108, 6] n/a[884, 6] scrambled_face[103, 6] unfamiliar_face[105, 6]
      rep_lag:
         1[77, 6] 10[15, 6] 11[13, 5] 12[9, 5] 13[7, 6] 14[6, 4] 15[2, 2] 6[1, 1] 7[2, 2] 8[6, 4] 9[10, 6] n/a[1052, 6]
      rep_status:
         delayed_repeat[71, 6] first_show[168, 6] immediate_repeat[77, 6] n/a[884, 6]
   Value columns[Events, Files]:
      stim_file[1200, 6]
      trial[1200, 6]
```
````

Notice that there is one *double_press* event in the *event_type* column of one of the 
six event files analyzed in this summary.
To narrow down which file this *double_press* event occurred in,
we could look at the 
[**full text summary**](./_static/data/summaries/FacePerception_column_values_summary.txt),
which includes individual summaries for each event file.

We also observe that three values *famous_face*, *unfamiliar_face* and *scrambled_face*
appear roughly the same number of times in the *face_type* across the six dataset.
The large number of *n/a* values in *face_type* is because the type of face is only
specified for the stimulus events:

> 108 (*famous_face*) + 103 (*scrambled_face*) + 105 (*unfamiliar_face*) =  
>  &nbsp; &nbsp; &nbsp; &nbsp; 310 (*show_face*) + 6 (*show_face_initial*)

As expected, the *show_face_initial* appears exactly once in each file (e.g., [6 events, 6 files]) since it is a setup-event.

(hed-tag-summary-anchor)=
## HED tag summary

The HED tag summary gives an overall picture of the types of HED tags in the
dataset along with counts and the number of files that these tags appear in.
An advantage that HED tag summaries have over straight column value summaries
is that the tags are comparable across experiments, 
while column values are experiment-specific.

The *tags* dictionary specifies how the results should be reported.
In the following remodeling file for generating a HED tag summary,
the tag counts will be grouped under the titles: "Sensory events",
"Agent actions" and "Items".
Tags that don't fit in these three categories will be grouped under "Other tags".


````{admonition} Example JSON remodeling file for a HED tag summary.
:class: tip
```json
[{
   "operation": "summarize_hed_tags",
   "description": "Summarize the HED tags in the dataset.",
   "parameters": {
       "summary_name": "hed_tag_summary",
       "summary_filename": "hed_tag_summary",
       "tags": {
           "Sensory events": ["Sensory-event", "Sensory-presentation",
                              "Task-stimulus-role", "Experimental-stimulus"],
           "Agent actions": ["Agent-action", "Agent", "Action", "Agent-task-role",
                             "Task-action-type", "Participant-response"],
           "Objects": ["Item"]
         },
       "expand_context": false
     }
}]

```
````


The following excerpt shows the dataset portion of the resulting summary in text format
when running on the [**reduced version**](https://github.com/hed-standard/hed-examples/tree/main/datasets/eeg_ds003645s_hed) face processing
dataset, which has 6 event files containing a total of 1200 events.

````{admonition} Text format excerpt with dataset-level summary of hed tag counts
```text
Context name: summarize_hed_tags
Context type: hed_tag_summary
Context filename: hed_tag_summary

Dataset
    Main tags[events,files]:
        Sensory events:
            Sensory-event[942,6] Cue[626,6] Experimental-stimulus[316,6]
        Agent actions:
            Agent-action[252,6] Press[1,1] Indeterminate-action[1,1] Participant-response[251,6]
        Objects:
            Image[942,6] Face[148,6] Keyboard-key[1,1]
    Other tags[events,files]:
        Experiment-structure[6,6] Def[1199,6] Onset[948,6] Experimental-trial[1194,6] 
        Pathname[942,6] Intended-effect[626,6] Offset[936,6] Item-interval[148,6]

```
````

The summary indicates that the event type breakdown:

> 942 sensory events + 252 agent actions + 6 experiment structure events = 1200 events

Further, there were 626 cues and 316 experimental stimuli among the sensory events.


(experimental-design-summary-anchor)=
## Experimental design summary

The HED type summary allows users to obtain a detailed summary of a particular tag.
Usually type summaries are used for *Condition-variable* tag, which encodes experimental
conditions and design.
The [**HED conditions and design matrices**](./HedConditionsAndDesignMatrices.md)
tutorial explains how this information is encoded and can be used.

Type summaries based on the *Task* tag and *Time-block* tag are also informative.


````{admonition} Example JSON remodeling file for a HED type summary based on *Condition-variable*.
:class: tip
```json
[{
   "operation": "summarize_hed_type",
   "description": "Summarize the condition variable tags in the dataset.",
   "parameters": {
       "summary_name": "wh_condition_variables",
       "summary_filename": "wh_condition_variables",
       "type_tag": "condition-variable"
     }
}]

```
````

The HED type summaries automatically expand the event-context, so that an event that has an *Onset*
tag will affect all intermediate events until its *Offset*.

The result of applying the above operation to the sample data is:

````{admonition} Text format excerpt with dataset-level summary of hed type (condition-variable) counts.
```text
Dataset: 3 condition-variable types in 6 files with a total of 1200
   key-assignment: 1 levels in 1200 events out of 1200 total events in 6 files
      right-sym-cond [1200 events, 6 files]:
         Tags: ['Index-finger', 'Right-side-of', 'Experiment-participant', 'Behavioral-evidence',
                'Symmetrical', 'Index-finger', 'Left-side-of', 'Experiment-participant', 
                'Behavioral-evidence', 'Asymmetrical']
         Description: Right index finger key press indicates a face with above average symmetry.
   face-type: 3 levels in 316 events out of 1200 total events in 6 files
      unfamiliar-face-cond [105 events, 6 files]:
         Tags: ['Image', 'Face', 'Unfamiliar']
         Description: A face that should not be recognized by the participants.
      famous-face-cond [108 events, 6 files]:
         Tags: ['Image', 'Face', 'Famous']
         Description: A face that should be recognized by the participants
      scrambled-face-cond [103 events, 6 files]:
         Tags: ['Image', 'Face', 'Disordered']
         Description: A scrambled face image generated by taking face 2D FFT.
   repetition-type: 3 levels in 316 events out of 1200 total events in 6 files
      first-show-cond [168 events, 6 files]:
         Tags: ['Item-count', 'Face', 'Item-interval']
         Description: Factor level indicating the first display of this face.
      immediate-repeat-cond [77 events, 6 files]:
         Tags: ['Item-count', 'Face', 'Item-interval']
         Description: Factor level indicating this face was the same as previous one.
      delayed-repeat-cond [71 events, 6 files]:
         Tags: ['Item-count', 'Face', 'Item-interval', 'Greater-than-or-equal-to', 'Item-interval']
         Description: Factor level indicating face was seen 5 to 15 trials ago.


```
````

This summary has three condition variables: *key-assignment*, *face-type* and *repetition-type*.
The *face-type* and *repetition-type* each have three levels encoding a 3 x 3 experimental design.
The *face-type* condition variable has three levels with roughly equal numbers of occurrences
(*famous-face-cond* with 108 events, *scrambled-face-cond* with 103 events, and
*unfamiliar-face-cond* with 105 events).

This information is similar to that obtained in the 
[**column value summary**](column-value-summary-anchor),
but only because these condition variables were directly encoded by columns `face_type` and
`repetition_type` in the events files.
The HED approach allows a more general, dataset-independent extraction of design matrices
and experimental conditions.

The final condition variable *key-assignment* only has one level and appears in all events in all the files. 
In reality the key assignment is designated in a single event in each file, but it appears
with an *Onset* and no *Offset*, indicating that it runs until the end of the file.
The *key-assignment* condition actually has two levels: *right-sym-cond* and *left-sym-cond*,
but this condition is counter-balanced across subjects rather than trials.
The two subjects in the sample data both were assigned the *right-sym-cond*.