% eeg_setchantypes - set the type field of chanlocs based on channels.tsv
%
% Usage:
%    eeg_setchantypes(EEG, fileOut)
%
%
% Parameters:
%    EEG       - [struct] the EEG structure
%    chanFile  - [string] filepath of relevant BIDS channels.tsv file
%
% Returns:
%    EEG       - [struct] the EEG structure modified with channel types
%    missing   - [cell array] a list of channels not found in the EEG.
%
% Author:Kay Robbins, 2022

function [chanlocs, missing] = setChanTypes(chanlocs, chanFile)
    chanMap = getChannelMap(chanFile);
    numRenamed = 0;
    missing = {};
    for nk = 1:length(chanlocs)
        label = chanlocs(nk).labels;
        if isKey(chanMap, label)
            chanlocs(nk).type = chanMap(label);
            numRenamed = numRenamed + 1;
        else
            missing{end+1} = label;  %#ok<AGROW>
        end
    end
end

function chanMap = getChannelMap(chanFile)
   opts = delimitedTextImportOptions( ...
        'Delimiter', '\t', 'DataLines', 2, 'VariableNamesLine', 1);
    T = readtable(chanFile, opts, 'ReadVariableNames', true);
    names = T.name;
    types = T.type;
    chanMap = containers.Map(names, types);
end  
