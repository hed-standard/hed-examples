function [] = dumpEEGLABEventFiles(fileList, nameSuffix, dumpSuffix)
%% Save event structures for EEG.set files in fileList.
%
%  Parameters:
%    fileList    Cell array of full paths of EEG.set files to be processed.
%    nameSuffix  
%    dumpSuffix  Str suffix added to the filename (before ext) for
%                created files.
    
    fprintf('Dumping %d EEG.set files...\n', length(fileList));
    for k = 1:length(fileList)
        EEG = pop_loadset(fileList{k});
        [pathName, fileName, ~] = fileparts(fileList{k});
        eventTable = struct2table(EEG.event);
        filePrefix = fileName(1:end-length(nameSuffix));
        newName = [pathName filesep filePrefix dumpSuffix];
        fprintf('\t%s\n', newName) 
%         writetable(eventTable, newName, 'WriteRowNames', false, ...
%             'Delimiter', '\t', 'QuoteStrings', false, 'FileType', 'text');
    end
