# HED summaries

The HED [**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html) provide a number of event summaries
and event file transformations that are very useful during curation and analysis.

As described in more detail in the [**File remodeling quickstart**](https://www.hed-resources.org/en/latest/FileRemodelingQuickstart.html) tutorial and the
[**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html)
user manual, these tools have as input, JSON file with a list of remodeling commands and
an event file.

The summary tools produce text and/or JSON summaries of the tabular files (usually event files).
Summaries accumulate the results for each tabular file that is input.
When the results are output, the summary tools produce an overall summary of all input
files that have been processed and, if requested, also include an individual summary
for each input file.

## Useful summaries
The examples in this section use the Wakeman-Hanson Face Processing dataset as an example.
A [**reduced version**](https://github.com/hed-standard/hed-examples/tree/main/datasets/eeg_ds003654s_hed) 
containing 2 subjects and no imaging data is used to produce the summaries in the examples.
The reduced dataset has 6 event files each containing 200 events.
The full dataset is available on OpenNeuro as [**ds003654**](https://openneuro.org/datasets/ds003645/versions/2.0.0).

Each example only shows the overall summary with links to the full summaries that
include individual summaries. The summaries use a **[number events, number files]**
display of the counts of how many events and files an item appears in.

### Summarizing event file values

The JSON remodeling file:

````{admonition} Example JSON remodeling file.
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
The result of running this summary operation on the sample data is:

````{admonition} Text format dataset-level summary of column values.
```text
Context name: column_values_summary
Context type: column_values
Context filename: column_values_summary

Dataset: Total events=1200 Total files=6
   Categorical column values[Events, Files]:
      event_type:
         double_press[1, 1] left_press[83, 4] right_press[168, 6] setup_right_sym[6, 6] 
         show_circle[316, 6] show_cross[310, 6] show_face[310, 6] show_face_initial[6, 6]
      face_type:
         famous_face[108, 6] n/a[884, 6] scrambled_face[103, 6] unfamiliar_face[105, 6]
      rep_lag:
         1[77, 6] 10[15, 6] 11[13, 5] 12[9, 5] 13[7, 6] 14[6, 4] 15[2, 2] 6[1, 1] 7[2, 2] 
         8[6, 4] 9[10, 6] n/a[1052, 6]
      rep_status:
         delayed_repeat[71, 6] first_show[168, 6] immediate_repeat[77, 6] n/a[884, 6]
      value:
         0[316, 6] 1[310, 6] 13[56, 6] 14[24, 6] 15[25, 6] 17[54, 6] 18[32, 6] 19[17, 6]
         256[83, 4] 3[6, 6] 4096[168, 6] 4352[1, 1] 5[58, 6] 6[21, 6] 7[29, 6]
   Value columns[Events, Files]:
      stim_file[1200, 6]
      trial[1200, 6]
```
````



As more HED-annotated data becomes available on repositories such as
[**OpenNeuro.org**](https://openneuro.org) and [**NEMAR**](https://nemar.org/)
HED summaries will better integrated into the 

## A summary for a single file.
The HED [**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html)