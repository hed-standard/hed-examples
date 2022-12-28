# How do you use HED?

HED (Hierarchical Event Descriptors) annotations provide an essential link between
experimental data and analysis.
HED annotations can be used to describe what happened while data was acquired,
participant state, experimental control, task parameters, and experimental conditions.
HED annotations are most commonly associated with event files, but can also
be applied to other types of tabular data.

<hr style="border: 3px solid #000080" />

## As an experimenter ...

<p style="font-size: 1.36em; font-weight: bold; color: #229955;">... designing experiments and acquiring data.</p>


### Planning and executing an experiment

#### Mapping events from logs

#### Assuring completeness

### Post-processing the data

#### Remapping columns

#### Other useful operations

<hr style="border: 3px solid #000080;" />

## As a data curator ...

<p style="font-size: 1.36em; font-weight: bold; color: #229955;">... organizing data.</p>

The move towards open, reproducible science, both in the scientific community and
by funding agencies, makes data sharing a requirement.
An added benefit, is that data used by others is likely to garner increased recognition
and additional citations.

### Standardizing the format

An important aspect of data-sharing is putting your data into a standardized format
so that tools can read and manipulate the data without users having to write
special-purpose reformatting.

[**BIDS**](https://bids.neuroimaging.io/) (Brain Imaging data Structure)
is a widely used data organization standard for neuroimaging data.
HED is well-integrated into the BIDS standard.

#### Learning about BIDS
- If you are unfamiliar with BIDS, we recommend the
[**BIDS Start Kit**](https://bids-standard.github.io/bids-starter-kit/index.html).
<p></p>

- The [**Folders and Files**](https://bids-standard.github.io/bids-starter-kit/folders_and_files/folders.html)
gives an overview of how files in a BIDS dataset are organized.
<p></p>

- The [**Annotating a BIDS dataset**](https://bids-standard.github.io/bids-starter-kit/tutorials/annotation.html) tutorial gives an overview
of how to get the appropriate metadata into a BIDS dataset.
<p></p>

- See the [**BIDS specification**](https://bids-specification.readthedocs.io/en/stable/)
for detailed information on the rules for BIDS.
Of special interest to HED users are the sections on [**Task events**](https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/05-task-events.html)
and the [**Hierarchical Event Descriptors**](https://bids-specification.readthedocs.io/en/stable/appendices/hed.html) appendix.
<p></p>

- There are a variety of tools available to convert to and from BIDS format as summarized
in [**Software currently supporting BIDS**](https://bids.neuroimaging.io/benefits.html#software-currently-supporting-bids).

#### Learning about HED

- The [**HED introduction**](https://www.hed-resources.org/en/latest/HedIntroduction.html)
gives a basic overview of HED's history and goals.   
<p></p>

- The [**"Capturing the nature of events..."**](https://www.sciencedirect.com/science/article/pii/S1053811921010387) paper works through a practical example of
using HED annotations and suggests best practices for annotation.  
<p></p>

- See the [**HED specification**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html) 
for detailed information on the rules for HED.
Of special interest to HED users are [**Chapter 4: Basic annotation**](https://hed-specification.readthedocs.io/en/latest/04_Basic_annotation.html) and [**Chapter 5: Advanced annotation**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html),
which explain the different types of HED
annotations and the rules for using them.

#### Reformatting event file


#### Integrating HED in BIDS

There are two strategies for incorporating HED annotations in a BIDS dataset:

> **Method 1**: Use a JSON (sidecar) file to hold the annotations.

> **Method 2**: Annotate each line in each event file using the **HED** column.

Method 1 is the typical way that HED annotations are incorporated into a BIDS dataset.
The [**HED online tools**](https://hedtools.ucsd.edu/hed) allow you to easily generate a template JSON sidecar to fill in.
The [**BIDS annotation quickstart**](https://www.hed-resources.org/en/latest/BidsAnnotationQuickstart.html) walks through this process step-by-step.

Method 2 is usually used for instrument-generated annotations or for manual processing (such as a user marking bad sections of the data or special features).
In both cases the annotations are usually created using special-purpose tools.

When using HED you must provide a HED schema version indicating the HED vocabulary
you are using.
In BIDS, the schema versions are specified in  `dataset_description.json`, 
a required JSON file that must be placed in the root directory of the dataset.
See [**HED schema versions**](https://bids-specification.readthedocs.io/en/stable/appendices/hed.html#hed-schema-versions) in the BIDS specification for
examples.

### Adding HED annotations
This sections discusses the strategy for adding annotations in a BIDS dataset. 
The discussion assumes that you have a JSON sidecar template file ready to annotate.
See [**BIDS annotation quickstart**](https://www.hed-resources.org/en/latest/BidsAnnotationQuickstart.html) for a walk-through of this process.

#### Viewing available tags

- The HED vocabulary is hierarchically organized as shown
in this [**expandable view**](https://www.hedtags.org/display_hed.html)
of the HED standard vocabulary.
<p></p>

- [**Schema viewers**](https://www.hed-resources.org/en/latest/HedSchemaViewers.html)
gives links to different versions of the HED standard HED vocabularies as well as 
library vocabularies.

#### Basic annotation strategy
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


#### More advanced annotations

HED supports a number of advanced annotation concepts which are necessary for a complete
description of the experiment ([**Advanced annotation**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html)).

- **HED definitions**: allow users to define complex concepts.
See [**HED definitions**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html#hed-definitions) for an overview and syntax.
<p></p>

- **Temporal scope**: annotate event processes that extend over time and provide a context for
events. Expression of temporal scope is enabled by *Temporal-marker* tags: *Onset*, *Offset*,
and *Duration* together with the *Definition* tag. See [**Temporal scope**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html#temporal-scope) for the rules and usage.
<p></p>

- **Conditions and experimental design**: HED allows users to express annotate experiment
design, as well as other information such as task, and the experiment's temporal organization.
See [**HED conditions and design matrices**](https://www.hed-resources.org/en/latest/HedConditionsAndDesignMatrices.html).

### Checking correctness

Checking for errors is an ongoing and iterative process.
It is much easier to build more complex annotations on a foundation of valid annotations.
Thus, as you are adding HED annotations, you should frequently revalidate.

#### Validating HED annotations

- The [**HED validation guide**](https://www.hed-resources.org/en/latest/HedValidationGuide.html) describes the different types of validators available.
<p></p>

- The [**HED errors**](https://hed-specification.readthedocs.io/en/latest/Appendix_B.html)
documentation lists the different types of HED errors and their potential causes.
<p></p>

- The JSON sidecar, which usually contains most of the HED annotations can be easily 
validated using the [**HED online tools**](https://hedtools.ucsd.edu/hed).
<p></p>

- You should validate the HED annotations separately using the online tools or
other the Python tools before doing a full BIDS validation, as this will make the
validation process much simpler.

#### Checking for consistency

Several HED summary tools allow you to check consistency.
The [**Understanding the data**](./HowCanYouUseHed.md#understanding-the-data)
tutorial in the next section describes some tools that are available
to help check the contents of the events file for surprises.

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

Ideally, a curator would provide information in the event file marking
unusual things such as these bad trials, since it is easy for downstream users
to improperly handle these situations, reducing the accuracy of analysis.

At this time, your only option is to do manual checks or write custom code to
detect these types of experiment-specific inconsistencies.
However, work is underway to include some standard types of checks in the
HED [**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html) in future releases.

<hr style="border: 3px solid #000080;" />

## As a data analyst ...

<p style="font-size: 1.36em; font-weight: bold; color: #229955;">... applying HED-informed data to answer scientific questions.</p>

### Understanding the data

Sadly, most currently shared data is under-annotated and may require considerable
work and possibly contact with the data authors for correct interpretation.

You can get a preliminary sense about what is in the data by downloading a
single event file (in BIDS `_events.tsv`) and its associated JSON sidecar
(`_events.json`). Typically, the sidecar is a single file in the root directory
of the dataset.

The


### Analyzing the data

The most common analysis application is to select events satisfying a particular criteria,
and compare some measure on signals containing these events with a control.
Depending on the modality, these might be different.

HED annotations facilitate the selection. This selection can be described in terms
of factor vectors. A **factor vector** for an event file has the same number of
rows as the event file (each row corresponding to an event marker).
Factor vectors contain 1's for rows in which a specified criterion is satisfied
and 0's otherwise.

The power of HED is two-fold -- its flexibility and its generality in specifying criteria.
Flexibility allows users to specify quite complex criteria without having to write 
additional code, while generality allows comparison of criteria across different
experiments.

The factor generation as described in this section relies on the HED
[**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.


#### Factors based on columns
#### Factors based on experimental conditions

<hr style="border: 3px solid #000080" />

## As a tool developer ...

<p style="font-size: 1.36em; font-weight: bold; color: #229955;">... modifying and adding to the growing HED tool base.</p>

### Developing new tools

### Integration with existing tools

<hr style="border: 3px solid #000080;" />

## As a schema developer ...

<p style="font-size: 1.36em; font-weight: bold; color: #229955;">... extending HED vocabulary to support new research directions.</p>

The HED standard library contains the basic terms needed to annotate experimental events.
The standard schema is organized into 6 subgroups: *Event*, *Agent*, *Action*, *Item*,
*Property*, and *Relation* as can be seen in the 
[**Expandable viewer**](https://www.hedtags.org/display_hed.html) for the HED standard
schema.

Many fields have much more specific annotation needs, and HED supports the
creation of library schema to meet these needs.

### Getting involved
If you are interested in developing a new HED library or joining an existing
development effort:

- Read the Setting up section of the  [**HED schema development guide**](https://www.hed-resources.org/en/latest/HedSchemaDevelopmentGuide.html).
<p></p>

- Post an issue on the [**hed-schemas/issues**](https://github.com/hed-standard/hed-schemas/issues) GitHub repository.


### Schema rules

- [**The HED schema](https://hed-specification.readthedocs.io/en/latest/03_Schema.html#)

