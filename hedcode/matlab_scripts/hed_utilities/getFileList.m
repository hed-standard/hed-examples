%% Dump the EEG.event structure from each EEG.set file in a dataset.

%% Create a list with all of the .set files in the BIDS dataset
function selectedList = getFileList(rootPath, namePrefix, nameSuffix, ...
    extensions, excludeDirs)
%% Return a full path list of specific files in the rootPath directory tree 
%
%  Parameters:
%      rootPath    (char) full path of root of directory tree to search
%      namePrefix  (char) prefix of the filename or any if empty
%      nameSuffix  (char) suffix of the filename or any if empty
%      extensions  (cell array) names of extensions (with . included)
%      excludeDirs (cell array) names of subdirectories to exclude
%
%  Returns: 
%      selectedList    (cell array) list of full paths of the files 
% 

    selectedList = {};
    dirList = {rootPath};
    while ~isempty(dirList)
        thisDir = dirList{1};
        dirList = dirList(2:end);
        fileList = dir(thisDir);
        for k = 1:length(fileList)
            thisFile = fileList(k);
            if checkDirExclusions(thisFile, excludeDirs)
                continue;
            elseif fileList(k).isdir
                dirList{end+1} = [fileList(k).folder filesep fileList(k).name];  %#ok<AGROW>
            elseif ~checkFileExclusions(thisFile, namePrefix, ...
                                        nameSuffix, extensions)
                thisPath = [thisFile.folder filesep thisFile.name];
                selectedList{end+1} = thisPath;  %#ok<AGROW>
            end
        end
    end
end


function isExcluded = checkDirExclusions(thisFile, excludeDirs)
% Returns true if this file entry corresponds to an excluded directory
    if ~thisFile.isdir
        isExcluded = false;
    elseif startsWith(thisFile.name, '.')
        isExcluded = true;
    else
        isExcluded = false;
        for k = 1:length(excludeDirs)
            if startsWith(thisFile.name, excludeDirs{k})
                isExcluded = true;
                break
            end
        end
        
    end
end

function isExcluded = checkFileExclusions(thisFile, namePrefix, ...
    nameSuffix, extensions)
% Returns true if this file entry corresponds to an excluded directory
    [~, theName, theExt] = fileparts(thisFile.name);
    if ~isempty(namePrefix) && ~startsWith(theName, namePrefix)
        isExcluded = true;
    elseif ~isempty(nameSuffix) && ~endsWith(theName, nameSuffix)
        isExcluded = true;
    elseif isempty(extensions)
        isExcluded = false;
    else
        isExcluded = true;
        for k = 1:length(extensions)
            if strcmpi(theExt, extensions{k})
                isExcluded = false;
                break
            end
        end

    end
end
