import os

from hed.errors.error_reporter import get_printable_issue_string
from hed.models.sidecar import Sidecar
from hed.models.events_input import EventsInput
from hed.validator.hed_validator import HedValidator
from hed.schema.hed_schema_io import load_schema
from hed.schema.hed_schema_group import HedSchemaGroup


if __name__ == '__main__':
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED8.0.0.xml'
    hed_library_url1 = \
        'https://raw.githubusercontent.com/hed-standard/hed-schemas/main/hedxml/HED_score_1.0.0.xml'
    hed_library_url2 = \
        'https://raw.githubusercontent.com/hed-standard/hed-schemas/main/hedxml/HED_test_1.0.2.xml'
    hed_schema = load_schema(hed_xml_url)
    hed_schema_lib1 = load_schema(hed_library_url1)
    hed_schema_lib1.set_library_prefix("sc")
    hed_schema_lib2 = load_schema(hed_library_url2)
    hed_schema_lib2.set_library_prefix("test")
    events_file = os.path.join(
        '../../../datasets/eeg_ds003645s_hed_library/sub-003/eeg/sub-003_task-FacePerception_run-2_events.tsv')
    json_file = os.path.join('../../../datasets/eeg_ds003645s_hed_library/task-FacePerception_events.json')

    schema_group = HedSchemaGroup([hed_schema, hed_schema_lib1, hed_schema_lib2])
    validator = HedValidator(hed_schema=schema_group)

    sidecar = Sidecar(json_file)
    input_file = EventsInput(events_file, sidecars=sidecar)
    issues = input_file.validate_file_sidecars(validator, check_for_warnings=False)
    issues += input_file.validate_file(validator, check_for_warnings=False)

    print(get_printable_issue_string(issues, "Validating a Bids event file with its JSON sidecar"))
