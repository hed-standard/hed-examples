%% Shows how to call hed-services to process a BIDS JSON sidecar.
% 
%  Example 1: Validate valid JSON sidecar using a HED version.
%
%  Example 2: Validate invalid JSON sidecar using HED URL.
%
%  Example 3: Convert valid JSON sidecar to long uploading HED schema.
%
%  Example 4: Convert valid JSON sidecar to short using a HED version.
%
%  Example 5: Extract a 4-column spreadsheet from a valid JSON sidecar.
%
%  Example 6: Merge a 4-column spreadsheet with a JSON sidecar.
%
%% Setup requires a csrf_url and services_url. Must set header and options.
host = 'http://127.0.0.1:5000';
%host = 'https://hedtools.ucsd.edu/hed';
csrf_url = [host '/services']; 
services_url = [host '/services_submit'];
[cookie, csrftoken] = getSessionInfo(csrf_url);
header = ["Content-Type" "application/json"; ...
          "Accept" "application/json"; 
          "X-CSRFToken" csrftoken; "Cookie" cookie];

options = weboptions('MediaType', 'application/json', 'Timeout', 120, ...
                     'HeaderFields', header);

%% Set up some data to use for the examples
jsonText = fileread('../../../datasets/eeg_ds003654s_hed/task-FacePerception_events.json');
jsonBadText = fileread('../../data/bids_data/both_types_events_errors.json');
spreadsheetText = fileread('../../data/bids_data/task-FacePerception_events_extracted.tsv');
myURL = ['https://raw.githubusercontent.com/hed-standard/' ...
         'hed-specification/master/hedxml/HED8.0.0.xml'];
schemaText = fileread('../../data/schema_data/HED8.0.0.xml');

%% Example 1: Validate valid JSON sidecar using a HED version.
request1 = struct('service', 'sidecar_validate', ...
                 'schema_version', '8.0.0', ...
                 'json_string', jsonText, ...
                 'check_for_warnings', 'on');
response1 = webwrite(services_url, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 validate a valid JSON sidecar');

%% Example 2: Validate invalid JSON sidecar using HED URL.
request2 = struct('service', 'sidecar_validate', ...
                  'json_string', jsonBadText, ...
                  'schema_url', myURL, ...    
                  'check_for_warnings', 'on');
response2 = webwrite(services_url, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 validate an invalid JSON sidecar');

%% Example 3: Convert valid JSON sidecar to long uploading HED schema.
request3 = struct('service', 'sidecar_to_long', ...
                  'schema_string', schemaText, ...
                  'json_string', jsonText, ...
                  'expand_defs', 'off');

response3 = webwrite(services_url, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 convert a JSON sidecar to long form');

%%  Example 4: Convert valid JSON sidecar to short using a HED version..
request4 = struct('service', 'sidecar_to_short', ...
                  'schema_version', '8.0.0', ...
                  'json_string', jsonText, ...
                  'expand_defs', 'on');
response4 = webwrite(services_url, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Example 4 convert a JSON sidecar to short form.');

%%  Example 5: Extract a 4-column spreadsheet from a JSON sidecar.
request5 = struct('service', 'sidecar_extract_spreadsheet', ...
                  'json_string', jsonText);
response5 = webwrite(services_url, request5, options);
response5 = jsondecode(response5);
outputReport(response5, ...
             'Example 5 extract a 4-column spreadsheet from a JSON sidecar.');
         
%%  Example 6: Merge a 4-column spreadsheet with a JSON sidecar.
request6 = struct('service', 'sidecar_merge_spreadsheet', ...
                  'json_string', '{}', 'has_column_names', 'on', ...
                  'spreadsheet_string', spreadsheetText);
response6 = webwrite(services_url, request6, options);
response6 = jsondecode(response6);
outputReport(response6, ...
             'Example 6 merge a 4-column spreadsheet with a JSON sidecar.');
 
 