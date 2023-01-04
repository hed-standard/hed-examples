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

## Syntax

| Token      | Meaning                       | Example        | Example Meaning                                                                             |
|------------|-------------------------------|----------------|---------------------------------------------------------------------------------------------|
| Term       | A base tag tag to search for  | Event          | Find strings that contain an Event tag, or any child tag of Event                           |
| Full Tag   | A tag with extension or value | Def/Def1       | Find strings that contain the exact tag Def/Def1.                                           |
| ,          | and                           | A, B           | Find strings or groups with both A and B                                                    |
| and        | and                           | A and B        | Find strings or groups with both A and B                                                    |
| or         | or                            | A or B         | Find strings or groups with either A or B                                                   |
| [[         | Exact group start             | [[A, B]]       | Find a group that contains both A and B.                                                    |
| ]]         | Exact group end               |                | eg "(A, B)" or "(A, B, C)"                                                                  |
| [          | Containing group start        | [A, B]         | Find a group that contains A and B, but both A and B could be any levels of subgroups down. |
| ]          | Containing group end          |                | eg "(A, B)" or "(A, (B, C))"                                                                |
| (          | Logical group Start           | A or (B and C) | Logically group operations to override precedence                                           |
| )          | Logical group End             |                | Find string with A or both B and C.                                                         |
| ~          | Negate                        | ~A             | Find lines that do not contain A                                                            |

These operations(including exact, containing, and logical groups) can be arbitrarily nested and combined.  e.g. "[A or ~[[B or C]] ]"

Ordering on either the search terms or strings to be searched doesn't matter unless it will impact precedence on the expression.  Use logical grouping if you aren't sure.

Precedence is purely left to right outside of grouping operations.  This may change in the future.

## Example Basic Search Strings
https://github.com/hed-standard/hed-examples/tree/main/datasets/eeg_ds003654s_hed <br>
These strings are used in the basic examples.

| #   | Line                                                                                                                                                                                                                                      |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | Experiment-structure,(Def/Right-sym-cond,Onset),(Def/Initialize-recording,Onset)                                                                                                                                                          |
| 2   | Sensory-event,Experimental-stimulus,(Def/Face-image,Onset),(Def/Blink-inhibition-task,Onset),(Def/Fixation-task,Onset),Def/Scrambled-face-cond,Def/First-show-cond,Experimental-trial/1,(Image,Pathname/s096.bmp)                         |
| 3   | Sensory-event,(Intended-effect,Cue),(Def/Circle-only,Onset),(Def/Face-image,Offset),(Def/Blink-inhibition-task,Offset),(Def/Fixation-task,Offset),Experimental-trial/1,(Image,Pathname/circle.bmp)                                        |
| 4   | Sensory-event,(Intended-effect,Cue),(Def/Cross-only,Onset),(Def/Fixation-task,Onset),(Def/Circle-only,Offset),Experimental-trial/2,(Image,Pathname/cross.bmp)                                                                             |
| 5   | Sensory-event,Experimental-stimulus,(Def/Face-image,Onset),(Def/Blink-inhibition-task,Onset),(Def/Cross-only,Offset),Def/Famous-face-cond,Def/First-show-cond,Experimental-trial/2,(Image,Pathname/f148.bmp)                              |
| 6   | Agent-action,Participant-response,Def/Press-right-finger,Experimental-trial/2                                                                                                                                                             |
| 7   | Sensory-event,(Intended-effect,Cue),(Def/Circle-only,Onset),(Def/Face-image,Offset),(Def/Blink-inhibition-task,Offset),(Def/Fixation-task,Offset),Experimental-trial/2,(Image,Pathname/circle.bmp)                                        |
| 8   | Sensory-event,(Intended-effect,Cue),(Def/Cross-only,Onset),(Def/Fixation-task,Onset),(Def/Circle-only,Offset),Experimental-trial/3,(Image,Pathname/cross.bmp)                                                                             |
| 9   | Sensory-event,Experimental-stimulus,(Def/Face-image,Onset),(Def/Blink-inhibition-task,Onset),(Def/Cross-only,Offset),Def/Famous-face-cond,Def/Immediate-repeat-cond,Experimental-trial/3,(Face,Item-interval/1),(Image,Pathname/f148.bmp) |
| 10  | Agent-action,Participant-response,Def/Press-right-finger,Experimental-trial/3                                                                                                                                                             |

