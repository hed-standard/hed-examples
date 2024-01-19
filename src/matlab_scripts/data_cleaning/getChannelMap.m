function [chanMap, chanNames] = getChannelMap(chanFile)
%% Create a Map of (channel name, channel type) and list of channel names.
%  
%  Parameters:
%      chanFile   Path name of BIDS channels.tsv file.
%      chanMap    (output) Map(channel names, channel types)
%      chanNames  (output) Channel names in order they appear in chanFile.
%%
    opts = delimitedTextImportOptions( ...
        'Delimiter', '\t', 'DataLines', 2, 'VariableNamesLine', 1);
    T = readtable(chanFile, opts, 'ReadVariableNames', true);
    chanNames = T.name;
    types = T.type;
    chanMap = containers.Map(chanNames, types);
end  
