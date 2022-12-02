%% Use this script to run an individual type of service.
host = 'https://hedtools.ucsd.edu/hed_dev';
% host = 'https://hedtools.ucsd.edu/hed';
host = 'http://127.0.0.1:5000/';
%host = 'http://192.168.0.25/hed_dev';
errors = testEventRemodelingServices(host);