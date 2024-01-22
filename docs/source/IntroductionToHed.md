(introduction-to-hed-anchor)=
# Introduction to HED

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
HED was originally proposed by Nima Bigdely-Shamlo in 2010 to support
annotation in [HeadIT](https://headit.ucsd.edu), 
an early public repository for EEG data hosted by the 
Swartz Center for Computational Neuroscience, UCSD (Bigdely-Shamlo et al. 2013).
HED has undergone several revisions and substantial infrastructure development since that time.

### HED generation 1

The first version of Hierarchical Event Descriptors was released in 2010
to support annotation of events for
 [**HeadIt**](https://headit.ucsd.edu/) an open repository of EEG datasets. 
The work was initiated as part of the PhD thesis of Nima Bigdely-Shamlo 
under the supervision of Scott Makeig and Kenneth Kreutz-delgado.
HED Generation 1 (HED version < 4.0.0) was organized around a 
single event hierarchy with root *Time-Locked Event* and 
immediate children *Stimulus* and *Response*.

### HED generation 2
In 2010, the Army Research Laboratory funding a multi-institution 
neuroergonomics project whose focus was to instrument the brain and 
body at work (ARL W911NF-10-2-0022). 
The project included the development of a repository
[**https://cancta.net**](https://cancta.net) of data collected 
using a standardized format [**EEG Study Schema (ESS)**](https://www.nitrc.org/projects/ess/)
to enable data sharing and cross-study analysis. 

A working group was formed to redesign HED to accommodate the vocabulary
needed to annotate the greater variety of datasets.
Recognizing the need for orthogonality in the vocabulary,
the working group redesigned HED as a sub-tag system.
Validators and online tools were developed to support HED.
HED generation 2 (versions 4.0.0 < 8.0.0) was first released in 2016
and iteratively improved over the next several years.
The [BIDS (Brain Imaging Data Structure)](https://bids.neuroimaging.io/) standards
group incorporated HED as annotation mechanism in 2019.

### HED generation 3

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
See the [**HED Specification**](https://hed-specification.readthedocs.io/en/latest/)
and the [**documentation summary**](DocumentationSummary.md) for additional details.

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

````{admonition} Goals of HED.
:class: tip

1. **Document the exact nature of events** (sensory, behavioral, environmental, and other) that occur during recorded time series data in order to inform data analysis and interpretation.
2. **Describe the design of the experiment** including participant task(s).
3. **Relate event occurrences** both to the experiment design and to participant tasks and experience.
4. **Provide basic infrastructure** for building and using machine-actionable tools to systematically analyze data associated with recorded events in and across data sets, studies, paradigms, and modalities.
````

Current systems in neuroimaging experiments do not record events beyond simple numerical (3)
or text (Event type Target) labels whose more complete and precise meanings are known
only to the experimenter(s). 

A central goal of HED is to enable building of archives of brain imaging data in an
amenable to large scale analysis, both within and across studies.
Such event-related analysis requires that the nature(s) of the recorded events
be specified in a common language.

The HED project seeks to formalize the development of this language,
to develop and distribute tools that maximize its ease of use,
and to inform new and existing researchers of its purpose and value.

## A basic HED annotation

HED annotations are comma-separated lists of tags selected from a HED schema.
(Use the [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html) to explore the available tags).

````{admonition} A simple HED annotation of presentation of a face image stimulus.

Sensory-event</em>, <em>Experimental-stimulus</em>, (<em>Visual-presentation</em>, (<em>Image</em>, <em>Face</em>, <em>Hair</em>)),
(<em>Image</em>, <em>Pathname/f032.bmp</em>), <em>Condition-variable/Famous-face</em>, <em>Condition-variable/Immediate-repeat</em> 
````
The annotation above is a very basic annotation of an event marker representing the
presentation of a face image with hair.
The event marker represents an experimental stimulus with two
experimental conditions *Famous-face* and *Immediate-repeat* in effect.

Because HED has a structured vocabulary,
other researchers use the same terms, making it easier to compare experiments.
Further, the HED infrastructure supports associating of these annotation strings
with the actual event markers during processing,
allowing tools to locate event markers using experiment-independent strategies.

The annotation in the example uses the most basic strategy for annotating
condition variables --- just naming the different conditions.
However, even this simple strategy allows tools to distinguish among events
taken under different task conditions.
HED also provides more advanced strategies that allow downstream tools to
automatically extract dataset-independent design matrices.

Every term in the HED structured vocabulary (HED schema) must be unique,
allowing users to use a single word for each annotation tag.
Tools can expand into their full paths within the HED schema,
allowing tools to leverage hierarchical relationships during searching.

````{admonition} An equivalent long-form HED annotation of face image stimulus from above.

<em>Event/<b>Sensory-event</b></em>,  
<em>Property/Task-property/Task-event-role/<b>Experimental-stimulus</b></em>,  
(<em>Property/Sensory-property/Sensory-presentation/<b>Visual-presentation</b></em>,  
(<em>Item/Object/Man-made-object/Media/Visualization/<b>Image</b></em>,  
<em>Item/Biological-item/Anatomical-item/Body-part/Head/<b>Face</b></em>,  
<em>Item/Biological-item/Anatomical-item/Body-part/Head/<b>Hair</b></em>)),  
(<em>Item/Object/Man-made-object/Media/Visualization/<b>Image</b></em>,  
<em>Property/Informational-property/Metadata/<b>Pathname/f032.bmp</b></em>),  
<em>Property/Organizational-property/<b>Condition-variable/Famous-face</b></em>,  
<em>Property/Organizational-property/<b>Condition-variable/Immediate-repeat</b></em>
````
HED is also extensible, in that most nodes can be extended to include more specific terms.
HED also permits [**library schema**](https://github.com/hed-standard/hed-schema-library),
which are specialized vocabularies.
HED tools support seamless annotations that include both terms from the base schema and
from specialized, discipline-specific vocabularies.

## How to get started

The [**HED annotation quickstart**](HedAnnotationQuickstart.md#hed-annotation-quickstart)
provides a simple step-by-step guide to doing basic HED annotation,
while the [**Bids annotation quickstart**](BidsAnnotationQuickstart.md#bids-annotation-quickstart)
introduces the various types of annotation that should be included in a BIDS
([**Brain Imaging Data Structure**](https://bids-specification.readthedocs.io/en/stable/)) dataset.
This tutorial also includes instructions for using the online tools to
start the annotation process.
