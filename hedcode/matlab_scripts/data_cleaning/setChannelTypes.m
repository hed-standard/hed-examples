
function [chanlocs, missing] = setChannelTypes(chanlocs, chanMap)
%% Set the types of the channels based on a map of channels and types.
%
% Parameters:
%    chanlocs   [struct](Input/Output) The EEG.chanlocs structure.
%    chanMap    [containers.Map] (Map of channel names, channel types).
%    missing    [cell array] (Output) Channels not found in the EEG.
%
% Author:Kay Robbins, 2022

    missing = {};
    for nk = 1:length(chanlocs)
        label = chanlocs(nk).labels;
        if isKey(chanMap, label)
            chanlocs(nk).type = chanMap(label);
        else
            missing{end+1} = label;  %#ok<AGROW>
        end
    end
end

