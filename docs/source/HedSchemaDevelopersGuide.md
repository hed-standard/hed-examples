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

The [**Naming conventions**](https://hed-specification.readthedocs.io/en/latest/03_HED_formats.html#naming-conventions) 
section of the HED specification gives a complete discussion of naming conventions.

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

### Naming your schema

Before starting, you must decide on a name for your schema.
It should be a relatively short, informative, alphabetic string.
The name can be an acronym or a meaningful name, 
but it cannot be the same name as any other recognized HED schema.

The SCORE library, for example, is an acronym based on its derivation from the
SCORE standard: Standardized Computer Based Organized Reporting of EEG.
The LISA library, a language schema now in prerelease, is another acronym standing for
LInguistic Stimuli Annotation.
A good name for the schema with vocabulary to describe experiments
involving simulated driving might be DRIVE.

### Getting listed

To get recognized as a HED library schema project,
post an issue to the hed-schemas [**issue forum**](https://github.com/hed-standard/hed-schemas/issues) with a brief overview
of your schema, its purpose, and your development team.
The HED Working Group will work with you to get started.

As part of the initiation process, the HED Working Group
will create a subdirectory in the
[**library_schemas**](https://github.com/hed-standard/hed-schemas/tree/main/library_schemas)
directory in the [**hed-schemas**](https://github.com/hed-standard/hed-schemas)
GitHub repository.

The new directory will named with the name of your schema and have a **prerelease** subdirectory.
You will use the GitHub Pull Request (PR) mechanism to make changes in 
this directory. 

### Schema file names

All HED schemas, including library schemas, adhere to [**semantic versioning**](https://semver.org/). 
The rules for what constitutes major, minor and patch changes are given
in the hed-schemas [**README**](https://github.com/hed-standard/hed-schemas/#hed-semantic-versioning).

Suppose you are just starting to create a library called DRIVE for
a vocabulary specific to simulated driving tasks.
You should name your first version of your schema `drive_0.0.1.mediawiki`.
This file will eventually go in the prerelease directory for your directory
on [**hed-schemas**](https://github.com/hed-standard/hed-scheams).

## Creating your schema

The following sections briefly describe how to go about actually creating your schema
files.

### Introducing MediaWiki

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

The MediaWiki GitHub previewer shows this as:

![GitHubPreview](./_static/images/GitHubPreviewOfMediaWiki.png)

Each line in the MediaWiki file represents a distinct tag (or other schema entity),
so `Top-level-`, `Child-1`, `Grandchild-1`, and `Child-2` are all
tags or terms in the schema.

Lines defining tags cannot be split.

Everything after the tag name should be enclosed in
<b>&lt;nowiki&gt; &lt;/nowiki&gt;</b> delimiters.
The tag description appears in square brackets ([ ]),
while the schema attributes such as `extensionAllowed` are
enclosed in curly braces ({ }).

The tag `Top-level-1`, which is a top-level tag or root of one of the schema's trees,
represents a major category in the schema. Top-level tags are enclosed in 
sets of three consecutive single quotes.

In contrast, child tags  such as `Child-1` appear on lines that start
with 1 or more asterisks (`*`), indicating the level of indentation or
alternatively depth in the schema tree.

### Defining a schema

We assume that you are going to develop a partnered library schema,
which require only the schema tags and no auxiliary sections.
Unpartnered schemas require that the auxiliary sections to be provided,
while partnered schemas use the auxiliary sections from their standard
schema partner.

The following illustrates the format for using an
exemplar library schema called drive. 

````{admonition} **Example:** Driving library schema (MEDIAWIKI template).

```moin
HED library="drive" version="0.0.1" withStandard="8.2.0" unmerged="true"

'''Prologue'''
Drive has tags of interest to driving experiments.

!# start schema

'''Vehicle-part''' <nowiki>{rooted=Device}[Parts of a vehicle of any kind.]</nowiki>
* Steering-device <nowiki>[The part of a vehicle used for steering.]</nowiki>
** Steering-wheel <nowiki>[A wheel used for steering as for a car.]</nowiki>
** Steering-yoke <nowiki>[A horizontal column used for steering, primarily in aircraft.]</nowiki>
* Brake-device <nowiki>[A part of a vehicle used for steering]</nowiki>

!# end schema 

!# end hed 

```
````

This schema would be saved in a MediaWiki file called `drive_0.0.1.mediawiki`.
To start developing simply replace "drive" with the name of your schema
and replace the drive tags with your own.

### Checking syntax

You should validate your schema frequently when developing it using
the [**HED online tools**](https://hedtools.org).

The following tools shows screen shows the user interface for
validating your schema using the online tools.

![ValidateSchema](./static/images/validateSchema.png)

Simply choose the MediaWiki file you wish to valid,
select the *Validate* action and press *Process.
If your file has errors, a text file containing the errors will become
available.

### Converting to XML

Although developers use th Mediawiki format, tools access the
schema in XML format.
Use the [**HED online tools**](https://hedtools.org) to convert as shown in the following screenshot:

![ValidateSchema](./static/images/validateSchema.png)


### Summarizing the process


````{admonition} **Standard development process for XML schema.**
:class: tip

1. Create or modify a `.mediawiki` file containing the schema.
2. Validate the `.mediawiki` file using the [**HED online tools**](https://hedtools.org/hed/schema).
3. Convert to `.xml` using the [**HED online tools**](https://hedtools.org/hed/schema).
4. Act according to the (Procedure for updating a schema)[## Procedure for updating a schema] section to contribute your changes to the GitHub [**HED schemas repository**](https://github.com/hed-standard/hed-schemas).
5. View in the [**HED schema viewer**](https://www.hedtags.org/display_hed.html) to verify.
````

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

The documentation on this page refers specifically to the HED vocabulary and supporting tools. Additional documentation is available on the following sites:

> [**HED project homepage**](https://www.hedtags.org) directs users to
> appropriate places to find information.



> [**HED organization**](https://github.com/hed-standard) GitHub
> organization houses the repositories holding HED source (all of which is open).

>[**hed-schemas**](https://github.com/hed-standard/hed-schemas) 
> GitHub repository houses all HED schemas in a form that
> can be accessed by tools at runtime.

>[**HED Resources**](https://www.hed-resources.org) 
> is the main site for HED documentation and tutorials.

> [**HED Specification**](https://hed-specification.readthedocs.io/en/latest/index.html) 
> displays the HED specification.

> [**HED web viewer**](http://www.hedtags.org/display_hed.html) allows users to explore the schemas that have been uploaded to [**hed-schemas**](https://github.com/hed-standard/hed-schemas).