## Basic queries

| Query                                       | Meaning                                                                            | Lines matching                  | Explanation/Notes                                                                                         |
|---------------------------------------------|------------------------------------------------------------------------------------|---------------------------------|-----------------------------------------------------------------------------------------------------------|
| "Experiment-structure"                      | Find lines with Experiment-structure term                                          | [1]                             | The tag is only on line 1                                                                                 |
| "Event"                                     | Find lines with Event term                                                         | [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] | This finds every line as the first tag in each line is inherited from Event                               |
| "Image, Pathname/f148.bmp"                  | Find lines with term Image, and the exact tag Pathname/f148.bmp                    | [5, 9]                          | Only lines 5 and 9 contain the Pathname/f148.bmp and both lines contain Image                             |
| "Image and ~Pathname/f148.bmp"              | Find lines with term Image, and they must not have the exact tag Pathname/f148.bmp | [2, 3, 4, 7, 8]                 | This excludes lines 5 and 9 as they contain Pathname/f148.bmp                                             |
| "Pathname/circle.bmp or Pathname/cross.bmp" | Find lines with either exact tag circle.bmp or cross.bmp                           | [3, 4, 7, 8]                    |                                                                                                           |
| "Def/Cross-only, Onset"                     | Find all lines with the exact tag Def/Cross-only and the term Onset                | [4, 5, 8, 9]                    | This finds every line with Def/Cross-only because it isn't checking if the Onset tag is in the same group |

## Queries based on groups

| Query                                                | Meaning                                                                                     | Lines matching | Explanation/Notes                                                                              |
|------------------------------------------------------|---------------------------------------------------------------------------------------------|----------------|------------------------------------------------------------------------------------------------|
| "[Def/Cross-only, Onset]"                            | Find all lines with the exact tag Def/Cross-only and the term Onset in the same subgroup    | [4, 8]         | This now only includes lines that contain both Def/Cross-only and Onset in the same subgroup.  |
 | "[Def/Cross-only, Onset] and Experimental-trial/3"   | Same as previous, but now the line must also contain Experimental-trial/3                   | [8]            | This further narrows the results                                                               |
| "[[Def/Cross-only, Onset]]"                          | Find all lines with the exact tag Def/Cross-only and the term Onset in the exact same group | [4, 8]         | This would no longer include cases where Def/Cross-only is in a subgroup below the onset group |
 | "[[Def/Cross-only, Onset]] and Experimental-trial/3" | Same as previous, but now the line must also contain Experimental-trial/3                   | [8]            | Further narrow previous result as the line must now include Experimental-trial/3               |


## Complex queries

Here are some slightly more complex queries and example results from searching simple strings.  These examples are more contrived than those above to show group searching abilities.

Expression: **"(Item or Agent) and [[Action or Event]]"**<br>
Meaning: Find a line that contains Item or Agent anywhere, and also contains a subgroup somewhere containing an Action or Event.

| Search String           | Expression                                | Result | Notes                                                                                       |
|-------------------------|-------------------------------------------|--------|---------------------------------------------------------------------------------------------|
| "(Clear-throat),Item"   | "(Item or Agent) and [[Action or Event]]" | True   |                                                                                             |
| "((Clear-throat),Item)" | "(Item or Agent) and [[Action or Event]]" | True   |                                                                                             |
| "Clear-throat,Item"     | "(Item or Agent) and [[Action or Event]]" | False  | This is not found as the [[Action or Event]] part means the event term must be in a group.  |
| "Clear-throat,Agent"    | "(Item or Agent) and [[Action or Event]]" | False  | This is not found as the [[Action or Event]] part means the event term must be in a group.  |
| 'Agent,Event'           | "(Item or Agent) and [[Action or Event]]" | False  | This is not found as the [[Action or Event]] part means the event term must be in a group.  |
| 'Agent,(Event)'         | "(Item or Agent) and [[Action or Event]]" | True   |                                                                                             |
| (Event),(Item)'         | "(Item or Agent) and [[Action or Event]]" | True   | This is found as the (Item or Agent) part can be anywhere in the string, including a group. |

