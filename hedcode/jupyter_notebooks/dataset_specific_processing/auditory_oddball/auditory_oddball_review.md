Review of Auditory oddball: openNeuro ds003061

Tags are reasonable, although some could be refined.

trial_type (BIDS) <==> trial_type (EEG.event)
value (BIDS) <==> type (EEG.event)
Questions:

* The `response_time` values are given in ms, but BIDS specifically says seconds.
* The stim files are provided, however they are not referenced in the
`stim_file` column of the `events.tsv` which are all `n/a`
  - Suggest eliminating the stim_file column and including in the tags for stimulus or putting them in and tagging -- possibly simplifying the filenames.
* There are 2 events with trial_type: STATUS and value: condition 5.
There are 139 events with trial_type: n/a and value: ignore.
  - Are these events the same?
  - The description says they should be ignored.  If so--why not take them out?
* Suggest renaming `trial_type` to `event_type` in both cases since multiple
events from same trial are included (both stimulus and response are events).
* Suggest renaming `value` to `task_role`.
* The `urevent` field is missing from `EEG.event`.
* The `value` columns have several values mispelled: `noise_with_reponse` etc.
* The `task-P300_events.json` uses Levels and Units together incorrectly:

```json
{
    "response_time": {
        "LongName": "Response time",
        "Description": "Latency of button press after auditory stimulus",
        "Units": "second",
        "Levels": {
            "Units": "millisecond"
        }
    }
}
```




