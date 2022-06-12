host = 'https://hedtools.ucsd.edu/hed';
errorMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
errorMap('testGetServices') = testGetServices(host);
errorMap('testEventServices') = testEventServices(host);
errorMap('testEventSearchServices') = testEventSearchServices(host);
errorMap('testSidecarServices') = testSidecarServices(host);
errorMap('testSpreadsheetServices') = testSpreadsheetServices(host);
errorMap('testStringServices') = testStringServices(host);

%% Output the errors
fprintf('\n\nOverall error report:\n');
keys = errorMap.keys();
for k = 1:length(keys)
    errors = errorMap(keys{k});
    if isempty(errors)
        fprintf('\t%s: no errors\n', keys{k});
    else
        fprintf('\t%s:\n', keys{k});
        for n = 1:length(errors)
           fprintf('\t\t%s\n', keys{k}, errors{n});
        end
    end
end
