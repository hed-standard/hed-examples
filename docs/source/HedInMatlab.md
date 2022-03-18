# HED in MATLAB

There are currently three types of support available for HED (Hierarchical Event Descriptors) supports in MATLAB:

* [**HED services in MATLAB**](hed-services-matlab-anchor) - web services called from MATLAB scripts
* [**EEGLAB integration**](eeglab-integration-anchor) - EEGLAB plugins and other HED support 
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
## EEGLAB integration

This is where a description of use in EEGLAB with links.

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
