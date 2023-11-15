function eventTable = getEventTable(eventsFile, typeMap, renameMap)
% Read the table of events from the events file
%
% Parameters:
%     eventsFile - the path of a BIDS tabular events file.
%     typeMap - map of non-string column types: (column-name, column-type)
%     renameMap - map of columns to be renamed: (old-name, new-name)
%                      
  
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
   for m = 1:length(variableNames)
       if isKey(renameMap, variableNames{m})
           variableNames{m} = renameMap(variableNames{m});
       end
   end
   eventTable.Properties.VariableNames = variableNames;
 