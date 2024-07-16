# HED annotation in NWB (draft)

[**Neurodata Without Borders (NWB)**](https://www.nwb.org/) is a data standard for organizing neurophysiology data.
NWB is used extensively as the data representation for single cell and animal recordings as well as
human neuroimaging modalities such as IEEG. HED (Hierarchical Event Descriptors) is a system of
standardized vocabularies and supporting tools that allows fine-grained annotation of data.
HED annotations can now be used in NWB.

A standardized HED vocabulary is referred to as a HED schema.
A single term in a HED vocabulary is called a HED tag. 
A HED string consists of one or more HED tags separated by commas and possibly grouped using parentheses.

The [**ndx-hed**](https://github.com/hed-standard/ndx-hed) extension consists of a `HedTags` class that extends 
the NWB [**VectorData**](https://hdmf-common-schema.readthedocs.io/en/stable/format.html#sec-dynamictable) class, 
allowing HED data to be added as a column to any NWB [**DynamicTable**](https://hdmf-common-schema.readthedocs.io/en/stable/format.html#sec-dynamictable).
`VectorData` and `DynamicTable` are base classes for many NWB data structures.
See the [**DynamicTable Tutorial**](https://hdmf.readthedocs.io/en/stable/tutorials/plot_dynamictable_tutorial.html#sphx-glr-tutorials-plot-dynamictable-tutorial-py)
for a basic guide for usage in Python and
[**DynamicTable Tutorial (MATLAB)**](https://neurodatawithoutborders.github.io/matnwb/tutorials/html/dynamic_tables.html)
for introductory usage in MATLAB.
The `ndx-hed` extension is not currently supported in MATLAB, although support is planned in the future.

## NWB ndx-hed installation

Should it be uploaded to PyPi?

## NWB ndx-hed examples

### HedTags as a standalone vector

The `HedTags` class has two required arguments (`hed_version` and `data`) and two optional arguments
(`name` and `description`). 
The result of the following example is a `HedTags` object whose data vector includes 2 elements.
Notice that the `data` argument value is a list with 2 values representing two distinct HED strings.
These values are validated using HED schema version 8.3.0 when `tags` is created. 
If any of the tags had been invalid, the constructor would have raised a `ValueError`.
The example uses the default column name (`HED`) and the default column description.

````{admonition} Create a HedTags object.
:class: tip

```python
tags = HedTags(hed_version='8.3.0', data=["Correct-action", "Incorrect-action"])
```
````

You must specify the version of the HED vocabulary to be used.
We recommend that you use the latest version of HED (currently 8.3.0).
A separate HED version is used for each instance of the `HedTags` column,
so in theory you could use a different version for each column. 
This is not recommended, as annotations across columns and tables may be combined for analysis.
See [**Understanding HED versions**](./UnderstandingHedVersions.md) for a more detailed explanation
of HED versioning.

### Adding a row to HedTags

The following example assumings that a `HedTags` object `tags` as already been
created as illustrated in the previous example.

````{admonition} Add a row to an existing HedTags object
:class: tip

```python
tags.add_row("Sensory-event, Visual-presentation")
```
````

After this `add_row` operation, `tags` has 3 elements. Notice that "Sensory-event, Visual-presentation"
is a single HED string, not two HED strings.
In contrast, ["Correct-action", "Incorrect-action"] is a list with two HED strings.

### HED in a table

The following color table uses HED tags to define the meanings of integer codes:
| color_code | HED |
|----- | --- |
| 1 | `Red` |
| 2 | `Green` |
| 3 | `Blue` |

````{admonition} Create an NWB DynamicTable to represent the color table.
:class: tip

```python

color_nums = VectorData(name="color_code", description="Internal color codes", data=[1,2,3])
color_tags = HedTags(name="HED", hed_version="8.2.0", data=["Red", "Green", "Blue"])
color_table = DynamicTable(
    name="colors", description="Experimental colors", columns=[color_num, color_tags])
```
````
The example sets up a table with columns named `color_code` and `HED`.
Table `colors` has 3 rows.

### Add a row to a `DynamicTable`
Once a table has been required, you can add a row using the table's `add_row` method.

````{admonition} Get row 0 of color_table as a Pandas DataFrame:
```python
df = color_table[0]
```
Append a row to `color_table`:
```python
color_table.add_row(color_code=4, HED="Black")
```
````
As mentioned above, the `DynamicTable` class is used as the base class for many table classes including the 
`TimeIntervals`, `Units`, and `PlaneSegmentation`.
For example `icephys` classes that extend `DynamicTable` include `ExperimentalConditionsTable`, `IntracellularElectrodesTable`,
`IntracellularResponsesTable`, `IntracellularStimuliTable`, `RepetitionsTable`, `SequentialRecordingsTable`,
`SimultaneousRecordingsTable` and the `SweepTable`.
This means that HED can be used to annotate a variety of NWB data.

HED tools recognize a column as containing HED annotations if it is an instance of `HedTags`.
This is in contrast to BIDS ([**Brain Imaging Data Structure**](https://bids.neuroimaging.io/)),
which identifies HED in tabular files by the presence of a `HED` column,
or by an accompanying JSON sidecar, which associates HED annotations with tabular column names.

## HED and ndx-events

The NWB [**ndx-events**](https://github.com/rly/ndx-events) extension provides data structures for 
representing event information about data recordings.
The following table lists elements of the *ndx-events* extension that inherit from
`DynamicTable` and can accommodate HED annotations.

```{list-table} ndx-events tables that can use HED.
:header-rows: 1
:name: ndx-events-data-structures

* - Table
  - Purpose
  - Comments
* - `EventsTypesTable`
  - Information about each event type<br/>One row per event type.
  - Analogous to BIDS events.json.
* - `EventsTable`
  - Stores event instances<br/>One row per event instance.
  - Analogous to BIDS events.tsv.
* - `TtlTypesTable`
  - Information about each TTL type.
  - 
* - `TtlTable`
  - Information about each TTL instance.
  - 
```

HED annotations that are common to a particular type of event can be added to e NWB `EventsTypesTable`,
which is analogous to the `events.json` in BIDS. 
A `HED` column can be added to a BIDS `events.tsv` file to provide HED annotations specific 
to each event instance. 
Any number of `HedTags` columns can be added to the NWB `EventsTable` to provide different types
of HED annotations for each event instance.

The HEDTools ecosystem currently supports assembling the annotations from all sources to construct
complete annotations for event instances in BIDS. Similar support is planned for NWB files.

## HED in NWB files

A single NWB recording and its supporting data is stored in an `NWBFile` object.
The NWB infrastructure efficiently handles reading, writing, and accessing large `NWBFile` objects and their components.
The following example shows the creation of a simple `NWBFile` using only the required constructor arguments.


````{admonition} Create an NWBFile object called my_nwb.
```python
from datetime import datetime
from dateutil.tz import tzutc
from pynwb import NWBFile

my_nwb = NWBFile(session_description='a test NWB File',
                   identifier='TEST123',
                   session_start_time=datetime(1970, 1, 1, 12, tzinfo=tzutc()))

```
````

An `NWBFile` has many fields, which can be set using optional parameters to the constructor
or set later using method calls. 

````{admonition} Add a HED trial column to an NWB trial table and add trial information.
```python
my_nwb.add_trial_column(name="HED", hed_version="8.3.0", col_cls=HedTags, data=[], description="temp")
my_nwb.add_trial(start_time=0.0, stop_time=1.0, HED="Correct-action")
my_nwb.add_trial(start_time=2.0, stop_time=3.0, HED="Incorrect-action")
```
````
The optional parameters for the `NWBFile` constructor whose values can inherit from `DynamicTable`
include `epochs`, `trials`, `invalid_times`, `units`, `electrodes`, `sweep_table`,
`intracellular_recordings`, `icephys_simultaneous_recordings`, `icephys_repetitions`, and 
`icephys_experimental_conditions`. 
The `NWBFile` class has methods of the form `add_xxx_column` for the
`epochs`, `electrodes`, `trials`, `units`,and `invalid_times` tables.
The other tables also allow a HED column to be added by constructing the appropriate table
prior to passing it to the `NWBFile` constructor.

In addition, the `stimulus` input is a list or tuple of objects that could include `DynamicTable` objects.

The NWB infrastructure provides IO functions to serialize these HED-augmented tables.