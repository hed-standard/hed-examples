## Review of GoNogo:  openNeuro ds002680

### Overall
Tags are reasonable, although some could be refined.
However, no descriptions are included of the event types.
Columns are misnamed in the `events.json`.

### Correspondence between BIDS and EEG
`trial_type` (BIDS) <==> `trial_type` (EEG.event)  
`value` (BIDS) <==> `type` (EEG.event)

### Questions/suggestions:

* The `response_time` values are given in ms, but BIDS specifically says seconds.
* The `sample` column is included but all `n/a`. This should be computed.
* Suggest renaming `trial_type` to `event_type` since multiple
events from same trial are included (both stimulus and response are events).
* The `urevent` field is missing from `EEG.event`.
* **Here is a big one**: The `event.json` file refers to a column with
name `type`, but there is no column name `type` on the BIDS side.
* The `event.json` does not have any `Levels` or `Description` but should.
* The `README` was quite detailed but did not explain the difference between
the type of targets and distractors -- no clue from the tagging either.
* The `dataset_description` should have actual citations to the papers.
