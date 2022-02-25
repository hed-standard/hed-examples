# HED introduction

HED (an acronym for Hierarchical Event Descriptors) is an evolving framework and
structured vocabulary for annotating data,
particularly data events to enable data search, extraction, and analysis.
Specifically, the goal of HED is to allow researchers to annotate what happened
during an experiment, including experimental stimuli and other sensory events,
participant responses and actions, experimental design, the role of events in
the task, and the temporal structure of the experiment.

The resulting annotation is **machine-actionable**, meaning that it can be 
used as input to algorithms without manual intervention.
HED facilitates detailed comparisons of data across studies
and promotes accurate interpretation of what happened as an experiment unfolds.

## Brief history of HED
HED was originally proposed by Nima Bigdely-Shamlo in 2010 to support annotation in
[HeadIT](https://headit.ucsd.edu) and early public repository for EEG data hosted by the 
Swartz Center for Computational Neuroscience, UCSD (Bigdely-Shamlo et al. 2013).
HED has undergone several revisions and substantial infrastructure development since that time.

The [BIDS (Brain Imaging Data Structure)](https://bids.neuroimaging.io/) standards
group incorporated HED as annotation mechanism in 2019.
In 2019, work also began on a rethinking of the HED vocabulary design,
resulting in the release of the third generation of HED in August 2021,
representing a dramatic increase in annotation capacity and a significant
simplification of the user experience.

````{admonition} **New in HED (versions 8.0.0+) released August 2021.**
:class: tip

1. Improved vocabulary structure
2. Short-form annotation
3. Library schema
4. Definitions
5. Temporal scope
6. Encoding of experimental design

````
See the [HED Specification](https://hed-specification.readthedocs.io/en/latest/)
and the [HED Documentation Summary](HedDocumentationSummary.md) for additional details.

## Goals of HED

Event annotation documents the things happening during data recording regardless of relevance
to data analysis and interpretation. Commonly recorded events in electrophysiological data
collection include the initiation, termination, or other features of **sensory presentations** 
and **participant actions**. Other events may be **unplanned environmental events** 
(for example, sudden onset of noise and vibration from construction work unrelated to the 
experiment, or a laboratory device malfunction), events recording **changes in experiment
control** parameters as well as **data feature events** and control **mishap events** that
cause operation to fall outside of normal experiment parameters. The goals of HED are to 
provide a standardized annotation and supporting infrastructure.

````{admonition} **Goals of HED.**
:class: tip

1. **Document the exact nature of events** (sensory, behavioral, environmental, and other) that occur during recorded time series data in order to inform data analysis and interpretation.
2. **Describe the design of the experiment** including participant task(s).
3. **Relate event occurrences** both to the experiment design and to participant tasks and experience.
4. **Provide basic infrastructure** for building and using machine-actionable tools to systematically analyze data associated with recorded events in and across data sets, studies, paradigms, and modalities.
````

Current systems in neuroimaging experiments do not record events beyond simple numerical (3)
or text (Event type Target) labels whose more complete and precise meanings are known
only to the experimenter(s). 

A central goal of HED is to enable building of archives of brain imaging data in a
amenable to large scale analysis, both within and across studies.
Such event-related analysis requires that the nature(s) of the recorded events
be specified in a common language.

The HED project seeks to formalize the development of this language,
to develop and distribute tools that maximize its ease of use,
and to inform new and existing researchers of its purpose and value.

## HED annotation


Similarly, making validation and analysis code independent of the HEDschema (4) allows redesign of the 
schema without having to re-implement the annotation tools. A well-specified and stable API 
(application program interface) empowers tool developers.


| **column_name** | **column_value** | **description** | **HED** |
| --------------- | ---------------- | --------------- | ------- |
| event_type | setup_right_sym | Description for <br>setup_right_sym | Label/setup_right_sym |
| event_type | show_face_initial | Description for show_face_initial | Label/show_face_initial |
| event_type | left_press | Description for left_press | Label/left_press |
| event_type | show_circle | Description for show_circle | Label/show_circle |
| . . . |   |   |  |
| stim_file | n/a | Description for stim_file | Label/# |


This tutorial provides a step-by-step guide to creating a JSON sidecar
template file from one of your BIDS `events.tsv` files.
You can then edit this JSON file directly using a text editor
to put in descriptions and HED annotations of your events.
Alternatively you can convert the JSON file to a spreadsheet for easier editing
and then convert back afterwards.

Finally, there is a standalone GUI tool called CTagger,
which provides user-friendly assistance.
See [] that you can fill in with takes you through the steps of annotating
the events in your BIDS dataset using HED (Hierarchical Event Descriptors)
and the online tools available at
[hedtools.ucsd.edu/hed](https://hedtools.ucsd.edu/hed).

The goal is to construct a single `events.json` sidecar file located in 
the root directory of your dataset with all the annotations needed for
users to understand and analyze your data.

| **column_name** | **column_value** | **description** | **HED** |
| --------------- | ---------------- | --------------- | ------- |
| event_type | setup_right_sym | Description xfor <br>setup_right_sym | Label/setup_right_sym |
| event_type | show_face_initial | Description for show_face_initial | Label/show_face_initial |
| event_type | double_press | Description for double_press | Label/double_press |
| event_type | left_press | Description for left_press | Label/left_press |
| event_type | right_press | Description for right_press | Label/right_press |
| event_type | show_face | Description for show_face | Label/show_face |
| event_type | show_circle | Description for show_circle | Label/show_circle |
| event_type | show_cross | Description for show_cross | Label/show_cross |
| face_type | unfamiliar_face | Description for unfamiliar_face | Label/unfamiliar_face |
| face_type | famous_face | Description for famous_face | Label/famous_face |
| face_type | scrambled_face | Description for scrambled_face | Label/scrambled_face |
| rep_status | delayed_repeat | Description for delayed_repeat | Label/delayed_repeat |
| rep_status | immediate_repeat | Description for immediate_repeat | Label/immediate_repeat |
| rep_status | first_show | Description for first_show | Label/first_show |
| trial | n/a | Description for trial | Label/# |
| rep_lag | n/a | Description for rep_lag | Label/# |
| value | n/a | Description for value | Label/# |
| stim_file | n/a | Description for stim_file | Label/# |


Another alternative to direct editing of the JSON file is the standalone GUI application, 
CTagger, which provides user-friendly assistance in tagging.
See [**HED tagging with CTagger**](TaggingWithCTagger.md) for a step-by-step guide.

Annotation is usually an iterative process.
Once you have done the initial annotation, you can improve it by editing the sidecar.

**Remember** The goal is to produce a single JSON file with annotations
to describe your events. In a few cases, you will need to provide additional
sidecars to annotate events specific to a particular event file.
However, for most datasets only one top-level JSON file is required.

**Caveat** The template generated from the online tools is based on the values
and columns in a single `_events.tsv` file.
If the file you selected is not representative, you may need to manually add additional
keys to your sidecar.

The HED [**Jupyter notebooks**](HedInPython.md) provide
examples of using the HEDTools directly to create a template using information from all
the event files in the dataset.

This tutorial takes you through the steps of creating a JSON sidecar template.
The next step is to actually do the annotation.
The [**Basic HED Annotation](BasicHedAnnotation.md) provides a short
guide for fast and easy annotation.
