%% Shows how to call hed-services to process a list of hedstrings.
% 
%  Example 1: Validate valid list of strings using HED version.
%
%  Example 2: Validate invalid list of strings using HED URL.
%
%  Example 3: Validate invalid list of strings uploading HED schema.
%
%  Example 4: Convert valid strings to long using HED version.
%
%% Setup requires a csrfUrl and servicesUrl. Must set header and options.
host = 'http://127.0.0.1:5000';
%host = 'https://hedtools.ucsd.edu/hed';
csrfUrl = [host '/services']; 
servicesUrl = [host '/services_submit'];
[cookie, csrftoken] = getSessionInfo(csrfUrl);
header = ["Content-Type" "application/json"; ...
          "Accept" "application/json"; ...
          "X-CSRFToken" csrftoken; "Cookie" cookie];

options = weboptions('MediaType', 'application/json', 'Timeout', 120, ...
                     'HeaderFields', header);

%% Read in the schema text for the examples
schemaText = fileread('../../data/schema_data/HED8.0.0.xml');
goodStrings = {'Red,Blue', 'Green', 'White, (Black, Image)'}; 
badStrings = {'Red, Blue, Blech', 'Green', 'White, Black, Binge'}; 

%% Example 1: Validate valid list of strings using HED URL.
request1 = struct('service', 'strings_validate', ...
                  'schema_version', '8.0.0', ...
                  'string_list', '', ...
                  'check_warnings_validate', 'on');
request1.string_list = goodStrings;
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 Validating a valid list of strings');

%% Example 2: Validate a list of invalid strings. HED schema is URL.
myURL = ['https://raw.githubusercontent.com/hed-standard/' ...
         'hed-specification/master/hedxml/HED8.0.0.xml'];

request2 = struct('service', 'strings_validate', ...
                  'schema_url', myURL, ...
                  'string_list', '', ...
                  'check_for_warnings', 'on');
request2.string_list = badStrings;
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, ...
             'Example 2 validating a list of strings with invalid values');

%% Example 3: Validate list of invalid strings uploading HED schema.
request3 = struct('service', 'strings_validate', ...
                  'schema_string', schemaText, ...
                  'string_list', '', ...
                  'check_for_warnings', 'on');
request3.string_list = badStrings;               
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, ...
            'Example 3 validate invalid strings using an uploaded HED schema');

%% Example 4: Convert valid strings to long using HED version.
request4 = struct('service', 'strings_to_long', ...
                  'schema_version', '8.0.0', ...
                  'string_list', '');
request4.string_list = goodStrings;               
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Example 4 Convert a list of valid strings to long');
