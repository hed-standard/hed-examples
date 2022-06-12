""" Example of converting a hed schema from .mediawiki format to .xml format. """

from hed.util.file_util import \
    write_strings_to_file
from hed.schema.hed_schema_io import load_schema


if __name__ == '__main__':

    # Convert mediawiki to XML and write to a temporary file
    hed_wiki_url = 'https://raw.githubusercontent.com/hed-standard/hed-specification/master' + \
                   '/hedwiki/HED8.0.0.mediawiki'
    print("Converting HED8.0.0.mediawiki to XML:")
    hed_schema = load_schema(hed_wiki_url)
    xml_file_string = hed_schema.get_as_xml_string()
    if xml_file_string:
        xml_location = write_strings_to_file(xml_file_string)
        print(f"XML temporary file:  {xml_location}")
