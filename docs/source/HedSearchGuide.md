# HED search guide

Many analysis methods locate event markers with specified properties and
extract sections of the data surrounding these markers for analysis.
This extraction process is called **epoching** or **trial selection**.

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
Usually, users just test whether this list is empty to determine if the query was satisfied.

### Calling syntax

To perform a search, create a `TagExpressionParser` object, which parses the query.
Once created, this query object can be applied to search multiple HED annotations.
The syntax is demonstrated in the following example:


````{admonition} Example calling syntax for HED search.

```python
schema = load_schema_version("8.1.0")
hed_string = HedString("Sensory-event, Sensory-presentation", schema=schema)
query_string = "Sensory-event"
query = QueryParser(query_string)
result = query.search(hed_string)
if result:
    print(f"{query_string} found in {str(hed_string)})
```
````

In the example the strings containing HED annotations are converted to a `HedString` object,
which is a parsed representation of the HED annotation.
The query facility assumes that the annotations have been validated.
A `HedSchema` is required.
In the example standard schema version 8.1.0 is loaded.
The schemas are available on GitHub.

The query is represented by a `QueryParser` object.
The `search` method returns a list of groups in the HED string that match the query.
This return list can be quite complex and usually must be filtered before being used directly.
In many applications, we are not interested in the exact groups,
but just whether the query was satisfied. 
In the above example, the `result` is treated as a boolean value.

````{warning}
- If you are searching many strings for the same expression, 
be sure to create the `QueryParser` only once.
- The current search facility is case-insensitive.
````

### Single tag queries

The simplest type of query is to search for the presence of absence of a single tag.
HED offers four variations on the single tag query as summarized in the following table.

| Query type                                                                                                        | Example query   | Matches                                                                                                                              | Does not match                              |
|-------------------------------------------------------------------------------------------------------------------|-----------------|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| **Single-term**<br/>Match the term or any child.<br/>Don't consider values or<br/>extensions when matching.       | *Agent-trait*   | *Agent-trait*<br/>*Age*<br/>*Age/35*<br/>*Right-handed*<br/>*Agent-trait/Glasses*<br/>*Agent-property/Agent-trait*<br/>*(Age, Blue)* | *Agent-property*                            |
| **Quoted-tag**<br/>Match the exact tag with<br/>extension or value                                                | "*Age*"         | *Age*<br/>*Agent-trait/Age*                                                                                                          | *Age/35*                                    |
|                                                                                                                   | "*Age/34*"      | *Age/34*<br/>*Agent-trait/Age/34*                                                                                                    | *Age/35*                                    |
| **Tag-path with slash**<br/>Match the exact tag with<br/>extension or value                                       | *Age/34*        | *Age/34*                                                                                                                             | *Age*<br/>*Age/35*<br/>*Agent-trait/Age/34* |
| **Tag-prefix with wildcard**<br/>Match the starting portion<br/>of a tag and possibly its<br/>value or extension. | <em>Age/3*</em> | *Age/34*<br/>*Age/3*<br/>*Agent-trait/Age/34*                                                                                        | *Age*<br/>*Age/40*                          |

The meanings of the different queries are explained in the following subsections.

#### Single-term search

