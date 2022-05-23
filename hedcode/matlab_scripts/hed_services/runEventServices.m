%% Shows how to call hed-services to process a BIDS events file.
% 
%  Example 1: Validate valid events file using HED version.
%
%  Example 2: Validate invalid events file using a HED URL.
%
%  Example 3: Assemble valid event HED strings uploading HED schema.
%
%  Example 4: Assemble valid event HED strings (def expand) using HED version.
%
%  Example 5: Assemble valid event HED strings (no def expand) with extra columns.
%
%  Example 6: Generate a JSON sidecar template from an events file.


%% Setup requires a csrf_url and services_url. Must set header and options.
host = 'https://hedtools.ucsd.edu/hed';
csrfUrl = [host '/services']; 
servicesUrl = [host '/services_submit'];
[cookie, csrftoken] = getSessionInfo(csrfUrl);
header = ["Content-Type" "application/json"; ...
          "Accept" "application/json"; ...
          "X-CSRFToken" csrftoken; "Cookie" cookie];

options = weboptions('MediaType', 'application/json', 'Timeout', 120, ...
                     'HeaderFields', header);

%% Read the JSON sidecar into a string for all examples
jsonText = fileread('../../../datasets/eeg_ds003654s_hed/task-FacePerception_events.json');
eventsText = fileread('../../../datasets/eeg_ds003654s_hed/sub-002/eeg/sub-002_task-FacePerception_run-1_events.tsv');
jsonBadText = fileread('../../data/bids_data/both_types_events_errors.json');
myURL = ['https://raw.githubusercontent.com/hed-standard/' ...
         'hed-specification/master/hedxml/HED8.0.0.xml'];
schemaText = fileread('../../data/schema_data/HED8.0.0.xml');


%% Example 1: Validate valid events file using HED version.
request1 = struct('service', 'events_validate', ...
                  'schema_version', '8.0.0', ...
                  'json_string', jsonText, ...
                  'events_string', eventsText, ...
                  'check_for_warnings', 'off');
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 validating a valid event file');

%% Example 2: Validate invalid events file using a HED URL.
request2 = struct('service', 'events_validate', ...
                  'schema_url', myURL, ...
                  'json_string', jsonBadText, ...
                  'events_string', eventsText, ...
                  'check_for_warnings', 'off');

response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, ...
             'Example 2 validating an events with invalid JSON');

%% Example 3: Assemble valid events file uploading a HED schema
request3 = struct('service', 'events_assemble', ...
                  'schema_string', schemaText, ...
                  'json_string', jsonText, ...
                  'events_string', eventsText, ...
                  'columns_included', '', ...
                  'expand_defs', 'off');
request3.columns_included = {'onset'};
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 output');

%%  Example 4: Assemble valid event HED strings(expand defs on).
request4 = struct('service', 'events_assemble', ...
                  'schema_version', '8.0.0', ...
                  'json_string', jsonText, ...
                  'events_string', eventsText, ...
                  'expand_defs', 'on');
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Example 4 assembling HED annotations for events');

%%  Example 5: Assemble valid event HED strings with additional columns.
columns_included = {'onset', 'face_type', 'rep_status'};
request5 = struct('service', 'events_assemble', ...
                  'schema_version', '8.0.0', ...
                  'json_string', jsonText, ...
                  'events_string', eventsText, ...
                  'columns_included', '', ...
                  'expand_defs', 'off');
request5.columns_included = columns_included;
response5 = webwrite(servicesUrl, request5, options);
response5 = jsondecode(response5);
outputReport(response5, 'Example 5 assembling HED with extra columns for events');


%%  Example 6: Generate a sidecar template from an events file.
request6 = struct('service', 'events_generate_sidecar', ...
                  'events_string', eventsText);
request6.columns_categorical = {'event_type', 'face_type', 'rep_status'};
request6.columns_value = {'trial', 'rep_lag', 'stim_file'};
response6 = webwrite(servicesUrl, request6, options);
response6 = jsondecode(response6);
outputReport(response6, 'Example 6 generate a sidecar from an event file');
