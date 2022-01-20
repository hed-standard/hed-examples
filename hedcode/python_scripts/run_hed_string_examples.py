""" Examples of creating a HedValidator and validating various Hed Strings with it.

Classes Demonstrated:
HedValidator - Validates a given input string or file
"""

from hed.errors.error_reporter import get_printable_issue_string
from hed.models.hed_string import HedString
from hed.schema.hed_schema_io import load_schema
from hed.validator.hed_validator import HedValidator


if __name__ == '__main__':
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED8.0.0.xml'
    hed_schema = load_schema(hed_xml_url)

    hed_validator = HedValidator(hed_schema)
    hed_validator_no_semantic = HedValidator(run_semantic_validation=False)

    hed_string_1 = \
        "Sensory-event,Visual-presentation,Experimental-stimulus,Green,Non-target," + \
        "(Letter/D, (Center-of, Computer-screen))"
    string_obj_1 = HedString(hed_string_1)
    validation_issues = string_obj_1.validate(hed_validator)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 1] hed_string_1 should have no issues with HEDv8.0.0'))

    string_1_long, issues = string_obj_1.convert_to_short(hed_schema)
    print(get_printable_issue_string(issues, title='[Example 2] hed_string_1 should convert to long without errors'))
    string_1_long_obj = HedString(string_1_long)
    validation_issues = string_1_long_obj.validate(hed_validator)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 3] hed_string_1 should validate after conversion to long'))

    hed_string_2 = "Sensory-event,Visual-presentation,BlankBlank,Experimental-stimulus,Blech"
    string_obj_2 = HedString(hed_string_2)
    validation_issues = string_obj_2.validate(hed_validator)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 4] hed_string_2 has 2 invalid tags HEDv8.0.0'))

    hed_string_3 = "Sensory-event,Visual-presentation,Experimental-stimulus,Red/Dog"
    string_obj_3 = HedString(hed_string_3)
    validation_issues = string_obj_3.validate(hed_validator)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 5] hed_string_3 extended tag gives a warning'))

    validation_issues = string_obj_3.validate(hed_validator, check_for_warnings=True)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 6] hed_string_3 extended tag flags error with warnings'))

    hed_string_4 = 'Event/Label/ButtonPushDeny, Event/Description/Button push to deny access to the ID holder,' \
                   'Event/Category/Participant response, ' \
                   '(Participant ~ Action/Button press/Keyboard ~ Participant/Effect/Body part/Arm/Hand/Finger)'
    string_obj_4 = HedString(hed_string_4)
    validation_issues = string_obj_4.validate(hed_validator)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 7] hed_string_4 has issues with the latest HED version'))

    hed_string_5 = 'Event,dskfjkf/dskjdfkj/sdkjdsfkjdf/sdlfdjdsjklj'
    string_obj_5 = HedString(hed_string_5)
    validation_issues = string_obj_5.validate(hed_validator)
    print(get_printable_issue_string(validation_issues,
                                     title='[Example 8] hed_string_5 does not validate with current HED schema'))

    validation_issues = string_obj_5.validate(hed_validator_no_semantic=True)
    print(get_printable_issue_string(validation_issues, title='[Example 8] hed_string_5 is syntactically correct'))
