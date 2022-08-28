% renameChannels - rename channels based on dictionary (does not reorder)
%
% Usage:
%    chanlocs = renameChannels(chanlocs, chanMap)
%
%
% Parameters:
%    chanlocs   [struct] the EEG.chanlocs structure
%
%    chanRemap  [containers.Map] with (old names, new names)
%
% Author: Kay Robbins, 2022
function [chanlocs, numRenamed] = renameChannels(chanlocs, chanRemap)
    numRenamed = 0;
    if isempty(chanRemap)
        return;
    end
    for k = 1:length(chanlocs)
        if isKey(chanRemap, chanlocs(k).labels)
            chanlocs(k).labels = chanRemap(chanlocs(k).labels);
            numRenamed = numRenamed + 1;
        end
    end
end

