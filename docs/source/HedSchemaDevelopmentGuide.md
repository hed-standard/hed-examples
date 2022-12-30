# HED schema development guide

HED annotations consist of comma-separated terms drawn from a hierarchically
structured vocabulary called a HED schema.
The **HED standard schema** contains basic terms that are common across
most human neuroimaging, behavioral, and physiological experiments.
The HED ecosystem also supports (**HED library schemas**) to expand the HED vocabulary 
in a scalable manner to support specialized data.

Although you can create a private HED vocabulary for your

This guide describes how to begin developing your own schema. 

This section describes how you can contribute to existing HED vocabularies
or creating an entirely new one.


## Setting up for schema development


## Design principles for schema

All HED schema (both the standard and library schemas) must conform to certain design principles
in addition to properly validating.

``````{admonition} Rules for HED schema design.
:class: tip

1. [**Unique**] Every term must be unique within the schema and must conform to the rules for
HED schema terms.
2. [**Meaningful**] Schema terms should be readily understood by most users. The terms should not be ambiguous and should be meaningful in themselves **without** reference to their position in the schema hierarchy.
3. [**Organized**] If possible, a schema sub-tree should have no more than 7 direct subordinate sub-trees.
4. [**Orthogonal**] Terms that are used independently of one another should be in different sub-trees (orthogonality).
5. [**Sub-classed**]Every term in the hierarchy satistifies the **is-a** relationship with its parent.
In other words if B has A as a parent in the schema hierarchy, then B is an example of A.
Searching for A will also return B (search generality).

``````

As in Python programming, we anticipate that many HED schema libraries may be defined 
and used, in addition to the base HED schema. Libraries allow individual research or
clinical communities to annotate details of events in experiments designed to answer questions 
of interest to particular to those communities.

Since it would be impossible to avoid naming conflicts across schema libraries
that may be built in parallel by different user communities,
HED supports schema library namespaces.
Users will be able to add library tags qualified with namespace designators.
All HED schemas, including library schemas, 
adhere to [semantic versioning](https://semver.org/). 


## Defining a schema

A HED library schema is defined in the same way as the base HED schema except that it has an
additional attribute name-value pair, `library="xxx"` in the schema header. We will use as an
illustration a library schema for driving. Syntax details for a library schema are similar to
those for the base HED schema.
(See the [HED schema format specification](https://hed-specification.readthedocs.io/en/latest/03_Schema.html)
for more details).

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

The required sections specifying the schema attributes  are *unit-class-specification*, 
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
purpose. Library schema developers should try not to reuse terms in the standard schema 
unless the intention is to convey a close or identical relationship.


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

### Schema properties

HED only supports the schema properties listed in Table B.2: *boolProperty*, 
*unitClassProperty*, *unitModifierProperty*, *unitProperty*, and *valueClassProperty*.  
If the library schema uses one of these in the library schema specification, 
then its specification must appear in the *property-specification* section of the library schema.

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

### Syntax checking

Regardless of whether a specification is in the standard schema or a library schema,
HED tools can perform basic syntax checking.

````{admonition} Basic syntax checking for library schema.
:class: tip

1. All attributes used in the schema proper must be defined in the schema attribute section of the schema.
2. Undefined attributes cause an error in schema validation.
3. Similar rules apply to unit classes, unit modifiers, value classes, and properties.
4. Actual handling of the semantics by HED tools only occurs for entities appearing in the base schema.
````

### Procedure for updating a schema.

#### Proposing changes
As modifications to the HED schema are proposed, they are added to the
**PROPOSED.md** file for the respective schema.
As changes are accepted, they are incorporated into the 
**prerelease** version of the schema and added as part of the 
**prerelease CHANGES.md**. 
These files are located in the **prerelease** subdirectory for the respective schema.
Examples of these files for the standard schema can be found in the standard schema
[**prelease directory**](https://github.com/hed-standard/hed-schemas/tree/main/standard_schema/prerelease).
[**Expandable html view of the prerelease HED schema**](https://www.hedtags.org/display_hed_prelease.html) 

Upon final review, the new HED schema is released, the XML file is copied to the
[**hedxml directory**](https://github.com/hed-standard/hed-schemas/tree/main/standard_schema/hedxml),
the mediawiki file is copied to the
[**hed]


## HED schema details
_HED schema_ is the structured vocabulary from which HED annotations base on. HED annotations consist of comma-separated path strings,
selected from the schema. In the newest versions of HED,
all individual nodes in the vocabulary are unique, so users can annotate
by simply giving the last node in the path string rather than the entire path
string: *Red* instead of *Attribute/Sensory/Sensory-property/Visual/Color/CSS-color/Red-color/Red*.

This repository contains the HED schema specification, where discussions on schema terms and syntax are held via Github issue mechanism and where HED-supporting tools can find machine-readable format of the schema. The HED schema is available in MediaWiki and XML. 

The MediaWiki markdown format, stored in 
[`hedwiki`](https://github.com/hed-standard/hed-specification/tree/master/hedwiki),
allows vocabulary developers to view and edit the vocabulary tree using a 
human-readable markdown language available in Wikis and on GitHub repositories. 
In addition, an expandable non-editable 
[HTML viewer](http://www.hedtags.org/display_hed.html)  is available
to help users explore the vocabulary.

All analysis and validation tools operate on an XML translation of the vocabulary 
markdown document, stored in [`hedxml`](https://github.com/hed-standard/hed-specification/tree/master/hedxml). 


## Further documentation

The documentation on this page refers specifically to the HED vocabulary and supporting tools. Additional documentation is available on:

> [**HED organization website**](https://www.hedtags.org)

All of the HED software is open-source and organized into various repositories on the HED standards organization website:

> [**HED organization github repository**](https://github.com/hed-standard)
