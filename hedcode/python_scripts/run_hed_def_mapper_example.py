"""
Examples of creating an EventsInput to open a spreadsheet, process it, then save it back out.

Classes Demonstrated:
HedSchema - Opens a hed xml schema.  Used by other tools to check tag attributes in the schema.
HedValidator - Validates a given input string or file
EventsInput - Used to open/modify/save a bids style spreadsheet, with json sidecars and definitions.
HedFileError - Exception thrown when a file cannot be opened.(parsing error, file not found error, etc)
Sidecar - Contains the data from a single json sidecar, can be validated using a HedSchema.
"""
import os
from hed.errors.error_reporter import get_printable_issue_string
from hed.models.sidecar import Sidecar
from hed.models.events_input import EventsInput
from hed.validator.hed_validator import HedValidator
from hed.schema.hed_schema_io import load_schema


if __name__ == '__main__':
    # Setup the files
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED8.0.0.xml'
    hed_schema = load_schema(hed_xml_url)
    events_file = \
        os.path.join('../../datasets/eeg_ds003654s_hed/sub-003/eeg/sub-003_task-FacePerception_run-2_events.tsv')
    json_file = os.path.join('../../datasets/eeg_ds003654s_hed/task-FacePerception_events.json')

    # Validate sidecar
    validator = HedValidator(hed_schema=hed_schema)
    sidecar = Sidecar(json_file)
    def_issues = sidecar.validate_entries(validator)
    if def_issues:
        print(get_printable_issue_string(def_issues,
                                         title="There should be no errors in the definitions from the sidecars:"))

    # Validate events file with sidecar
    input_file = EventsInput(events_file, sidecars=sidecar)

    # Not recommended that the sidecar be validated separately as part of sidecar validation
    validation_issues = input_file.validate_file_sidecars(validator)
    if validation_issues:
        print(get_printable_issue_string(validation_issues,
                                         title="There should be no errors with this sidecar.  \""
                                         "This will likely cause other errors if there are."))

    # Validate the events file
    validation_issues = input_file.validate_file(validator)
    print(get_printable_issue_string(validation_issues, "There should be no errors with this events file"))
