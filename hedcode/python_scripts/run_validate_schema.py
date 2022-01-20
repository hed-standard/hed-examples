"""
Example of how to validate a given hed schema file.

Functions Demonstrated:
hed_schema.check_compliance - Checks if a HedSchema object is hed3 compatible.
"""

from hed.errors.error_reporter import get_printable_issue_string
from hed.schema.hed_schema_io import load_schema

if __name__ == '__main__':
    # this should produce fairly minimal issues.
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED8.0.0.xml'
    hed_schema = load_schema(hed_xml_url)
    print("\nValidating HED8.0.0 will produce 3 errors and a warning that do not prevent conversion...")
    issues = hed_schema.check_compliance()
    print(get_printable_issue_string(issues))

    # This old schema should produce many issues, including many duplicate terms
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED7.2.0.xml'
    hed_schema = load_schema(hed_xml_url)
    print("\nValidating HED7.2.0 should produce many issues....")
    issues = hed_schema.check_compliance()
    print(get_printable_issue_string(issues))
