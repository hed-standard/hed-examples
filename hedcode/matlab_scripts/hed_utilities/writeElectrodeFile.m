function numchans = writeElectrodeFile(chanlocs, electrodesFile)
%% Write the electrodes.tsv file for the chanlocs.
%
%    writeElectrodeFile(chanlocs, electrodesFile)
%
% Parameters:
%    chanlocs        [struct] The EEG.chanlocs structure.
%    electrodesFile  [string] The filepath of the electrodes file.
%
% Returns:
%    numchans        [numerical] number of channels in electrodes file.
%%
    if isempty(chanlocs) || ~isfield(chanlocs, 'X')
       numchans = 0;
       return
    end
    fid = fopen(electrodesFile, 'w');
    fprintf(fid, 'name\tx\ty\tz\n');
    for iChan = 1:length(chanlocs)
        fprintf(fid, '%s', chanlocs(iChan).labels);
        chanwrite(fid, chanlocs(iChan).X);
        chanwrite(fid, chanlocs(iChan).Y);
        chanwrite(fid, chanlocs(iChan).Z);
        fprintf(fid, '\n');
    end
    fclose(fid);
    numchans = length(chanlocs);
end

function [] = chanwrite(fid, pos)
   if isempty(pos) || isnan(pos)
       fprintf(fid, '\tn/a');
   else
       fprintf(fid,'\t%2.6f', pos);
   end
end