%% Use this script to run an individual type of service.
% host = 'https://hedtools.org/hed';
host = 'http://127.0.0.1:5000/';
%host = 'https://hedtools.org/hed_dev';
%errors = testLibraryServices(host);
%errors = testSpreadsheetServices(host);
%errors = testEventSearchServices(host);
%errors = testEventServices(host);
errors = testStringServices(host);