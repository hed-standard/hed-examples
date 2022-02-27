Review of ImaginedEmotion: Review of ds003004

The descriptions in the Levels in the JSON sidecars are extensive and useful.
There are no HED tags in this dataset.

trial_type (BIDS) <==> trial_type (EEG.event)
value (BIDS) <==> type (EEG.event)

Questions/suggestions:

* **There is a separate `events.json` file in every directory rather than at the top-level.**
Presumably these are identical, but this should be replaced by a single
file in the dataset root directory.
* The `events.json` files do not have HED tags.
* The `duration` values appear to be given in ms, but BIDS specifically says seconds.
* The `sample`, `response_time`, `stim_file`,  `trial_type`, and `HED` columns
are included in the BIDS `events.tsv` files but only have `n/a` values.
Suggest eliminating these columns. 
* The `value` column has 30 distinct values. The names have inconsistent formats
(camel-case, snake-case, underbar, lowercase).
Some names are not self-explanatory (`press` vs `press1`).
* Suggest renaming `trial_type` to `event_type` in both cases since multiple
events from same trial are included (both stimulus and response are events).
* The `EEG.event` has a `chanindex` field which is either blank or 0.
There is no corresponding information in the BIDS `events.tsv`.
In any case, `n\a` not blanks should be used in the BIDS version.
There is no information about what this field means.
* The `README` was quite detailed but did not explain the difference between
the type of targets and distractors -- no clue from the tagging either.
* The `dataset_description` should have actual citations to the papers.
* **The README indicates that this dataset has already been preprocessed,
with bad channels removed and filtered at 1 Hz.
The data in openNeuro should not have bad channels removed or be filtered.**
* The information in the `events.json` file should also be in the `README`.


