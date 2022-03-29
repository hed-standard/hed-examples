function srateMap = eeglabEventsToTsv(fileList, nameSuffix, saveSuffix)
%% Save event structures as .tsv file for EEG.set files in fileList.
%
%  Parameters:
%    fileList    Cell array of full paths of EEG.set files to be processed.
%    nameSuffix  
%    saveSuffix  Char suffix added to the filename (before ext) for
%                created files.
%
%  Returns: 
%     map (filebaseName, samplingRate)
    
    fprintf('Saving events from %d EEG.set files...\n', length(fileList));
    srateMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for k = 1:length(fileList)
        EEG = pop_loadset(fileList{k});
        [pathName, fileName, ~] = fileparts(fileList{k});
        srateMap(fileName) = EEG.srate;
        eventTable = struct2table(EEG.event);
        filePrefix = fileName(1:end-length(nameSuffix));
        newName = [pathName filesep filePrefix saveSuffix];
        fprintf('\t%s\n', newName) 
        writetable(eventTable, newName, 'WriteRowNames', false, ...
            'Delimiter', '\t', 'QuoteStrings', false, 'FileType', 'text');
    end