In a single-term search, the query is a single term or node in the HED schema.
(Use the [**HED Schema Viewer**](https://www.hedtags.org/display_hed.html) to see the available tags for your search.)
The query may not contain any slashes or wildcards.

Single-term queries leverage the HED hierarchical structure,
recognizing that schema children of the query term should also satisfy the query.
This is HED's **is-a** principle.

The example query in the above table is *Agent-trait*.
The full path of *Agent-trait* in the HED schema is *Property/Agent-property/Agent-trait*.
Further, the *Agent-trait* has several child nodes including: *Age*, *Agent-experience-level*,
*Gender*, *Sex*, and *Handedness*.

The single-term query matches child tags without regard to tag extension or value.
Hence, *Agent-trait* matches *Age* which is a child and *Age/35* which is child with a value.
*Agent-trait*, itself, may be extended, so *Agent-trait* also matches *Agent-trait/Glasses*.
Here *Glasses* is a user-extension.

#### Quoted-tag search

If the tag-term is enclosed in quotes, the search matches that tag exactly.
If you want to match a value as well, you must include that specific value in the quoted tag-term.  This is exactly the same as Tag-path with slash, except you can search a single term without a slash.


#### Tag-path with slash

If the query includes a slash in the tag path, then the query must match the 
exact value with the slash.
Thus, *Age/34* does not match *Age* or *Age/35*.
The query matches *Agent-trait/Age/34* because the short-form of this tag-path is *Age/34*.
The tag short forms are used for the matching to assure consistency.


#### Tag-prefix with wildcard

Matching using a tag prefix with the `*` wildcard, matches the starting portion of the tag.
Thus, <em>Age/3*</em> matches *Age/3* as well as *Age/34*.

Notice that the query <em>Age*</em> matches a myriad of tags including *Agent*, *Agent-state*,
and *Agent-property*.

### Logical queries

In the following `A` and `B` represent HED expressions that may contain multiple
comma-separated tags and parenthesized groups.
`A` and `B` may also contain group queries as described in the next section.
The expressions for `A` and `B` are each evaluated and then combined using standard logic.


| Query form                                                                                       | Example query               | Matches                                                                                                              | Does not match                                                                                        |
|--------------------------------------------------------------------------------------------------|-----------------------------|----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| **`A`, `B`**<br/>Match if both `A` and `B`<br/>are matched.                                      | *Event*, *Sensory-event*    | *Event*, *Sensory-event*<br/>*Sensory-event*, *Event*<br/>(*Event*, *Sensory-event*)                                 | *Event*                                                                                               |
| **`A` and `B`**<br/>Match if both `A` and `B` <br/>are matched.  <br>Same as the comma notation. | *Event* and *Sensory-event* | *Event*, *Sensory-event*<br/>*Sensory-event*, *Event*<br/>(*Event*, *Sensory-event*)                                 |                                                                                                       |  *Event*         |
| **`A` or `B`**<br/>Match if either `A` or `B`.                                                   | *Event* or *Sensory-event*  | *Event*, *Sensory-event*<br/>*Sensory-event*, *Event*<br/>(*Event*, *Sensory-event*)<br/>*Event*<br/>*Sensory-event* | *Agent-trait*                                                                                         |
| **~`A`**<br/>Match groups that do<br/>not contain `A`<br/> `A` can be an arbitrary expression.   | { *Event*, ~*Action* }      | (*Event*)<br/>(*Event*, *Animal-agent*)<br/>(*Sensory-event*, (*Action*))                                            | *Event*<br/>*Event*, *Action*<br/>(*Event*, *Action*)<br>                                             |
| **@`A`**<br/>Match a line that <br/>does not contain `A`.                                        | @*Event*                    | *Action*<br>*Agent-trait*<br>*Action, Agent-Trait*<br>(*Action*, *Agent*)                                            | *Event*<br>(*Action*, *Event*)<br>(*Action*, *Sensory-event*)<br>(*Agent*, (*Sensory-event*, *Blue*)) |

### Group queries

Tag grouping with parentheses is an essential part of HED annotation,
since HED strings are
independent of ordering of tags or tag groups at the same level.

Consider the annotation:

> *Red*, *Square*, *Blue*, *Triangle*

In this form, tools cannot distinguish which color goes with which shape.
Annotators must group tags using parentheses to make the meaning clear:

> (*Red*, *Square*), (*Blue*, *Triangle*)

Indicates a red square and a blue triangle.
Group queries allow analysts to detect these groupings.

As with logical queries,
`A` and `B` represent HED expressions that may contain multiple
comma-separated tags and parenthesized groups.

| Query form                                                                                                               | Example query | Matches                                                     | Does not match                                                |
|--------------------------------------------------------------------------------------------------------------------------|---------------|-------------------------------------------------------------|---------------------------------------------------------------|
| **{`A`, `B`}**<br/>Match a group that<br/>contains both `A` and `B`<br/>at the same level<br/>in the same group.         | *{Red, Blue}* | *(Red, Blue)*<br/>*(Red, Blue, Green)*                      | *(Red, (Blue, Green))*                                        |
| **[`A`, `B`]** <br/> Match a group that<br/>contains `A` and `B`.<br/> Both `A` and `B` could<br/>be any subgroup level. | *[Red, Blue]* | *(Red, (Blue, Green))*<br/>*((Red, Yellow), (Blue, Green))* | *Red, (Blue, Green)*                                          |
| **{`A`, `B:`}**<br/>Match a group that<br/>contains both `A` and `B`<br/>at the same level<br/>and no other contents.    | *{Red, Blue:}*         | *(Red, Blue)*                                                   | *(Red, Blue, Green)*<br/>*(Red, Blue, (Green))*  |
| **{`A`, `B: C`}**<br/>Match a group that<br/>contains both `A` and `B`<br/>at the same level<br/>and optionally `C`.     | *{Red, Blue: Green}*   | *(Red, Blue)*<br/>*(Red, Blue, Green)*                          | *(Red, (Blue, Green))*<br/>*(Red, Blue, (Green))*|

These operations can be arbitrarily nested and combined, as for example in the query:

> *[`A` or {`B` and `C`} ]*

In this query
Ordering on either the search terms or strings to be searched doesn't matter, 
precedence is generally left to right outside of grouping operations.

Wildcard matching is supported, but primarily makes sense in exact matching groups.
You can replace any term with a wildcard:

| Query form                           | Example query   | Matches               | Does not match                |
|--------------------------------------|-----------------|-----------------------|-------------------------------|
| **`?`**<br/>Matches any tag or group | {`A` and `?`}   | *(A, B}<br/>(A, (B))* | *(A)<br/>(B, C)*              |
| **`??`**<br/>Matches any tag         | {`A` and `??`}  | *(A, B}*              | *(A)<br/>(B, C)<br/>(A, (B))* |
| **`???`**<br/>Matches any group      | {`A` and `???`} | *(A, (B))*            | *(A)<br/>(B, C)<br/>(A, B)*   |


**Notes**: You cannot use negation inside exact matching groups "{X:}" or "{X:Y}" notation. <br/>
You cannot use negation in combination with wildcards ( ?, ??, or ??? )<br/>
In exact group matching, or matches one or the other, not both.  eg. {A or B:} matches (A) or (B), but not (A, B)

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
