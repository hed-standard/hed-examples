%% Dump the EEG.event structure from each EEG.set file in a dataset.

%% Create a list with all of the .set files in the BIDS dataset
pathname = 'G:\AttentionShift\AttentionShiftWorking1';

eventList = {};
dirList = {pathname};
while ~isempty(dirList)
    thisDir = dirList{1};
    dirList = dirList(2:end);
    fileList = dir(thisDir);
    for k = 1:length(fileList)
        thisFile = fileList(k);
        if fileList(k).isdir && startsWith(fileList(k).name, 'sourcedata')
            continue
        elseif fileList(k).isdir && ~startsWith(fileList(k).name, '.')
            dirList{end+1} = [fileList(k).folder filesep fileList(k).name]; %#ok<SAGROW>
        elseif fileList(k).isdir
            continue
        elseif ~thisFile.isdir && endsWith(thisFile.name, 'eeg.set')
            thisPath = [thisFile.folder filesep thisFile.name];
            fprintf('%s [%s]\n', thisFile.name, thisPath);
            eventList{end+1} = thisPath; %#ok<SAGROW>
        end
    end
end

%% Load each EEG set file and dump the events to a '_events_temp.tsv' file.
runMap = containers.Map('keyType', 'char', 'valueType', 'char');
for k = 1:length(eventList)
    EEG = pop_loadset(eventList{k});
    [pathName, fileName, ext] = fileparts(eventList{k});
    runMap(fileName) = EEG.setname;
    eventTable = struct2table(EEG.event);
    filePrefix = fileName(1:end-3);
    newName = [pathName filesep filePrefix 'events_temp.tsv'];
    writetable(eventTable, newName, 'WriteRowNames', false, ...
        'Delimiter', '\t', 'QuoteStrings', false, 'FileType', 'text');
end

%% Print the file correspondence
mapKeys = keys(runMap);
for k = 1:length(mapKeys)
    key = mapKeys{k};
    keyNum = key(5:7);
    keyRun = key(end-5: end-4);
    value = runMap(key);
    pieces = split(value, '_');
    valNum = pieces{2};
    valRun = pieces{4};
    fprintf('%s_%s\t%s_%s\n', keyNum, keyRun, valNum, valRun);
end
