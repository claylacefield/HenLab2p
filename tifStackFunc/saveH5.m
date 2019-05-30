function saveH5(Y, outfile, info)

%% USAGE: saveH5(Y, outfile, info);
% Clay 2017
% 
% 111317
% - permuting (transposing) before save to maintain correct dimensions
% 052719
% - now adding 'info' argument for writing proper attributes to h5 file

disp('Saving stack as H5 with sima dimensions (tzyxc)');

if ~isa(Y, 'uint16')
    Y = uint16(Y); % convert to uint16 if necessary (but may need to check scaling first)
end

Y = permute(Y,[2 1 3]);

Ysiz2 = size(Y);

Y = reshape(Y, [1,Ysiz2(1), Ysiz2(2), 1, Ysiz2(3)]);

disp(['Writing H5 file ' outfile]); 
%h5create(outfile, '/imaging', size(Y), 'ChunkSize', [1, Ysiz2(1), Ysiz2(2),1,1]);
h5create(outfile, '/imaging', size(Y), 'Datatype', 'uint16', 'ChunkSize', [1, Ysiz2(1), Ysiz2(2),1,1]);
tic;
h5write(outfile, '/imaging', Y);
h5writeatt(outfile, '/imaging', 'channel_names', 'Ch1');
h5writeatt(outfile, '/imaging', 'element_size_um', [1;1.29;1.29]);

% NOTE: currently I don't know how to write this attribute, because cell
% arrays can't be used as an attribute in h5writeatt
%h5writeatt(outfile, '/imaging', 'DIMENSION_LABELS', {'t'; 'z'; 'y'; 'x'; 'c'});


toc;