Expression: **"[[ [[Event]], [[Action]] ]]"**<br>
Meaning: Find a group that has a direct child subgroup containing Event, and a direct child subgroup containing Action.

| Search String                | Expression                    | Result | Notes                                                                                                                                 |
|------------------------------|-------------------------------|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| '((Event),(Clear-throat))'   | "[[ [[Event]], [[Action]] ]]" | True   | This is the most basic example perfectly mirroring the search string.                                                                 |
| '(Clear-throat,Event)'       | "[[ [[Event]], [[Action]] ]]" | False  | This is not found because the two pairs of double brackets require at least one nested subgroup.                                      |
| '((Event),((Clear-throat)))' | "[[ [[Event]], [[Action]] ]]" | False  | This is not found because the Clear-throat subgroup is not a direct child of the group containing (Event)                             |
| '((Clear-throat,Event))'     | "[[ [[Event]], [[Action]] ]]" | True   | This is found due to a quirk in the searching.  It does not strictly require [[Event]] and [[Action]] to be in separate child groups. |

Expression: **"[[ [Event], [Action] ]]"**<br>
Meaning: Find a group that has a descendant subgroup containing Event, and a descendant subgroup containing Action

| Search String                | Expression                 | Result | Notes                                                                                                                                 |
|------------------------------|----------------------------|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| '((Event),(Clear-throat))'   | "[[ [Event]], [Action] ]]" | True   | This is the most basic example perfectly mirroring the search string.                                                                 |
| '(Clear-throat,Event)'       | "[[ [Event]], [Action] ]]" | False  | This is not found because the two pairs of double brackets require at least one nested subgroup.                                      |
| '((Event),((Clear-throat)))' | "[[ [Event]], [Action] ]]" | True   | This is now found as the single brackets don't require it to be a direct child.                                                       |
| '((Clear-throat,Event))'     | "[[ [Event]], [Action] ]]" | True   | This is found due to a quirk in the searching.  It does not strictly require [[Event]] and [[Action]] to be in separate child groups. |

Expression: **"[[ [[~Event]] ]]"**<br>
Meaning: Find a group containing a direct child group that does not contain Event.

| Search String                | Expression         | Result | Notes                                                                        |
|------------------------------|--------------------|--------|------------------------------------------------------------------------------|
| '(Clear-throat,Event)'       | "[[ [[~Event]] ]]" | False  | This is not found as the group has no subgroups.                             |
| '((Clear-throat),(Event))'   | "[[ [[~Event]] ]]" | True   | This is found because one of the subgroups does not contain Event            |
| '((Event))'                  | "[[ [[~Event]] ]]" | False  | This is not found because the only subgroup contains Event                   |
| '(((Clear-throat)),(Event))' | "[[ [[~Event]] ]]" | True   | This is found because the ((Clear-throat)) subgroup does not contain Event   |
| '((Clear-throat,Event))'     | "[[ [[~Event]] ]]" | False  | This is not found because the child subgroup contains Clear-throat and Event |

## Implementation 

Searching is handled similar to regular expressions.  You create a TagExpressionParser then use it to search individual HedString objects one by one.

```
hed_string = HedString(..., schema=schema)
expression_string = "Experiment-structure"
expression = TagExpressionParser(expression_string)
result = expression.search_hed_string(hed_string)
```

Notes: If you're searching many strings for the same expression, make sure you create the TagExpressionParser only once.<br>
search_hed_string returns a list of groups your expression is found in.  Treat the result as a bool unless you're interested in the exact groups.
