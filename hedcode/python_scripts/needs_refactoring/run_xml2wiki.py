""" Example of converting a hed schema from .xml format to .mediawiki format. """

from hed.util.file_util import write_strings_to_file
from hed.schema.hed_schema_io import load_schema


if __name__ == '__main__':

    # Convert mediawiki to XML and write to a temporary file
    hed_xml_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master/hedxml/HED8.0.0.xml'
    print("Converting HED8.0.0.xml to mediawiki:")
    hed_schema = load_schema(hed_xml_url)
    mediawiki_file_string = hed_schema.get_as_mediawiki_string()
    if mediawiki_file_string:
        mediawiki_location = write_strings_to_file(mediawiki_file_string)
        print(f"Mediawiki temporary file:  {mediawiki_location}")
