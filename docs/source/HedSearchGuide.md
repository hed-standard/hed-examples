# HED search guide

<div style="background-color:gold;">
<span style="color:red;font-weight:bold;">UNDER CONSTRUCTION</span>
</div>


Many analysis methods locate event markers with specified properties and
extract sections of the data surrounding these markers for analysis.
This extraction process is often referred to as **epoching** the data
or sometimes **trial selection**.

Analysis may also exclude data surrounding particular event markers.

Other approaches find sections of the data with particular
signal characteristics and then determine which types of event markers 
are more likely to be associated with data sections having these characteristics.

At a more global level, analysts may want to locate datasets
whose event markers have certain properties in choosing data for
initial analysis or for comparisons with their own data.

## HED search basics

Datasets whose event markers are annotated with HED (Hierarchical Event Descriptors)
can be searched in a dataset independent manner.
The HED search facility has been implemented in the 
Python [**HEDTools**](https://pypi.org/project/hedtools/) library,
an open source Python library.
The latest versions are available in the 
[**hed-python**](https://github.com/hed-standard/hed-python) GitHub repository.

To perform a query using HEDTools,
users create a query object containing the parsed query.
Once created, this query object can then be applied to any number of HED annotations
-- say to the annotations for each event-marker associated with a data recording.

The query object returns a list of matches within the annotation.
Usually, users just test whether this list is empty or not to determine whether the query
was satisfied.

### Calling syntax

To perform a search, create a `TagExpressionParser` object, which parses the query.
Once created, this query object can be applied to search multiple HED annotations.
The syntax is demonstrated in the following example:


````{admonition} Example calling syntax for HED search.

```python
hed_string = HedString("Sensory-event, Sensory-presentation", schema=schema)
query_string = "Sensory-event"
query = TagExpressionParser(query_string)
result = query.search_hed_string(hed_string)
if result:
    print(f"{query_string} found in {str(hed_string)})
```
````

In the example the strings containing HED annotations are converted to a `HedString` object,
which is a parsed representation of the HED annotation.
The query facility assumes that the annotations have been validated.

The query is represented by a `TagExpressionParser` object.
The `search_hed_string` method returns a list of groups in the HED string that match the query.
This return list can be quite complex and usually must be filtered before being used directly.
In many applications, we are not interested in the exact groups,
but just whether the query was satisfied. 
In the above example, the `result` is treated as a boolean value.

````{warning}
- If you are searching many strings for the same expression, 
be sure to create the `TagExpressionParser` only once.
- The current search facility is case-insensitive.
````

### Single tag queries

The simplest type of query is to search for the presence of absence of a single tag.
HED offers four variations on the single tag query as summarized in the following table.

| Query type  | Example query  | Matches | Does not match |
|------------ |----------------| --------------- | ---------------- |
| **Single-term**<br/>Match the term or any child.<br/>Don't consider values or<br/>extensions when matching.| *Agent-trait* | *Agent-trait*<br/>*Age*<br/>*Age/35*<br/>*Right-handed*<br/>*Agent-trait/Glasses*<br/>*Agent-property/Agent-trait*<br/>*(Age, Blue)* |*Agent-property* |
| **Quoted-tag**<br/>Match the exact tag with<br/>extension or value | "*Age*"    | *Age*<br/>*Agent-trait/Age*  | *Age/35* |
| | "*Age/34*"    | *Age/34*<br/>*Agent-trait/Age/34*  | *Age/35* |
| **Tag-path with slash**<br/>Match the exact tag with<br/>extension or value | *Age/34*    | *Age/34* | *Age*<br/>*Age/35*<br/>*Agent-trait/Age/34* |
| **Tag-prefix with wildcard**<br/>Match the starting portion<br/>of a tag and possibly its<br/>value or extension. | <em>Age/3*</em>  | *Age/34*<br/>*Age/3*<br/>*Agent-trait/Age/34* | *Age*<br/>*Age/40*

The meanings of the different queries are explained in the following subsections.

#### Single-term search

In a single-term search, the query is a single term or node in the 
[**HED schema**](https://www.hedtags.org/display_hed.html).
The query may not contain any slashes or wildcards.

Single-term queries leverage the HED hierarchical structure,
recognizing that schema children of the query term should also satisfy the query.

The example the query in the above table is *Agent-trait*.
The full path of *Agent-trait* in the HED schema is *Property/Agent-property/Agent-trait*.
Further, the *Agent-trait* has several child nodes including: *Age*, *Agent-experience-level*,
*Gender*, *Sex*, and *Handedness*

The single-term query matches child tags without regard to tag extension or value.
Hence, *Agent-trait* matches *Age* which is a child and *Age/35* which is child with a value.
*Agent-trait*, itself, may be extended, so *Agent-trait* also matches *Agent-trait/Glasses*.
Here *Glasses* is a user-extension.

#### Quoted-tag search

If you enclose a tag-term in quotes, the search matches that tag exactly.
If you want to match a value as well, you must include that value in the quoted tag-term.
**IAN** check this --- how is this different from tag-path with slash

#### Tag-path with slash

If the query includes a slash in the tag path, then the query must match the exact value with
the slash.  Thus, *Age/34* does not match *Age* or *Age/35*.
The query does match *Agent-trait/Age/34* because the short-form of this tag-path is *Age/34*.
The tag short forms are used for the matching to assure consistency.

#### Tag-prefix with wildcard

Matching using a tag prefix with the `*` wildcard, matches the starting portion of the tag.
Thus, <em>Age/3*</em> matches *Age/3* as well as *Age/34.

Note that the query <em>Age*</em> matches a myraid of tags including *Agent*, *Agent-state*,
and *Agent-property*.

### Logical queries

In the following `A` and `B` represent arbitrary HED strings, which may contain multiple
comma separated tags and parenthesized groups.
`A` and `B` may also contain group queries as described in the next section.
The expressions for `A` and `B` are each evaluated and then combined using standard logic.

| Query form | Example query        | Matches | Does not match |
|------------|----------------------|----------------| --------------- | 
| **`A`, `B`**<br/>Match if both `A` and `B`<br/>are matched. | *Event*, *Sensory-event* | *Event*, *Sensory-event*<br/>*Sensory-event*, *Event*<br/>(*Event*, *Sensory-event*) | *Event*   |
| **`A` and `B`**<br/>Match strings or groups<br/>with both `A` and `B`.  |   |     |
| **`A` or `B`**<br/>Match strings or groups<br/>with either `A` or `B`. |   |     |
| **~`A`**<br/>Match strings that do<br/>not contain `A`<br/>Note: not what you think. |   |     |    |
| **@`A`**<br/>Match a line that does not contain `A`. |   |    |     |

**Ian:** please fill in the examples.
Also, what does `A` and `B` return?

### Group queries

Tag grouping with parentheses is an essential part of HED annotation since HED strings are
independent of ordering of tags or tag groups at the same level.

Thus, tools have no way of distinguishing which color goes with which shape in the annotation *Red*, *Square*, *Blue, *Triangle*. Annotators must group tags using parentheses to make the meaning clear:
(*Red*, *Square*), (*Blue, *Triangle*).  Group queries allow analysts to detect these groupings.

| Query form | Example query        | Matches | Does not match |
|------------|----------------------|----------------| --------------- |
| **[[`A`, `B`]]**<br/>Match a group that<br/>contains both `A` and `B`<br/>at the same level<br/>in the same group. | *[[Red, Blue]]* | *(Red, Blue)*<br/>*(Red, Blue, Green)* | *(Red, (Blue, Green))*  |
| **[`A`, `B`]** <br/> Match a group that<br/>contains `A` and `B`.<br/> Both `A` and `B` could<br/>be any subgroup level. | *[Red, Blue]* |*(Red, (Blue, Green))*<br/>*((Red, Yellow), (Blue, Green))*| *Red, (Blue, Green)* |
                

These operations (including exact, containing, and logical groups) can be
arbitrarily nested and combined, as for example in the query:

> *[`A` or [[`B` and `C`]] ]*

Ordering on either the search terms or strings to be searched doesn't matter unless it will impact
precedence on the expression.  Use logical grouping with parentheses if you aren't sure.

Precedence is purely left to right outside of grouping operations.
Thus, unlike many traditional programming languages, **and** does not take precedence over **or**.
This may change in the future.

### Notations under discussion

Some more advanced wild card searches are also under discussion. 

| Query form | Example query  | Matches | Does not match |
|----------- |--------------- |-------- | ---------|
| **[[`A`, ?]]** <br/>Match a group with `A`<br/>and any tag or subgroup. |    |     |
| **[[`A`, ??]]** <br/>Match a group with `A`<br/> and any tag. |  |    |
| **[[`A`, ???]]** <br/>Match a group with `A`<br/> and any subgroup.  |   |   |
| **{`A`}** <br/>Match a group or string<br/> with `A` and nothing else. |    |  |


    Note: {} notation does NOT require a group.

    {A} would match "A" or "(A)" or "B, (A)"
    [{A}] would match "(A)" or "B, (A)"

---

    Note: Adding a wildcard to a search will automatically make whatever group it's found in an "exact group"<br>
    e.g.: Query: A ?
    This would match: 
        1. A, B
        2. (A, B)
        3. A, (B)
        4. (A, (B))
    But NOT:
        1. (A), B
          This is because once A is found, there needs to be wildcard group or tag at the same level.
                     
    Note: Wildcards should be as late in a search as possible for efficency.  eg "A and ?" rather than "? and A"

### Wildcards
    Wildcards are supported under the new system.  They mostly make sense in containing groups.  They can be mixed and matched,
    e.g: [[A or B and ??? and ??]]
    Meaning: Find a group containing tag A or tag B, while also containing another unrelated tag and another unrelated group.
    
### Search Term Wildcards
Term search - Checks all parent terms in the tags searched as well, does not interact with extensions of values in any way.
Tag search - Finds tags where the short form IS the indicated search string, unless it has a wildcard.(any search term with a "/" or a "*" or wrapped in double quotes turns it into a tag search)

Examples:
1. Orange : would be a TERM search, finding the children as well since Orange is a term in any children of orange.
2. Orange/* : Would be a TAG search, finding any Orange tags that have an extension or value
3. Orange/2*: Would be a TAG search, finding any Orange tags that have an extension or value beginning with 2.
4. Orange* : would be a TAG search, but the wildcard would have it find the children too.
    This would additionally find any potentially completely unrelated tags that start with Orange in short form.  Say "OrangeTheFruit"
5. "Orange":  would be a TAG search, with no extensions allowed due to the quotes.
    The entire short form of the tag must be "Orange" and nothing else.

### Updated search:
Query: Event and Sensory-event<br>
String being searched: Sensory-event<br>
#### Old System
    In the old system this would match.  It would first find an Event tag, matching Sensory-event.  It would then find a Sensory-event tag, also matching Sensory-event.
    It did not care it was matching the same tag twice.

#### New System
    Once it matches a tag, it "consumes" the tag and marks it as used.  
    So it would find Event, then be unable to match Sensory-event as there were no tags left.
    
<hr/>

<hr/>
<div style="background-color:gold;">
<span style="color:red;font-weight:bold;">Examples not for discussion---under revision.</span>
</div>

## Example queries

https://github.com/hed-standard/hed-examples/tree/main/datasets/eeg_ds003654s_hed <br>
These strings are used in the basic examples.

| #   | Line     |
|-----|-----------|
| 1   | *Experiment-structure,(Def/Right-sym-cond,Onset),<br/>(Def/Initialize-recording,Onset)   |
| 2   | Sensory-event,Experimental-stimulus,(Def/Face-image,Onset),(Def/Blink-inhibition-task,Onset),(Def/Fixation-task,Onset),Def/Scrambled-face-cond,Def/First-show-cond,Experimental-trial/1,(Image,Pathname/s096.bmp)                         |
| 3   | Sensory-event,(Intended-effect,Cue),(Def/Circle-only,Onset),(Def/Face-image,Offset),(Def/Blink-inhibition-task,Offset),(Def/Fixation-task,Offset),Experimental-trial/1,(Image,Pathname/circle.bmp)                                        |
| 4   | Sensory-event,(Intended-effect,Cue),(Def/Cross-only,Onset),(Def/Fixation-task,Onset),(Def/Circle-only,Offset),Experimental-trial/2,(Image,Pathname/cross.bmp)                                                                             |
| 5   | Sensory-event,Experimental-stimulus,(Def/Face-image,Onset),(Def/Blink-inhibition-task,Onset),(Def/Cross-only,Offset),Def/Famous-face-cond,Def/First-show-cond,Experimental-trial/2,(Image,Pathname/f148.bmp)                              |
| 6   | Agent-action,Participant-response,Def/Press-right-finger,Experimental-trial/2                                                                                                                                                             |
| 7   | Sensory-event,(Intended-effect,Cue),(Def/Circle-only,Onset),(Def/Face-image,Offset),(Def/Blink-inhibition-task,Offset),(Def/Fixation-task,Offset),Experimental-trial/2,(Image,Pathname/circle.bmp)                                        |
| 8   | Sensory-event,(Intended-effect,Cue),(Def/Cross-only,Onset),(Def/Fixation-task,Onset),(Def/Circle-only,Offset),Experimental-trial/3,(Image,Pathname/cross.bmp)                                                                             |
| 9   | Sensory-event,Experimental-stimulus,(Def/Face-image,Onset),(Def/Blink-inhibition-task,Onset),(Def/Cross-only,Offset),Def/Famous-face-cond,Def/Immediate-repeat-cond,Experimental-trial/3,(Face,Item-interval/1),(Image,Pathname/f148.bmp) |
| 10  | Agent-action,Participant-response,Def/Press-right-finger,Experimental-trial/3                                                                                                                                                             |

### Basic query examples

| Query  | Meaning  | Lines matching  | Explanation/Notes  |
|------- |----------|-----------|------------|
| Experiment-structure   | Match *Experiment-structure* the term  | [1]  | The tag is only on line 1                                                                                 |
| Event   | Find lines with Event term  | [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] | Finds every line as the first<br/>tag in each line is<br/> inherited from Event                               |
| Image, Pathname/f148.bmp   | Find lines with term *Image*<br/> or any of its child terms<br/> and the exact tag *Pathname/f148.bmp*  | [5, 9]    | Match *Pathname/f148.bmp* and *Image*.  |
| Image and ~Pathname/f148.bmp  | Match *Image* but without the exact<br/> tag *Pathname/f148.bmp* | [2, 3, 4, 7, 8]  | Lines 5 and 9 contain *Pathname/f148.bmp*  |
| Pathname/circle.bmp or Pathname/cross.bmp | Match either exact tag *Pathname/circle.bmp* or *Pathname/cross.bmp* | [3, 4, 7, 8]   |         |
| Def/Cross-only, Onset  |Match the exact tag *Def/Cross-only*<br/> and the term *Onset*   | [4, 5, 8, 9]                    | Matches every line with *Def/Cross-only*<br/> because it isn't checking if the <br/> *Onset* tag is in the same group. |

### Group query examples

| Query    | Meaning     | Lines matching | 
|----------|-------------|----------------|
| [Def/Cross-only, Onset]  | Match exact tag *Def/Cross-only* and<br/> the term *Onset* in the same group or subgroup. | [4, 8]   |
 | [Def/Cross-only, Onset] and Experimental-trial/3   | Same as previous, but now the line must also<br/> contain *Experimental-trial/3*  | [8]    | 
| [[Def/Cross-only, Onset]]  | Match the exact tag *Def/Cross-only* and<br/> the term *Onset* in the exact same group. | [4, 8]    | 
 | [[Def/Cross-only, Onset]] and Experimental-trial/3 | Same as previous, but now the line must also<br/> contain *Experimental-trial/3*  | [8]  | 


### Complex query examples

Here are some slightly more complex queries and example results from searching simple strings.  These examples are more contrived than those above to show group searching abilities.

Expression: **"(Item or Agent) and [[Action or Event]]"**<br>
Meaning: Find a line that contains Item or Agent anywhere, and also contains a subgroup somewhere containing an Action or Event.

| Query | String   | Result | Notes  |
| ----- | -------- | ------ |--------|
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

| Search String   | Expression  | Result | Notes   |
|----------------|------------|--------|--------|
| '((Event),(Clear-throat))'   | "[[ [Event]], [Action] ]]" | True   | This is the most basic example perfectly mirroring the search string.                                                                 |
| '(Clear-throat,Event)'       | "[[ [Event]], [Action] ]]" | False  | This is not found because the two pairs of double brackets require at least one nested subgroup.                                      |
| '((Event),((Clear-throat)))' | "[[ [Event]], [Action] ]]" | True   | This is now found as the single brackets don't require it to be a direct child.                                                       |
| '((Clear-throat,Event))'     | "[[ [Event]], [Action] ]]" | True   | This is found due to a quirk in the searching.  It does not strictly require [[Event]] and [[Action]] to be in separate child groups. |

Expression: **"[[ [[~Event]] ]]"**<br>
Meaning: Find a group containing a direct child group that does not contain Event.

| Search String   | Expression         | Result | Notes     |
|-----------------|--------------------|--------|-----------|
| '(Clear-throat,Event)'       | "[[ [[~Event]] ]]" | False  | This is not found as the group has no subgroups.                             |
| '((Clear-throat),(Event))'   | "[[ [[~Event]] ]]" | True   | This is found because one of the subgroups does not contain Event            |
| '((Event))'                  | "[[ [[~Event]] ]]" | False  | This is not found because the only subgroup contains Event                   |
| '(((Clear-throat)),(Event))' | "[[ [[~Event]] ]]" | True   | This is found because the ((Clear-throat)) subgroup does not contain Event   |
| '((Clear-throat,Event))'     | "[[ [[~Event]] ]]" | False  | This is not found because the child subgroup contains Clear-throat and Event |


## Where can HED search be used?

The HED search facility allows users to form sophisticated queries 
based on HED annotations in a dataset-independent manner.
These queries can be used to locate data sets satisfying the specified criteria
and to find the relevant event markers in that data.

For example, the [**factor_hed_tags**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html#factor-hed-tags) 
operation of the HED [**file remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html)
creates factor vectors for selecting events satisfying general HED queries.

The [**HED-based epoching**](https://www.hed-resources.org/en/latest/HedMatlabTools.html#hed-based-epoching) tools in [**EEGLAB**](https://sccn.ucsd.edu/eeglab/index.php) 
can use HED-based search to epoch data based on HED tags.

Work is underway to integrate HED-based search into other tools including
[**Fieldtrip**](https://www.fieldtriptoolbox.org/) and 
[**MNE-python**](https://mne.tools/stable/index.html) 
as well into the analysis platforms [**NEMAR**](https://nemar.org/) and
[**EEGNET**](http://eegnet.org/)
