# HED online tools 

HED web-based tools are available directly through a browser from 
[https://hedtools.ucsd.edu/hed](https://hedtools.ucsd.edu/hed) or
as RESTful services from the same URL.
These services do not require a login to use.

The tools are implemented in a Docker module and can be deployed locally 
provided that Docker is installed. 
See the [HED Web](https://hed-web.readthedocs.io/en/latest/) documentation
about download and deployment information.

* [**Browser-based tools**](browser-based-tools-anchor) - web-based tools for HED.
* [**RESTful services**](hed-restful-services-anchor) - RESTful online HED services.

(browser-based-tools-anchor)=
## Browser-based access

The HED browser-based tools are organized into the following pages,
each focused on a particular type of file. 
* [**Event online tools**](event-online-tools-anchor) - validation, summary, and generation tools.
* [**Sidecar online tools**](sidecar-online-tools-anchor) - validation, transformation, extraction, and merging tools.
* [**Spreadsheet online tools**](spreadsheet-online-tools-anchor) - validation and transformation tools.
* [**String online tools**](string-online-tools-anchor) - validation and transformation tools.
* [**Schema online tools**](schema-online-tools-anchor) - validation and conversion tools.

Many of the tools require that you provide a HED schema.
Usually, you can do this by selecting one of the standard HED versions using a pull-down menu,
and the tool downloads this version from GitHub if the server doesn't already have it cached.

If you want to use a different version of HED,
you can select the *Other* option from the pull-down and upload your own HED schema.

The long form HED tag consists of the tag's full path in the HED schema,
while the short form consists only of the tag's leaf node in the schema and possibly a value.
Intermediate form tags consist of a partial paths from a leaf node to an 
intermediate node in the HED schema.
Compliant HED tools should be able to handle any combination of short, long,
or intermediate form tags.

Several of the tools have an `Expand defs` option to indicate that definitions should be expanded.
When this option is in effect,
tools should replace *Def/xxx* tags with an expanded definition for 'xxx' with a
tag group of the form *(Def-expand/xxx, yyy)* where 'yyy' is the actual definition contents of 'xxx'.

**Note**: Expansion of definitions is independent of whether the individual HED tags are
in long form or short form.


(event-online-tools-anchor)=
### Events files
Events files are BIDS style tab-separated value files.
The first line is always a header line giving the names of the columns,
which are used as keys to metadata in accompanying JSON sidecars.

The HED tools have four separate tools: validate, assemble annotations,
generate sidecar template, and execute remodel script.

#### Validate an events file
The validate tool for events is useful for debugging the HED annotations in your 
BIDS dataset while avoiding a full BIDS-validation each time you make a change.
The tool first validates the sidecar if present and
then does a final validation in combination with the events file.

``````{admonition} Validate a BIDS-style events file

**Steps:**
 - Select the `Validate` action.
 - Set `Check for warnings` on if you want to include warnings. 
 - Select the HED version.  
 - Optionally upload a JSON sidecar file (`.json`).
 - Upload an events file (`.tsv`).  
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages.
 
``````

The online events file validation tool is very useful for quick validation while developing your annotation.
However, the tool only validates a single events file with an accompanying sidecar.
The tool does not validate multiple events files at the same time,
nor does the tool handle inherited sidecars.

The [bids_validate_hed.ipynb](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids/bids_validate_dataset.ipynb)
Python Jupyter notebook is available for validating all the events files
in a BIDS dataset along with multiple sidecars.
The Jupyter notebook handles validation with library schema.

#### Assemble annotations

Assembling HED annotations of a BIDS-style events file
produces a two-column result file whose first column
contains the onsets of the original events file and the second column
contains the fully assembled HED annotation for each event.

``````{admonition} Assemble HED annotations for a BIDS-style events file.

**Steps:**
 - Select the `Assemble annotations` action.  
 - Set `Expand defs` on if you want to include expanded definitions.  
 - Specify the HED version.  
 - Optionally upload a JSON sidecar file (`.json`).  
 - Upload the events file (`.tsv`).    
 
 - Click the `Process` button.  

**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns the assembled `.tsv` events file.  
``````

The online tools do not allow the option of retaining other columns in the returned file.
A more general alternative is to use the remodeling tools through the interface.

#### Generate sidecar template

Generating a sidecar template file from the information in a single events file
produces a `.json` sidecar template file ready to be filled in with 
descriptions and HED annotations.

``````{admonition} Generate a sidecar template from an events file.

**Steps:**
 - Select the `Generate sidecar template` action.
 - Upload the events file (`.tsv`). A list of the event file column names with number of unique values in each column appears below the selection.
 - In the left column of checkboxes select those corresponding to columns you wish to include in the template.
 - In the right column of checkboxes, select those corresponding to columns for which you wish to supply individual annotations for each unique value.
 - Click the `Process` button.  

**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable `.json` sidecar template file 
corresponding to the events file.  
``````

The online generation tool is very useful for constructing a sidecar template file,
but the template is based only on the particular events file used in the generation.
For many BIDS datasets, this is sufficient for generating a complete template.
However, for datasets that have many types of events files, you will want to use the
[bids_generate_sidecar.ipynb](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids/bids_generate_sidecar.ipynb)
to generate a JSON sidecar based on all the events files in a BIDS dataset.

#### Execute remodel script

The HED remodeling tools provide an interface to nearly all the HED tools functionality without programming. To use the tools, create a JSON file containing the commands that you
wish to execute on the events file. Command are available to do various transformations
and summaries of events files as explained in
the [**File remodeling quickstart**](https://www.hed-resources.org/en/latest/FileRemodelingQuickstart.html) and the
[**File remodeling tools**](https://www.hed-resources.org/en/latest/FileRemodelingTools.html).

``````{admonition} Execute a remodel script.

**Steps:**
 - Select the `Execute remodel script` action.  
 - Set `Include summaries` if you wish to get the summary output.  
 - Specify the HED version.  
 - Upload a JSON file containing the remodel commands.  
 - Optionally upload a JSON sidecar file (`.json`).  
 - Upload the events file (`.tsv`).    
 - Click the `Process` button.  

**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages.
If there are no errors, the tool returns a zip archive containing 
the transformed events file and any possible summaries that were generated.

``````

(sidecar-online-tools-anchor)=
### Sidecar files

BIDS JSON sidecars have file names ending in `events.json`.
These JSON files contain metadata and HED tags applicable to associated events files.

#### Validate a sidecar

The validate tool for sidecars is useful for debugging the HED annotations in your 
BIDS dataset while avoiding a full BIDS-validation each time you make a change.
The tool validates a single JSON sidecar.

``````{admonition} Validate a BIDS style JSON sidecar.

 - Select the `Validate` action.
 - Set `Check for warnings` to on if you want to include warnings.  
 - Select the HED version. 
 - Upload a JSON sidecar file (`.json`).   
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages.  
``````

The online validation tool is very useful for quick validation while developing your annotation.
For datasets that have all of their HED annotations in a single JSON sidecar in the 
dataset root directory, this is all that is needed.

However, if the sidecar is part of an inheritance chain, some of its definitions
are externally defined, or the sidecar contains tags from multiple HED schemas,
you should use the 
[bids_validate_dataset.ipynb](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids/bids_validate_dataset.ipynb)
Python Jupyter notebook to validate the HED in your BIDS dataset.

#### Convert sidecar to long

The convert sidecar to long tool first does a preliminary validation of the sidecar
to detect errors that prevent conversion from being successful.
You should always do a full validation prior to doing conversion.

If successful, the convert sidecar to long tool produces a new sidecar file
with all the HED tags in full long-form. The non-HED portions of the sidecar
are the same as in the original file.

``````{admonition} Convert a JSON sidecar HED tags to long form.

**Steps:**
 - Select the `Convert to long` action.  
 - Set `Expand defs` to on if you want to include expanded definitions.  
 - Specify the HED version. 
 - Upload the JSON sidecar file (`.json`).     
 - Click the `Process` button. 
    
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable converted JSON sidecar file.  
``````

#### Convert sidecar to short

The convert sidecar to short tool first does a preliminary validation of the sidecar
to detect errors that prevent conversion from being successful.
You should always do a full validation prior to doing conversion.

If successful, the convert sidecar to short tool produces a new sidecar file
with all the HED tags in short form, making the sidecar easier to read and work with.
The non-HED portions of the sidecar are the same as in the original file.

``````{admonition} Convert a JSON sidecar HED tags to short form.

**Steps:**
 - Select the `Convert to short` action.  
 - Set `Expand defs` to on if you want to include expanded definitions.  
 - Specify the HED version.   
 - Upload the JSON sidecar file (`.json`).  
 - Click the `Process` button. 
    
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable converted JSON sidecar file.  
``````

#### Extract spreadsheet from sidecar

JSON sidecars are sometimes hard to edit, particularly if the annotations are complicated.
The extract spreadsheet from sidecar tool
produces a 4-column `.tsv` file that can be edited with tools such as Excel.
The first row of the extracted spreadsheet contains the 4 column names:
`column_name`, `column_value`, `description` and `HED`.
See the [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html) 
for a tutorial on how to use the resulting spreadsheet for annotation.

``````{admonition} Extract a 4-column spreadsheet from a JSON sidecar.

**Steps:**
 - Select the `Extract HED spreadsheet` action.
 - Upload the JSON sidecar file (`.json`).     
 - Click the `Process` button. 
    
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable `.tsv` spreadsheet.  
``````
The [bids_sidecar_to_spreadsheet.ipynb](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids/bids_sidecar_to_spreadsheet.ipynb) Python Jupyter notebook does the same operation.

#### Merge a spreadsheet with a sidecar

This tool merges a 4-column tag spreadsheet with an existing JSON file
to produce a JSON file that contains HED annotations updated with the
information from the spreadsheet.
The spreadsheet can be in either tab-separated (`.tsv`) or in Excel (`.xlsx`) format,
but it must have the 4 column names: `column_name`, `column_value`, `description` and `HED`.

You have the option of including the contents of each cell in the *description* column
of the spreadsheet as a *Description/xxx* tag in the corresponding HED annotation.

See the [**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html) 
for a tutorial on how this works in practice.

``````{admonition} Merge a 4-column spreadsheet with a JSON sidecar.

**Steps:**
 - Select the `Merge HED spreadsheet` action.
 - Set `Include Description tags` to on if you want to include descriptions.  
 - Upload the target JSON sidecar file (`.json`).
 - Upload the spreadsheet to be merged (`.tsv` or `.xlsx`).    
 - Click the `Process` button. 
    
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable merged `.json` file.  
``````
The [bids_merge_sidecar.ipynb](https://github.com/hed-standard/hed-examples/blob/main/hedcode/jupyter_notebooks/bids/bids_merge_sidecar.ipynb) Python Jupyter notebook does the same operation.


(spreadsheet-online-tools-anchor)=
### Spreadsheet files

Spreadsheets (either in Excel or tab-separated-value format) are convenient for organizing tags.
Of particular interest is the 4-column spreadsheet described in the
[**BIDS annotation quickstart**](https://hed-examples.readthedocs.io/en/latest/BidsAnnotationQuickstart.html).
However, the online tools support a more general spreadsheet format,
where any columns can contain HED tags.
You can also specify prefixed columns --- 
columns in which a particular column has its values prefixed by a
particular HED tag prior to processing.
Often prefixing is used for the *Description* tag.

These spreadsheets are not necessarily associated with particular
datasets or events files.
Rather, they are useful when you are developing annotations in general.

#### Validate a spreadsheet

The validate tool for spreadsheets is useful for debugging HED annotations
while you are developing them.
The tool validates a single spreadsheet worksheet, either in tab-separated value (`.tsv`)
or Excel (`.xlsx`) format.
The Excel format supports spreadsheets containing multiple worksheets,
but you must validate each worksheet individually.
When you select a spreadsheet or change the individual worksheet being considered,
a list of column names will appear with checkboxes on the left and text boxes on the right.
Select the checkboxes for columns you wish to validate. Add a prefix tag in the corresponding
text box on the left, if the entry is to be prefixed by a particular tag before validating.

``````{admonition} Validate a spreadsheet.

 - Select the `Validate` action.
 - Set `Check for warnings` to on if you want to include warnings. 
 - Select the HED version.   
 - Upload a spreadsheet file (`.tsv` or `.xlsx`).
 - Select a worksheet if necessary.
 - Check the columns that contain HED information and should be validated.
 - Enter relevant prefixes in the text boxes to the right of the column names. 
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages.  
``````

#### Convert spreadsheet to long

The convert spreadsheet to long tool first does a preliminary validation
to detect errors that prevent conversion from being successful.
You should always do a full validation prior to doing conversion.

As with other spreadsheet operations, you will have to provide information about
which columns of the spreadsheet contain HED tags that should be converted to long
by checking the appropriate boxes on the left next to the desired column names.
This option does not have text boxes for prefixes.

If successful, the convert spreadsheet to long tool produces a new spreadsheet file
with all the HED tags in full long-form.
The non-HED portions of the spreadsheet and the prefix-columns are the same as in the original file.

``````{admonition} Convert a spreadsheet to long.

 - Select the `Convert to long` action.
 - Select the HED version.  
 - Upload a spreadsheet file (`.tsv` or `.xlsx`).
 - Select a worksheet if necessary.
 - Check the columns that contain HED information and should be validated.
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable spreadsheet with the HED tags converted to long.  

``````

#### Convert spreadsheet to short

The convert spreadsheet to short tool first does a preliminary validation
to detect errors that prevent conversion from being successful.
You should always do a full validation prior to doing conversion.

As with other spreadsheet operations, you will have to provide information about
which columns of the spreadsheet contain HED tags that should be converted to short
by checking the appropriate boxes on the left next to the desired column names.
This option does not have text boxes for prefixes.

If successful, the convert spreadsheet to short tool produces a new spreadsheet file
with all the HED tags in short form.
The non-HED portions of the spreadsheet and the prefix-columns are the same as in the original file.

``````{admonition} Convert a spreadsheet to short form.

 - Select the `Convert to short` action.
  - Select the HED version.  
 - Upload a spreadsheet file (`.tsv` or `.xlsx`).
 - Select a worksheet if necessary.
 - Check the columns that contain HED information and should be validated.
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherise the tool returns a downloadable spreadsheet with the HED tags converted to short.  
``````

(string-online-tools-anchor)=
### String online tools

While in the process of annotating or working with HED,
you might find it convenient to do a quick check or conversion of a HED string,
particularly when you are building complex annotations.
The HED string online tools are useful for this.

#### Validate a HED string

The validate tool for HED strings validates a single HED string.
The HED string may contain multiple HED tags and parenthesized groups of HED tags.

``````{admonition} Validate a HED string.

 - Select the `Validate` action.
 - Set `Check for warnings` to on if you want to include warnings.
 - Select the HED version.    
 - Type or paste your HED string into the text box.  
 - Click the `Process` button.
   
**Returns:** 
Errors are displayed in the *Results* text box at the bottom of the page.
``````


#### Convert a HED string to long

The convert string to long tool first does a preliminary validation of the string
to detect errors that prevent conversion from being successful.
You should always do a full validation prior to doing conversion.

If successful, the convert to long tool displays the converted string
in the *Results* text box at the bottom of the page.
You can then use copy or cut with paste to use the converted string in other documents.

``````{admonition} Convert HED string to long form.

**Steps:**
 - Select the `Convert to long` action.  
 - Specify the HED version.  
 - Type or paste your HED string into the text box.
 - Click the `Process` button. 
    
**Returns:**  
If there are any errors, the tool displays the error messages in the *Results* at the bottom of the page,
otherwise the tool displays the converted string in the *Results* textbox.  
``````

#### Convert HED string to short

The convert string to short tool first does a preliminary validation of the string
to detect errors that prevent conversion from being successful.
You should always do a full validation prior to doing conversion.

If successful, the convert to short tool displays the converted string
in the *Results* text box at the bottom of the page.
You can then use copy or cut with paste to use the converted string in other documents.

``````{admonition} Convert HED string to short form.

**Steps:**
 - Select the `Convert to short` action.  
 - Specify the HED version.  
 - Type or paste your HED string into the text box.
 - Click the `Process` button. 
     
**Returns:**  
If there are any errors, the tool displays the error messages in the *Results* at the bottom of the page,
otherwise the tool displays the converted string in the *Results* textbox.  
``````

(schema-online-tools-anchor)=
### Schema online tools
HED schema tools are designed to assist HED schema developers and library schema developers
in making sure that their schema has the correct form.
The schema tools also provide an easy mechanism for converting between
 `.xml` and `.mediawiki` schema formats.

You can view standard schema using the expandable
[**HED Schema Viewer**](https://www.hedtags.org/display_hed.html).

#### Validate a HED schema

The validation operation checks syntax as well as HED-3G compliance.
Schema nodes must be unique and have a specified format.

``````{admonition} Validate a HED schema.

 - Select the `Validate` action.
 - Set `Check for warnings` on if you want to include warnings.  
 - Enter a schema URL or upload a schema file (`.xml` or `.mediawiki`) and select the corresponding option. 
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages.  
``````

#### Convert a HED schema

The convert HED schema tool allows you to convert between `.mediawiki` and `.xml` formats.
All HED tools use the `.xml` format, but the `.mediawiki` format is much easier to read
and modify.

The [**HED specification**](https://github.com/hed-standard/hed-specification) GitHub
repository maintains both versions of the schema.

``````{admonition} Convert a HED schema.

 - Select the `Convert schema` action. 
 - Enter a schema URL or upload a schema file (`.xml` or `.mediawiki`) and select corresponding option.
 - Click the `Process` button.
   
**Returns:**  
If there are any errors, the tool returns a downloadable `.txt` file of error messages,
otherwise the tool returns a downloadable `.xml` or `.mediawiki` file.  
``````

(hed-restful-services-anchor)=
## HED RESTful services

HED supports a number of REST web services in support of HED including schema conversion
and validation, JSON sidecar validation, spreadsheet validation, and validation of a single
BIDS events file with supporting JSON sidecar.

Short-to-long and long-to-short conversion of HED tags are supported for HED strings,
JSON sidecars, BIDS-style events files, and spreadsheets in `.tsv` or `.xlsx` format.

Support is also included for assembling the annotations for a BIDS-style 
events file with a JSON sidecar and for generating a template of a JSON sidecar from a BIDS events file.

The [**web_services**](https://github.com/hed-standard/hed-examples/tree/main/hedcode/matlab_scripts/web_services) directory in the `hed-examples` repository provides MATLAB examples of how to call these 
services in MATLAB.

### Service setup

The HED web services are accessed by making a request to the HED web server to obtain a
CSRF access token for the session and then making subsequent requests as designed. 
The steps are:

1. Send an HTTP `get` request to the HED CSRF token access URL. 
2. Extract the CSRF token and returned cookie from the response to use in the headers of future `post` requests.
3. Send an HTTP `post` request in the format as described below and read the response.

The following table summarizes the location of the relevant URLs for online deployments of HED 
web-based tools and services.

`````{list-table} URLs for HED online services.
:header-rows: 1
:widths: 20 50

* - Service
  - URL
* - Online HED tools
  - [https://hedtools.ucsd.edu/hed](https://hedtools.ucsd.edu/hed)
* - CSRF token access
  - [https://hedtools.ucsd.edu/hed/services](https://hedtools.ucsd.edu/hed/services)  
* - Service request
  - [https://hedtools.ucsd.edu/hed/services_submit](https://hedtools.ucsd.edu/hed/services_submit)
`````

### Request format

HED services are accessed by passing a JSON dictionary of parameters in a request to the online server.
All requests are in JSON format and include a `service` name and additional parameters. 

The service names are of the form `target_command` where `target` specifies the 
input data type (events, sidecar, spreadsheet, string, or schema)
and `command`specifies the service to be performed. 
For example, `events_validate` indicates that
a BIDS-style events file is to be validated. 
The exception to this naming rule is the `get_services` command,
which returns a list of all available services and their parameters.

All parameter values are passed as strings. 
The contents of file parameters are read into strings to be passed as part of the request.
The following example shows the JSON for a HED service request to validate a JSON sidecar. 
The contents of the JSON file to be validated are abbreviated as `"json file text"`.

````{admonition} **Example:** Request parameters for validating a JSON sidecar.

```json
{
    "service": "sidecar_validate",
    "schema_version": "8.0.0", 
    "json_string": "json file text",
    "check_for_warnings": "on"
}
```

````

The parameters are explained in the following table. Parameter values listed in square brackets
(e,g, [`a`, `b`]) indicate that only one of `a` or `b`should be provided.

`````{list-table} Summary of HED ReST services
:header-rows: 1
:widths: 15 20 45

* - Service
  - Parameters	
  - Descriptions
* - get_services
  - none
  - Returns a list of available services.
* - events_assemble  
  - events_string,  
    json_string,   
    [schema_version,      
    schema_string],   
    check_for_warnings,     
    expand_defs   
  - Assemble tags for each event in a BIDS-style events file into a single HED string. 
       
    Returned data: a file of assembled events as text or an error file as text if errors.
* - events_extract  
  - events_string   
  - Extract a template JSON sidecar based on the contents of the events file.  
    
    Returned data: A JSON sidecar (template) if no errors.
* - events_validate  
  - events_string,   
    json_string,  
    [schema_string,  
     schema_url,  
     schema_version],  
    check_for_warnings   
  - Validate a BIDS-style events file and its JSON sidecar if provided.  
      
    Returned data: an error file as text if errors.  
* - sidecar_to_long  
  - json_string,   
    [schema_string,  
     schema_url,  
     schema_version],   
  - Convert a JSON sidecar with all of its HED tags expressed in long form.  
    
    Returned data: a converted JSON sidecar as text or an error file as text if errors.  
* - sidecar_to_short  
  - json_string,   
    [schema_string,  
     schema_url,  
     schema_version]    
  - Convert a JSON sidecar with all of its HED tags expressed in short form.  
    
    Returned data: a converted JSON sidecar as text or an error file as text if errors.  
* - sidecar_validate  
  - json_string,   
    [schema_string,  
     schema_url,  
     schema_version],  
    check_for_warnings  
  - Validate a BIDS-style JSON sidecar.  
    
    Returned data: an error file as text if errors.
* - spreadsheet_to_long  
  - spreadsheet_string,   
    [schema_string,  
     schema_url,  
     schema_version],  
    check_for_warnings,  
    column_x_check,  
    column_x_input,  
    has_column_names        
  - Convert a tag spreadsheet (tsv only) to long form.  
    
    Returned data: a converted tag spreadsheet as text or an error file as text if errors.    
* - spreadsheet_to_short 
  - spreadsheet_string,    
    [schema_string,  
     schema_url,  
     schema_version],  
    check_for_warnings,  
    column_x_check,  
    column_x_input,  
    has_column_names     
  - Convert a tag spreadsheet (tsv only) to short form.  
  
    Returned data: a converted tag spreadsheet as text or an error file as text if errors.  
* - spreadsheet_validate  
  - spreadsheet_string,   
    [schema_string,  
     schema_url,  
     schema_version],  
    check_for_warnings,  
    column_x_check,  
    column_x_input,  
    has_column_names,  
  - Validate a tag spreadsheet (tab-separated format only). 
     
    Returned data: an error file as text if errors.        
* - strings_to_long  
  - string_list,    
    [schema_string,  
     schema_url,  
     schema_version]  
  - Convert a list of strings to long.  
  
    Returned data: an error string or a list of strings in long form.
* - strings_to_short 
  - string_list,   
    [schema_string,  
     schema_url,  
     schema_version]  
  - Convert errors or a list of short-form strings.  
    
    Returned data: an error string or a list of strings in short form.
* - strings_validate  
  - hed_strings,   
    [schema_string,  
     schema_url,  
     schema_version]  
  - Validates a list of hed strings and returns a list of errors.
      
    Returned data: an error string or a list of strings in short form.
``````

The following table gives an explanation of the parameters used for various services.


`````{list-table} Parameters for web services.
:header-rows: 1
:widths: 20 20 40

* - Key value
  - Type
  - Description
* - check_for_warnings
  - boolean
  - If true, check for warnings when processing.
* - column_x_check:
  - boolean
  - If present with value 'on', column x has HED tags.".
* - column_x_input:
  - string
  - Contains the prefix prepended to column x if column x has HED tags.
* - expand_defs
  - boolean
  - If true replaces *def/XXX* with *def-expand/XXX* grouped with the definition content.
* - events_string
  - string
  - A BIDS events file as a string..
* - hed_columns
  - list of numbers
  - A list of HED string column numbers (starting with 1).
* - hed_schema_string
  - string
  - HED schema in XML format as a string.
* - hed_strings
  - list of strings
  - A list containing HED strings.
* - json_string
  - string
  - BIDS-style JSON events sidecar as a string.
* - json_strings
  - string
  - A list of BIDS-style JSON sidecars as strings.
* - schema_string
  - string
  - A HED schema file as a string.
* - schema_version
  - string
  - Version of HED to be accessed if relevant.
* - service
  - string
  - The name of the requested service.
* - spreadsheet_string
  - string
  - A spreadsheet tsv as a string.
``````
### Service responses

The web-services always return a JSON dictionary with four keys: `service`, 
`results`, `error_type`, and `error_msg`. If `error_type` and `error_msg` 
are not empty, the operation failed, while if these fields are empty, 
the operation completed. Completed operations always return their results 
in the `results` dictionary. Keys in the `results` dictionary return 
as part of a HED web service response.

`````{list-table} The results dictionary.
:header-rows: 1
:widths: 20 10 50

* - Key
  - Type
  - Description
* - command
  - string
  - Command executed in response to the service request.
* - command_target
  - string
  - The type of data on which the command was executed..
* - data
  - string
  - A list of errors or the processed result.
* - schema_version
  - string
  - The version of the HED schema used in the processing.
* - msg_category
  - string
  - One of success, warning, or failure depending on the result.
* - msg
  - string
  - Explanation of the result of service processing.

``````

The `msg` and `msg_category` pertain to contents of the response information. For example a `msg_category` of 
`warning` in response to a validation request indicates that the validation completed and that the object that
was validated had validation errors.  In contrast, the `error_type`, and `error_msg` values are 
only for web service requests. These keys indicate whether validation was able to take place. 
Examples of failures that would cause errors include the service timing out or the 
service request parameters were incorrect. 
