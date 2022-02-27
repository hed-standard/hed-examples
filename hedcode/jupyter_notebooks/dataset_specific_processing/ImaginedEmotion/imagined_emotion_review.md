##Review of ImaginedEmotion: Review of ds003004

### Overall
The descriptions in the Levels in the JSON sidecars are extensive and useful.
There are no HED tags in this dataset.

### Correspondence between BIDS and EEG
`trial_type` (BIDS) <==> `trial_type` (EEG.event)  
`value` (BIDS) <==> `type` (EEG.event)

### Questions/suggestions:

* **There is a separate `events.json` file in every directory rather than at the top-level.**
Presumably these are identical, but they should be replaced by a single
file in the dataset root directory.
* **The README indicates that this dataset has already been preprocessed,
with bad channels removed and filtered at 1 Hz.
The data in openNeuro should not have bad channels removed or be filtered.**
* The `events.json` files do not have HED tags.
* The `duration` values appear to be given in ms, but BIDS specifically says seconds.
* The `sample`, `response_time`, `stim_file`,  `trial_type`, and `HED` columns
are included in the BIDS `events.tsv` files but only have `n/a` values.
Suggest eliminating these columns. 
* The `value` column has 30 distinct values. The names have inconsistent formats
(camel-case, snake-case, underbar, lowercase).
Some names are not self-explanatory (`press` vs `press1`).
* Suggest renaming `trial_type` to `event_type` in both BIDS and EEG since multiple
events from same trial are included (both stimulus and response are events).
* The `EEG.event` has a `chanindex` field which is either blank or 0.
There is no information about what this field means or corresponding information in the BIDS `events.tsv`.
In any case, `n/a` not blanks should be used in the BIDS version.
* The information in the `events.json` file should also be in the `README`.
