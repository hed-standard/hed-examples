# Understanding HED versions

HED (Hierarchical Event Descriptors) schemas are standardized tre-structured vocabularies for annotating experimental data, particularly 
neuroimaging and behavioral data. 
The **HED standard schema** contains a base vocabulary of terms that are common to most experiments,
while various **HED library schemas** contain discipline specific vocabularies.
The [**HED schema viewer**](https://www.hedtags.org/display_hed.html) allows users to view the available vocabularies.

Applications that use HED must specify which versions of the HED schemas they are using.
The definitive HED vocabulary files are available in the
[**hed-schemas](https://github.com/hed-standard/hed-schemas) GitHub repository.
Tools retrieve the XML files corresponding to the designated HED either from GitHUB or from
their internal caches to use in validation and analysis.

This tutorial explains HED versioning and how to specify HED version.

## HED version basics

HED uses semantic versioning of the form *Major.Minor.Patch* for the standard schema.
If referring to a library schema the *library_* is prepended to the version.

When multiple schemas are being used together, you specify the versions as a list of strings.


```{list-table} HED version examples
:header-rows: 1
:name: hed-version-examples

* - Version
  - Meaning
* - *"8.3.0"*
  - HED standard schema version *8.3.0*
* - *"score_1.0.0"*
  - SCORE library schema version *1.0.0*
* - *"score_1.2.0"*
  - SCORE library schema version *score_1.2.0*<br/>partnered with standard schema *8.2.0*
* - *["score_1.2.0", "bc:testlib_4.0.0"]*
  - SCORE library schema version *score_1.2.0* and *testlib_4.0.0*.
* - *["score_1.0.0", "ac:8.3.0"]*
  - SCORE library schema version 1.0.0 and standard schema *8.3.0*.
* - *["lang_1.0.0", "score_2.0.0"]*
  - LANG library schema version *lang_1.0.0* and<br/>SCORElibrary schema *score_2.0.0*<br/>both partnered with standard schema *8.3.0*.
```  

SCORE library schema version 1.0.0 is an **unpartnered schema**.
This means that if you want to use any tags from the standard schema you must explicitly give the version.
Multiple unpartnered schemas must use prefixes for all but one of the schema versions.
Annotations using tags from schemas whose versions are prefixed must also include the prefix in the tag.
So if the version specification is *["score_1.0.0", "ac:8.3.0"]*, an annotation using the HED tag `Event`
must be `ac:Event`.

**Partnered schemas** automatically include a specific version of the standard schema.
LANG library schema 1.0.0 and SCORE library schema 2.0.0 (both in prerelease)
are both partnered with standard schema 8.3.0.
Further, these library schemas have no conflicts with each other.
Hence, the version specifications *["lang_1.0.0", "score_2.0.0"]* does not require a prefixes.
All three schemas are loaded as a single schema at runtime.

## Using HED versions

In BIDS (Brain Imaging Data Structure) datasets, the HED version is
specified in the `dataset_description.json` file at the top level of the dataset.
See [**7.5. Library schemas in BIDS**](https://hed-specification.readthedocs.io/en/latest/07_Library_schemas.html#library-schemas-in-bids)
in the HED specification for information about the rules.

In NWB (Neurodata Without Borders) dataset, the HED version is specified
when `HedTags` objects are created.
See [**HED annotation in NWB**](https://www.hed-resources.org/en/develop/HedAnnotationInNWB.html)
for additional information and examples.

