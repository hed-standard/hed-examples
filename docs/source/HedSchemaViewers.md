# HED schema viewers

## HED schema basics

### Schema is-a
Each child tag is considered to be a special type of any of its parents (i.e., child is-a type of parent).  For example, *Square* is-a type of *Rectangle* which is-a type of *2D-shape*.

The strict requirement of child is-a parent means that when downstream tools
search for *2D-shape*, the search will return tag strings containing *Square* as well
as those containing *Rectangle*.


When you tag, you need only use the node name (e.g, *Square*).
Tools can convert between this "short-form" and the complete path "long-form" (e.g. */Item/Object/Geometric-object/2D-shape/Rectangle/Square*) when needed in
search and other processing.
 
## Viewing the standard schema

The HED standard schema contains the basic vocabulary for annotating experiments.
Special purpose HED terms, such as *Definition* and *Def* are only interpreted by HED tools
if they come from the standard schema.

| Viewer | Link | Use |
| ------ | ---- | --- |
|Expandable<br/>HTML | [**Latest**](http://www.hedtags.org/display_hed.html) or<br/> [**Prerelease**](https://www.hedtags.org/display_hed_prelease.html) | Look up or search for tags.<br/>View during vocabulary development. |
| XML | [**Raw**](https://raw.githubusercontent.com/hed-standard/hed-schemas/main/standard_schema/hedxml/HED8.1.0.xml) or</br>[**Formatted**](https://github.com/hed-standard/hed-schemas/blob/main/standard_schema/hedxml/HED8.1.0.xml) | Accessed by tools for validation and analysis. |
| Mediawiki | [**Raw**](https://raw.githubusercontent.com/hed-standard/hed-schemas/main/standard_schema/hedwiki/HED8.1.0.mediawiki) or<br/> [**Formatted**](https://github.com/hed-standard/hed-schemas/blob/main/standard_schema/hedwiki/HED8.1.0.mediawiki) |  Edit to create a new schema. |


## Viewing the SCORE library

| Viewer | Link | Use |
| ------ | ---- |  --- |
|Expandable<br/>HTML | [**Latest**](https://www.hedtags.org/display_hed_score.html) or<br/> [**Prerelease**](https://www.hedtags.org/display_hed_score_prerelease.html) | Look up or search for tags.<br/>View during vocabulary development. |
| XML | [**Raw**](https://raw.githubusercontent.com/hed-standard/hed-schemas/main/library_schemas/score/hedxml/HED_score_0.0.1.xml) or<br/>[**Formatted**](https://github.com/hed-standard/hed-schemas/blob/main/library_schemas/score/hedxml/HED_score_0.0.1.xml) | Accessed by tools for validation and analysis. |
| Mediawiki | [**Raw**](https://raw.githubusercontent.com/hed-standard/hed-schemas/main/library_schemas/score/hedwiki/HED_score_0.0.1.mediawiki) or<br/> [**Formatted**](https://github.com/hed-standard/hed-schemas/blob/main/library_schemas/score/hedwiki/HED_score_0.0.1.mediawiki) |  Edit to create a new schema.  |
