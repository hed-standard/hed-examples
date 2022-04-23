eegPath = 'D:/sub-01_ses-01_task-DriveRandomSound_run-1_eeg.set';
eventsPath = 'D:/sub-01_ses-01_task-DriveRandomSound_run-1_events.tsv';
eventsPathA = 'D:/sub-01_ses-01_task-DriveRandomSound_run-1_eventsA.tsv';
eventsPathB = 'D:/sub-01_ses-01_task-DriveRandomSound_run-1_eventsB.tsv';
EEG = pop_loadset('filepath', eegPath);
[EEG1, bids, eventData, eventDesc] = ...
    eeg_importeventsfiles(EEG, eventsPath);

[EEG2, bidsA, eventDataA, eventDescA] = ...
    eeg_importeventsfiles(EEG, eventsPathA);

[EEG3, bidsB, eventDataB, eventDescB] = ...
    eeg_importeventsfiles(EEG, eventsPathB);