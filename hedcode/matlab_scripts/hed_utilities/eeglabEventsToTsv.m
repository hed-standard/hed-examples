function srateList = eeglabEventsToTsv(fileList, nameSuffix, saveSuffix)
%% Save event structures as .tsv file for EEG.set files in fileList.
%
%  Parameters:
%    fileList    Cell array of full paths of EEG.set files to be processed.
%    nameSuffix  
%    saveSuffix  Char suffix added to the filename (before ext) for
%                created files.
    
    fprintf('Saving events from %d EEG.set files...\n', length(fileList));
    srateList = zeros(length(fileList), 1);
    for k = 1:length(fileList)
        EEG = pop_loadset(fileList{k});
        srateList(k) = EEG.srate;
        [pathName, fileName, ~] = fileparts(fileList{k});
        eventTable = struct2table(EEG.event);
        filePrefix = fileName(1:end-length(nameSuffix));
        newName = [pathName filesep filePrefix saveSuffix];
        fprintf('\t%s\n', newName) 
        writetable(eventTable, newName, 'WriteRowNames', false, ...
            'Delimiter', '\t', 'QuoteStrings', false, 'FileType', 'text');
    end
