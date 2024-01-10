function errors = testEventRemodelingServices(host)
%% Shows how to call hed-services to remodel an events file.
%
%  Example 1: Remodeling an events file with no summary or HED
%
%  Example 2: Search an events file for HED and return additional columns.

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getTestData();
errors = {};

% %% Example 1: Remodel an events file with no summary or HED.
request1 = struct('service', 'events_remodel', ...
                  'schema_version', '8.2.0', ...
                  'remodel_string', data.remodel1Text, ...
                  'events_string', data.eventsText);

response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 Remodel by removing value and sample columns');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Example 1 failed execute the search.';
end

%% Example 2: Remodel an events file with summary and no HED.
request2 = struct('service', 'events_remodel', ...
                  'schema_version', '8.2.0', ...
                  'remodel_string', data.remodel2Text, ...
                  'events_string', data.eventsText);

response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 Remodel by summarizing columns');
if ~isempty(response2.error_type) || ...
   ~strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Example 2 failed execute the search.';
end

%% Example 3: Summarize files including HED
request3 = struct('service', 'events_remodel', ...
                  'schema_version', '8.2.0', ...
                  'remodel_string', data.remodel3Text, ...
                  'events_string', data.eventsText, ...
                  'sidecar_string', data.jsonText);

response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 Remodel by summarizing columns');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'success')
   errors{end + 1} = 'Example 3 failed execute the search.';
end

