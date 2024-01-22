function errors = testSidecarServices(host)
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

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getTestData();
errors = {};

%% Example 1: Validate valid JSON sidecar using a HED version.
request1 = struct('service', 'sidecar_validate', ...
                  'schema_version', '8.2.0', ...
                  'sidecar_string', data.jsonText, ...
                  'check_for_warnings', 'on');
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 validate a valid JSON sidecar.');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Example 1 failed to validate a correct JSON file.';
end

%% Example 2: Validate invalid JSON sidecar using HED URL.
request2 = struct('service', 'sidecar_validate', ...
                  'sidecar_string', data.jsonBadText, ...
                  'schema_url', data.schemaUrl, ...    
                  'check_for_warnings', 'on');
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 validate an invalid JSON sidecar.');
if isempty(response2.error_type) && ...
   ~isempty(response2.results.msg_category) && ...        
   strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Example 2 failed to detect an incorrect JSON file.';
end

%% Example 3: Convert valid JSON sidecar to long uploading HED schema.
request3 = struct('service', 'sidecar_to_long', ...
                  'schema_string', data.schemaText, ...
                  'sidecar_string', data.jsonText, ...
                  'expand_defs', 'off');

response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 convert a JSON sidecar to long form.');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'success')
   errors{end + 1} = 'Example 3 failed to convert a valid JSON to long.';
end

%%  Example 4: Convert valid JSON sidecar to short using a HED version..
request4 = struct('service', 'sidecar_to_short', ...
                  'schema_version', '8.2.0', ...
                  'sidecar_string', data.jsonText, ...
                  'expand_defs', 'on');
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Example 4 convert a JSON sidecar to short form.');
if ~isempty(response4.error_type) || ...
   ~strcmpi(response4.results.msg_category, 'success')
   errors{end + 1} = 'Example 4 failed to convert a valid JSON to short.';
end

%%  Example 5: Extract a 4-column spreadsheet from a JSON sidecar.
request5 = struct('service', 'sidecar_extract_spreadsheet', ...
                  'sidecar_string', data.jsonText);
response5 = webwrite(servicesUrl, request5, options);
response5 = jsondecode(response5);
outputReport(response5, ...
             'Example 5 extract 4-column spreadsheet from a JSON sidecar.');
if ~isempty(response5.error_type) || ...
   ~strcmpi(response5.results.msg_category, 'success')
   errors{end + 1} = ...
      'Example 5 failed to convert JSON to 4-column spreadsheet.';
end

%%  Example 6: Merge a 4-column spreadsheet with a JSON sidecar.
request6 = struct('service', 'sidecar_merge_spreadsheet', ...
                  'sidecar_string', '{}', 'has_column_names', 'on', ...
                  'spreadsheet_string', '');
request6.spreadsheet_string = data.spreadsheetTextExtracted;
response6 = webwrite(servicesUrl, request6, options);
response6 = jsondecode(response6);
outputReport(response6, ...
             'Example 6 merge a 4-column spreadsheet with a JSON sidecar.');
if ~isempty(response6.error_type) || ...
  ~strcmpi(response6.results.msg_category, 'success')
   errors{end + 1} = ...
       'Example 6 failed to merge 4-column spreadsheet with JSON.';
end 
 