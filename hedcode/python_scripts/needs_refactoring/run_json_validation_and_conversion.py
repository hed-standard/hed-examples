"""

Examples using the sidecars:

Example 1: Create a Sidecar from a json sidecar file and validate it

Example 2: Open a json Sidecar, modify it, then save it back out.


Classes Demonstrated:
HedSchema - Opens a hed xml schema.  Used by other tools to check tag attributes in the schema.
Sidecar - Contains the data from a single json sidecar, can be validated using a HedSchema.
HedString - Main class for handling a hed string during processing and analysis
"""

from tempfile import TemporaryFile
from hed.errors.error_reporter import get_printable_issue_string
from hed.models.hed_string import HedString
from hed.models.sidecar import Sidecar
from hed.schema.hed_schema_io import load_schema
from hed.validator.hed_validator import HedValidator

if __name__ == '__main__':
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED8.0.0.xml'
    hed_schema = load_schema(hed_xml_url)
    json_filename = "../../../datasets/eeg_ds003645s_hed/task-FacePerception_events.json"

    # Example 1
    print("\nExample 1 demonstrating Sidecar validation....")
    sidecar = Sidecar(json_filename)
    validator = HedValidator(hed_schema)
    issues = sidecar.validate_entries(validator, check_for_warnings=True)
    if issues:
        print(get_printable_issue_string(issues), "JSON dictionary from eeg_ds003645s_hed has validation errors")
    else:
        print("JSON dictionary from eeg_ds003645s_hed has no validation errors")

    # Example 2: Convert JSON to long and output it.
    print("\n\nExample 2 converting a Sidecar to long in place ...")
    tag_form = 'long_tag'
    validator = HedValidator(hed_schema)
    for hed_string_obj, position_info, issue_items in sidecar.hed_string_iter(validators=validator,
                                                                              expand_defs=False,
                                                                              allow_placeholder=True):
        converted_string = hed_string_obj.get_as_form(tag_form)
        issues = issues + issue_items
        sidecar.set_hed_string(converted_string, position_info)
    print(f"Outputting the converted results:\n{sidecar.get_as_json_string()}")
