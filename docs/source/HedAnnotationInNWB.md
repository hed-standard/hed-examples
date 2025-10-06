# HED annotation in NWB

[**Neurodata Without Borders (NWB)**](https://www.nwb.org/) is a data standard for organizing neurophysiology data.
NWB is used extensively as the data representation for single cell and animal recordings as well as
human neuroimaging modalities such as IEEG. HED (Hierarchical Event Descriptors) is a system of
standardized vocabularies and supporting tools that allows fine-grained annotation of data.
HED annotations can now be used in NWB.

A standardized HED vocabulary is referred to as a **HED schema**.
A single term in a HED vocabulary is called a **HED tag**. 
A **HED string** or **HED annotation** consists of one or more HED tags 
separated by commas and possibly grouped using parentheses.

The [**ndx-hed**](https://github.com/hed-standard/ndx-hed) extension allows HED annotations to be inserted in any NWB
`DynamicTable` using either the `HedTags` class or the `HedValueVector` class.
The `DynamicTable` class is used as the base class for many table classes including the 
`TimeIntervals`, `Units`, and `PlaneSegmentation`.
For example `icephys` classes that extend `DynamicTable` include `ExperimentalConditionsTable`,
`IntracellularElectrodesTable`, `IntracellularResponsesTable`, `IntracellularStimuliTable`, 
`RepetitionsTable`, `SequentialRecordingsTable`,`SimultaneousRecordingsTable` and the `SweepTable`.
This means that HED can be used to annotate a variety of NWB data.

## NWB ndx-hed installation

The `ndx-hed` extension for Python can be installed using `pip`:


```bash
pip install -U ndx-hed
```

The `ndx-hed` extension for MATLAB is under development and not available.

## ndx-hed 0.2.0 Architecture

Version 0.2.0 introduces a three-class architecture:

1. `HedLabMetaData` - required metadata container storing HED schema version and optional definitions. 
2. `HedTags` - row-specific HED annotations for DynamicTable rows.  
3. `HedValueVector` - column-wide HED templates with value placeholders (`#`).  

### Required: HedLabMetaData

**Important:** Before using any HED annotations in an `NWBFile`, you must add `HedLabMetaData` 
to specify the HED schema version:

````{admonition} Create and add HED metadata to NWBFile.
:class: tip

```python
from pynwb import NWBFile
from ndx_hed import HedLabMetaData
from datetime import datetime, timezone

# Create NWB file
nwbfile = NWBFile(
    session_description="Example with HED",
    identifier="example001",
    session_start_time=datetime.now(timezone.utc)
)

# Add HED metadata (required) - must be named "hed_schema" (the default)
hed_metadata = HedLabMetaData(hed_schema_version="8.4.0")
nwbfile.add_lab_meta_data(hed_metadata)
```
````

We recommend using the latest version of HED (currently 8.4.0). 
The `HedLabMetaData` object centralizes HED schema management for the entire `NWBFile`, 
ensuring consistency across all HED annotations.

## NWB ndx-hed Examples

### Row-Specific annotations with HedTags

The `HedTags` class extends `VectorData` to store one HED string per row. 
It must be named "HED" (enforced by constructor). 

````{admonition} Create a HedTags column in a DynamicTable
:class: tip

```python
from ndx_hed import HedTags
from pynwb.core import DynamicTable, VectorData

# HedTags with row-specific annotations
hed_tags = HedTags(data=[
    "Agent-action,Correct-action",
    "Agent-action, Incorrect-action",
    "Sensory-event, Visual-presentation, Cue"
])

# Create table with HED column
table = DynamicTable(
    name="events",
    description="Events with HED annotations",
    columns=[
        VectorData(name="event_type", data=["go", "nogo", "cue"], description="Event types"),
        hed_tags  # Column name is automatically "HED"
    ]
)
```
````

### Column-wide templates with HedValueVector

The `HedValueVector` class extends the NWB `VectorData` class that includes a HED annotation template
in its metadata. The template is a HED annotation that includes a single `#` placeholder.
The template annotation applies to all the rows in the column.
The applicable HED annotation for a given row is constructed by replacing the `#` with the
column value appearing in that row:

````{admonition} Create a HedValueVector column
:class: tip

```python
from ndx_hed import HedValueVector

# Stimulus intensity with HED template
intensity_column = HedValueVector(
    name="stimulus_intensity",
    description="Luminance contrast of stimuli",
    data=[0.5, 0.7, 0.3, 0.9],
    hed="Sensory-event, Visual-presentation, Luminance-contrast/#"
)
```

The `#` placeholder in the HED string is replaced by each value during analysis. 
For example, the first value (0.5) expands to `Sensory-event, Visual-presentation, Luminance-contrast/0.5`.

````

A `HedValueVector` can be used in any NWB `DynamicTable`, including the new `EventsTable` from ndx-events.

### Examples of HED in DynamicTables

HED annotations can be added to any NWB DynamicTable using either `HedTags` for row-specific annotations or `HedValueVector` for column-wide templates. Here are consolidated examples:

````{admonition} HED in a simple lookup table
:class: tip

```python
from pynwb.core import DynamicTable, VectorData
from ndx_hed import HedTags

# Create a color lookup table with HED annotations
color_nums = VectorData(name="color_code", description="Internal color codes", data=[1, 2, 3])
color_tags = HedTags(data=["Red", "Green", "Blue"])  # Automatically named "HED"

color_table = DynamicTable(
    name="colors",
    description="Experimental colors",
    columns=[color_nums, color_tags]
)

# Add a row to the table
color_table.add_row(color_code=4, HED="Black")
```
````

## HED and ndx-events

The NWB [**ndx-events**](https://github.com/rly/ndx-events) extension provides modern data structures for 
representing timestamped event data. **Version 0.4.0** (current) introduces significant breaking changes 
and implements [NWBEP001: Events](https://docs.google.com/document/d/1qcsjyFVX9oI_746RdMoDdmQPu940s0YtDjb1en1Xtdw/edit).

The current ndx-events 0.4.0 provides these data types that can accommodate HED annotations:

```{list-table} ndx-events 0.4.0 tables that can use HED.
:header-rows: 1
:name: ndx-events-data-structures

* - Table/Type
  - Purpose
  - HED Usage
* - `EventsTable`
  - Stores timestamped events<br/>One row per event instance.
  - Can include `HedTags` columns for event annotations.
* - `MeaningsTable`
  - Maps categorical values to descriptions<br/>Used with `CategoricalVectorData`.
  - Can include `HedTags` columns for semantic annotations.
* - `CategoricalVectorData`
  - Stores categorical data with meanings<br/>References a `MeaningsTable`.
  - The referenced `MeaningsTable` can contain HED annotations.
```

### Using HED with EventsTable

The new `EventsTable` replaces the older table structures and provides a clean interface for event data:

````{admonition} Create EventsTable with HED annotations
:class: tip

```python
from ndx_events import EventsTable, TimestampVectorData
from ndx_hed import HedTags, HedLabMetaData
from pynwb import NWBFile
from datetime import datetime, timezone

# Create NWB file with HED metadata
nwbfile = NWBFile(
    session_description="Events with HED",
    identifier="events001",
    session_start_time=datetime.now(timezone.utc)
)

# Add HED metadata (required)
hed_metadata = HedLabMetaData(hed_schema_version="8.4.0")
nwbfile.add_lab_meta_data(hed_metadata)

# Create EventsTable with HED annotations
events_table = EventsTable(
    name="stimulus_events",
    description="Visual stimulus presentation events"
)

# Add HED column for event-specific annotations
events_table.add_column(
    name="HED", 
    col_cls=HedTags, 
    description="HED annotations for each event"
)

# Add events with timestamps and HED annotations
events_table.add_row(
    timestamp=1.0, 
    HED="Sensory-event, Visual-presentation, (Onset, (Image, Face))"
)
events_table.add_row(
    timestamp=2.5, 
    HED="Sensory-event, Visual-presentation, (Onset, (Image, House))"
)

# Add the table to the NWB file
nwbfile.add_acquisition(events_table)
```
````

### Using HED with CategoricalVectorData and MeaningsTable

For categorical event data, you can use HED annotations in the associated meanings:

````{admonition} EventsTable with categorical data and HED meanings
:class: tip

```python
from ndx_events import EventsTable, CategoricalVectorData, MeaningsTable
from ndx_hed import HedTags

# Create meanings table with HED annotations
meanings_table = MeaningsTable(
    name="stimulus_meanings",
    description="Meanings for stimulus types"
)

# Add HED column to meanings table
meanings_table.add_column(
    name="HED",
    col_cls=HedTags,
    description="HED annotations for stimulus meanings"
)

# Add stimulus type meanings with HED
meanings_table.add_row(
    value="face",
    meaning="Human face photograph",
    HED="Sensory-event, Visual-presentation, (Image, Face)"
)
meanings_table.add_row(
    value="house", 
    meaning="House photograph",
    HED="Sensory-event, Visual-presentation, (Image, House)"
)

# Create EventsTable with categorical stimulus types
events_table = EventsTable(
    name="categorized_events",
    description="Events with categorical stimulus types"
)

# Add the meanings table to the events table
events_table.meanings_tables = [meanings_table]

# Add categorical column referencing the meanings
events_table.add_column(
    name="stimulus_type",
    col_cls=CategoricalVectorData,
    meanings=meanings_table,
    description="Type of visual stimulus"
)

# Add events
events_table.add_row(timestamp=1.0, stimulus_type="face")
events_table.add_row(timestamp=2.5, stimulus_type="house")
```
````

**Important Note:** ndx-events 0.4.0 introduces breaking changes from previous versions. 
If you need the older `EventsTypesTable` and `TtlTable` structures, use ndx-events version 0.2.1:

```bash
pip install ndx-events==0.2.1
```

The HED tools ecosystem is being updated to support the new ndx-events 0.4.0 architecture for 
assembling complete annotations from multiple sources.

## HED in NWB files

A single NWB recording and its supporting data is stored in an `NWBFile` object.
The NWB infrastructure efficiently handles reading, writing, and accessing large `NWBFile` objects and their components.
The following example shows the creation of a simple `NWBFile` using only the required constructor arguments.


````{admonition} Create an `NWBFile` object called my_nwb.
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

````{admonition} Add HED to NWB trials table
```python
from ndx_hed import HedLabMetaData, HedTags

# First, add HED metadata (required)
hed_metadata = HedLabMetaData(hed_schema_version="8.4.0")
my_nwb.add_lab_meta_data(hed_metadata)

# Then add HED column to trials
my_nwb.add_trial_column(name="HED", col_cls=HedTags, data=[], description="HED annotations for trials")

# Add trials with HED annotations
my_nwb.add_trial(start_time=0.0, stop_time=1.0, HED="Experimental-trial, Correct-action")
my_nwb.add_trial(start_time=2.0, stop_time=3.0, HED="Experimental-trial, Incorrect-action")
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

## HED Definitions

Version 0.2.0 adds support for custom HED definitions through `HedLabMetaData`. Definitions allow you to create reusable HED annotations:

````{admonition} Using HED definitions
:class: tip

```python
from ndx_hed import HedLabMetaData, HedTags

# Define custom HED definitions
definitions = "(Definition/Go-stimulus,(Sensory-event,Visual-presentation)),(Definition/Response-time/#,(Time-interval/# s))"

# Create metadata with definitions
hed_metadata = HedLabMetaData(
    hed_schema_version="8.4.0",
    definitions=definitions
)
nwbfile.add_lab_meta_data(hed_metadata)

# Use definitions in annotations
nwbfile.add_trial_column(name="HED", col_cls=HedTags, data=[])
nwbfile.add_trial(
    start_time=0.0,
    stop_time=1.0,
    HED="Def/Go-stimulus, Def/Response-time/0.45"
)
```
````

Definitions are expanded during validation and analysis. The definition `Def/Go-stimulus` expands to "Sensory-event, Visual-presentation", while `Def/Response-time/0.45` expands to "Time-interval/0.45 s".

## Validation

The `HedNWBValidator` class validates HED annotations against the schema:

````{admonition} Validate HED annotations
:class: tip

```python
from ndx_hed.utils.hed_nwb_validator import HedNWBValidator

# Create validator from HedLabMetaData
validator = HedNWBValidator(hed_metadata)

# Validate entire file
issues = validator.validate_file(nwbfile)

if not issues:
    print("All HED annotations are valid!")
else:
    for issue in issues:
        print(f"Error: {issue['message']}")
```
````

Validation ensures that all HED tags conform to the specified schema version and that definitions are properly formed.

## BIDS Compatibility

The `ndx_hed.utils.bids2nwb` module provides utilities for converting between BIDS events files and NWB EventsTable format:

````{admonition} Convert BIDS events to NWB
:class: tip

```python
from ndx_hed.utils.bids2nwb import extract_meanings, get_events_table
import pandas as pd
import json

# Load BIDS events and sidecar
events_df = pd.read_csv("events.tsv", sep="\t")
with open("events.json") as f:
    sidecar = json.load(f)

# Extract meanings and create EventsTable
meanings = extract_meanings(sidecar)
events_table = get_events_table("task_events", "Task events", events_df, meanings)

# Add to NWB file (requires ndx-events extension)
nwbfile.add_acquisition(events_table)
```
````

For the reverse conversion (NWB to BIDS), use `get_bids_events()`:

````{admonition} Convert EventsTable to BIDS format
:class: tip

```python
from ndx_hed.utils.bids2nwb import get_bids_events

# Convert EventsTable to BIDS
bids_df, bids_sidecar = get_bids_events(events_table)

# Save to files
bids_df.to_csv("events.tsv", sep="\t", index=False)
with open("events.json", "w") as f:
    json.dump(bids_sidecar, f, indent=2)
```
````
