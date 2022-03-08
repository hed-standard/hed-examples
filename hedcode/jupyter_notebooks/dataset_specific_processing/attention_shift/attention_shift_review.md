## Review of AttentionShift:  ds002893
The dataset had a number of inconsistencies and issues
with columns and event codes that have been corrected prior
to uploading as a new version.

### Overall
This original dataset was tagged using HED-2G and included
a HED column in the BIDS `events.tsv` files and a `usertags`
field in the `EEG.event` structures.
Several datasets had orphan codes at the beginning and/or
end which have been removed.

Three datasets had orphan runs, which included no data.
Those files have been removed and copied into sourcedata.
Many event codes were incorrect or omitted, but could be
reconstructed from the data.
This was done and manually verified.

requires extensive curation to fix issues.
The BIDS `events.tsv` files have a `HED` column,

### Correspondence between BIDS and EEG

`trial_type` (BIDS) <==> `cond_code` (EEG.event)  
`value` (BIDS) <==> `type` (EEG.event)

### Operations:
1. `sub-020_run-01`, `sub-021_run-01`, and `sub-022_run-01` should be deleted as
only contain pulse codes (event code 199). These have been moved to the `sourcedata`
directory.
2. `sub-007_run-01` has the beginning 5 events with `event_code` value of 255 or 202,
indicating several pauses and restarts. We manually removed the first 4 events of this file,
leaving a 202 indicating a pause occurred here.

