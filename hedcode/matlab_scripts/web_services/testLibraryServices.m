function errors = testLibraryServices(host)

%% Shows how to call hed-services using libraries.
% 
%  Example 1: Validate valid events file using HED version list.
%  Example 2: Validate valid events file using HED version list needed libraries.
%  Example 3: Validate events file invalid because of missing library.

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getTestData();
errors = {};

%% Example 1: Validate valid events file using HED versions no library tags.
request1 = struct('service', 'events_validate', ...
                  'schema_version', '', ...
                  'sidecar_string', data.jsonText, ...
                  'events_string', data.eventsText, ...
                  'check_for_warnings', 'off');
request1.schema_version = ...
    {'8.0.0', 'sc:score_1.0.0', 'test:testlib_1.0.2'};
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 validating a valid event file.');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Example 1 failed to validate a correct event file.';
end

%% Example 2: Validate valid events file using library tags.
request2 = struct('service', 'events_validate', ...
                  'schema_version', '', ...
                  'sidecar_string', data.jsonLibrary, ...
                  'events_string', data.eventsText, ...
                  'check_for_warnings', 'off');
request2.schema_version = ...
    {'8.0.0', 'sc:score_1.0.0', 'test:testlib_1.0.2'};
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 validating a valid event file with libraries.');
if ~isempty(response2.error_type) || ...
   ~strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Example 2 validated a correct event file.';
end

%% Example 3: Validate invalid events file because of missing libraries.
request3 = struct('service', 'events_validate', ...
                  'schema_version', '8.1.0', ... ...
                  'sidecar_string', data.jsonLibrary, ...
                  'events_string', data.eventsText, ...
                  'check_for_warnings', 'off');

response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 validating events with missing library.');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'warning')
   errors{end + 1} = ...
       'Example 3 failed to detect event file validation errors missing library.';
end
