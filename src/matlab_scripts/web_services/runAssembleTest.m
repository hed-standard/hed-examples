%% Use this script to run an individual type of service.
% host = 'https://hedtools.ucsd.edu/hed';
host = 'http://127.0.0.1:5000/';
%host = 'https://hedtools.ucsd.edu/hed_dev';
[servicesUrl, options] = getHostOptions(host);
dataPath = 'D:/test1/';
jsonText = fileread([dataPath 'events.json']);
eventsText =  fileread([dataPath 'events.tsv']);
data = getTestData();
errors = {};
%%  Example 4: Assemble valid event HED strings(expand defs on).
request4 = struct('service', 'events_assemble', ...
                  'schema_version', '8.2.0', ...
                  'sidecar_string', jsonText, ...
                  'events_string', eventsText, ...
                  'expand_defs', 'on');
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, ...
    'Example 4 assembling HED annotations for events.');
if ~isempty(response4.error_type) || ...
   ~strcmpi(response4.results.msg_category, 'success')
   errors{end + 1} = ...
       'Example 4 failed to assemble events file with expand defs.';
end

