# HED schema developer's guide

A _HED schema_ is a structured vocabulary of terms that can be used in HED annotations.
The **HED standard schema** contains basic terms that are common across
most human neuroimaging, behavioral, and physiological experiments.
The HED ecosystem also supports **HED library schemas** to expand the HED vocabulary 
in a scalable manner to support specialized data annotations.

This guide describes how to begin developing your own library schema or 
contribute to existing HED vocabularies.
If you have questions about how to get started,
please post an issue on the [**hed-schemas issues**](https://github.com/hed-standard/hed-schemas/issues) GitHub forum or
email the [**HED maintainers**](mailto:hed.maintainers@gmail.com).

More detailed information and exact syntax rules are available in
the [**Library schemas**](https://https://hed-specification.readthedocs.io/en/latest/07_Library_schemas.html) chapter of
the [**HED specification**](https://hed-specification.readthedocs.io/en/latest/index.html).

Details about syntax are available in the 
[**Schema formats**](https://hed-specification.readthedocs.io/en/latest/03_HED_formats.html#schema-formats) section and
the [**Schema format details**](https://hed-specification.readthedocs.io/en/latest/Appendix_A.html) chapter of the
[**HED specification**](https://hed-specification.readthedocs.io/en/latest/index.html).

## Schema design basics

A HED schema is structured as a set of trees,
each of which corresponds to a major term category for the vocabulary.

Before developing a schema,
you should explore the standard schema and other available schemas using the
[**HED schema viewer**](https://www.hedtags.org/display_hed.html). 
In the standard schema for example, the `Clap-hands` tag is in the `Action`
subtree, but is 3 levels down:

> `Action` &rarr; `Communicate` &rarr; `Communicate-gesturally` &rarr; `Clap-hands`

### Uniqueness and forms
All tags (vocabulary terms) in a HED schema must be unique, so the short-form `Clap-hands` uniquely specifies the term,
as does any partial path: `Communicate-gesturally/Clap-hands`, 
`Communicate/Communicate-gesturally/Clap-hands` and
`Action/Communicate/Communicate-gesturally/Clap-hands`.

### Is-a
An important feature of HED schemas is that each child (path successor) extends or
specializes its parent (predecessor) in the hierarchy.
Thus, `Clap-hands` is a type of `Communicate-gesturally` action.
The **is-a** relationship between a child term and its ancestors in the hierarchy is fundamental
to HED and enables search generality:  a search for `Communicate-gesturally` will return
annotations that contain any of this tag's descendents (e.g., tags such as `Nod-head`, 
`Pump-fist`, etc.).

### Top-level as categories
As a vocabulary designer, you should think about the **major categories** 
that are appropriate for your schema
in selecting top-level nodes to anchor your schema's major categories.
For example, the standard schema has the following top-level tags:
`Event`, `Agent`, `Action`, `Item`, `Property`, and `Relation`.

### Choosing tag names

Each individual tag in your vocabulary must stand by itself ---
that is, its meaning should be clear.
Tags must be unique and should be distinct from the tags in
the standard schema.
(Your should avoid overlap with tags from other libraries if possible.
This is not required.)

Tag names may only contain alphanumeric characters, hyphens, and underbars.
No blanks are allowed.
Except for certain SI unit designators, HED tags are case-insensitive.
However, the tag names in the schema document follow the following conventions:
- The first character of tag names starting with a letter is capitalized.  
- All letters in a tag name except for the first character are in lower case.  
- Tags representing multiple words are hyphenated.


### Design principles for schema

All HED schema (both the standard and library schemas) must conform to certain design principles
in addition to properly validating.

``````{admonition} Rules for HED schema design.
:class: tip

1. [**Unique**] Every term must be unique within the schema and must conform to the rules for
HED schema terms.
2. [**Meaningful**] Schema terms should be readily understood by most users. The terms should not be ambiguous and should be meaningful in themselves **without** reference to their position in the schema hierarchy.
3. [**Organized**] If possible, a schema sub-tree should have no more than 7 direct subordinate sub-trees.
4. [**Orthogonal**] Terms that are used independently of one another should be in different sub-trees (orthogonality).
5. [**Sub-classed**]Every term in the hierarchy satistifies the **is-a** relationship with its ancestors in the schema tree.
In other words if B has A as an ancestor in the schema hierarchy, then B is an example of A.
Searching for A will also return B (search generality).

``````

### Deciding partnership

While developing a schema as a standalone vocabulary is supported,
**it is strongly recommended that library schemas partner with the (latest) standard schema**.
For more detailed rules and syntax about partnering
see the [**Partnered schemas**](https://hed-specification.readthedocs.io/en/latest/07_Library_schemas.html#partnered-schemas)
section of the [**HED specification**](https://hed-specification.readthedocs.io/en/latest/index.html).

#### Unpartnered libraries

The standard schema provides the basic terms needed for annotating events in most experiments. 
A library's role is to provide additional specialized vocabulary for a specific application.
If multiple schemas are used to annotate a datasets, the tags from
one of the datasets must be prefixed with a user-selected
namespace designator as shown in this schematic.

![standardPlusLibrary](./_static/images/standardPlusLibrary.png)

Here the standard schema (shown in blue) and an unpartnered
library schema (shown in green) are used in an annotation. 
Each of these schemas could be used individually in a dataset
without reference to the other.
However, if annotations in a dataset use more than one schema,
tags from one of the schemas must be prefixed with a namespace designator. 
The choice of which schema's tags will be prefixed is up to the user.
In the example on the right of the diagram, the tags from SCORE library version 1.0.0
are prefixed with `sc:` as indicated by the **HEDVersion** specification at the bottom.

#### Partnered schemas

Most applications need to use terms from both the standard schema and possibly a library schema.
For this reason the concept of **partnered schemas** was introduced.
Schema partnership means that a library schema is merged with a
specific version of the standard schema when the library schema is
distributed with its standard schema partner as a single schema.
Tags from both the library schema and its partnered can be used
without prefixes as shown in the following schematic.
Note however, that tags from additional schemas will still need to be prefixed.

![partnered schema](./_static/images/PartneredSchema.png)

Here the standard schema (shown in blue) and its partnered
library schema (shown in green) are merged and viewed as a single
schema when the schema is validated and distributed.

Notice that some green nodes in the diagram are children
of nodes in the standard schema.
While some top-level nodes in your library schema may represent categories that stand by themselves,
it is likely that other nodes are elaborations of terms that already exist in the standard schema.
You can declare a top-level node in your schema (and its attached subtree)
to be placed under a node in the standard schema by giving it the `rooted=XXX`
attribute, where `XXX` is the name of the parent node in
the standard schema under which the subtree should be rooted.


## Creating your schema

Schema developers work with HED schema in `.mediawiki` format for ease in editing.
MediaWiki is a markdown-like text format that can be displayed
in GitHub in a nicely formatted manner for easy editing.

Mediawiki was chosen as the developer format because of its clear
representation of indented outlines (or equivalently, trees)
as illustrated in the following example:


````{admonition} **Example:** Top-level node in MediaWiki format.

```moin
'''Top-level-1''' <nowiki>[The best top-level node in this schema.]</nowiki>
* Child-1 <nowiki>{extensionAllowed}[A child of Top-level-1.]</nowiki>
** Grandchild-1 <nowiki>[A child of Child-1.]</nowiki>
* Child-2 <nowiki>[A child of Top-level-1 that cannot be extended.]</nowiki>
```
````

Each line in the MediaWiki file represents a distinct tag (or other schema entity),
so `Top-level-`, `Child-1`, `Grandchild-1`, and `Child-2` are all
tags or terms in the schema.
Lines defining tags cannot be split.

Everything after the tag name should be enclosed in
&lt;nowiki&gt; &lt;/nowiki&gt; delimiters.
The tag description appears in square brackets ([ ]),
while the schema attributes such as `extensionAllowed` are
enclosed in curly braces ({ }).

Each tag line should always inc
or other schema element.
The tag `Top-level-1` is a top-level tag, a root of one of the schema's trees,
represents a major category in the schema. Top-level tags are enclosed in 
sets of three consecutive single quotes.
In contrast child tags a
HED tools generally use XML versions of the HED schema. 



As in Python programming packages, we anticipate that many HED schema libraries may be defined 
and used, in addition to the base HED schema. Libraries allow individual research or
clinical communities to annotate details of events in experiments designed to answer questions 
of interest to particular to those communities.

Since it would be impossible to avoid naming conflicts across schema libraries
that may be built in parallel by different user communities,
HED supports schema library namespaces.
Users will be able to add library tags qualified with [namespace designators](##schema-namespaces).

All HED schemas, including library schemas, adhere to [semantic versioning](https://semver.org/). 


## Defining a schema

A HED library schema is defined in the same way as the base HED schema except that it has an
additional attribute name-value pair, `library="xxx"` in the schema header. We will use as an
illustration a library schema for driving. Syntax details for a library schema are similar to
those for the base HED schema.
See the [HED schema format specification](https://hed-specification.readthedocs.io/en/develop/03_HED_formats.html)
for more details.

````{admonition} **Example:** Driving library schema (MEDIAWIKI template).

```moin
HED library="driving" version="1.0.0" 
!# start schema 
   [... contents of the HED driving schema ...]
!# end schema
   [... required sections specifying schema attribute definitions ...]
!# end hed
```
````

The required sections specifying the [schema attributes](##attributes-and-classes)  are *unit-class-specification*, 
*unit-modifier-specification*, *value-class-specification*, *schema-attribute-specification*,
and *property-specification*.

````{admonition} **Example:** Driving library schema (XML template).

```xml
<?xml version="1.0" ?>
<HED library="driving" version="1.0.0">
    [... contents of the HED_DRIVE schema ... ]
</HED>
```
````

The schema XML file should be saved as `HED_driving_1.0.0.xml` to facilitate 
specification in tools.

## Schema namespaces

As part of the HED annotation process, users must associate a standard HED schema with their
datasets. Users may also include tags from an arbitrary number of additional library schemas.
For each library schema used to annotate a data recording, the user must associate a local 
name with the appropriate library schema name and version. Each library must be associated 
with a distinct local name within a recording annotations. The local names should be 
strictly alphabetic with no blanks or punctuation. 

The user must pass information about the library schema and their associated local names to 
processing functions. HED uses a standard method of identifying namespace elements by prefixing
HED library schema tags with the associated local names. Tags from different library schemas can
be intermixed with those of the base schema. Since the node names within a library must be
unique, annotators can use short form as well as fully expanded tag paths for library schema 
tags as well as those from the base-schema.

````{admonition} **Example:** Driving library schema example tags.

```
dp:Action/Drive/Change-lanes
dp:Drive/Change-lanes
dp:Change-lanes
```
````

A colon (`:`) is used to separate the qualifying local name from the remainder of the tag. 
Notice that *Action* also appears in the standard HED schema. Identical terms may be used 
in a library schema and the standard HED schema. Use of the same term implies a similar 
purpose. **Library schema developers should try not to reuse terms in the standard schema 
unless the intention is to convey a close or identical relationship.**

### Partnered Schemas
Starting with HED schema version **8.2.0**, HED supports **partnered schemas**,
which are library schemas that are merged with a standard schema.
Partnered schemas allow schema designers to include library
tags that are elaborations of tags in the standard schema in addition to other
specialized tags. See the [HED schemas documentation](https://www.hed-resources.org/en/latest/HedSchemas.html#types-of-schemas) for more details.

## Attributes and classes

In addition to the specification of tags in the main part of a schema, a HED schema has 
sections that specify unit classes, unit modifiers, value classes, schema attributes, 
and properties. The rules for the handling of these sections for a library schema are 
as follows:

### Required sections

The required sections of a library schema are: the *schema-specification*, 
the *unit-class-specification*, the *unit-modifier-specification*, 
the *value-class-specification* section, the *schema-attribute-specification* section, 
and the *property-specification*. The library schema must include all required 
schema sections even if the content of these sections is empty.

### Relation to base schema

Any schema attribute, unit class, unit modifier, value class, or property used in the
library schema must be specified in the appropriate section of the library schema
regardless of whether these appear in base schema. Validators check the library
schema strictly on the basis of its own specification without reference to another 
schema.



### Unit classes

The library schema may define unit classes and units as desired or include unit classes or 
units from the base schema. Similarly, library schema may define unit modifiers or 
reuse unit modifiers from the base schema. HED validation and basic analysis tools 
validate these based strictly on the schema specification and do not use any outside 
information for these.

### Value classes

The standard value classes (*dateTimeClass[*]*, *nameClass*, *numericClass[*]*, 
*posixPath[*]*, *textClass[*]*) if used, should have the same meaning as in the 
base schema. The hard-coded behavior associated with the starred ([*]) value 
classes will be the same. Library schema may define additional value classes and 
specify their allowed characters, but no additional hard-coded behavior will be 
available in the standard toolset. This does not preclude special-purpose tools 
from incorporating their own behavior.

### Schema attributes

The standard schema attributes (*allowedCharacter*, *defaultUnits*, *extensionAllowed*,
*recommended*, *relatedTag*, *requireChild*, *required*, *SIUnit*, *SIUnitModifier*,
*SIUnitSymbolModifier*, *suggestedTag*, *tagGroup*, *takesValue*, *topLevelTagGroup*, 
*unique*, *unitClass*, *unitPrefix*, *unitSymbol*, *valueClass*) should have the same
meaning as in the base schema. The hard-coded behavior associated with the schema 
attributes will be the same. Library schema may define additional schema attributes. 
They will be checked for syntax, but no additional hard-coded behavior will be available
in the standard toolset. This does not preclude special-purpose tools from incorporating
their own behavior.

### Schema properties

[**Schema properties**](https://hed-specification.readthedocs.io/en/latest/03_HED_formats.html#schema-properties) apply to schema attributes
and indicate what the type of the schema attribute is.
You should not add properties to your library schema as
the handling of the schema properties is hard-coded into the HED tools.
If you feel that there is a property that is needed,
please post an issue on the hed-schemas GitHub 
[**issues forum**](https://github.com/hed-standard/hed-schemas/issues).
You can view them HED only supports the schema properties listed in Table B.2: *boolProperty*, 
*unitClassProperty*, *unitModifierProperty*, *unitProperty*, and *valueClassProperty*.  
If the library schema uses one of these in the library schema specification, 
then its specification must appear in the *property-specification* section of the library schema.

### Schema development process


````{admonition} **Standard development process for XML schema.**
:class: tip

1. Create or modify a `.mediawiki` file containing the schema.
2. Validate the `.mediawiki` file using the [**HED online tools**](https://hedtools.ucsd.edu/hed/schema).
3. Convert to `.xml` using the [**HED online tools**](https://hedtools.ucsd.edu/hed/schema).
4. Act according to the (Procedure for updating a schema)[## Procedure for updating a schema] section to contribute your changes to the GitHub [**HED schemas repository**](https://github.com/hed-standard/hed-schemas).
5. View in the [**expandable schema viewer**](https://www.hedtags.org/display_hed.html) to verify.
````

## Syntax checking

Regardless of whether a specification is in the standard schema or a library schema,
HED tools can perform basic syntax checking.

````{admonition} Basic syntax checking for library schema.
:class: tip

1. All attributes used in the schema proper must be defined in the schema attribute section of the schema.
2. Undefined attributes cause an error in schema validation.
3. Similar rules apply to unit classes, unit modifiers, value classes, and properties.
4. Actual handling of the semantics by HED tools only occurs for entities appearing in the base schema.
````

## Procedure for updating a schema

### Proposing changes
As modifications to the HED schema are proposed, they are added to the
**PROPOSED.md** file for the respective schema.
As changes are accepted, they are incorporated into the 
**prerelease** version of the schema and added as part of the 
**prerelease CHANGES.md**. 
These files are located in the **prerelease** subdirectory for the respective schema.
Examples of these files for the standard schema can be found in the standard schema [**prerelease directory**](https://github.com/hed-standard/hed-schemas/tree/main/standard_schema/prerelease).
This is viewable in the [**Expandable html view of the prerelease HED schema**](https://www.hedtags.org/display_hed_prerelease.html) 

Upon final review, the new HED schema is released, the XML file is copied to the
[**hedxml directory**](https://github.com/hed-standard/hed-schemas/tree/main/standard_schema/hedxml),
the mediawiki file is copied to the [**hedwiki directory**](https://github.com/hed-standard/hed-schemas/tree/main/standard_schema/hedwiki).


## Further documentation

The documentation on this page refers specifically to the HED vocabulary and supporting tools. Additional documentation is available on:

> [**HED organization website**](https://www.hedtags.org)

All of the HED software is open-source and organized into various repositories on the HED standards organization website:

> [**HED organization github repository**](https://github.com/hed-standard)
The [hed-schemas](https://github.com/hed-standard/hed-schemas) GitHub repository contains the HED schema specification, 
where discussions on schema terms and syntax are held via Github issue mechanism and where HED-supporting tools can find machine-readable format of the schema.

The HED schema is available in MediaWiki and XML:
* The MediaWiki markdown format, stored in [`hedwiki`](https://github.com/hed-standard/hed-specification/tree/master/hedwiki),
allows vocabulary developers to view and edit the vocabulary tree using a 
human-readable Markdown language available in Wikis and on GitHub repositories. 
* All analysis and validation tools operate on an XML translation of the vocabulary 
markdown document, stored in [`hedxml`](https://github.com/hed-standard/hed-specification/tree/master/hedxml). 

In addition, an expandable non-editable [HTML viewer](http://www.hedtags.org/display_hed.html)  is available
to help users explore the vocabulary.
