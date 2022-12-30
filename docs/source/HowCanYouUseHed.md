# How do you use HED?

HED (Hierarchical Event Descriptors) annotations provide an essential link between
experimental data and analysis.
HED annotations can be used to describe what happened while data was acquired,
participant state, experimental control, task parameters, and experimental conditions.
HED annotations are most commonly associated with event files, but can also
be applied to other types of tabular data.

**This guide organizes HED resources based on how you might use HED:**

* [**As an experimenter**](as-an-experimenter-anchor)
* [**As a data curator**](as-a-data-curator-anchor)
* [**As a data analyst**](as-a-data-analyst-anchor)
* [**As a tool developer**](as-a-tool-developer-anchor)
* [**As a schema developer**](as-a-schema-developer-anchor)

<hr style="border: 3px solid #000080" />

(as-an-experimenter-anchor)=
## <span style="color: #229955;">As an experimenter</span>
> <span style="font-size: 1.5em; font-weight: 900; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... designing experiments and acquiring data:</span>

The lynch-pin of scientific inquiry is the planning and running of experiments to test 
hypotheses and study behavior.
The focus of the discussion here is not explicitly the standard concerns of how an experiment
should be designed,
but rather how data should be recorded and identified to maximize its downstream usability.

**Here are some topics of interest to experiment designers:**

The lynch-pin of scientific inquiry is the planning and running of experiments to test 
hypotheses and study behavior.
The focus of the discussion here is not explicitly the standard concerns of how an experiment
should be designed,
but rather how data should be recorded and identified to maximize its downstream usability.

**Here are some topics of interest to experiment designers:**

* [**Planning and running an experiment**](planning-and-running-an-experiment-anchor)
* [**Post processing the data**](post-processing-the-data-anchor)

(planning-and-running-an-experiment-anchor)=
### Planning and running an experiment

Most laboratory experiments use a combination of peripheral devices and neuroimaging equipment in
combination with experiment control software to acquire the experimental data.

From a data perspective, important considerations include:

- How will 

#### Encoding of events and design

Some considerations are:

- 

#### The importance of pilot data

- Data that isn't recorded is lost forever.
- 
#### Mapping events from logs

#### Assuring completeness

(post-processing-the-data-anchor)=
### Post-processing the data

#### Remapping columns

#### Other useful operations

<hr style="border: 3px solid #000080;" />

(as-a-data-curator-anchor)=
## <span style="color: #229955;">As a data curator</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... organizing data for sharing and analysis:</span>

The move towards open, reproducible science, both in the scientific community and
by funding agencies, makes data sharing a requirement.
An added benefit, is that data used by others is likely to garner increased recognition
and additional citations.
This section emphasizes the importance of complete and accurate metadata to enable analysis.

**Here are some topics of interest to data curators:**

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

- The [**HED introduction**](https://www.hed-resources.org/en/latest/HedIntroduction.html)
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
in this [**expandable view**](https://www.hedtags.org/display_hed.html)
of the HED standard vocabulary.
<p></p>

- [**Schema viewers**](https://www.hed-resources.org/en/latest/HedSchemaViewers.html)
gives links to different versions of the HED standard HED vocabularies as well as 
library vocabularies.

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
See [**HED definitions**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html#hed-definitions) for an overview and syntax.
<p></p>

- **Temporal scope**: annotate event processes that extend over time and provide a context for
events. Expression of temporal scope is enabled by *Temporal-marker* tags: *Onset*, *Offset*,
and *Duration* together with the *Definition* tag. See [**Temporal scope**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html#temporal-scope) for the rules and usage.
<p></p>

- **Conditions and experimental design**: HED allows users to express annotate experiment
design, as well as other information such as task, and the experiment's temporal organization.
See [**HED conditions and design matrices**](https://www.hed-resources.org/en/latest/HedConditionsAndDesignMatrices.html).

The [**Advanced annotation**](https://hed-specification.readthedocs.io/en/latest/05_Advanced_annotation.html)) chapter of the HED specification
explains the rules for using these more advanced concepts.

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

Ideally, a curator would provide information in the event file marking
unusual things such as these bad trials, since it is easy for downstream users
to improperly handle these situations, reducing the accuracy of analysis.

At this time, your only option is to do manual checks or write custom code to
detect these types of experiment-specific inconsistencies.
However, work is underway to include some standard types of checks in the
HED [**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html) in future releases.

You may also want to reorganize the event files using the remodeling tools.
See the [**Remapping columns**](./HowCanYouUseHed.md#remapping-columns) for
a discussion and links to examples of how to reorganize the information in the
columns of the event files.

<hr style="border: 3px solid #000080;" />

(as-a-data-analyst-anchor)=
## <span style="color: #229955;">As a data analyst</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... applying HED tools to answer scientific questions:</span>

Whether you are analyzing your own data or using shared data produced by others to 
answer a scientific question, fully understanding the data and its limitations are essential
for accurate and reproducible analysis.
This section discusses how HED annotations and tools can be used for effective analysis.

**Here are some topics of interest to data analysts:**

* [**Understanding the data**](understanding-the-data-anchor)
* [**Analyzing the data**](analyzing-the-data-anchor)
  * [**Factors based on columns**](factors-based-on-columns-anchor)
  * [**Factors based on experimental conditions**](factors-based-on-experimental-conditions-anchor)
  * [**Factors based on HED tags**](factors-based-on-hed-tags-anchor)

(understanding-the-data-anchor)=
### Understanding the data

Sadly, most currently shared data is under-annotated and may require considerable
work and possibly contact with the data authors for correct interpretation.

You can get a preliminary sense about what is in the data by downloading a
single event file (in BIDS `_events.tsv`) and its associated JSON sidecar
(`_events.json`). Typically, the sidecar is a single file in the root directory
of the dataset.


(analyzing-the-data-anchor)=
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

(factors-based-on-columns-anchor)=
#### Factors based on columns

(factors-based-on-experimental-conditions-anchor)=
#### Factors based on experimental conditions

(factors-based-on-hed-tags-anchor)=
#### Factors based on HED tags

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

* [**Integrating with other tools**](integrating-with-existing-tools-anchor)
* [**Developing new tools**](developing-new-tools-anchor)

(integrating-with-existing-tools-anchor)=
### Integration with existing tools

(developing-new-tools-anchor)=
### Developing new tools

(requesting-features-anchor)=
### Requesting features

(reporting-issues-anchor)=
### Reporting issues




<hr style="border: 3px solid #000080;" />

(as-a-schema-developer-anchor)=
## <span style="color: #229955;">As a schema developer</span>
> <span style="font-size: 1.5em; font-weight: bold; color: #229955; font-family: Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;">&nbsp;&nbsp;... extending HED in new directions:</span>

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
is there using the [**Standard viewer**](https://www.hedtags.org/display_hed.html) for the HED standard
schema.

The SCORE library for clinical annotation of EEG
can be viewed using the [**Score viewer**](https://www.hedtags.org/display_hed_score.html)

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

You should also read the [**HED schema development guide**](https://www.hed-resources.org/en/latest/HedSchemaDevelopmentGuide.html) to get an overview of the development process.

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
