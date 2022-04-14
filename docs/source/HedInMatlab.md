# HED in MATLAB

There are currently three types of support available for HED (Hierarchical Event Descriptors) supports in MATLAB:

* [**HED services in MATLAB**](hed-services-matlab-anchor) - web services called from MATLAB scripts
* [**EEGLAB plug-in integration**](eeglab-integration-anchor) - EEGLAB plugins and other HED support 
* [**HED MATLAB scripts**](hed-matlab-scripts-anchor) - useful MATLAB data processing scripts and functions

HED services allow MATLAB programs to request the same services that are available 
through the browser at [https://hedtools.ucsd.edu/hed](https://hedtools.ucsd.edu/hed).

(hed-services-matlab-anchor)=
## HED services in MATLAB

HED RESTful services allow programs to make requests directly to the
HED online tools available at
[https://hedtools.ucsd.edu/hed](https://hedtools.ucsd.edu/hed) or
in a locally-deployed docker module.
See [**HED-web**](https://hed-web.readthedocs.io/en/latest/index.html)
for additional information on the deployment.

| Target | MATLAB Script |
| ------ | ------------- |
| Events | [**<code>runEventServices<code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/runEventServices.m) |
| Schema |      *in progress*          |
| Sidecars | [**<code>runSidecarServices</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/runSidecarServices.m) |
| Spreadsheets | [**<code>runSpreadsheetServices</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/runSpreadsheetServices.m) |
| Strings | [**<code>runStringServices</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/runStringServices.m) |

Calling HED services from MATLAB requires the following steps:
1. Set up a session:
   1. Establish a session by requesting a CSRF token and a cookie.
   2. Construct a header array using the token and the cookie.
2. Create a request structure.
5. Make a request using the MATLAB `webwrite`.
6. Decode and use the returned response from `webwrite`.

Usually, you will do the first step (the session setup) once at the beginning of your script
to construct a fixed session header that can be used in subsequent requests in your script.

### Setting up a session from MATLAB

The goal of the session setup is to construct a header that can be used in subsequent web requests.
The first step is to call the [**<code>getSessionInfo</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/getSessionInfo.m)
to obtain a CSRF token and a cookie:

(setting)=
`````{admonition} Establish a session.
:class: tip
```matlab

host = 'https://hedtools.ucsd.edu/hed';
csrfUrl = [host '/services']; 
servicesUrl = [host '/services_submit'];
[cookie, csrftoken] = getSessionInfo(csrfUrl);
```
`````
The `host` should be set to the URL of the webserver that you are using.
The remaining variables are fixed.

Once you have the session information, call the MATLAB `weboptions` to create an opaque
`weboptions` object, which can be passed to subsequent MATLAB `webwrite` requests.

`````{admonition} Create an options object for future requests.
:class: tip
```matlab
header = ["Content-Type" "application/json"; "Accept" "application/json"; ...
          "X-CSRFToken" csrftoken; "Cookie" cookie];
options = weboptions('MediaType', 'application/json', 'Timeout', 120, 'HeaderFields', header);
```
`````
The `MediaType` parameter indicates the format of the request and response.
All HED services use JSON for both requests and responses.

The `Timeout` parameter indicates how many seconds MATLAB will wait for a response
before returning as a failed operation.
The `HeaderFields` sets the parameters of HTTP request.

### Creating a request structure

The request structure is a MATLAB `struct` which must have a `service` field and can have an
arbitrary number of fields depending on which service is being requested.

The simplest service is `get_services`,
which returns a string containing information about the available services. 
This service requires no additional parameters.

`````{admonition} Request a list of available HED web services.
:class: tip
```matlab
servicesUrl = 'https://hedtools.ucsd.edu/hed/services_submit';
request = struct('service', 'get_services');
response = webwrite(servicesUrl, request, options);
response = jsondecode(response);
```
`````
The example assumes that the `options` object has been created as explained above
and accesses the online web services.
The MATLAB `webwrite` returns a JSON structure as specified in the `options`.
The MATLAB `jsondecode` function returns a MATLAB `struct` whose format is explained
below in [**Decoding a MATLAB response**](decoding-a-matlab-response-anchor).

The [**<code>runGetServices.m</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/runGetServices.m)
script contains a complete example of running the service.
You should always run this script before developing or running any of your own scripts
to make sure that the service is up and that you have Internet access.

Except for `get_services`, all other services are of the form *target_command*
where *target* is the primary type of data acted on (events, schema, sidecar, spreadsheet, or string).
The possible values for *command* depend on the value of *target*.
For example `sidecar_validate` requests that a JSON sidecar be validated.

The `get_services` command provides information about the HED services that
are available and the parameters required.
The `get_services` entry for `sidecar_validate` is the following:

`````{admonition} The get_services entry for sidecar_validate.
:class: tip
```text
sidecar_validate:
	Description: Validate a BIDS JSON sidecar (in string form) and return errors.
	Parameters: ["json_string", ["schema_string", "schema_url", "schema_version"], "check_for_warnings"]
	Returns: A list of errors if any.
```
`````

The *Parameters* section indicates the fields in addition to `service`
that are needed in the request structure.

Options listed square brackets ([]) indicate that only one of the parameters should be provided.
For example, `sidecar_validate` requires a HED schema.
One possibility is to read a schema into a string and provide this information in `schema_string`.
Another possibility is to provide a URL for the schema.
The most-commonly used option is to use `schema_version` to indicate one of the supported
versions available in the 
[**hedxml**](https://github.com/hed-standard/hed-specification/tree/master/hedxml) directory of the
[**hed-specification**](https://github.com/hed-standard/hed-specification) repository on GitHub.

(create-request-sidecar-validate-anchor)=
`````{admonition} Create a request for the sidecar_validate web service.
:class: tip
```matlab
jsonText = fileread('../../../datasets/eeg_ds003654s_hed/task-FacePerception_events.json');
request = struct('service', 'sidecar_validate', 'schema_version', '8.0.0', ...
                 'json_string', jsonText, 'check_for_warnings', 'on');
```
`````
This example reads the JSON sidecar to be validated as a character array into the variable `jsonText`
and makes a request for validation using HED8.0.0.xml.

The request indicates that validation warnings as well as errors should be included in the response.
If you wish to exclude warnings, use `off` instead of `on` as the `check_for_warnings` field value.

The [**<code>runSidecarServices.m</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/runSidecarServices.m) script
shows complete examples of the various HED services for JSON sidecars.

### Making a service request

The HED services all use the MATLAB `webwrite` to make HED web service requests.
The following call uses the 
[**sidecar_validate request**](create-request-sidecar-validate-anchor)
from the previous section.

`````{admonition} Request the sidecar validation service.
:class: tip
```matlab
response = webwrite(servicesUrl, request, options);
response = jsondecode(response);
outputReport(response, 'Example: validate a JSON sidecar');
```
`````

The [**<code>outputReport.m</code>**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_services/outputReport.m)
MATLAB script outputs the response in readable form with a user-provided table.

If the web server is down or times out during a request,
the MATLAB `web_write` function throws an exception,
and the script terminates without setting the response.

If the connection completes successfully, the response will set.
The next section explains the response structure in more detail.

(decoding-a-service-response-anchor)=
### Decoding a service response

All HED web services return a response consisting of a JSON dictionary with 
4 keys as summarized in this table.

| Field name | Meaning |
| ---------- | ------- |
| service | Name of the requested service. |
| results | Results of the operation. |
| error_type | Type of error if the service failed. |
| error_msg | Explanation of the message if the service failed. |

The `jsondecode` function translates the JSON dictionary into a MATLAB structure.

The `error_type` indicates whether the service request completed successfully
and was able to get results. 
The `error_type` **does NOT** indicate the nature of the results 
(for example whether a JSON sidecar was valid or not),
but rather whether the server was able to complete the request without raising an exception.
A failure `error_type` is highly unusual and indicates some type of
unexpected internal web service error.

The `results` structure has the actual results of the service request.

| Field name | Meaning   |
| ---------- | ------- |
| command | Command executed in response to the service request. |
| command_target | Type of data on which the command was executed. |
| data | Data returned by the service (either processed result or a list of errors). |
| msg_category | Success or warning depending on the result of processing the service. |
| msg | Explanation of the output of the service. |
| output_display_name | (Optional) File name for saving return data. |
| schema_version | (Optional) Version of the HED schema used in the processing. |

The `results` structure will always have `command`, `command_target`
fields indicating what operation was performed on what type of data.

The `msg_category` will be `success` or `warning` depending on whether there were errors.
The contents of the `data` field will contain different information depending on the `msg_category`.
For example, if a sidecar had validation errors, 
`results.msg_category` will be `warning` and the `results.data` value
should be interpreted as a list of errors.
If the sidecar had no errors, `results.data` will be an empty string.

(eeglab-integration-anchor)=
## EEGLAB plug-in integration
EEGLAB is the most widely used EEG software environment for analysis of human electrophsyiological (and related) data. It combines graphical and command-line user interfaces, making it friendly for both beginners who may who prefer a more flexible, visual, and automated way of analyzing data, and experts, who can easily customize and extend the EEGLAB tool environment by writing new EEGLAB-compatible scripts and functions, and/or by publishing EEGLAB plug-in toolboxes that are then immediately callable from the EEGLAB graphic user interface (GUI) menu or MATLAB commandline of anyone who downloads them. HED is fully integrated into EEGLAB via the *HEDTools* plug-in, allowing users to annotate their EEGLAB STUDY and datasets with HED, as well as enabling HED-based data manipulation and processing.

__1. Installing *HEDTools*__

*HEDTools* EEGLAB plug-in can be installed using one of the following ways:

1. From the EEGLAB Extension Manager: Launch EEGLAB and go to **File -> Manage EEGLAB extension**. The extension manager GUI will pop up. From this GUI look for and select the plug-in *HEDTools* from the main window, then click into the *Install/Update* button to install the plug-in.
2. From the web: Download the zip file with the content of the plug-in *HEDTools* either from [GitHub](https://github.com/hed-standard/hed-matlab/blob/master/EEGLABPlugin) or from the EEGLAB [plug-ins summary page](https://sccn.ucsd.edu/eeglab/plugin_uploader/plugin_list_all.php). Decompress the zip file into the folder *../eeglab/plugins* and restart the *eeglab* function in a MATLAB session.

__2. Annotating dataset__

We will start by adding HED annotations to the EEGLAB tutorial dataset. Once you have opened the EEGLAB main window, load the dataset by clicking on the **File > Load existing dataset** menu item, then selecting the tutorial dataset under your eeglab installation _eeglab/sample_data/eeglab_data.set_. 

Read a description of the dataset and of its included event codes by selecting **Edit -> About this dataset**:

<img src="_static/images/I15about_this_dataset.png" alt="I15about_this_dataset" align="center" style="zoom:100%;" />

The description gave us a general idea of the codes found in the event structure. Yet inquisitive researchers who are intersted in the exact nature of the stimuli (e.g. color and exact location of the squares on the screen) would have to look up the referenced paper for details. Our goal in using HED tags is to describe the experimental events that are recorded in the *EEG.event* data structure in sufficient detail that anyone using the dataset in the future will not need to find and read a separate, detailed description of the dataset or study to understand the exact natures of the recorded experimental events. As we will see later in section 3, such annotation will allow us to extract epochs using meaningful HED tags instead of the alpha-numeric codes often associated with shared EEG data.

To add and view HED tags for the dataset, from EEGLAB menu, select **Edit -> Add/Edit event HED tags**. _HEDTools_ will extract information from the *EEG.event* structure and automatically detect present fields and their unique values, , ignoring default fields *.latency*, *.epoch*, and *.urevent*. A window will show up asking you to verify/select categorical fields:

<img src="_static/images/CTagger_categorical_field.jpg" alt="categorical_fields" />

Here both *position* and *type* are categorical fields. *HEDTools* automatically detects fields with less than 20 unique values to be categorical. We will click *Continue* to bring up the *CTagger* interface:
![CTAGGER](_static/images/CTagger_interface.jpg)

CTagger (for 'Community Tagger') is a graphical user interface (GUI) built to faciliate the process of adding HED tags to recorded events in existing datasets. Through its GUI, users can explore the HED schema, quickly look up and add tags (or tag groups) to the desired event codes, and use import/export features to reuse tags on other datasets (e.g., other datasets from the same study). The process of tagging can be to simply choose tags from the schema to associate with each event code or typing tags directly into the editor window once users are already familiar with the HED vocabulary. Here CTagger is used as part of the HEDTools plug-in but it can also be used as a standalone application. Detailed introduction on how to download and use the standalone version of CTagger, as well as step-by-step guide on how to add HED annotation with CTagger, can be found at the [tagging with CTagger page](./TaggingWithCTagger.md).

Here we have prepared annotations as through the process in [HED annotation quick start](./HedAnnotationQuickstart.md), we will import the annotation saved in the _events.json file format. Download the file [eeglab-tutorial_events.json](./_static/data/eeglab-tutorial_events.json) then select *File -> Import -> Import BIDS events.json file* to import it to CTagger. You can now review all the tags via *File -> Review all tags*. 

![review tag](_static/images/review-all-tags.jpg)

The last step of the annotation process is to validate our annotations. Click on the *Validate all* button at the bottom pane. A window will pop up showing validation results. If there're issues with the annotation, there will be a line for each of the issues found. Here are an example of validation log file with issues:

![validation-issues](_static/images/validation-error.jpg)

Otherwise, a message will appear confirming that our annotation is correct:

![validation-success](_static/images/validation-success.jpg)

In our case, our annotation looks good. We can now click *Finish* to end the annotation. The tag review window will show up again for a final review and the option to save the annotation into an _events.json file for distribution just as with the *eeglab-tutorial_events.json*. Hit *Ok* to continue after that.

A last window will pop up asking what you would like to do to the newly tagged dataset and the old, untagged, dataset. You can choose to overwrite the old dataset with the tagged one or save new dataset as a separate file. Click **Ok** when you're done. 

![new-set](_static/images/pop_newset.jpg)

You just finished tagging! *HEDTools* generates the final HED string for each event by concatenating all tags associated with the event values of that event, seperated by commas, and put the string in a new field **HED** in EEG.event. 

__3. Extracting HED-tagged events and event-locked data epochs from an EEGLAB dataset__

The EEGLAB *pop_epoch* function extracts data epochs that are time locked to specified event types. This function allows you to epoch on one of a specified list of event types as defined by the *EEG.event.type* field of the EEG structure. *HEDTools* provides a simple way for extracting data epochs from annotated datasets using a much richer set of conditions. To use HED epoching, you must have annotated the EEG dataset. If the dataset is not tagged, please refer to [section 2](#2) on how to tag a dataset.

Start by choosing the menu option **Tools > Extract epochs by tags**:

<img src="images/extract-epoch-selection.png" alt="extract-epoch-selection" style="zoom:50%;" />



This will bring up a window to specify the options for extracting data epochs:

<img src="images/epoch-options.png" alt="extract-epoch-selection" style="zoom:50%;" />

The *pop_epochhed* menu is almost identical to the EEGLAB *pop_epoch* menu with the exceptions of the first input field (**Time-locking HED tag(s)**) and the second input field (**Exclusive HED tag(s)**). Instead of passing in or selecting from a group of unique event types, the user passes in a comma separated list of HED tags. For each event all HED tags in this list must be found for a data epoch to be generated. Clicking the adjacent button (with the label …) will open a search tool to help you select HED tags retrieved from the dataset.

<img src="images/epoch-tags.png" alt="extract-epoch-selection" style="zoom:50%;" />

When you type something in the search bar, the dialog displays a list below containing possible matches. Pressing the "up" and "down" arrows on the keyboard while the cursor is in the search bar moves to the next or previous tag in the list. Pressing "Enter" selects the current tag in the list and adds the tag to the search bar. You can continue search and add tags after adding a comma after each tag. When done, click the **Ok** button to return to the main epoching menu. 

Exclusive tags negate matches to other tags that are grouped with them. In order for a match to be returned the exclusive tag must be specified in the search string also. By default, there are three exclusive tags: *Attribute/Intended effect*, *Attribute/Offset*, and *Attribute/Participant indication*.

Another thing to keep in mind is that the matching works differently when specifying non-exclusive tags that are attributes (_Attribute/*_ tags). If an attribute tag is specified in the search by itself then it needs to be present at the top-level of the event tags, the top-level and all tag groups, or in all tag groups if there are no top-level tags. 

Here are a few examples applied on part of the HED string produced by our previous tagging to help clarify the way that the search works. Here the event tags are printed in their separate lines to make it easier to read. We will leave the exclusive tags list as default, which include *Attribute/Intended effect*.

Event tags:

"Event/Category/Experimental stimulus, 

Participant/State/Attention/Covert, 

Participant/State/Under time pressure, 

Sensory presentation/Visual/Rendering type/Screen/2D, 

(Action/Button press, Attribute/Intended effect),

(Attribute/Location/Screen/Center displacement/Horizontal/5.5 degrees, Attribute/Location/Screen/Center displacement/Vertical/1.8 degrees, Attribute/Size/Area/1.4 cm2, Attribute/Visual/Color/Black, Item/2D shape/Ellipse/Circle)"

**Example 1**: Partial match found. 

Search tags: Participant/State/Attention 

Result: True 

**Example 2**: Match found but offset because exclusive tag isn’t specified in search. 

Search tags: Action/Button press

Result: False 

**Example 3**: Match found but offset because exclusive tags need to be grouped with other tags. 

Search tags: Participant/State/Under time pressure, Attribute/Intended effect 

Result: False 

**Example 4**: Match found but offset because attribute tags are found in group but not found at the top-level and the whole group doesn't match. 

Search tags: Attribute/Visual/Color/Black, Attribute/Size/Area/1.4 cm2 

Result: False 

**Example 5**: Match found because a whole group is matched even though it doesn’t match the other group 

Search tags: Action/Button press, Attribute/Intended effect

Result: True


(hed-matlab-scripts-anchor)=
## HED MATLAB scripts

* [**Find files in directory tree**](find-files-directory-tree-anchor)
* [**EEGLAB events to a tsv file**](eeglab-events-to-a-tsv-file-anchor)  


(find-files-directory-tree-anchor)=
### Find files in directory tree

The [**getFileList**](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_utilities/getFileList.m)
function returns a cell array of full path names of
the files in a directory tree satisfying specified criteria.

`````{admonition} Example call to getFileList.
:class: tip
````matlab
%% Call getFileList to find fullpaths of files of form *_eeg.set
rootPath = '/local/data/Sternberg';
excludeDirs = {'sourcedata', 'code', 'stimuli'};
namePrefix = '';
nameSuffix = '_eeg';
extensions = {'.set'};
selectedList = getFileList(rootPath, namePrefix, nameSuffix, extensions, excludeDirs);

%% Output the list of filenames
for k = 1:length(selectedList)
    fprintf('%s\n', selectedList{k});
end
````
`````

The `getFileList` function is useful in scripts designed to apply
an operation to all files of a particular type in a directory tree.

(eeglab-events-to-a-tsv-file-anchor)=
### EEGLAB events to a tsv file

[**EEGLAB**](https://eeglab.org/) stores EEG files in `.set` format or as a
combination of two files in `.set` and `.fdt` format, respectively.
The EEGLAB `.set` format stores the data in a Matlab `EEG` structure.

The events in the recording are stored internally in the `.set` file
in the `EEG.event` substructure.
Assuming that your dataset is in 
[**BIDS**](https://bids-specification.readthedocs.io/en/stable/) format,
you may want to compare the events stored internally in `EEG.event` with
the events stored in an external `events.tsv` file required by BIDS.

The [`eeglabEventsToTsv`](https://raw.githubusercontent.com/hed-standard/hed-examples/main/hedcode/matlab_scripts/hed_utilities/eeglabEventsToTsv.m)
function takes a list of full pathnames of EEGLAB `.set` files and creates `.tsv` files
containing the `EEG.event` structure in tab-separated-value form in the same
directories as the corresponding `.set` files.

`````{admonition} Example call to eeglabEventsToTsv.
:class: tip
````matlab
% Use eeglabEventsToTsv to save EEG.set events to a tsv file
saveSuffix = '_events.tsv';
nameSuffix = '_eeg';
eeglabEventsToTsv(selectedList, nameSuffix, saveSuffix);
````
`````

In this example, `/local/data/Sternberg/sub-01_task-memory_run-1_eeg.set`
will produce an event file `/local/data/Sternberg/sub-01_task-memory_run-1_events.tsv`.
The `nameSuffix` and extension are removed from the filename, and the 
`saveSuffix` is appended.
