%% Shows how to call hed-services to searcg a BIDS events file.
%
%  Example 1: Search an events file for HED using a valid query.
%
%  Example 2: Search an events file for HED using an invalid query.

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
jsonBadText = fileread('../../data/bids_data/both_types_events_errors.json');
eventsText = fileread('../../../datasets/eeg_ds003654s_hed/sub-002/eeg/sub-002_task-FacePerception_run-1_events.tsv');
schemaText = fileread('../../data/schema_data/HED8.0.0.xml');
myURL = ['https://raw.githubusercontent.com/hed-standard/' ...
         'hed-specification/master/hedxml/HED8.0.0.xml'];
     

%% Example 1: Search an events file for HED
request1 = struct('service', 'events_search', ...
                  'schema_version', '8.0.0', ...
                  'json_string', jsonText, ...
                  'events_string', eventsText, ...
                  'query', '[[Intended-effect, Cue]]');

response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 Querying an events file');
