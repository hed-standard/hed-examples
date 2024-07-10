# HED conditions and design matrices

This tutorial discusses how information from neuroimaging experiments should be
stored and annotated so that the underlying experimental design and experimental conditions
for a dataset can be automatically extracted, summarized, and used in analysis.
The mechanisms for doing this use HED (Hierarchical Event Descriptors) in conjunction
with a [BIDS](https://bids.neuroimaging.io/)
(Brain Imaging Data Structure) representation of the dataset.

This tutorial introduces tools and strategies for encoding information
about the experimental design as part of a dataset metadata
without excessive effort on the part of the researcher.
The discussion mainly focuses on categorical variables.

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
