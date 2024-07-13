# HED annotation in NWB (draft)

[**Neurodata Without Borders (NWB)**](https://www.nwb.org/) is a data standard for organizing neurophysiology data.
NWB is used extensively as the data representation for single cell and animal recordings as well as
human neuroimaging modalities such as IEEG. HED (Hierarchical Event Descriptors) is a system of
standardized vocabularies and supporting tools that allows fine-grained annotation of data.

Each NWB file (extension `.nwb`) is a self-contained (and hopefully complete) representation of
experimental data for a single experiment.
The file should contain all experimental stimuli, acquired data, and metadata synchronized to a global
timeline for the experiment.
See [**Intro to NWB**](https://nwb-overview.readthedocs.io/en/latest/intro_to_nwb/1_intro_to_nwb.html)
for a basic introduction to NWB.

## The ndx-hed NWB extension
The [**ndx-hed**](https://github.com/hed-standard/ndx-hed) extension allows HED annotations to be added as a column to any NWB
[**DynamicTable**](https://hdmf-common-schema.readthedocs.io/en/stable/format.html#sec-dynamictable).
extends the NWB [**VectorData**](https://hdmf-common-schema.readthedocs.io/en/stable/format.html#sec-dynamictable) 
class, allowing HED data to be added as a column to any NWB
[**DynamicTable**](https://hdmf-common-schema.readthedocs.io/en/stable/format.html#sec-dynamictable).
The `DynamicTable` class is the underlying base class for many data structures within NWB files,
and this extension allows HED annotations to be easily added to NWB.
See [**DynamicTable Tutorial**](https://hdmf.readthedocs.io/en/stable/tutorials/plot_dynamictable_tutorial.html#sphx-glr-tutorials-plot-dynamictable-tutorial-py)
for a basic guide for usage in Python and
[**DynamicTable Tutorial (MATLAB)**](https://neurodatawithoutborders.github.io/matnwb/tutorials/html/dynamic_tables.html)
for introductory usage in MATLAB.

The class that implements the ndx-hed extension is called `HedTags`.
This class represents a column vector (`VectorData`) of HED tags and the version
of the HedSchema needed to validate the tags. 
Valid
which 

## Example HED usage in NWB

### HED as a standalone vector

The `HedTags` class has two required argument (the `hed_version` and the `data`) and two optional arguments
(`name` and `description`).

````{admonition} Create a HedTags object.
:class: tip

```python
tags = HedTags(hed_version='8.3.0', data=["Correct-action", "Incorrect-action"])
```
````
The result is a `VectorData` object whose data vector includes 2 elements.
Notice that data is a list with 2 values representing two distinct HED strings.
The values of these elements are validated using HED schema version 8.3.0 when `tags` is created. 
If any of the tags had been invalid, the constructor would raise a `ValueError`.

````{admonition} Add a row to an existing HED VectorData
:class: tip

```python
tags.add_row("Sensory-event, Visual-presentation")
```
After this `add_row` operation, `tags` has 3 elements. Notice that "Sensory-event, Visual-presentation"
is a single HED string, not two HED strings.

````

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
Here are some common operations that you might want to perform on such a table:
````{admonition}
Get row 0 of `color_table` as a Pandas DataFrame:
```python
df = color_table[0]
```
Append a row to `color_table`:
```python
color_table.add_row(color_code=4, HED="Black")
```
````
The `HED`
color_table = DynamicTable(name="colors", description="Color table for the experiment",
                           columns=[{"name"="code", "description"="Internal color codes", data=[1, 2, 3]},
                                    HedTags(name="HED", hed_version="8.3.0", data=["Red", "Green", "Blue"])]

```



```
## Installation

## Implementation
The implementation is based around
### The HedTags class



### In TrialTable

### in EventTable

file including the `TimeIntervals`, `Units`, `PlaneSegmentation`, and many of the
the `icephys` tables (`ExperimentalConditionsTable`, `IntracellularElectrodesTable`,
`IntracellularResponsesTable, `IntracellularStimuliTable`, `RepetitionsTable`, SequentialRecordingsTable`,
`SimultaneousRecordingsTable` and the `SweepTable`)(`TrialTable`, Epch