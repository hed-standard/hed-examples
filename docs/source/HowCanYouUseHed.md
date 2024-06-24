# How do you use HED?

HED (Hierarchical Event Descriptors) annotations provide an essential link between
experimental data and analysis.
HED annotations can be used to describe what happened while data was acquired,
participant state, experimental control, task parameters, and experimental conditions.
HED annotations are most commonly associated with event files, 
but these annotations can also be applied to other types of tabular data.

**This guide organizes HED resources based on how you might use HED:**

* [**As an experimenter**](as-an-experimenter-anchor)
* [**As a data annotator**](as-a-data-annotator-anchor)
* [**As a data analyst**](as-a-data-analyst-anchor)
* [**As a tool developer**](as-a-tool-developer-anchor)
* [**As a schema builder**](as-a-schema-builder-anchor)

<hr style="border: 3px solid #000080" />

(as-an-experimenter-anchor)=
## <span style="color: #229955;">As an experimenter</span>
> <span style="font-size: 1.5em; font-weight: 900; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... doing experiments and acquiring data:</span>

The lynch-pin of scientific inquiry is the planning and running of experiments to test 
hypotheses and study behavior.
The focus of the discussion here is not explicitly on how an experiment
should be designed,
but rather on how data should be recorded and transformed to maximize its downstream usability.

**Here are some topics of interest to experimenters:**

* [**Planning and running an experiment**](planning-and-running-an-experiment-anchor)
* [**Post-processing the data**](post-processing-the-data-anchor)

