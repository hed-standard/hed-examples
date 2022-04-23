function eventTable = getEventTable(eventsFile, columnTypes, renameColumns)
% Read the table of events from the events file
   typeMap = containers.Map(columnTypes(:, 1), columnTypes(:, 2));       
   optsDect = detectImportOptions(eventsFile, 'FileType', 'delimitedtext');
  
   % Set the types and fill values of the columns as specified.
   columnNames = optsDect.VariableNames;
   columnTypes = cell(size(columnNames));
   for m = 1:length(columnNames)
       if isKey(typeMap, columnNames{m})
           columnTypes{m} = typeMap(columnNames{m});
       else
           columnTypes{m} = 'char';
       end
   end
   optsDect = setvartype(optsDect, columnTypes);
   optsDect = setvaropts(optsDect, ...
       columnNames(~strcmpi(columnTypes, 'char')), 'FillValue', NaN);
   optsDect = setvaropts(optsDect, ...
       columnNames(strcmpi(columnTypes, 'char')), 'FillValue', 'n/a');
   
   % Read in the event table
   eventTable = readtable(eventsFile, optsDect);
   
   % Rename the columns that are requested.
   variableNames = eventTable.Properties.VariableNames;
   for m = 1:length(renameColumns)
      variableNames{strcmpi(variableNames, renameColumns{m, 1})} = ...
          renameColumns{m, 2};
   end
   eventTable.Properties.VariableNames = variableNames;
 