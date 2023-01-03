# HED search guide

**Under construction**

Many analysis methods locate event markers with specified properties and
extract sections of the data surrounding these markers for analysis.
Other approaches locate particular sections of the data with particular
signal characteristics in order to identify whether particular types of event markers 
are more likely to be associated with data sections having these characteristics.

At a more global level, analysts may want to locate datasets
whose event markers have certain properties in choosing datasets for
initial analysis or to compare with their own data.

## Where can HED search be used?
The HED search facility allows users to form sophisticated queries in a dataset-independent manner.
These queries can be used to locate data sets satisfying the specified criteria
and to find the relevant event markers in the data.

For example, the [**factor_hed_tags**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html#factor-hed-tags) 
operation of the HED [**file remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html)
creates factor vectors for selecting events satisfying general HED queries.

The [**HED-based epoching**](https://www.hed-resources.org/en/latest/HedMatlabTools.html#hed-based-epoching) tools in [**EEGLAB**](https://sccn.ucsd.edu/eeglab/index.php) 
can use HED-based search to epoch data based on HED tags.

Work is underway to integrate HED-based search into other tools including
[**Fieldtrip**](https://www.fieldtriptoolbox.org/) and 
[**MNE-python](https://mne.tools/stable/index.html) 
as well as the analysis platforms [**NEMAR**](https://nemar.org/) and
[**EEGNET**](http://eegnet.org/)

See bottom for the strings being searched.

## Syntax

| Token | Meaning                | Example        | Example Meaning                                              |
|-------|------------------------|----------------|--------------------------------------------------------------|
| ,     | and                    | A, B           | Find strings or groups with both A and B                     |
| and   | and                    | A and B        | Find strings or groups with both A and B                     |
| or    | or                     | A or B         | Find strings or groups with either A or B                    |
| [[    | Exact group start      | [[A, B]]       | Find a group that contains both A and B.                     |
| ]]    | Exact group end        |                | eg "(A, B)" or "(A, B, C)"                                   |
| [     | Containing group start | [A, B]         | Find a group that contains A and B, but it could be a child. |
| ]     | Containing group end   |                | eg "(A, B)" or "(A, (B, C))"                                 |
| (     | Logical Group Start    | A or (B and C) | Logically group operations to override precedence            |
| )     | Logical Group End      |                | Find string with A or both B and C.                   |
| ~     | Negate                 | ~(A, B)        | Find all groups that do not contain both A and B             |

Tag searching contains two modes.

- **Mode 1("terms")**:You can search for any tag, and you will find it as well as any child tags of it.

- **Mode 2("exact")** You can search for exact tags.  This is currently required if you wish to search extensions or values.

Example searches are mode 2 unless otherwise specified. How is mode specified?  
Could we expand the description of the different modes and what they mean?

## Search rules:

The following things need to be clarified:

1. The group search criteria should be satisfied regardless of the order the tags appear in the query.
2. The search criteria is case-insensitive.
3. We need criteria that allow additional tags in the group rather than exact groups.
4. We need to incorporate wild-cards in search.  For example [[A, B, *]] might be a possible syntax
for a tag group that has A, B and any other tags in it.


What are the rules?

## Query examples

The following table of sample queries illustrate the basic HED query features. 

````{admonition} Example HED queries illustrating HED query features.

| Query string | Mode  | Explanation  | Matching  | 
| ----- | ----- | -------- | --------------- |
| Experiment-structure  | Exact | Find *Experiment-structure tag.<br/>The tag is only in string 1.  | [1]  |
| Image, Pathname/f148.bmp       | Exact | Find both  *Image* and *Pathname*.<br/>Only strings #5 and #9 contain *Pathname/f148.bmp*<br/> and both strings contain *Image*.   | [5, 9]  |
| Image and ~Pathname/f148.bmp | Exact | Find  *Image*, and no Pathname<br/> or pathname except *f148.bmp*.<br/>This excludes strings 5 and 9 as they<br/>contain *Pathname/f148.bmp*. | [2, 3, 4, 7, 8]  |
| Experiment-structure | Terms | Find *Experiment-structure tag*<br/> or any of it's children.<br/>The tag is only in string 1. | [1] |                                                       |
| Image, Pathname/f148.bmp  | Terms | Find terms *Image*, and *Pathname/f148.bmp*.<br/>Pathname/f148.bmp* is not a schema term,<br/> and this will find no strings. | []  |
| Image and ~Pathname/f148.bmp   | Terms | Find term *Image*, and not term *Pathname/f148.bmp*.<br/>This finds every string with *Image*,<br/>because *Pathname/f148.bmp* is not a term. | [2, 3, 4, 5, 7, 8, 9] |
| Image and Pathname | Terms | Find terms *Image* and *Pathname*.<br/>This finds *Image*, because *Pathname* is in every string with *Image*. | [2, 3, 4, 5, 7, 8, 9] | 
| Image and ~Pathname | Terms | Find terms *Image*, but not the term *Pathname*.<br/>No strings are found because every string<br/> containing *Image* also contains *Pathname*.  | [] | 
````

The **Matching** column list indicates which strings in the following table
of sample HED strings match the query.

````{admonition} Test HED strings used to illustrate queries.
| #   | String   |
| ----- | ------- |
| 1   | *Experiment-structure, (Def/Right-sym-cond, Onset), (Def/Initialize-recording, Onset)*  |
| 2   | *Sensory-event, Experimental-stimulus, (Def/Face-image, Onset), (Def/Blink-inhibition-task, Onset),*<br/>*(Def/Fixation-task, Onset), Def/Scrambled-face-cond, Def/First-show-cond,*<br/>*Experimental-trial/1, (Image,Pathname/s096.bmp)* |
| 3   | *Sensory-event, (Intended-effect, Cue),(Def/Circle-only, Onset), (Def/Face-image, Offset),*<br/>*(Def/Blink-inhibition-task, Offset), (Def/Fixation-task, Offset),*<br/>*Experimental-trial/1, (Image, Pathname/circle.bmp)* |
| 4   | *Sensory-event, (Intended-effect, Cue), (Def/Cross-only, Onset), (Def/Fixation-task,Onset),*<br/>*(Def/Circle-only, Offset),Experimental-trial/2, (Image, Pathname/cross.bmp)* |
| 5   | *Sensory-event, Experimental-stimulus, (Def/Face-image, Onset), (Def/Blink-inhibition-task, Onset),*<br/>*(Def/Cross-only, Offset), Def/Famous-face-cond, Def/First-show-cond,*<br/>*Experimental-trial/2, (Image, Pathname/f148.bmp)*  |
| 6   | *Agent-action, Participant-response, Def/Press-right-finger, Experimental-trial/2* |
| 7   | *Sensory-event, (Intended-effect, Cue), (Def/Circle-only, Onset), (Def/Face-image, Offset),*<br/>*(Def/Blink-inhibition-task, Offset), (Def/Fixation-task, Offset),*<br/>*Experimental-trial/2, (Image, Pathname/circle.bmp)* |
| 8   | *Sensory-event, (Intended-effect, Cue), (Def/Cross-only, Onset), (Def/Fixation-task, Onset),*<br/>*(Def/Circle-only, Offset), Experimental-trial/3,*<br/>*(Image, Pathname/cross.bmp)*  |
| 9   | *Sensory-event, Experimental-stimulus, (Def/Face-image, Onset),*<br/>*(Def/Blink-inhibition-task, Onset), (Def/Cross-only, Offset),*<br/>*Def/Famous-face-cond, Def/Immediate-repeat-cond, Experimental-trial/3,*<br/>*(Face, Item-interval/1), (Image, Pathname/f148.bmp)* |
| 10  | *Agent-action, Participant-response, Def/Press-right-finger, Experimental-trial/3* |
````

The sample strings are actual examples of assembled strings from the 
[**Face processing**](https://github.com/hed-standard/hed-examples/tree/main/datasets/eeg_ds003654s_hed)
sample dataset.
The full dataset [**ds003654**](https://openneuro.org) is available on openneuro.org.

## Implementation 

Put in first draft here describing the syntax of calls and expression parser.


## Features under discussion