The *Actionable event annotation and analysis in fMRI: A practical guide to event handling* preprint,
which can be found at [**https://osf.io/93km8/**](https://osf.io/93km8/),
provides concrete guidance and discussion of pitfalls in transforming experimental logs
into usable event data.
The site includes sample data to use in running the examples.

(planning-and-running-an-experiment-anchor)=
### Planning and running an experiment

Most laboratory experiments use neuroimaging equipment and peripheral devices in
combination with experiment control software to acquire the experimental data.
This section describes some HED tools that may be of use during the log-to-data extraction process. 
Key questions are:

- What should go into an experimental log?
- How should information about the experimental design and temporal structure be included?
- How will the log data be synchronized with other data?

We assume that event information is primarily contained in experimental logs,
whose log entries contain a timestamp, a code, and possibly other information.
We assume that this information can be extracted in tabular format.
The key point here is:

><span style="color:#A00000; font-weight:bold;">Data that isn't recorded is lost forever!</span>

With that caveat in mind, most researchers will run a pilot before the actual
experiment to detect issues that might reduce the effectiveness or correctness of the experiment.
HED file remodeling tools can help smooth the transition from acquisition to data,
both in the pilot and the experiment itself.

#### Event acquisition

In a traditional neuroimaging experiment that is organized by trial, it may be easy to
focus exclusively on marking the experimental stimuli, but
the incidental sensory presentations can also be important,
particularly for analyses that use regression techniques.
Examples of incidental sensory presentations include cues, instructions, feedback,
and experimental control events that are visible to the participant.

Participant responses should also be marked in the timeline, even though
this may require synchronization of presentation with the acquisition of the participant's
response indicators.
Downstream analysis may include time-locking to the actual response point to study
neural correlates of the motor reaction.
A common approach for including participant's response is to identify the closing of a switch
on a push-button, marking the end of the participant's response.
More sophisticated instrumentation might include detection of initiation and termination
of muscle movement using EMG (electromyography) sensors.

Another issue which should be addressed in the pilot is how experimental control
information will be embedded in the data.
Will there be embedded markers for trial or block beginnings?
How will information about experimental conditions be embedded?
Often a condition will be counterbalanced within a run and embedding markers that
identify the current conditions in the log can facilitate the use of tools
in post-processing and assure that the conditions are correctly marked.

#### Logs to event files

Although the HED tools do not yet directly support any particular experimental presentation/control
software packages, the HED [**File remodeling tools**](./FileRemodelingTools.md) can
be useful in working with logged data.

Assuming that you can put the information from your experimental log into a tabular form such as:

(sample-tabular-log-anchor)=
````{admonition} A sample log file in tabular form.
| onset  | code  | description |
| -------- | ------- | ------------- |
| 0.3423 | 4332  | Presentation of a fixation cross for 0.25 seconds. |
| 0.5923 | 4333  | Presentation of a face image for 0.5 seconds. |
| 1.7000 | 4332  | Presentation of a fixation cross for 0.25 seconds. |
|  ...   |  ...  | ... |

````

The [**summarize column values**](./FileRemodelingTools.md#summarize-column-values)
operation in the HED [**file remodeling tools**](./FileRemodelingTools.md)
compiles detailed summaries of the contents of tabular files.
Use the following remodeling file and your tabular log file as input 
to the HED online [**event remodeling**](https://hedtools.ucsd.edu/hed_dev/events) tools
to quickly get an overview of its contents.

````{admonition} A sample JSON file with the command to get a summary of the column values in a file.
:class: tip
```json
[{
   "operation": "summarize_column_values",
   "description": "Summarize the column values in my log.",
   "parameters": {
       "summary_name": "Log_summary",
       "summary_filename": "Log_summary",
       "skip_columns": ["onset"],
       "value_columns": ["description"]
   }
}]
```
````

(post-processing-the-data-anchor)=
### Post-processing the event data

The information that first comes off the experimental logs is usually not directly usable for
sharing and analysis. A number of HED [**File remodeling tools**](./FileRemodelingTools.md)
might be helpful for restructuring your first pass at the event files.

The [**remap columns**](./FileRemodelingTools.md#remap-columns) transformation is 
particularly useful during the initial processing of tabular log information
as exemplified by the following example

````{admonition} A sample JSON remodel to create *duration* and *event_type* columns from *code*.
:class: tip

```json
[{ 
    "operation": "remap_columns",
    "description": "Expand the code column.",
    "parameters": {
        "source_columns": ["code"],
        "destination_columns": ["duration", "event_type"],
        "map_list": [["4332", 0.25, "show_cross"],
                     ["4333", 0.50, "show_face"]],
        "ignore_missing": true
    }
}]

```
````

The result of applying the above transformation to the [**sample tabular log**](sample-tabular-log-anchor)
file is shown in the following table:

````{admonition} Result of applying remap_columns to the sample tabular log file.
| onset  | code  | description | duration | event_type |
| -------- | ------- | ------------- | ------- | ------ |
| 0.3423 | 4332  | Presentation of a fixation cross for 0.25 seconds. | 0.25  | show_cross |
| 0.5923 | 4333  | Presentation of a face image for 0.5 seconds. | 0.50  | show_face |
| 1.7000 | 4332  | Presentation of a fixation cross for 0.25 seconds. | 0.25  | show_cross |
|  ...   |  ...  | ... | ... | ... |

````

The remapping transformation retains all the columns. At this point you can delete and/or
reorder columns using other remodeling commands, 
since BIDS requires that the first two columns in all events files be *onset* and *duration*,
respectively. The remodeling JSON file can be expanded to include these transformations as well.

<hr style="border: 3px solid #000080;" />

(as-a-data-annotator-anchor)=
## <span style="color: #229955;">As a data annotator</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... organizing data and tagging events:</span>

The move towards open, reproducible science, both in the scientific community and
by funding agencies, makes data sharing a requirement.
An added benefit, is that data used by others is likely to garner increased recognition
and additional citations.
This section emphasizes the importance of complete and accurate metadata to enable analysis.

**Here are some topics of interest to data annotators:**

* [**Standardizing the format**](standardizing-the-format-anchor)
  * [**Learning about BIDS**](learning-about-bids-anchor)
  * [**Learning about HED**](learning-about-hed-anchor)
  * [**Integrating HED in BIDS**](integrating-hed-in-bids-anchor)
* [**Adding HED annotations**](adding-hed-annotations-anchor)
  * [**Viewing available tags**](viewing-available-tags-anchor)
  * [**Basic annotation strategies**](basic-annotation-strategies-anchor)
  * [**More advanced annotations**](more-advanced-annotations-anchor)
* [**Checking correctness**](checking-correctness-anchor)
  * [**Validating HED annotations**](validating-hed-annotations-anchor)
  * [**Checking for consistency**](checking-for-consistency-anchor)

(standardizing-the-format-anchor)=
### Standardizing the format

An important aspect of data-sharing is putting your data into a standardized format
so that tools can read and manipulate the data without the need for
special-purpose reformatting code.

[**BIDS**](https://bids.neuroimaging.io/) (Brain Imaging data Structure)
is a widely used data organization standard for neuroimaging data.
HED is well-integrated into the BIDS standard.

(learning-about-bids-anchor)=
#### Learning about BIDS
- If you are unfamiliar with BIDS, we recommend the
[**BIDS Start Kit**](https://bids-standard.github.io/bids-starter-kit/index.html).
<p></p>

- [**Folders and Files**](https://bids-standard.github.io/bids-starter-kit/folders_and_files/folders.html)
gives an overview of how files in a BIDS dataset are organized.
<p></p>

- The [**Annotating a BIDS dataset**](https://bids-standard.github.io/bids-starter-kit/tutorials/annotation.html) tutorial gives an overview
of how to get the appropriate metadata into a BIDS dataset.
<p></p>

- See the [**BIDS specification**](https://bids-specification.readthedocs.io/en/stable/)
for detailed information on the rules for BIDS.
Of special interest to HED annotators are the sections on [**Task events**](https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/05-task-events.html)
and the [**Hierarchical Event Descriptors**](https://bids-specification.readthedocs.io/en/stable/appendices/hed.html) appendix.
<p></p>

- There are a variety of tools available to convert to and from BIDS format as summarized
in [**Software currently supporting BIDS**](https://bids.neuroimaging.io/benefits.html#software-currently-supporting-bids).

(learning-about-hed-anchor)=
#### Learning about HED

- The [**Introduction to HED**](https://www.hed-resources.org/en/latest/IntroductionToHed.html)
gives a basic overview of HED's history and goals.   
<p></p>

- The [**"Capturing the nature of events..."**](https://www.sciencedirect.com/science/article/pii/S1053811921010387) paper works through a practical example of
using HED annotations and suggests best practices for annotation.  
<p></p>

- See the [**HED specification**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html) 
for detailed information on the rules for HED.
Of special interest to HED users are [**Chapter 4: Basic annotation**](https://hed-specification.readthedocs.io/en/latest/04_Basic_annotation.html) and [**Chapter 5: Advanced annotation**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html).
These chapters explain the different types of HED
annotations and the rules for using them.


(integrating-hed-in-bids-anchor)=
#### Integrating HED in BIDS

There are two strategies for incorporating HED annotations in a BIDS dataset:

> **Method 1**: Use a JSON (sidecar) file to hold the annotations.

> **Method 2**: Annotate each line in each event file using the **HED** column.

Method 1 is the typical way that HED annotations are incorporated into a BIDS dataset.
The [**HED online tools**](https://hedtools.ucsd.edu/hed) allow you to easily generate a template JSON sidecar to fill in.
The [**BIDS annotation quickstart**](https://www.hed-resources.org/en/latest/BidsAnnotationQuickstart.html) walks through this process step-by-step.

Method 2 is usually used for instrument-generated annotations or for manual processing (such as users marking bad sections of the data or special features).
In both cases the annotations are usually created using special-purpose tools.

When using HED you must provide a HED schema version indicating the HED vocabulary
you are using.
In BIDS, the schema versions are specified in  `dataset_description.json`, 
a required JSON file that must be placed in the root directory of the dataset.
See [**HED schema versions**](https://bids-specification.readthedocs.io/en/stable/appendices/hed.html#hed-schema-versions) in the BIDS specification for
examples.

(adding-hed-annotations-anchor)=
### Adding HED annotations
This section discusses the strategy for adding annotations in a BIDS dataset using sidecars.
The discussion assumes that you have a JSON sidecar template file ready to annotate.
See [**BIDS annotation quickstart**](https://www.hed-resources.org/en/latest/BidsAnnotationQuickstart.html) for a walk-through of this process.

(viewing-available-tags-anchor)=
#### Viewing available tags

- The HED vocabulary is hierarchically organized as shown
in the schema as viewed in the [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html).
Library schemas can also be viewed using this viewer.
<p></p>

(basic-annotation-strategies-anchor)=
#### Basic annotation strategies
HED annotations come in variety of levels and complexity.
If your HED annotations are in a JSON sidecar, 
it is easy to start simple and incrementally improve your annotations just by editing
the JSON sidecar.

- The [**HED annotation quickstart**](https://www.hed-resources.org/en/latest/HedAnnotationQuickstart.html) provides a recipe
for creating a simple HED annotation.

**A key part of the annotation is to include a good description** of each type
event. One way to do this is to include a *Description/* tag with a text value
as part of each annotation. A good description helps to clarify the information
that you want to convey in the tags.
<p></p>

- [**Viewing available tags**](./HowCanYouUseHed.md#viewing-available-tags)
gives options for viewing tags to select.
<p></p>

- [**CTAGGER**](https://www.hed-resources.org/en/latest/CTaggerGuiTaggingTool.html)
is a standalone tagging assistant with a user-friendly GUI to ease the tagging process.

(more-advanced-annotations-anchor)=
#### More advanced annotations

HED supports a number of advanced annotation concepts which are necessary for a complete
description of the experiment. 

- **HED definitions**: allow users to define complex concepts.
See [**Creating definitions**](https://hed-specification.readthedocs.io/en/develop/05_Advanced_annotation.html#creating-definitions) and [**Using definitions**](https://hed-specification.readthedocs.io/en/develop/05_Advanced_annotation.html#using-definitions) for an overview and syntax.
<p></p>

- **Temporal scope**: annotate event processes that extend over time and provide a context for
events. Expression of temporal scope is enabled by *Temporal-marker* tags: *Onset*, *Offset*,
and *Duration* together with the *Definition* tag. See [**Temporal scope**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html#temporal-scope) for the rules and usage.
<p></p>

- **Conditions and experimental design**: HED allows users to express annotate experiment
design, as well as other information such as task, and the experiment's temporal organization.
See [**HED conditions and design matrices**](https://www.hed-resources.org/en/latest/HedConditionsAndDesignMatrices.html).

The [**Advanced annotation**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html)
chapter of the HED specification explains the rules for using these more advanced concepts.

(checking-correctness-anchor)=
### Checking correctness

Checking for errors is an ongoing and iterative process.
It is much easier to build more complex annotations on a foundation of valid annotations.
Thus, as you are adding HED annotations, you should frequently revalidate.

(validating-hed-annotations-anchor)=
#### Validating HED annotations

- The [**HED validation guide**](https://www.hed-resources.org/en/latest/HedValidationGuide.html) describes the different types of validators available.
<p></p>

- The [**HED errors**](https://hed-specification.readthedocs.io/en/latest/Appendix_B.html)
documentation lists the different types of HED errors and their potential causes.
<p></p>

- The JSON sidecar, which usually contains most of the HED annotations, can be easily 
validated using the [**HED online tools**](https://hedtools.ucsd.edu/hed).
<p></p>

- You should validate the HED annotations separately using the online tools or
the HED Python tools before doing a full BIDS validation, as this will make the
validation process much simpler.

(checking-for-consistency-anchor)=
#### Checking for consistency

Several HED summary tools allow you to check consistency.
The [**Understanding the data**](./HowCanYouUseHed.md#understanding-the-data)
tutorial in the next section describes some tools that are available
to help check the contents of the events files for surprises.

The summary tools are a start, but there are also experiment-specific 
aspects which ideally should be checked.
Bad trial identification is a typical example of experiment-specific checking.

````{admonition} Example of experiment-specific checking.
:class: tip

Suppose each trial in an experiment should consist of a sequence:

> **stimulus-->key-press-->feedback**

You can expect that there will be situations in which participants
forget to press the key, press the wrong key, press the key multiple times,
or press the key both before and after the feedback.
````

Ideally, a data annotator would provide information in the event file marking
unusual things such as these bad trials, since it is easy for downstream users
to improperly handle these situations, reducing the accuracy of analysis.

At this time, your only option is to do manual checks or write custom code to
detect these types of experiment-specific inconsistencies.
However, work is underway to include some standard types of checks in the
HED [**File remodeling tools**](./FileRemodelingTools.md) in future releases.

You may also want to reorganize the event files using the remodeling tools.
See the [**Remap columns**](remap-columns-anchor) 
a discussion above and links to examples of how to reorganize the information in the
columns of the event files.

<hr style="border: 3px solid #000080;" />

(as-a-data-analyst-anchor)=
## <span style="color: #229955;">As a data analyst</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... applying HED tools to answer scientific questions:</span>

Whether you are analyzing your own data or using shared data produced by others to 
answer a scientific question, fully understanding the data and its limitations is essential
for accurate and reproducible analysis.
This section discusses how HED annotations and tools can be used for effective analysis.

**Here are some topics of interest to data analysts:**

* [**Understanding the data**](understanding-the-data-anchor)
* [**Preparing the data**](preparing-the-data-anchor)
* [**Analyzing the data**](analyzing-the-data-anchor)
  * [**Factors vectors and selection**](factor-vectors-and-selection-anchor)
  * [**HED analysis in EEGLAB**](hed-analysis-in-eeglab-anchor)


(understanding-the-data-anchor)=
### Understanding the data

Sadly, most currently shared data is under-annotated and may require considerable
work and possibly contact with the data authors for correct use and interpretation.

You can get a preliminary sense about what is actually in the data by downloading a
single event file (e.g., a BIDS `_events.tsv`) and its associated JSON sidecar
(e.g., a BIDS `_events.json`) and creating HED remodeling tool summaries using the 
[**HED online tools for debugging**](./FileRemodelingQuickstart.md#online-tools-for-debugging).
Summaries of particular use for analysts include:

- The [**column value summary**](./HedSummaryGuide.md#column-value-summary) compiles a summary of 
the values in the various columns of the event files in the dataset. This summary does not require any HED information.
<p></p>

- The [**HED tag summary**](./HedSummaryGuide.md#hed-tag-summary)
creates a summary of the HED tags used to annotate the data.
<p></p>

- The [**experimental design summary**](./HedSummaryGuide.md#experimental-design-summary)
gives a summary of the condition variables or other structural tags relating to experimental design, task,
or temporal layout of the experiment. 

While HED tag summary and the experimental design summaries require that the dataset have HED annotations, these summaries do not rely on the experiment-specific
event-coding used in each experiment and can be used to compare information for different datasets.

The [**File remodeling quickstart**](./FileRemodelingQuickstart.md) tutorial
gives an overview of the remodeling tools and how to use them.
More detailed information can be found in [**File remodeling tools**](./FileRemodelingTools.md).

The [**Online tools for debugging**](./FileRemodelingQuickstart.md#online-tools-for-debugging)
shows how to use remodeling tools to obtain these summaries without writing any code.

The [**HED conditions and design matrices**](HedConditionsAndDesignMatrices.md) guide explains how
information structure information is encoded in HED and how to interpret the summaries of this information.

(preparing-the-data-anchor)=
### Preparing the data

In deciding on an analysis, you may discover that the information in the event files is not
organized in a way that would support your analyses. 

(analyzing-the-data-anchor)=
### Analyzing the data

The power of HED is two-fold -- its flexibility and its generality in specifying criteria.
Flexibility allows users to specify quite complex criteria without having to write 
additional code, while generality allows comparison of criteria across different
experiments.

The factor generation as described in the next section relies on the HED
[**File remodeling tools**](FileRemodelingTools.md).
See [**File remodeling tools**](FileRemodelingTools.md).

(factor-vectors-and-selection-anchor)=
#### Factor vectors and selection

The most common analysis application is to select events satisfying a particular criteria,
and compare some measure on signals containing these events with a control.
Depending on the modality, these might be different.

HED annotations facilitate the selection. This selection can be described in terms
of factor vectors. A **factor vector** for an event file has the same number of
rows as the event file (each row corresponding to an event marker).
Factor vectors contain 1's for rows in which a specified criterion is satisfied
and 0's otherwise.

- The [**factor column operation**](./FileRemodelingTools.md#factor-column)
creates factor vectors based on the unique values in specified columns.
This factor operation does not require any HED information.
<p></p>

- The [**factor HED tags**](./FileRemodelingTools.md#factor-hed-tags)
creates factor vectors based on a HED tag query. 
The [**HED search guide**](./HedSearchGuide.md) explains the HED query structure and
available search options.
<p></p>

- The [**factor HED type**](./FileRemodelingTools.md#factor-hed-type)
creates factors based on a HED tag representing structural information about the data such as
*Condition-variable* (for experimental design and experimental conditions) or *Task*.

(hed-analysis-in-eeglab-anchor)=
#### HED analysis in EEGLAB

[**EEGLAB**](https://sccn.ucsd.edu/eeglab/index.php), the interactive
MATLAB toolbox for EEG/MEG analysis, supports HED through the
[**EEGLAB HEDTools plugin**](./HedAndEEGLAB.md).

The *End-to-end processing of EEG with HED and EEGLAB* preprint, which can be found 
at [**https://osf.io/8brgv/**](https://osf.io/8brgv/),
works through the entire analysis process, including porting the analysis
to high performance computing platforms.
The site includes sample data to use in running the examples.

#### HED support in other tools

Work is underway to integrate HED support in other analysis packages.
If you are interested in helping in this effort please email
hed.maintainers@gmail.com.


<hr style="border: 3px solid #000080" />

(as-a-tool-developer-anchor)=
## <span style="color: #229955;">As a tool developer</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... helping expand the growing HED tool base:</span>

The power of HED is its ability to capture important details of the experiment design and events in
a form that is both human-understandable and directly usable in processing programs.
The HED ecosystem relies on tools that read, understand, and incorporate HED as part of analysis.
This section describes how, as a tool developer, you can contribute to this growing ecosystem
to support HED for processing and analysis.

**Here are some topics of interest to developers:**

* [**Integrating with existing tools**](integrating-with-existing-tools-anchor)
* [**The HED code base**](the-hed-code-base-anchor)
  * [**The HED Python code base**](the-hed-python-code-base-anchor)
  * [**The HED JavaScript code base**](the-hed-javascript-code-base-anchor)
  * [**The HED MATLAB code base**](the-hed-matlab-code-base-anchor)
  * [**Web tools and REST services**](web-tools-and-rest-services-anchor)
* [**Future development plans**](future-development-plans-anchor)


(integrating-with-existing-tools-anchor)=
### Integration with existing tools


The GitHub repositories and other resources associated with these projects are described in this section.
The HED project page is [**https://www.hedtags.org**](https://www.hedtags.org).
The documentation and examples are housed in the 
[**hed-examples**](https://github.com/hed-standard/hed-examples) GitHub repository.

Contributions are welcome in any area (e.g., code, examples, documentation, ideas, issues).
Use the **issues** mechanism of the most appropriate HED standard repository to ask questions or to
describe your ideas and how you would like to contribute.
Alternatively, you can email hed.maintainers@gmail.com.

(the-hed-code-base-anchor)=
### The HED code base

The [**HED standard organization**](https://github.com/hed-standard) has several
code projects and distinct tool bases in Python, MATLAB, and JavaScript.
All HED efforts are open source.

(the-hed-python-code-base-anchor)=
#### The HED python code base

The Python HED tools contain the core technology for HED including code for validation, analysis,
and schema development.
The code for HEDTools is in the [**hed-python**](https://github.com/hed-standard/hed-python) GitHub repository.

The latest stable release is available as [**hedtools**](https://pypi.org/project/hedtools/)
on PyPI and can be installed using the regular `pip` install mechanism.

The `develop` branch of [**hed-python**](https://github.com/hed-standard/hed-python) contains the latest
versions of the tools and can be installed from GitHub using:

```bash
 pip install git+https://github.com/hed-standard/hed-python/@develop
```

(the-hed-javascript-code-base-anchor)=
#### The HED JavaScript code base

GitHub repository. The JavaScript tools focus on HED validation and its main client is the 
[**Bids validator**](https://github.com/bids-standard/bids-validator).
The code for this project is in the [**hed-javascript**](https://github.com/hed-standard/hed-javascript)

The latest stable release is available as the [**hed-validator**](https://www.npmjs.com/package/hed-validator)
on npm.

(the-hed-matlab-code-base-anchor)=
#### The HED MATLAB code base

The MATLAB HED tools project focuses primarily on analysis using HED, 
although there is substantial support for annotation as well.

The **HEDTools plugin** is available for installation through [**EEGLAB**](https://sccn.ucsd.edu/eeglab/index.php). The[**EEGLAB plug-in integration**](https://www.hed-resources.org/en/latest/HedMatlabTools.html#eeglab-plug-in-integration) tutorial explains the installation 
and integration of HED tools in the EEGLAB environment.
Although this toolset focuses on analysis, it also includes extensive tools for importing and annotating
HED data through the **CTagger** GUI.
<p></p>

**CTagger** is a GUI for HED annotation and validation. 
CTagger can be run as a standalone program, but is also integrated and callable from MATLAB via an
[**EEGLAB plug-in**](https://www.hed-resources.org/en/latest/HedMatlabTools.html#eeglab-plug-in-integration).
See [**CTAGGER GUI tagging tool**](https://www.hed-resources.org/en/latest/CTaggerGuiTaggingTool.html) tutorial
for more information on installation and use.
The project source code is located in the [**CTagger**](https://github.com/hed-standard/ctagger) GitHub repository.
<p></p>

[*HED MATLAB Tools**](https://www.hed-resources.org/en/latest/HedMatlab.md) explains how the 
users can use the HEDTools in MATLAB using one of three approaches: using MATLAB wrappers for the HED Python tools,
using MATLAB wrappers for the HED web services, or by calling HED tools through EEGLAB.

The [**HED online services**](https://hedtools.ucsd.edu/hed) can be called programmatically in MATLAB. The HED services are deployed online through a docker container
as described in [**Web tools and rest services**](web-tools-and-rest-services-anchor). 
<p></p>


(web-tools-and-rest-services-anchor)=
#### Web tools and REST services

The HED online tools are available at [**https://hedtools.ucsd.edu/hed**](https://hedtools.ucsd.edu/hed).

A development version of the online tools is available at [**https://hedtools.ucsd.edu/hed_dev**](https://hedtools.ucsd.edu/hed_dev).

These servers not only provide a GUI interface to the tools that is useful for debugging or for a quick analysis,
but they also provide REST services for various HED tools as described in
[**HED RESTful services**](hed-restful-services-anchor).

The project source code is located in the [**hed-web**](https://github.com/hed-standard/hed-web) GitHub repository.



(future-development-plans-anchor)=
### Future development plans

We are always looking for people with suggestions or new ideas to join our community.
In the short term we have the following development goals:

- Finish integration of search for epoching and its documentation in [**fieldtrip**](https://www.fieldtriptoolbox.org/).
- Integrate searching, summary, and epoching into [**MNE-Python**](https://mne.tools/stable/index.html).
- Integrate search and summary into the [**Nemar**](https://nemar.org) and [**EEGNET**](http://eegnet.org/) platforms.

Longer term we hope to develop more sophisticated analysis methods based on HED and 
to better integrate presentation and experimental control software with the annotation process.

We are also tackling the problem of how to effectively capture event relationships to facilitate
more complex and sophisticated automated analysis.

<hr style="border: 3px solid #000080;" />

(as-a-schema-builder-anchor)=
## <span style="color: #229955;">As a schema builder</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... extending HED vocabulary in new directions:</span>

HED annotations consist of comma-separated terms drawn from a hierarchically
structured vocabulary called a HED schema.
The **HED standard schema** contains basic terms that are common across
most human neuroimaging, behavioral, and physiological experiments.

The HED ecosystem also includes **HED library schemas** to expand the HED vocabulary 
in a scalable manner to support more specialized data.

**Here are some topics of interest to schema developers:**

* [**Viewing available schemas**](viewing-available-schemas-anchor)
* [**Improving an existing schema**](improving-an-existing-schema-anchor)
* [**Creating a new library schema**](creating-a-new-library-schema-anchor)
* [**Private vocabularies and extensions**](private-vocabularies-and-extensions-anchor)

The SCORE library for clinical EEG annotations has been released.
Other schema libraries are under development include a movie annotation library and
a language annotation library, but these have not yet reached the stage 
that they are available for community comment.

If you are interested in participating in the development of any ongoing library development efforts,
please email hed.maintainers@gmail.com.

(viewing-available-schemas-anchor)=
### Viewing available schemas

The first step in using or improving the HED vocabularies is to explore what
is there using the [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html) for the HED standard
schema.

The SCORE library for clinical annotation of EEG
can be viewed using the [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html?schema=score)
for score.

(improving-an-existing-schema-anchor)=
### Improving an existing schema

If you see a need for additional terms in an existing schema,
post an issue to schema to
[**hed-schemas/issues**](https://github.com/hed-standard/hed-schemas/issues) on GitHub 
with the following information:

````{admonition} Proposing a new tag in an existing HED schema.
Be sure to include the following when posting an issue to add a schema term.

- The name of the schema (standard or library-name).
- The proposed name of the term or the name of term to be modified. 
- A brief and informative text description of its meaning. 
- A suggestion for where term should be placed in the schema if new.
- An explanation of why this term is needed and how it might be used. 

Proposals for modifications to existing terms should include similar information.

````

The posting of an issue will start the discussion going.
A HED schema term must stand on its own and must not exist elsewhere in the schema.
When thinking about where a term should be located within the schema hierarchy,
also remember that every term satisfies the **is-a** relationship with any of its schema parents.

Besides adding new terms, you might suggest improvements to an existing term's
description or a modification of its attributes.
You might also suggest the need for modifications or additions to the schema attributes, 
value classes, or unit classes.

All suggested changes or errors should be reported using the same mechanism
as proposing new terms through the [**hed-schemas/issues**](https://github.com/hed-standard/hed-schemas/issues) mechanism on GitHub.

(creating-a-new-library-schema-anchor)=
### Creating a new library schema

If you are interested in developing a library schema in a new area,
you should post an issue on the [**hed-schemas/issues**](https://github.com/hed-standard/hed-schemas/issues) 
GitHub repository. Your post should start with a brief description of the 
proposed library and its applications.

````{admonition} Starting the process of developing a new HED schema library.
Be sure to include the following for your initial post proposing creation of a new library.

- A proposed name for the HED library schema.
- A brief description of the library's purpose and contents.
- GitHub handles for potential collaborators.
 
````

You should also read the [**HED schema developer's guide**](https://www.hed-resources.org/en/latest/HedSchemaDevelopersGuide.html) to get an overview of the development process.

**Note**: You must have a GitHub account in order to work on the development of a
new schema as all development processes for HED use the GitHub Pull Request mechanism for
development and community comment.

(private-vocabularies-and-extensions-anchor)=
### Private vocabularies and extensions

Although you can create a private HED vocabulary for your own use,
many HED tools assume that only standardized schemas available on the
[**hed-schemas**](https://github.com/hed-standard/hed-schemas) GitHub repository will be used. 
These tools fetch or internally cache the most recent versions of the HED schemas,
and users need only specify the HED schema versions during validation and analysis.

The decision to only support standardized schemas was after serious deliberation
by the HED Working Group based on the observation that the ability of
HED to enable standardized dataset summaries and comparisons would be compromised by
allowing unvetted, private vocabularies.
